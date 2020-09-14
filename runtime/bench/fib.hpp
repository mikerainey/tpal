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
#include "fib_rollforward_decls.hpp"

static
uint64_t fib_serial2(uint64_t n) {
  if (n < 2) {
    return n;
  } else {
    return fib_serial2(n - 1) + fib_serial2(n - 2);
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
        *dst = fib_serial2(n);
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

extern
uint64_t fib_serial(uint64_t n, tpalrts::stack_type s);

extern
void fib_interrupt(uint64_t n, uint64_t* dst,
                   tpalrts::stack_type s, void* p, void* pc, uint64_t f);

int fib_handler(uint64_t n, uint64_t*& dst,
		tpalrts::stack_type s, char*& sp, char*& prmhd, char*& prmtl,
		void* pc, uint64_t f,
		void* __entry, void* __retk, void* __joink, void* __clonek,
		void* _p) {
  tpalrts::promotable* p = (tpalrts::promotable*)_p;
  if (prmempty(prmtl, prmhd)) {
    return 0;
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
    void* pc2;
    auto t = tpalrts::reverse_lookup_rollforward_entry(sload(sp_top, -1l, void*));
    if (t != __clonek) { // slow clone
      pc2 = __entry;
    } else { // fast clone
      pc2 = __clonek;
      s2.stack = s.stack;
      s2.sp = saddr(sp_top, -1l);
    }
    fib_interrupt(n2, &(std::get<1>(*dst_rec)), s2, p2, pc2, 0);
  }, [=] (tpalrts::promotable* p2) {
    auto f2 = std::get<0>(*dst_rec) + std::get<1>(*dst_rec);
    decr_arena_block(dst_blk);
    auto sj = s;
    sj.sp = sp_cont;
    fib_interrupt(0, dst0, sj, p2, __retk, f2);
  });
  dst = &std::get<0>(*dst_rec);
  return 1;
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
