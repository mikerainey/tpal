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

#include "floyd_warshall_rollforward_decls.hpp"

#define MIN(x, y) ((x < y) ? x : y)

#define SUB(array, row_sz, i, j) (array[i * row_sz + j])

#define INF           INT_MAX-1

extern
void floyd_warshall_serial(int* dist, int vertices);

extern
void floyd_warshall_interrupt(int* dist, int vertices, int via_lo, int via_hi, void* p);

extern
void floyd_warshall_interrupt_from(int* dist, int vertices, int via_lo, int via_hi, int from_lo, int from_hi, void* p);

extern
void floyd_warshall_interrupt_to(int* dist, int vertices, int via_lo, int via_hi, int from_lo, int from_hi, int to_lo, int to_hi, void* p);

int to_loop_handler(int* dist, int vertices, int via_lo, int via_hi, int from_lo, int from_hi, int to_lo, int to_hi, void* _p) {
  tpalrts::promotable* p = (tpalrts::promotable*)_p;
  if ((via_hi - via_lo) <= 0) {
    return 0;
  }
  auto nb_from = from_hi - from_lo;
  if (nb_from == 0) {
    return 0;
  }
  auto via_hi2 = via_lo + 1;
  assert((via_hi2 - via_lo) == 1);
  assert((via_hi - via_hi2) >= 0);
  if (nb_from == 1) {
    auto nb_to = to_lo - to_hi;
    if (nb_to <= 1) {
      return 0;
    }
    assert(nb_to >= 2);
    auto to_mid = (to_lo + to_hi) / 2;
    p->fork_join_promote2([=] (tpalrts::promotable* p2) {
      floyd_warshall_interrupt_to(dist, vertices, via_lo, via_hi2, from_lo, from_hi, to_lo, to_mid, p2);
    }, [=] (tpalrts::promotable* p2) {
      floyd_warshall_interrupt_to(dist, vertices, via_lo, via_hi2, from_lo, from_hi, to_mid, to_hi, p2);
    }, [=] (tpalrts::promotable* p2) {
      floyd_warshall_interrupt(dist, vertices, via_hi2, via_hi, p2);
    });
    return 1;
  }
  assert(nb_from >= 2);
  auto ff = [=] (tpalrts::promotable* p2) {
    floyd_warshall_interrupt_to(dist, vertices, via_lo, via_hi2, from_lo, from_hi, to_lo, to_hi, p2);
  };
  auto from_mid = (from_lo + from_hi) / 2;
  p->fork_join_promote3(ff, [=] (tpalrts::promotable* p2) {
    floyd_warshall_interrupt_from(dist, vertices, via_lo, via_hi2, from_lo, from_mid, p2);
  }, [=] (tpalrts::promotable* p2) {
    floyd_warshall_interrupt_from(dist, vertices, via_lo, via_hi2, from_mid, from_hi, p2);
  }, [=] (tpalrts::promotable* p2) {
    floyd_warshall_interrupt(dist, vertices, via_hi2, via_hi, p2);
  });
  return 1;
}

int from_loop_handler(int* dist, int vertices, int via_lo, int via_hi, int from_lo, int from_hi, void* p) {
  return to_loop_handler(dist, vertices, via_lo, via_hi, from_lo, from_hi, 0, 0, p);
}

int from_from_loop_handler(int* dist, int vertices, int via_lo, int via_hi, int from_lo, int from_hi, void* p) {
  return to_loop_handler(dist, vertices, via_lo, via_hi, from_lo, from_hi, 0, 0, p);
}

int to_to_loop_handler(int* dist, int vertices, int via_lo, int via_hi, int from_lo, int from_hi, int to_lo, int to_hi, void* p) {
  return to_loop_handler(dist, vertices, via_lo, via_hi, from_lo, from_hi, to_lo, to_hi, p);
}

int from_to_loop_handler(int* dist, int vertices, int via_lo, int via_hi, int from_lo, int from_hi, int to_lo, int to_hi, void* p) {
  return to_loop_handler(dist, vertices, via_lo, via_hi, from_lo, from_hi, to_lo, to_hi, p);
}

void floyd_warshall_cilk(int* dist, int vertices) {
#if defined(USE_CILK_PLUS)
  for(int via = 0; via < vertices; via++) {
    cilk_for(int from = 0; from < vertices; from++) {
      cilk_for(int to = 0; to < vertices; to++) {
        if ((from != to) && (from != via) && (to != via)) {
          SUB(dist, vertices, from, to) = std::min(SUB(dist, vertices, from, to), SUB(dist, vertices, from, via) + SUB(dist, vertices, via, to));
        }
      }
    }
  }
#endif
}
