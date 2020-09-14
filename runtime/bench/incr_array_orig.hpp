int64_t* incr_array_interrupt(int64_t* a, uint64_t lo, uint64_t hi, void* p) {
  for (uint64_t i = lo; i != hi; i++) {
    a[i]++;
  }
  return a;
}
