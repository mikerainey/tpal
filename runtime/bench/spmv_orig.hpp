/*
compiled using
https://godbolt.org/
gcc 9.3
-O3 -m64 -march=x86-64 -mtune=x86-64 -fopt-info-vec -mavx -fomit-frame-pointer -DNDEBUG
./gen_rollforward.sh spmv spmv
 */


#include <stdint.h>

void spmv_serial(
  double* val,
  uint64_t* row_ptr,
  uint64_t* col_ind,
  double* x,
	double* y,
	uint64_t n) {
  for (int64_t i = 0; i < n; i++) { // row loop
    double t = 0.0;
    for (int64_t k = row_ptr[i]; k < row_ptr[i + 1]; k++) { // col loop
      t += val[k] * x[col_ind[k]];
    }
    y[i] = t;
  }
}

#define MIN(x, y) ((x < y) ? x : y)

#define likely(x)      __builtin_expect(!!(x), 1)
#define unlikely(x)    __builtin_expect(!!(x), 0)

#define D_row 2048
#define D_col 2048

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
  double t,
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
  if (! (row_lo < row_hi)) { // row loop (1)
    return;
  }
  for (; ; ) { 
    uint64_t row_lo2 = row_lo;
    uint64_t row_hi2 = MIN(row_lo + D_row, row_hi);
    for (; row_lo2 < row_hi2; row_lo2++) { // row loop (2)
      double t = 0.0;
      uint64_t col_lo = row_ptr[row_lo2];
      uint64_t col_hi = row_ptr[row_lo2 + 1];
      if (! (col_lo < col_hi)) { // col loop (1)
        goto exit_col_loop;
      }
      for (; ; ) {
        uint64_t col_lo2 = col_lo;
        uint64_t col_hi2 = MIN(col_lo + D_col, col_hi);
        for (; col_lo2 < col_hi2; col_lo2++) { // col loop (2)
          t += val[col_lo2] * x[col_ind[col_lo2]];
        }
        col_lo = col_lo2;
        if (unlikely(! (col_lo < col_hi))) {
          break;
        }
        if (unlikely(heartbeat)) {
          if (col_loop_handler(val, row_ptr, col_ind, x, y, row_lo2, row_hi, col_lo, col_hi, t, p)) {
            return;
          }
        }
      }
    exit_col_loop:
      y[row_lo2] = t;
    }
    row_lo = row_lo2;
    if (unlikely(! (row_lo < row_hi))) {
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
  double t,
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
  double t,
  double* dst,
  void* p) {
  if (!(col_lo < col_hi)) {
    goto exit;
  }
  for (; ; ) {
    uint64_t col_lo2 = col_lo;
    uint64_t col_hi2 = MIN(col_lo + D_col, col_hi);
    for (; col_lo2 < col_hi2; col_lo2++) {
      t += val[col_lo2] * x[col_ind[col_lo2]];
    }
    col_lo = col_lo2;
    if (unlikely(! (col_lo < col_hi))) {
      break;
    }
    if (unlikely(heartbeat)) {
      if (col_loop_handler_col_loop(val, row_ptr, col_ind, x, y, col_lo, col_hi, t, dst, p)) {
        return;
      }
    }
  }
exit:
  *dst = t;
}
