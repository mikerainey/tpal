/*
compiled using
https://godbolt.org/
gcc 9.3
-O3 -m64 -march=x86-64 -mtune=x86-64 -fopt-info-vec -mavx -fomit-frame-pointer -DNDEBUG
./gen_rollforward.sh plus_reduce_array pra
 */

#include <stdint.h>

int64_t plus_reduce_array_serial(int64_t* a, uint64_t lo, uint64_t hi) {
  int64_t r = 0;
  for (uint64_t i = lo; i != hi; i++) {
    r += a[i];
  }
  return r;
}

#define MIN(x, y) ((x < y) ? x : y)

#define likely(x)      __builtin_expect(!!(x), 1)
#define unlikely(x)    __builtin_expect(!!(x), 0)

#define D 2048

extern volatile
int heartbeat;

extern
int loop_handler(int64_t* a, uint64_t lo, uint64_t hi, uint64_t r, int64_t* dst, void* p);

void plus_reduce_array_interrupt(int64_t* a, uint64_t lo, uint64_t hi, uint64_t r, int64_t* dst, void* p) {
  if (! (lo < hi)) {
    goto exit;
  }
  for (; ; ) {
    uint64_t lo2 = lo;
    uint64_t hi2 = MIN(lo + D, hi);
    for (; lo2 < hi2; lo2++) {
      r += a[lo2];
    }
    lo = lo2;
    if (unlikely(! (lo < hi))) {
      break;
    }
    if (unlikely(heartbeat)) { 
      if (loop_handler(a, lo, hi, r, dst, p)) {
        return;
      }
    }
  }
 exit:
  *dst = r;
}
