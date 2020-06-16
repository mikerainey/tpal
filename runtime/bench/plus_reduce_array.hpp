#pragma once

#include <cstdint>

#include "mcsl_util.hpp"

#include "tpalrts_fiber.hpp"

/*---------------------------------------------------------------------*/
/* Manual version */

static
int64_t plus_reduce_array_serial(int64_t* a, int64_t lo, int64_t hi) {
  int64_t r = 0;
  for (int64_t i = lo; i != hi; i++) {
    r += a[i];
  }
  return r;
}

static
int64_t plus_reduce_array_manual_T = 8096;

template <typename Scheduler>
class plus_reduce_array_manual : public tpalrts::fiber<Scheduler> {
public:

  using trampoline_type = enum { entry, exit };

  trampoline_type trampoline = entry;
  
  int64_t* a; int64_t lo; int64_t hi; int64_t* dst;
  int64_t r1, r2;

  plus_reduce_array_manual(int64_t* a, int64_t lo, int64_t hi, int64_t* dst)
    : tpalrts::fiber<Scheduler>([] (tpalrts::promotable*) { return mcsl::fiber_status_finish; }),
      a(a), lo(lo), hi(hi), dst(dst)
  { }

  mcsl::fiber_status_type exec() {
    switch (trampoline) {
    case entry: {
      if (hi-lo <= plus_reduce_array_manual_T) {
        *dst = plus_reduce_array_serial(a, lo, hi);
      } else {
        int64_t mid = (lo+hi)/2;
        auto f1 = new plus_reduce_array_manual(a, lo, mid, &r1);
        auto f2 = new plus_reduce_array_manual(a, mid, hi, &r2);
        tpalrts::fiber<Scheduler>::add_edge(f1, this);
        tpalrts::fiber<Scheduler>::add_edge(f2, this);
        f1->release();
        f2->release();
        tpalrts::stats::increment(tpalrts::stats_configuration::nb_promotions);
        tpalrts::stats::increment(tpalrts::stats_configuration::nb_promotions);
        trampoline = exit;
        return mcsl::fiber_status_pause;	  
      }
      break;
    }
    case exit: {
      *dst = r1 + r2;
      break;
    }
    }
    return mcsl::fiber_status_finish;
  }

};

/*---------------------------------------------------------------------*/
/* Hardware-interrupt version */

extern "C"
void plus_reduce_array_interrupt_l0();
extern "C"
void plus_reduce_array_interrupt_l1();
extern "C"
void plus_reduce_array_interrupt_l2();
extern "C"
void plus_reduce_array_interrupt_l3();

extern "C"
void plus_reduce_array_interrupt_rf_l0();
extern "C"
void plus_reduce_array_interrupt_rf_l1();
extern "C"
void plus_reduce_array_interrupt_rf_l2();
extern "C"
void plus_reduce_array_interrupt_rf_l3();

extern "C"
void plus_reduce_array_interrupt(int64_t*, int64_t, int64_t, int64_t*, tpalrts::promotable*);
extern "C"
void plus_reduce_array_interrupt_promote(int64_t* a, int64_t lo, int64_t* ptr_hi, int64_t** ptr_dst, tpalrts::promotable* p);

void plus_reduce_array_interrupt_promote(int64_t* a, int64_t lo, int64_t* ptr_hi, int64_t** ptr_dst, tpalrts::promotable* p) {
  auto hi = *ptr_hi;
  if (hi-lo <= 1) {
    return;
  }
  auto mid = (lo+hi)/2;
  *ptr_hi = mid;
  auto r1 = new int64_t;
  auto r2 = new int64_t;
  auto r0 = *ptr_dst;
  *ptr_dst = r1;
  p->fork_join_promote([=] (tpalrts::promotable* p2) {
    plus_reduce_array_interrupt(a, mid, hi, r2, p2);
  }, [=] (tpalrts::promotable*) {
    *r0 = *r1 + *r2;
    delete r1;
    delete r2;
  });
}

/*---------------------------------------------------------------------*/
/* Software-polling version */

static
void plus_reduce_array_software_polling(int64_t* a, int64_t lo, int64_t hi, int64_t* dst, tpalrts::promotable* p) {
  int64_t result = 0;
  int64_t K = deepsea::cmdline::parse_or_default_int("software_polling_K", 128);
  uint64_t promotion_prev = mcsl::cycles::now();
  int64_t lo_outer = lo;
  while (lo_outer != hi) {
    int64_t hi_outer = std::min(hi, lo_outer + K);
    result += plus_reduce_array_serial(a, lo_outer, hi_outer);
    lo_outer = hi_outer;
    { // polling
      auto cur = mcsl::cycles::now();
      if (mcsl::cycles::diff(promotion_prev, cur) > tpalrts::kappa_cycles) {
        // try to promote
        promotion_prev = cur;
        if (hi-lo_outer <= 1) {
          continue;
        }
        // promotion successful
        auto mid = (lo_outer+hi)/2;
	auto dst1 = new int64_t;
	auto dst2 = new int64_t;
	auto dst0 = dst;
	dst = dst1;
        p->fork_join_promote([=] (tpalrts::promotable* p2) {
          plus_reduce_array_software_polling(a, mid, hi, dst2, p2);
        }, [=] (tpalrts::promotable*) {
          *dst0 = *dst1 + *dst2;
	  delete dst1;
	  delete dst2;
	});
        hi = mid;
      }
    }
  }
  *dst = result;
}

/*---------------------------------------------------------------------*/
/* Cilk version */

static
int64_t plus_reduce_array_cilk(int64_t* a, int64_t lo, int64_t hi) {
#if defined(USE_CILK_PLUS)
  cilk::reducer_opadd<int> sum(0);
  cilk_for (int64_t i = 0; i != hi; i++) {
    *sum += a[i];
  }
  return sum.get_value();
#else
  mcsl::die("Cilk unsupported\n");
#endif
  return 0;
}
