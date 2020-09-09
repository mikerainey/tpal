/*
compiled using
https://godbolt.org/
gcc 9.3
-O3 --std=c++17 -m64 -march=x86-64 -mtune=x86-64 -fopt-info-vec -mavx -fomit-frame-pointer -DNDEBUG
 */

#include <algorithm>

#define SUB(array, row_sz, i, j) (array[i * row_sz + j])

void floyd_warshall_serial(int* dist, int vertices) {
  for(int via = 0; via < vertices; via++) {
    for(int from = 0; from < vertices; from++) {
      for(int to = 0; to < vertices; to++) {
        if ((from != to) && (from != via) && (to != via)) {
          SUB(dist, vertices, from, to) = std::min(SUB(dist, vertices, from, to), SUB(dist, vertices, from, via) + SUB(dist, vertices, via, to));
        }
      }
    }
  }
}

#define MIN(x, y) ((x < y) ? x : y)

#define likely(x)      __builtin_expect(!!(x), 1)
#define unlikely(x)    __builtin_expect(!!(x), 0)

#define D_from 64
#define D_to 128

extern volatile 
int heartbeat;

extern
int from_loop_handler(int* dist, int vertices, int via_lo, int via_hi, int from_lo, int from_hi, void* p);

extern
int to_loop_handler(int* dist, int vertices, int via_lo, int via_hi, int from_lo, int from_hi, int to_lo, int to_hi, void* p);

void floyd_warshall_interrupt(int* dist, int vertices, int via_lo, int via_hi, void* p) {
  for(; via_lo < via_hi; via_lo++) {
    int from_lo = 0;
    int from_hi = vertices;
    if (! (from_lo < from_hi)) {
      return;
    }
    for (; ; ) {
      int from_lo2 = from_lo;
      int from_hi2 = MIN(from_lo + D_from, from_hi);
      for(; from_lo2 < from_hi2; from_lo2++) {
        int to_lo = 0;
        int to_hi = vertices;
        if (! (to_lo < to_hi)) {
          return;
        }
        for (; ; ) {
          int to_lo2 = to_lo;
          int to_hi2 = MIN(to_lo + D_to, to_hi);
          for(; to_lo2 < to_hi2; to_lo2++) {
            if ((from_lo2 != to_lo2) && (from_lo2 != via_lo) && (to_lo2 != via_lo)) {
              SUB(dist, vertices, from_lo2, to_lo2) = std::min(SUB(dist, vertices, from_lo2, to_lo2), SUB(dist, vertices, from_lo2, via_lo) + SUB(dist, vertices, via_lo, to_lo2));
            }
          }
          to_lo = to_lo2;
          if (unlikely(! (to_lo < to_hi))) {
            break;
          }
          if (unlikely(heartbeat)) {
            if (to_loop_handler(dist, vertices, via_lo, via_hi, from_lo2, from_hi, to_lo, to_hi, p)) {
              return;
            }
          }
        }
      }
      from_lo = from_lo2;
      if (unlikely(! (from_lo < from_hi))) {
        break;
      }
      if (unlikely(heartbeat)) {
        if (from_loop_handler(dist, vertices, via_lo, via_hi, from_lo, from_hi, p)) {
          return;
        }
      }
    }
  }
}

extern
int from_from_loop_handler(int* dist, int vertices, int via_lo, int via_hi, int from_lo, int from_hi, void* p);

extern
int from_to_loop_handler(int* dist, int vertices, int via_lo, int via_hi, int from_lo, int from_hi, int to_lo, int to_hi, void* p);

void floyd_warshall_interrupt_from(int* dist, int vertices, int via_lo, int via_hi, int from_lo, int from_hi, void* p) {
  if (! (from_lo < from_hi)) {
    return;
  }
  for (; ; ) {
    int from_lo2 = from_lo;
    int from_hi2 = MIN(from_lo + D_from, from_hi);
    for(; from_lo2 < from_hi2; from_lo2++) {
      int to_lo = 0;
      int to_hi = vertices;
      if (! (to_lo < to_hi)) {
       return;
      }
      for (; ; ) {
        int to_lo2 = to_lo;
        int to_hi2 = MIN(to_lo + D_to, to_hi);
        for(; to_lo2 < to_hi2; to_lo2++) {
          if ((from_lo2 != to_lo2) && (from_lo2 != via_lo) && (to_lo2 != via_lo)) {
            SUB(dist, vertices, from_lo2, to_lo2) = std::min(SUB(dist, vertices, from_lo2, to_lo2), SUB(dist, vertices, from_lo2, via_lo) + SUB(dist, vertices, via_lo, to_lo2));
          }
        }
        to_lo = to_lo2;
        if (unlikely(! (to_lo < to_hi))) {
          break;
        }
        if (unlikely(heartbeat)) {
          if (from_to_loop_handler(dist, vertices, via_lo, via_hi, from_lo2, from_hi, to_lo, to_hi, p)) {
            return;
          }
        }
      }
    }
    from_lo = from_lo2;
    if (unlikely(! (from_lo < from_hi))) {
      break;
    }
    if (unlikely(heartbeat)) {
      if (from_from_loop_handler(dist, vertices, via_lo, via_hi, from_lo, from_hi, p)) {
        return;
      }
    }
  }
}

extern
int to_to_loop_handler(int* dist, int vertices, int via_lo, int via_hi, int from_lo, int from_hi, int to_lo, int to_hi, void* p);

void floyd_warshall_interrupt_to(int* dist, int vertices, int via_lo, int via_hi, int from_lo, int from_hi, int to_lo, int to_hi, void* p) {
  if (! (to_lo < to_hi)) {
    return;
  }
  for (; ; ) {
    int to_lo2 = to_lo;
    int to_hi2 = MIN(to_lo + D_to, to_hi);
    for(; to_lo2 < to_hi2; to_lo2++) {
      if ((from_lo != to_lo2) && (from_lo != via_lo) && (to_lo2 != via_lo)) {
        SUB(dist, vertices, from_lo, to_lo2) = std::min(SUB(dist, vertices, from_lo, to_lo2), SUB(dist, vertices, from_lo, via_lo) + SUB(dist, vertices, via_lo, to_lo2));
      }
    }
    to_lo = to_lo2;
    if (unlikely(! (to_lo < to_hi))) {
      break;
    }
    if (unlikely(heartbeat)) {
      if (to_to_loop_handler(dist, vertices, via_lo, via_hi, from_lo, from_hi, to_lo, to_hi, p)) {
        return;
      }
    }
  }
}
