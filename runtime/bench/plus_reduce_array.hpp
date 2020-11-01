#pragma once

#ifdef USE_CILK_PLUS
#include <cilk/cilk.h>
#include <cilk/cilk_api.h>
#include <cilk/reducer_opadd.h>
#endif
#include <cstdint>

#include "mcsl_util.hpp"

#include "tpalrts_fiber.hpp"
#include "plus_reduce_array_rollforward_decls.hpp"

/*---------------------------------------------------------------------*/
/* Manual version */

double plus_reduce_array_serial(double* a, uint64_t lo, uint64_t hi);

static
uint64_t plus_reduce_array_manual_T = 8096;

template <typename Scheduler>
class plus_reduce_array_manual : public tpalrts::fiber<Scheduler> {
public:

  using trampoline_type = enum { entry, exit };

  trampoline_type trampoline = entry;
  
  double* a; uint64_t lo; uint64_t hi; double* dst;
  double r1, r2;

  plus_reduce_array_manual(double* a, uint64_t lo, uint64_t hi, double* dst)
    : tpalrts::fiber<Scheduler>([] (tpalrts::promotable*) { return mcsl::fiber_status_finish; }),
      a(a), lo(lo), hi(hi), dst(dst)
  { }

  mcsl::fiber_status_type exec() {
    switch (trampoline) {
    case entry: {
      if (hi-lo <= plus_reduce_array_manual_T) {
        *dst = plus_reduce_array_serial(a, lo, hi);
      } else {
        uint64_t mid = (lo+hi)/2;
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

void plus_reduce_array_interrupt(double* a, uint64_t lo, uint64_t hi, uint64_t r, double* dst, void* p);

int loop_handler(double* a, uint64_t lo, uint64_t hi, uint64_t r, double* dst, void* _p) {
  tpalrts::promotable* p = (tpalrts::promotable*)_p;
  tpalrts::stats::increment(tpalrts::stats_configuration::nb_heartbeats);
  if ((hi - lo) <= 1) {
    return 0;
  }
  auto mid = (lo + hi) / 2;
  using dst_rec_type = std::pair<double, double>;
  dst_rec_type* dst_rec;
  tpalrts::arena_block_type* dst_blk;
  std::tie(dst_rec, dst_blk) = tpalrts::alloc_arena<dst_rec_type>();
  p->fork_join_promote2([=] (tpalrts::promotable* p2) {
    plus_reduce_array_interrupt(a, lo, mid, r, &(dst_rec->first), p2);
  }, [=] (tpalrts::promotable* p2) {
    plus_reduce_array_interrupt(a, mid, hi, 0, &(dst_rec->second), p2);
  }, [=] (tpalrts::promotable*) {
    *dst = dst_rec->first + dst_rec->second;
    decr_arena_block(dst_blk);
  });
  return 1;
}

/*---------------------------------------------------------------------*/
/* Cilk version */

static
double plus_reduce_array_cilk(double* a, uint64_t lo, uint64_t hi) {
#if defined(USE_CILK_PLUS)
  cilk::reducer_opadd<int> sum(0);
  cilk_for (uint64_t i = 0; i != hi; i++) {
    *sum += a[i];
  }
  return sum.get_value();
#else
  //mcsl::die("Cilk unsupported\n");
#endif
  return 0;
}

/*---------------------------------------------------------------------*/

namespace plus_reduce_array {

using namespace tpalrts;

char* name = "plus_reduce_array";
  
uint64_t nb_items = 100 * 1000 * 1000;
double* a;
double result = 0.0;
  
auto bench_pre(promotable*) -> void {
  rollforward_table = {
    #include "plus_reduce_array_rollforward_map.hpp"
  };
  a = (double*)malloc(sizeof(double)*nb_items);
  for (uint64_t i = 0; i < nb_items; i++) {
    a[i] = 1.0;
  }
}

auto bench_body_interrupt(promotable* p) -> void {
  plus_reduce_array_interrupt(a, 0, nb_items, 0, &result, p);
}

auto bench_body_software_polling(promotable* p) -> void {

}

auto bench_body_serial(promotable* p) -> void {
  result = plus_reduce_array_serial(a, 0, nb_items);
}

auto bench_post(promotable*) -> void {
  free(a);
}

  auto bench_body_cilk() {
  result = plus_reduce_array_cilk(a, 0, nb_items);
};

} // plus_reduce_array
