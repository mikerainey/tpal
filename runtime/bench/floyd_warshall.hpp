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

// code 

#ifndef max_vertices
#define max_vertices 8192
#endif
#define INF           INT_MAX-1

int dist[max_vertices][max_vertices];

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
