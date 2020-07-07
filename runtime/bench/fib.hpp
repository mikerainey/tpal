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

/*---------------------------------------------------------------------*/
/* Manual version */

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

using fib_software_polling_type = enum fib_software_polling_entry_type {
  fib_software_polling_entry,
  fib_software_polling_retk
};

void fib_software_polling_loop(uint64_t n, uint64_t* dst, tpalrts::promotable* p, int64_t K,
                               tpalrts::stack_type s, fib_software_polling_type ty, uint64_t f) {
  char* stack = s.stack;
  char* sp = s.sp;
  char* prmhd = s.prmhd;
  char* prmtl = s.prmtl;


  uint64_t promotion_prev = mcsl::cycles::now();
  uint64_t k = K;

  if (ty == fib_software_polling_entry) {
    goto entry;
  } else if (ty == fib_software_polling_retk) {
    goto retk;
  }    

 entry:
  salloc(sp, 1);
  sstore(sp, 0, void*, &&exitk);

 loop:
  { // polling
    if (--k == 0) {
      k = K;
      auto cur = mcsl::cycles::now();
      if (mcsl::cycles::diff(promotion_prev, cur) > tpalrts::kappa_cycles) {
        // try to promote
        promotion_prev = cur;
        if (! prmempty(prmtl, prmhd)) {
          char* sp_cont;
          uint64_t top;
          prmsplit(sp, prmtl, prmhd, sp_cont, top);
          char* sp_top = sp + top;
          uint64_t n2 = sload(sp_top, 0, uint64_t);
          sstore(sp_top, -1l, void*, &&exitk);
          auto dst0 = dst;
          auto dst1 = new uint64_t;
          auto dst2 = new uint64_t;
          auto s2 = tpalrts::snew();
          p->fork_join_promote([=] (tpalrts::promotable* p2) {
            fib_software_polling_loop(n2, dst2, p2, K, s2, fib_software_polling_entry, 0);
          }, [=] (tpalrts::promotable* p2) {
            sdelete(s2);
            auto f2 = *dst1 + *dst2;
            delete dst1;
            delete dst2;
            auto sj = s;
            sj.sp = sp_cont;
            fib_software_polling_loop(0, dst0, p2, K, sj, fib_software_polling_retk, f2);
          });
          dst = dst1;
        }
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

 exitk:
  sfree(sp, 1);
  *dst = f;
  
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
