#include <cstdint>

void incr_array_serial(int64_t* a, uint64_t lo, uint64_t hi) {
  for (; lo != hi; lo++) {
    a[lo]++;
  }
}

#define MIN(x, y) ((x < y) ? x : y)

#define likely(x)      __builtin_expect(!!(x), 1)
#define unlikely(x)    __builtin_expect(!!(x), 0)

#define D 128

extern volatile
int heartbeat;
 
extern
int incr_array_handler(int64_t* a, uint64_t lo, uint64_t& hi, void* p);

void incr_array_interrupt(int64_t* a, uint64_t lo, uint64_t hi, void* p) {
  if (! (lo < hi)) {
    return;
  }
  for (;;) {
    uint64_t lo2 = lo;
    uint64_t hi2 = MIN(lo + D, hi);
    for (; lo2 != hi2; lo2++) {
      a[lo2]++;
    }
    lo = lo2;
    if (unlikely(! (lo < hi))) {
      break;
    }
    if (unlikely(heartbeat)) { 
      incr_array_handler(a, lo, hi, p);
    }
  }
}
