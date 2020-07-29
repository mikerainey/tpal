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
#include "tpalrts_rollforward.hpp"

/*---------------------------------------------------------------------*/
/* Manual version */

uint64_t fib_custom_stack_serial(uint64_t n, int64_t K, tpalrts::stack_type s) {
  char* stack = s.stack;
  char* sp = s.sp;
  char* prmhd = s.prmhd;
  char* prmtl = s.prmtl;
  uint64_t f = 0;

 entry:
  salloc(sp, 1);
  sstore(sp, 0, void*, &&exitk);

 loop:
  f = n;
  if (n < 2) {
    goto retk;
  }
  f = 0;
  salloc(sp, 2);
  sstore(sp, 0, void*, &&branch1);
  sstore(sp, 1, uint64_t, n - 2);
  n--;
  goto loop;

 branch1:
  n = sload(sp, 1, uint64_t);
  sstore(sp, 0, void*, &&branch2);
  sstore(sp, 1, uint64_t, f);
  goto loop;

 branch2:
  f += sload(sp, 1, uint64_t);
  sfree(sp, 2);
  goto retk;

 retk:
  goto *sload(sp, 0, void*);

 exitk:
  sfree(sp, 1);
  return f;
  
}

static
uint64_t fib_serial(uint64_t n) {
  if (n < 2) {
    return n;
  } else {
    return fib_serial(n - 1) + fib_serial(n - 2);
  }
}

static
uint64_t fib_manual_T = 2;

template <typename Scheduler>
class fib_manual : public tpalrts::fiber<Scheduler> {
public:

  using trampoline_type = enum { entry, exit };

  trampoline_type trampoline = entry;

  uint64_t n; uint64_t* dst;
  uint64_t d1, d2;

  fib_manual(uint64_t n, uint64_t* dst)
    : tpalrts::fiber<Scheduler>([] (tpalrts::promotable*) { return mcsl::fiber_status_finish; }),
      n(n), dst(dst) { }

  mcsl::fiber_status_type run() {
    switch (trampoline) {
    case entry: {
      if (n <= fib_manual_T) {
        *dst = fib_serial(n);
        break;
      }
      auto f1 = new fib_manual(n-1, &d1);
      auto f2 = new fib_manual(n-2, &d2);
      tpalrts::fiber<Scheduler>::add_edge(f1, this);
      tpalrts::fiber<Scheduler>::add_edge(f2, this);
      f2->release();
      f1->release();
      tpalrts::stats::increment(tpalrts::stats_configuration::nb_promotions);
      tpalrts::stats::increment(tpalrts::stats_configuration::nb_promotions);
      trampoline = exit;
      return mcsl::fiber_status_pause;	  
    }
    case exit: {
      *dst = d1 + d2;
      break;
    }
    }
    return mcsl::fiber_status_finish;
  }

};

/*---------------------------------------------------------------------*/
/* Software-polling version */

using fib_heartbeat_type = enum fib_heartbeat_entry_type {
  fib_heartbeat_entry,
  fib_heartbeat_retk,
  fib_heartbeat_clonek
};

using heartbeat_mechanism_type = enum heartbeat_mechanism_struct {
  heartbeat_mechanism_software_polling,
  heartbeat_mechanism_hardware_interrupt
};

template <int heartbeat=heartbeat_mechanism_software_polling>
void fib_heartbeat(uint64_t n, uint64_t* dst, tpalrts::promotable* p, int64_t K,
                   tpalrts::stack_type s, fib_heartbeat_type ty, uint64_t f = 0) {
  sunpack(s);
  
  void* __joink = &&joink;
  void* __clonek = &&clonek;
  
  auto try_promote = [&] {
    if (prmempty(prmtl, prmhd)) {
      return;
    }
    char* sp_cont;
    uint64_t top;
    prmsplit(sp, prmtl, prmhd, sp_cont, top);
    char* sp_top = sp + top;
    uint64_t n2 = sload(sp_top, 0, uint64_t);
    sstore(sp_top, -1l, void*, __joink);
    auto dst0 = dst;
    using dst_rec_type = std::tuple<uint64_t, uint64_t>;
    dst_rec_type* dst_rec;
    tpalrts::arena_block_type* dst_blk;
    std::tie(dst_rec, dst_blk) = tpalrts::alloc_arena<dst_rec_type>();
    p->fork_join_promote([=] (tpalrts::promotable* p2) {
      tpalrts::stack_type s2 = tpalrts::snew();
      fib_heartbeat_type ty;
      if (sload(sp_top, -1l, void*) != __clonek) { // slow clone
        ty = fib_heartbeat_entry;
      } else { // fast clone
        ty = fib_heartbeat_clonek;
        s2.stack = s.stack;
        s2.sp = saddr(sp_top, -1l);
      }
      fib_heartbeat<heartbeat>(n2, &(std::get<1>(*dst_rec)), p2, K, s2, ty, 0);
    }, [=] (tpalrts::promotable* p2) {
      auto f2 = std::get<0>(*dst_rec) + std::get<1>(*dst_rec);
      decr_arena_block(dst_blk);
      auto sj = s;
      sj.sp = sp_cont;
      fib_heartbeat<heartbeat>(0, dst0, p2, K, sj, fib_heartbeat_retk, f2);
    });
    dst = &std::get<0>(*dst_rec);
  };

  uint64_t promotion_prev = (heartbeat == heartbeat_mechanism_software_polling) ? mcsl::cycles::now() : 0;
  uint64_t k = K;

  if (ty == fib_heartbeat_entry) {
    goto entry;
  } else if (ty == fib_heartbeat_retk) {
    goto retk;
  } else if (ty == fib_heartbeat_clonek) {
    goto clonek;
  }

 entry:
  salloc(sp, 1);
  sstore(sp, 0, void*, &&exitk);

 loop:
  if (--k == 0) {
    k = K;
    if (heartbeat == heartbeat_mechanism_software_polling) {
      auto cur = mcsl::cycles::now();
      if (mcsl::cycles::diff(promotion_prev, cur) > tpalrts::kappa_cycles) {
        promotion_prev = cur;
        tpalrts::stats::increment(tpalrts::stats_configuration::nb_heartbeats);
        try_promote();
      }
    } else if (heartbeat == heartbeat_mechanism_hardware_interrupt) {
      if (tpalrts::flags.mine().load()) {
        tpalrts::flags.mine().store(false);
        try_promote();
      }
    }
  }
  f = n;
  if (n < 2) {
    goto retk;
  }
  f = 0;
  salloc(sp, 4);
  sstore(sp, 0, void*, &&branch1);
  sstore(sp, 1, uint64_t, n - 2);
  prmpush(sp, 2, prmtl, prmhd);
  n--;
  goto loop;

 branch1:
  n = sload(sp, 1, uint64_t);
  sstore(sp, 0, void*, &&branch2);
  sstore(sp, 1, uint64_t, f);
  prmpop(sp, 2, prmtl, prmhd);
  goto loop;

 branch2:
  f += sload(sp, 1, uint64_t);
  sfree(sp, 4);
  goto retk;

 retk:
  goto *sload(sp, 0, void*);

 joink:
  sstore(sp, 0, void*, &&clonek);
  sfree(sp, 1);
  *dst = f;
  return;

 clonek:
  salloc(sp, 1);
  sstore(sp, 0, void*, &&joink);
  goto loop;
  
 exitk:
  sfree(sp, 1);
  *dst = f;
  sdelete(s);
  
}

/*---------------------------------------------------------------------*/
/* Cilk version */

static
uint64_t fib_cilk(uint64_t n) {
  uint64_t r = 0;
#if defined(USE_CILK_PLUS)
  if (n < 2) {
    return n;
  } else {
    uint64_t r1, r2;
    r1 = cilk_spawn fib_cilk(n - 1);
    r2 = fib_cilk(n - 2);
    cilk_sync;
    r = r1 + r2;
  }
#else
  assert(false);
#endif
  return r;
}
