/*
compiled using
https://godbolt.org/
gcc 9.3
--std=c++17 -O3 -m64 -march=x86-64 -mtune=x86-64 -fomit-frame-pointer -fno-asynchronous-unwind-tables -DNDEBUG
./gen_rollforward.sh spmv spmv
 */


#include <stdint.h>
#include <algorithm>

void spmv_serial(
  double* val,
  uint64_t* row_ptr,
  uint64_t* col_ind,
  double* x,
	double* y,
	uint64_t n) {
  for (int64_t i = 0; i < n; i++) { // row loop
    double r = 0.0;
    for (int64_t k = row_ptr[i]; k < row_ptr[i + 1]; k++) { // col loop
      r += val[k] * x[col_ind[k]];
    }
    y[i] = r;
  }
}

#define unlikely(x)    __builtin_expect(!!(x), 0)

#define D 1024

extern volatile 
int heartbeat;

extern
int row_loop_handler(
  double* val,
  uint64_t* row_ptr,
  uint64_t* col_ind,
  double* x,
  double* y,
  uint64_t row_lo,
  uint64_t row_hi,
  void* p);

extern
int col_loop_handler(
  double* val,
  uint64_t* row_ptr,
  uint64_t* col_ind,
  double* x,
  double* y,
  uint64_t row_lo,
  uint64_t row_hi,
  uint64_t col_lo,
  uint64_t col_hi,
  double r,
  void* p);

void spmv_interrupt(
  double* val,
  uint64_t* row_ptr,
  uint64_t* col_ind,
  double* x,
  double* y,
  uint64_t row_lo,
  uint64_t row_hi,
  void* p) {
  if (! (row_lo < row_hi)) { // row loop
    return;
  }
  for (; ; ) { 
    double r = 0.0;
    uint64_t col_lo = row_ptr[row_lo];
    uint64_t col_hi = row_ptr[row_lo + 1];
    if (! (col_lo < col_hi)) { // col loop (1)
      goto exit_col_loop;
    }
    for (; ; ) {
      uint64_t col_lo2 = col_lo;
      uint64_t col_hi2 = std::min(col_lo + D, col_hi);
      for (; col_lo2 < col_hi2; col_lo2++) { // col loop (2)
        r += val[col_lo2] * x[col_ind[col_lo2]];
      }
      col_lo = col_lo2;
      if (! (col_lo < col_hi)) {
        break;
      }
      if (unlikely(heartbeat)) {
        if (col_loop_handler(val, row_ptr, col_ind, x, y, row_lo, row_hi, col_lo, col_hi, r, p)) {
          return;
        }
      }
    }
  exit_col_loop:
    y[row_lo] = r;
    row_lo++;
    if (! (row_lo < row_hi)) {
      break;
    }
    if (unlikely(heartbeat)) {
      if (row_loop_handler(val, row_ptr, col_ind, x, y, row_lo, row_hi, p)) {
        return;
      }
    }
  }
}

extern
int col_loop_handler_col_loop(
  double* val,
  uint64_t* row_ptr,
  uint64_t* col_ind,
  double* x,
  double* y,
  uint64_t col_lo,
  uint64_t col_hi,
  double r,
  double* dst,
  void* p);

void spmv_interrupt_col_loop(
  double* val,
  uint64_t* row_ptr,
  uint64_t* col_ind,
  double* x,
  double* y,
  uint64_t col_lo,
  uint64_t col_hi,
  double r,
  double* dst,
  void* p) {
  if (! (col_lo < col_hi)) {
    goto exit;
  }
  for (; ; ) {
    uint64_t col_lo2 = col_lo;
    uint64_t col_hi2 = std::min(col_lo + D, col_hi);
    for (; col_lo2 < col_hi2; col_lo2++) {
      r += val[col_lo2] * x[col_ind[col_lo2]];
    }
    col_lo = col_lo2;
    if (! (col_lo < col_hi)) {
      break;
    }
    if (unlikely(heartbeat)) {
      if (col_loop_handler_col_loop(val, row_ptr, col_ind, x, y, col_lo, col_hi, r, dst, p)) {
        return;
      }
    }
  }
exit:
  *dst = r;
}
