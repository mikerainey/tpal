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

#define MIN(x, y) ((x < y) ? x : y)

#ifndef max_vertices
#define max_vertices 8192
#endif

#define SUB(array, i, j) (array[i * max_vertices + j])

#define INF           INT_MAX-1

extern
void floyd_warshall_serial(int* dist, int vertices);

extern
void floyd_warshall_interrupt(int* dist, int vertices);

int from_loop_handler(int* dist, int vertices, int via_lo, int via_hi, int from_lo, int from_hi, void* p) {
  return 0;
}

int to_loop_handler(int* dist, int vertices, int via_lo, int via_hi, int from_lo, int from_hi, int to_lo, int to_hi, void* p) {
  return 0;
}

int from_from_loop_handler(int* dist, int vertices, int via_lo, int via_hi, int from_lo, int from_hi, void* p) {
  return 0;
}

int to_to_loop_handler(int* dist, int vertices, int via_lo, int via_hi, int from_lo, int from_hi, int to_lo, int to_hi, void* p) {
  return 0;
}

int from_to_loop_handler(int* dist, int vertices, int via_lo, int via_hi, int from_lo, int from_hi, int to_lo, int to_hi, void* p) {
  return 0;
}

void floyd_warshall_cilk(int* dist int vertices) {
#if defined(USE_CILK_PLUS)
  for(int via = 0; via < vertices; via++) {
    cilk_for(int from = 0; from < vertices; from++) {
      cilk_for(int to = 0; to < vertices; to++) {
        if ((from != to) && (from != via) && (to != via)) {
          SUB(dist, from, to) = std::min(SUB(dist, from, to), SUB(dist, from, via) + SUB(dist, via, to));
        }
      }
    }
  }
#endif
}
