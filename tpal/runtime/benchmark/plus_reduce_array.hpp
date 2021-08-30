#pragma once

#ifdef USE_CILK_PLUS
#include <cilk/cilk.h>
#include <cilk/cilk_api.h>
#include <cilk/reducer_opadd.h>
#endif
#include <cstdint>

#include "benchmark.hpp"
#include "plus_reduce_array_rollforward_decls.hpp"

/*---------------------------------------------------------------------*/
/* Manual version */

double plus_reduce_array_serial(double* a, uint64_t lo, uint64_t hi);

/*---------------------------------------------------------------------*/
/* Hardware-interrupt version */

void plus_reduce_array_interrupt(double* a, uint64_t lo, uint64_t hi, double r, double* dst, void*);

int loop_handler(double* a, uint64_t lo, uint64_t hi, double r, double* dst, void*) {
  return 0; 
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
  
auto bench_pre() -> void {
  rollforward_table = {
    #include "plus_reduce_array_rollforward_map.hpp"
  };
  a = (double*)malloc(sizeof(double)*nb_items);
  for (uint64_t i = 0; i < nb_items; i++) {
    a[i] = 1.0;
  }
}

auto bench_body_heartbeat() -> void {
  plus_reduce_array_interrupt(a, 0, nb_items, 0, &result, nullptr);
}

auto bench_body_serial() -> void {
  result = plus_reduce_array_serial(a, 0, nb_items);
}

auto bench_post() -> void {
  free(a);
}

auto bench_body_cilk() {
  result = plus_reduce_array_cilk(a, 0, nb_items);
};

} // plus_reduce_array
