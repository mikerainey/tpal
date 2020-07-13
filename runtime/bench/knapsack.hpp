#pragma once

#ifdef USE_CILK_PLUS
#include <cilk/cilk.h>
#include <cilk/cilk_api.h>
#include <cilk/reducer_opadd.h>
#endif
#include <cstdint>
#include <assert.h>

#include "mcsl_util.hpp"

#include "tpalrts_fiber.hpp"
#include "tpalrts_stack.hpp"

struct item {
  int value;
  int weight;
};


std::atomic<int> best_so_far(INT_MIN);

static inline
void update_best_so_far(int val) {
  int curr = best_so_far.load(std::memory_order_relaxed);

  while (val > curr) {
    bool b = best_so_far.compare_exchange_weak(curr, val, std::memory_order_relaxed, std::memory_order_relaxed);
    if (! b) {
      mcsl::cycles::spin_for(1l<<12);
    }
  }
}

int seq_best_so_far = INT_MIN;

int compare(struct item *a, struct item *b) {
  double c = ((double) a->value / a->weight) -
    ((double) b->value / b->weight);
  
  if (c > 0)
    return -1;
  if (c < 0)
    return 1;
  return 0;
}

/*---------------------------------------------------------------------*/
/* Manual version */

void knapsack_seq(struct item *e, int c, int n, int v, int *sol) {
   int with, without, best;
   double ub;

   /* base case: full knapsack or no items */
   if (c < 0) {
     *sol = INT_MIN;
     return;
   }

   /* feasible solution, with value v */
   if (n == 0 || c == 0) {
     *sol = v;
     return;
   }

   ub = (double) v + c * e->value / e->weight;

   if (ub < seq_best_so_far) {
    /* prune ! */
     *sol = INT_MIN;
     return;
   }
   /*
    * compute the best solution without the current item in the knapsack
    */
   knapsack_seq(e + 1, c, n - 1, v, &without);

   /* compute the best solution with the current item in the knapsack */
   knapsack_seq(e + 1, c - e->weight, n - 1, v + e->value, &with);

   best = with > without ? with : without;

   /*
    * notice the race condition here. The program is still
    * correct, in the sense that the best solution so far
    * is at least best_so_far. Moreover best_so_far gets updated
    * when returning, so eventually it should get the right
    * value. The program is highly non-deterministic.
    */
   if (best > seq_best_so_far) seq_best_so_far = best;

   *sol = best;
}

template <typename Scheduler>
class knapsack_manual : public tpalrts::fiber<Scheduler> {
public:

  using trampoline_type = enum { entry, exit };

  trampoline_type trampoline = entry;

  knapsack_manual()
    : tpalrts::fiber<Scheduler>([] (tpalrts::promotable*) { return mcsl::fiber_status_finish; }) { }

  mcsl::fiber_status_type run() {
    return mcsl::fiber_status_finish;
  }

};

/*---------------------------------------------------------------------*/
/* Cilk version */

using pair_ints_type = std::pair<int,int>;

int knapsack_custom_stack_serial(struct item *e, int c, int n, int v, tpalrts::stack_type s) {
  char* stack = s.stack;
  char* sp = s.sp;
  char* prmhd = s.prmhd;
  char* prmtl = s.prmtl;
  int best = 0;
  double ub;

 entry:
  salloc(sp, 1);
  sstore(sp, 0, void*, &&exitk);
  
 loop:
  if (c < 0) {
    best = INT_MIN;
    goto retk;
  }
  if ((n == 0) || (c == 0)) {
    best = v;
    goto retk;
  }
  ub = (double) v + c * e->value / e->weight;
  if (ub < seq_best_so_far) {
    best = INT_MIN;
    goto retk;
  }
  salloc(sp, 4);
  sstore(sp, 0, void*, &&branch1);
  sstore(sp, 1, struct item*, e + 1);
  {
    auto p = std::make_pair(c - e->weight, n - 1);
    sstore(sp, 2, pair_ints_type, p);
  }
  sstore(sp, 3, int, v + e->value);
  e++;
  n--;
  goto loop;

 branch1:
  e = sload(sp, 1, struct item*);
  std::tie(c, n) = sload(sp, 2, pair_ints_type);
  v = sload(sp, 3, int);
  sstore(sp, 0, void*, &&branch2);
  sstore(sp, 1, int, best); 
  goto loop;

 branch2:
  {
    auto with = best;
    auto without = sload(sp, 1, int);
    best = with > without ? with : without;
  }
  if (best > seq_best_so_far) {
    seq_best_so_far = best;
  }
  sfree(sp, 4);
  goto retk;
  
 retk:
  goto *sload(sp, 0, void*);
  
 exitk:
  sfree(sp, 1);
  return best;
  
}

using knapsack_heartbeat_type = enum knapsack_heartbeat_entry_type {
  knapsack_heartbeat_entry,
  knapsack_heartbeat_retk
};

using knapsack_heartbeat_mechanism_type = enum knapsack_heartbeat_mechanism_struct {
  knapsack_heartbeat_mechanism_software_polling,
  knapsack_heartbeat_mechanism_hardware_interrupt
};

template <int heartbeat=knapsack_heartbeat_mechanism_software_polling>
void knapsack_heartbeat(struct item *e, int c, int n, int v, int* dst,
                        tpalrts::promotable* p, tpalrts::stack_type s,
                        int64_t K=128, knapsack_heartbeat_type ty=knapsack_heartbeat_entry, int best = 0) {
  char* stack = s.stack;
  char* sp = s.sp;
  char* prmhd = s.prmhd;
  char* prmtl = s.prmtl;
  double ub;

  void* __exitk = &&exitk;
  
  auto try_promote = [&] {
    if (prmempty(prmtl, prmhd)) {
      return;
    }
    char* sp_cont;
    uint64_t top;
    prmsplit(sp, prmtl, prmhd, sp_cont, top);
    char* sp_top = sp + top;
    int v2 = sload(sp_top, 0, int);
    pair_ints_type pi2 = sload(sp_top, -1l, pair_ints_type);
    int c2 = pi2.first;
    int n2 = pi2.second;
    struct item* e2 = sload(sp_top, -2l, struct item*);
    sstore(sp_top, -3l, void*, __exitk);
    auto dst0 = dst;
    auto dst1 = new int;
    auto dst2 = new int;
    auto s2 = tpalrts::snew();
    p->fork_join_promote([=] (tpalrts::promotable* p2) {
      knapsack_heartbeat<heartbeat>(e2, c2, n2, v2, dst2, p2, s2, K, knapsack_heartbeat_entry, 0);
    }, [=] (tpalrts::promotable* p2) {
      sdelete(s2);
      auto with = *dst1;
      auto without = *dst2;
      auto best0 = with > without ? with : without;
      delete dst1;
      delete dst2;
      auto sj = s;
      sj.sp = sp_cont;
      knapsack_heartbeat<heartbeat>(e, c, n, v, dst0, p2, sj, K, knapsack_heartbeat_retk, best0);
    });
    dst = dst1;
  };

  uint64_t promotion_prev = mcsl::cycles::now();
  uint64_t k = K;

  if (ty == knapsack_heartbeat_entry) {
    goto entry;
  } else if (ty == knapsack_heartbeat_retk) {
    goto retk;
  }

 entry:
  salloc(sp, 1);
  sstore(sp, 0, void*, &&exitk);
  
 loop:
  if (--k == 0) {
    k = K;
    if (heartbeat == knapsack_heartbeat_mechanism_software_polling) {
      auto cur = mcsl::cycles::now();
      if (mcsl::cycles::diff(promotion_prev, cur) > tpalrts::kappa_cycles) {
        tpalrts::stats::increment(tpalrts::stats_configuration::nb_heartbeats);
        promotion_prev = cur;
        try_promote();
      }
    } else if (heartbeat == knapsack_heartbeat_mechanism_hardware_interrupt) {
      if (tpalrts::flags.mine().load()) {
        tpalrts::flags.mine().store(false);
        try_promote();
      }
    }
  }
  if (c < 0) {
    best = INT_MIN;
    goto retk;
  }
  if ((n == 0) || (c == 0)) {
    best = v;
    goto retk;
  }
  ub = (double) v + c * e->value / e->weight;
  if (ub < best_so_far.load(std::memory_order_relaxed)) {
    best = INT_MIN;
    goto retk;
  }
  salloc(sp, 6);
  sstore(sp, 0, void*, &&branch1);
  sstore(sp, 1, struct item*, e + 1);
  {
    auto p = std::make_pair(c - e->weight, n - 1);
    sstore(sp, 2, pair_ints_type, p);
  }
  sstore(sp, 3, int, v + e->value);
  prmpush(sp, 4, prmtl, prmhd);
  e++;
  n--;
  goto loop;

 branch1:
  e = sload(sp, 1, struct item*);
  std::tie(c, n) = sload(sp, 2, pair_ints_type);
  v = sload(sp, 3, int);
  sstore(sp, 0, void*, &&branch2);
  sstore(sp, 1, int, best);
  prmpop(sp, 4, prmtl, prmhd);
  goto loop;

 branch2:
  {
    auto with = best;
    auto without = sload(sp, 1, int);
    best = with > without ? with : without;
  }
  if (best > best_so_far.load(std::memory_order_relaxed)) {
    update_best_so_far(v);
  }
  sfree(sp, 6);
  goto retk;
  
 retk:
  goto *sload(sp, 0, void*);
  
 exitk:
  sfree(sp, 1);
  *dst = best;

}

int knapsack_cilk(struct item *e, int c, int n, int v) {
  int best;
#if defined(USE_CILK_PLUS)

   /* base case: full knapsack or no items */
   if (c < 0) {
     return INT_MIN;
   }
   if (n == 0 || c == 0) {
     return v;		/* feasible solution, with value v */
   }

   double ub = (double) v + c * e->value / e->weight;

   if (ub < best_so_far.load(std::memory_order_relaxed)) {
     /* prune ! */
     return INT_MIN;
   }
   /* 
    * compute the best solution without the current item in the knapsack 
    */
   int without = cilk_spawn knapsack_cilk(e + 1, c, n - 1, v);

   /* compute the best solution with the current item in the knapsack */
   int with = knapsack_cilk(e + 1, c - e->weight, n - 1, v + e->value);

   cilk_sync;

   best = with > without ? with : without;

   /* 
    * notice the race condition here. The program is still
    * correct, in the sense that the best solution so far
    * is at least best_so_far. Moreover best_so_far gets updated
    * when returning, so eventually it should get the right
    * value. The program is highly non-deterministic.
    */
   if (best > best_so_far.load(std::memory_order_relaxed)) {
     update_best_so_far(v);
   }

#endif
     
     return best;
}
