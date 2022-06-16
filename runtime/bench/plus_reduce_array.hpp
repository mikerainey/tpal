#pragma once

#ifdef USE_CILK_PLUS
#include <cilk/cilk.h>
#include <cilk/cilk_api.h>
#include <cilk/reducer_opadd.h>
#endif
#include <cstdint>

#include "mcsl_util.hpp"

#include "tpalrts_fiber.hpp"
#include <fcntl.h>

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

double plus_reduce_array_serial(double* a, uint64_t lo, uint64_t hi) {
  double r = 0.0;
  for (uint64_t i = lo; i != hi; i++) {
    r += a[i];
  }
  return r;
}

#define unlikely(x)    __builtin_expect(!!(x), 0)

#define D 64

void plus_reduce_array_interrupt(double* a, uint64_t lo, uint64_t hi, double r, double* dst, void* p);

/*
void dump_table() {
  int fd = open("rf.bin", O_WRONLY|O_CREAT, 0666);
  int n = write(fd,rollforward_table,rollforward_table_size*16);
  assert(n == rollforward_table_size*16);
  close(fd);
  fd = open("rb.bin", O_WRONLY|O_CREAT, 0666);
  n = write(fd,rollback_table,rollforward_table_size*16);
  close(fd);
  assert(n == rollforward_table_size*16);
  }*/

void __attribute__((preserve_all, noinline)) __rf_handle_plus_reduce_array(double* a, uint64_t lo, uint64_t hi, double r, double* dst, bool& promoted, void* _p) {
  tpalrts::promotable* p = (tpalrts::promotable*)_p;
  if ((hi - lo) <= 1) {
    promoted = false;
  } else {
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
    promoted = true;
  }
  void* ra_dst = __builtin_return_address(0);
  void* ra_src = NULL;
  // Binary search over the rollbackwards
  {
    int64_t i = 0, j = (int64_t)rollforward_table_size - 1;
    int64_t k;
    while (i <= j) {
      k = i + ((j - i) / 2);
      if ((uint64_t)rollback_table[k].from == (uint64_t)ra_dst) {
	ra_src = rollback_table[k].to;
	break;
      } else if ((uint64_t)rollback_table[k].from < (uint64_t)ra_dst) {
	i = k + 1;
      } else {
	j = k - 1;
      }
    }
  }
  if (ra_src != NULL) {
    void* fa = __builtin_frame_address(0);
    void** rap = (void**)((char*)fa + 8);
    *rap = ra_src;
  } else {
    printf("oops! %lx %lu\n\n",ra_dst, rollback_table_size);

    
    for (uint64_t i = 0; i < rollback_table_size; i++) {
      if (rollforward_table[i].from == ra_dst) {
	ra_src = rollforward_table[i].to;
	break;
      }
    }

    if (ra_src == NULL) {
      printf("found no entry in rollforward table!\n");
    }
    //    dump_table();
    exit(1);
  }
}

void plus_reduce_array_interrupt(double* a, uint64_t lo, uint64_t hi, double r, double* dst, void* p) {
  if (! (lo < hi)) {
    goto exit;
  }
  for (; ; ) {
    uint64_t lo2 = lo;
    uint64_t hi2 = std::min(lo + D, hi);
    for (; lo2 < hi2; lo2++) {
      r += a[lo2];
    }
    lo = lo2;
    if (! (lo < hi)) {
      break;
    }
    bool promoted = false;
    __rf_handle_plus_reduce_array(a, lo, hi, r, dst, promoted, p);
    if (unlikely(promoted)) {
      return;
    }
  }
 exit:
  *dst = r;
}

/*---------------------------------------------------------------------*/
/* Cilk version */

static
double plus_reduce_array_cilk(double* a, uint64_t lo, uint64_t hi) {
#if defined(USE_CILK_PLUS)
  cilk::reducer_opadd<double> sum(0);
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

auto rf_well_formed_check() {
  if (rollforward_table_size == 0) {
    return;
  }
  
  uint64_t rff1 = (uint64_t)rollforward_table[0].from;
  for (uint64_t i = 1; i < rollforward_table_size; i++) {
    uint64_t rff2 = (uint64_t)rollforward_table[i].from;
    // check increasing order of 'from' keys in rollforwad table
    if (rff2 < rff1) {
      printf("bogus ordering in rollforward table rff2=%lx rff1=%lx\n",rff2,rff1);
      //      exit(1);
    }
    // check that rollback table is an inverse mapping of the
    // rollforward table
    uint64_t rft2 = (uint64_t)rollforward_table[i].to;
    uint64_t rbf2 = (uint64_t)rollback_table[i].from;
    uint64_t rbt2 = (uint64_t)rollback_table[i].to;
    if (rft2 != rbf2) {
      printf("bogus mapping rft2=%lx rbf2=%lx\n",rft2,rbf2);
      exit(1);
    }
    if (rff2 != rbt2) {
      printf("bogus mapping!\n");
      exit(1);
    }
    rff1 = rff2;
  }
  //  printf("passed rf table checks\n");
}
  
auto bench_pre(promotable*) -> void {
  rf_well_formed_check();
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
