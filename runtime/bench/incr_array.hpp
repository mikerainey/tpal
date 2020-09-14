#pragma once

#include <cstdint>

#include "mcsl_util.hpp"

#include "tpalrts_fiber.hpp"

#include "incr_array_rollforward_decls.hpp"

/*---------------------------------------------------------------------*/
/* Manual version */

extern
int64_t* incr_array_serial(int64_t* a, uint64_t lo, uint64_t hi);

static
int64_t incr_array_manual_T = 8096;

template <typename Scheduler>
class incr_array_manual : public tpalrts::fiber<Scheduler> {
public:

  using trampoline_type = enum { entry, exit };

  trampoline_type trampoline = entry;
  
  int64_t* a; uint64_t lo; uint64_t hi;

  incr_array_manual(int64_t* a, uint64_t lo, uint64_t hi)
    : tpalrts::fiber<Scheduler>([] (tpalrts::promotable*) { return mcsl::fiber_status_finish; }),
      a(a), lo(lo), hi(hi)
  { }

  mcsl::fiber_status_type exec() {
    switch (trampoline) {
    case entry: {
      if (hi-lo <= incr_array_manual_T) {
        incr_array_serial(a, lo, hi);
      } else {
        auto mid = (lo+hi)/2;
        auto f1 = new incr_array_manual(a, lo, mid);
        auto f2 = new incr_array_manual(a, mid, hi);
        tpalrts::fiber<Scheduler>::add_edge(f1, this);
        tpalrts::fiber<Scheduler>::add_edge(f2, this);
        f2->release();
        f1->release();
        tpalrts::stats::increment(tpalrts::stats_configuration::nb_promotions);
        tpalrts::stats::increment(tpalrts::stats_configuration::nb_promotions);
        trampoline = exit;
        return mcsl::fiber_status_pause;	  
      }
      break;
    }
    case exit: {
      break;
    }
    }
    return mcsl::fiber_status_finish;
  }

};

/*---------------------------------------------------------------------*/
/* Hardware-interrupt version */

extern
void incr_array_interrupt(int64_t* a, uint64_t lo, uint64_t hi, void* p);

int incr_array_handler(int64_t* a, uint64_t lo, uint64_t& hi, void* _p) {
  auto p = (tpalrts::promotable*)_p;
  if (hi - lo <= 1) {
    return 0;
  }
  auto mid = (lo + hi) / 2;
  p->async_finish_promote([=] (tpalrts::promotable* p2) {
    incr_array_interrupt(a, mid, hi, p2);
  });
  hi = mid;
  return 1;
}

/*---------------------------------------------------------------------*/
/* Software-polling version */

static
int64_t* incr_array_software_polling(int64_t* a, int64_t lo, int64_t hi, tpalrts::promotable* p, int64_t K=tpalrts::dflt_software_polling_K) {
  uint64_t promotion_prev = mcsl::cycles::now();
  int64_t lo_outer = lo;
  while (lo_outer != hi) {
    int64_t hi_outer = std::min(hi, lo_outer + K);
    incr_array_serial(a, lo_outer, hi_outer);
    lo_outer = hi_outer;
    { // polling
      auto cur = mcsl::cycles::now();
      if (mcsl::cycles::diff(promotion_prev, cur) > tpalrts::kappa_cycles) {
        // try to promote
        promotion_prev = cur;
        tpalrts::stats::increment(tpalrts::stats_configuration::nb_heartbeats);
        if (hi-lo_outer <= 1) {
          continue;
        }
        // promotion successful
        auto mid = (lo_outer+hi)/2;
        p->async_finish_promote([=] (tpalrts::promotable* p) {
          incr_array_software_polling(a, mid, hi, p, K);
        });
        hi = mid;
      }
    }
  }
  return a;
}

/*---------------------------------------------------------------------*/
/* Cilk version */

static
int64_t* incr_array_cilk(int64_t* a, int64_t lo, int64_t hi) {
#if defined(USE_CILK_PLUS)
  cilk_for (int64_t i = lo; i != hi; i++) {
    a[i]++;
  }
#else
  assert(false);
#endif
  return a;
}
