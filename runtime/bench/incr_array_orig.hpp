#include <cstdint>
#include <algorithm>

void incr_array_serial(double* a, uint64_t lo, uint64_t hi) {
  for (; lo != hi; lo++) {
    a[lo] += 1.0;
  }
}

#define unlikely(x)    __builtin_expect(!!(x), 0)

#define D 64

extern volatile
int heartbeat;
 
extern
int incr_array_handler(double* a, uint64_t lo, uint64_t& hi, void* p);

void incr_array_interrupt(double* a, uint64_t lo, uint64_t hi, void* p) {
  if (! (lo < hi)) {
    return;
  }
  for (;;) {
    uint64_t lo2 = lo;
    uint64_t hi2 = std::min(lo + D, hi);
    for (; lo2 != hi2; lo2++) {
      a[lo2] += 1.0;
    }
    lo = lo2;
    if (! (lo < hi)) {
      break;
    }
    if (unlikely(heartbeat)) { 
      incr_array_handler(a, lo, hi, p);
    }
  }
}
