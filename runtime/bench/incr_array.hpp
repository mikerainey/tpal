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
  tpalrts::stats::increment(tpalrts::stats_configuration::nb_heartbeats);
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

/*---------------------------------------------------------------------*/

namespace tpalrts {
namespace incr_array {
  
uint64_t nb_items = 100 * 1000 * 1000;
int64_t* a;
  
auto bench_pre(promotable*) -> void {
  rollforward_table = {
    #include "incr_array_rollforward_map.hpp"
  };
  a = (int64_t*)malloc(sizeof(int64_t)*nb_items);
  if (a == nullptr) {
    return;
  }
  for (int64_t i = 0; i < nb_items; i++) {
    a[i] = 0;
  }
}

auto bench_body_interrupt(promotable* p) -> void {
  incr_array_interrupt(a, 0, nb_items, p);
}

auto bench_body_software_polling(promotable* p) -> void {
  
}

auto bench_body_serial(promotable* p) -> void {
  incr_array_serial(a, 0, nb_items);
}

auto bench_post(promotable*) -> void {
#ifndef NDEBUG
  int64_t m = 0;
  for (int64_t i = 0; i < nb_items; i++) {
    m += a[i];
  }
  assert(m == nb_items);
#endif
  free(a);
}

auto bench_body_cilk() {
  incr_array_cilk(a, 0, nb_items);
};

} // incr_array
}
