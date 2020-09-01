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

extern "C"
void floyd_warshall_interrupt(int* dist, int vertices);

/*
https://godbolt.org/

extern
void outer_loop_handler(int via, int* from);

void floyd_warshall_interrupt(int* dist, int vertices) {
  for(int via = 0; via < vertices; via++) {
    for(int from = 0; from < vertices; ) {
      for(int to = 0; to < vertices; to++) {
        if ((from != to) && (from != via) && (to != via)) {
          SUB(dist, from, to) = MIN(SUB(dist, from, to), SUB(dist, from, via) + SUB(dist, via, to));
        }
      }
      from++;
      if ((from % 16) == 0) { outer_loop_handler(via, &from); }
    }
  }
}
 */

void floyd_warshall_serial(int vertices) {
  for(int via = 0; via < vertices; via++) {
    for(int from = 0; from < vertices; from++) {
      for(int to = 0;to < vertices; to++) {
        if ((from != to) && (from != via) && (to != via)) {
          dist[from][to] = std::min(dist[from][to], dist[from][via] + dist[via][to]);
        }
      }
    }
  }
}

void floyd_warshall_cilk(int vertices) {
#if defined(USE_CILK_PLUS)
  for(int via = 0; via < vertices; via++) {
    cilk_for(int from = 0; from < vertices; from++) {
      cilk_for(int to = 0; to < vertices; to++) {
        if ((from != to) && (from != via) && (to != via)) {
          dist[from][to] = std::min(dist[from][to], dist[from][via] + dist[via][to]);
        }
      }
    }
  }
#endif
}
