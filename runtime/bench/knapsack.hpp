#pragma once

#ifdef USE_CILK_PLUS
#include <cilk/cilk.h>
#include <cilk/cilk_api.h>
#include <cilk/reducer_opadd.h>
#endif
#include <cstdint>
#include <climits>
#include <assert.h>

#ifdef TPALRTS_LINUX
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <string.h>
#endif

#include "mcsl_util.hpp"

#include "tpalrts_fiber.hpp"
#include "tpalrts_stack.hpp"
#include "knapsack_rollforward_decls.hpp"

struct item {
  int value;
  int weight;
};

#include "knapsack_input.hpp"

#define MAX_ITEMS 256

int seq_best_so_far = INT_MIN;

int knapsack_serial2(int& best_so_far, struct item *e, int c, int n, int v) {
  int with, without, best;
  double ub;

  /* base case: full knapsack or no items */
  if (c < 0) {
    return INT_MIN;
  }

  /* feasible solution, with value v */
  if (n == 0 || c == 0) {
    return v;
  }

  ub = (double) v + c * e->value / e->weight;

  if (ub < best_so_far) {
   /* prune ! */
    return INT_MIN;
  }
  /*
   * compute the best solution without the current item in the knapsack
   */
  without = knapsack_serial2(best_so_far, e + 1, c, n - 1, v);

  /* compute the best solution with the current item in the knapsack */
  with = knapsack_serial2(best_so_far, e + 1, c - e->weight, n - 1, v + e->value);

  best = with > without ? with : without;

  /*
   * notice the race condition here. The program is still
   * correct, in the sense that the best solution so far
   * is at least best_so_far. Moreover best_so_far gets updated
   * when returning, so eventually it should get the right
   * value. The program is highly non-deterministic.
   */
  if (best > best_so_far) best_so_far = best;

  return best;
}

void* __entry = nullptr;
void* __exitk = nullptr;
void* __retk = nullptr;
void* __joink = nullptr;
void* __clonek = nullptr;
void* __branch1 = nullptr;
void* __branch2 = nullptr;

using pair_ints_type = std::pair<int,int>;

extern
int knapsack_serial(int& best_so_far, struct item *e, int c, int n, int v, tpalrts::stack_type s);

std::atomic<int> best_so_far(INT_MIN);

#ifndef SANITIZE
void* sanitize_label(void* l) {
  return tpalrts::reverse_lookup_rollforward_entry(l);
}
#endif
#define SANITIZE

extern
void knapsack_interrupt(std::atomic<int>& best_so_far, struct item *e, int c, int n, int v, int* dst,
                        void* p, tpalrts::stack_type s,
			void* pc, int best);

int knapsack_handler(std::atomic<int>& best_so_far, struct item *e, int c, int n, int v, int*& dst,
		     tpalrts::stack_type s, char*& sp, char*& prmhd, char*& prmtl,
		     void* pc, int best, void* _p) {
  tpalrts::promotable* p = (tpalrts::promotable*)_p;
  if (__entry == nullptr) {
    return 0;
  }
  if (prmempty(prmtl, prmhd)) {
    return 0;
  }
  char* sp_cont;
  uint64_t top;
  prmsplit(sp, prmtl, prmhd, sp_cont, top);
  char* sp_top = sp + top;
  assert(sload(sp_top, 0, void*) ==  __branch1);
  sstore(sp_top, 0, void*, __joink);
  struct item* e2 = sload(sp_top, 3, struct item*);
  pair_ints_type pi2 = sload(sp_top, 4, pair_ints_type);
  int c2 = pi2.first;
  int n2 = pi2.second;
  int v2 = sload(sp_top, 5, int);
  auto dst0 = dst;
  using dst_rec_type = std::tuple<int, int>;
  dst_rec_type* dst_rec;
  tpalrts::arena_block_type* dst_blk;
  std::tie(dst_rec, dst_blk) = tpalrts::alloc_arena<dst_rec_type>();
  p->fork_join_promote([=, &best_so_far] (tpalrts::promotable* p2) {
    tpalrts::stack_type s2 = tpalrts::snew();
    void* pc2;
    auto t = sload(sp_top, 0, void*);
    if (t != __clonek) { // slow clone
      pc2 = __entry;
    } else { // fast clone
      pc2 = __clonek;
      s2.stack = s.stack;
      s2.sp = sp_top;
    }
    knapsack_interrupt(best_so_far, e2, c2, n2, v2, &std::get<1>(*dst_rec), p2, s2, pc2, 0);
  }, [=, &best_so_far] (tpalrts::promotable* p2) {
    auto with = std::get<0>(*dst_rec);
    auto without = std::get<1>(*dst_rec);
    decr_arena_block(dst_blk);
    auto best0 = with > without ? with : without;
    auto sj = s;
    sj.sp = sp_top;
    knapsack_interrupt(best_so_far, e, c, n, v, dst0, p2, sj, __retk, best0);
  });
  dst = &std::get<0>(*dst_rec);
  return 1;
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

static inline
void update_best_so_far(std::atomic<int>& best_so_far, int val) {
  int curr = best_so_far.load(std::memory_order_relaxed);

  while (val > curr) {
    bool b = best_so_far.compare_exchange_weak(curr, val, std::memory_order_relaxed, std::memory_order_relaxed);
  }
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
     update_best_so_far(best_so_far, best);
   }

#endif
     
     return best;
}

namespace knapsack {

using namespace tpalrts;

char* name = "knapsack";
  
int n, capacity;
int sol = INT_MIN;
tpalrts::stack_type s;
struct item items[MAX_ITEMS];
#ifdef TPALRTS_LINUX
std::string inputfile;
#endif

int compare(struct item *a, struct item *b) {
  double c = ((double) a->value / a->weight) -
    ((double) b->value / b->weight);
  
  if (c > 0)
    return -1;
  if (c < 0)
    return 1;
  return 0;
}

void print_input(struct item* items, int capacity, int n) {
#ifdef TPALRTS_LINUX
  printf("int capacity = %d;\n", capacity);
  printf("int n = %d;\n", n);
  for (int i = 0; i < n; i++) {
    printf("items[%d].value = %d;\n", i, items[i].value);
    printf("items[%d].weight = %d;\n", i, items[i].weight);
  }
#endif
}

int read_input(const char *filename, struct item *items, int *capacity, int *n)
{
  #ifdef TPALRTS_LINUX
     int i;
     FILE *f;

     if (filename == NULL) filename = "\0";
     f = fopen(filename, "r");
     if (f == NULL)
     {
       fprintf(stderr, "open_input(\"%s\") failed\n", filename);
       exit(1);
     }
     /* format of the input: #items capacity value1 weight1 ... */
     int err1 = fscanf(f, "%d", n);
     int err2 = fscanf(f, "%d", capacity);

     for (i = 0; i < *n; ++i)
     {
       int err3 = fscanf(f, "%d %d", &items[i].value, &items[i].weight);
     }

     fclose(f);

     /* sort the items on decreasing order of value/weight */
     /* cilk2c is fascist in dealing with pointers, whence the ugly cast */
     qsort(items, *n, sizeof(struct item), (int (*)(const void *, const void *)) compare);
#endif
     return 0;
}

auto bench_pre(promotable* p) {
  rollforward_table = {
    #include "knapsack_rollforward_map.hpp"
  };
#ifdef TPALRTS_LINUX
  if (inputfile != "") {
    read_input(inputfile.c_str(), items, &capacity, &n);
    return;
  }
#endif
  best_so_far.store(INT_MIN);
  seq_best_so_far = INT_MIN;
  n = knapsack_n;
  capacity = knapsack_capacity;
  knapsack_init(items);
};

auto bench_body_interrupt(promotable* p) {
  s = tpalrts::snew();
  knapsack_interrupt(best_so_far, items, capacity, n, 0, &sol, p, s, nullptr, 0);
};

auto bench_body_software_polling(promotable* p) {
};

auto bench_body_serial(promotable* p) {
  //    knapsack_serial2(items, capacity, n, 0, &sol);
  s = tpalrts::snew();
  sol = knapsack_serial(seq_best_so_far, items, capacity, n, 0, s);
};

auto bench_post(promotable* p) {
		    //    best_so_far = INT_MIN;
  //    assert(sol == knapsack_serial(items, capacity, n, 0));
};

auto bench_body_cilk() {
   sol = knapsack_cilk(items, capacity, n, 0);
};
  
}
