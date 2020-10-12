/*
https://github.com/neboat/cilkbench/tree/master/intel/Mandelbrot_12_17_14
compiled using
https://godbolt.org/
gcc 9.3

 */

#include <emmintrin.h>
#include <algorithm>

unsigned char* mandelbrot_serial(double x0, double y0, double x1, double y1,
                                 int width, int height, int max_depth) {
  double xstep = (x1 - x0) / width;
  double ystep = (y1 - y0) / height;
  //  unsigned char* output = static_cast<unsigned char*>(_mm_malloc(width * height * sizeof(unsigned char), 64));
  unsigned char* output = (unsigned char*)malloc(width * height * sizeof(unsigned char));
  for(int j = 0; j < height; ++j) { // col loop
    for (int i = 0; i < width; ++i) { // row loop
      double z_real = x0 + i*xstep;
      double z_imaginary = y0 + j*ystep;
      double c_real = z_real;
      double c_imaginary = z_imaginary;
      double depth = 0;
      while(depth < max_depth) {
        if(z_real * z_real + z_imaginary * z_imaginary > 4.0) {
          break;
        }
        double temp_real = z_real*z_real - z_imaginary*z_imaginary;
        double temp_imaginary = 2.0*z_real*z_imaginary;
        z_real = c_real + temp_real;
        z_imaginary = c_imaginary + temp_imaginary;
        ++depth;
      }
      output[j*width + i] = static_cast<unsigned char>(static_cast<double>(depth) / max_depth * 255);
    }
  }
  return output;
}

#define unlikely(x)    __builtin_expect(!!(x), 0)

#define D_row 32

extern volatile 
int heartbeat;

extern
int col_loop_handler(
  double x0, double y0, double x1, double y1,
  int width, int height, int max_depth,
  unsigned char* output, double xstep, double ystep,
  int col_lo, int col_hi, void* p);

extern
int row_loop_handler(
  double x0, double y0, double x1, double y1,
  int width, int height, int max_depth,
  unsigned char* output, double xstep, double ystep,
  int col_lo, int col_hi, int row_lo, int row_hi, void* p);

void mandelbrot_interrupt_col_loop(double x0, double y0, double x1, double y1,
                                  int width, int height, int max_depth,
                                  unsigned char* output, double xstep, double ystep,
                                  int col_lo, int col_hi, void* p) {
  if (! (col_lo < col_hi)) {
    return;
  }
  for(; ; ) { // col loop
    int row_lo = 0;
    int row_hi = width;
    if (! (row_lo < row_hi)) {
      break;
    }
    for (; ; ) {
      int row_lo2 = row_lo;
      int row_hi2 = std::min(row_lo + D_row, row_hi);
      for (; row_lo2 < row_hi2; ++row_lo2) { // row loop
        double z_real = x0 + row_lo2*xstep;
        double z_imaginary = y0 + col_lo*ystep;
        double c_real = z_real;
        double c_imaginary = z_imaginary;
        double depth = 0;
        while(depth < max_depth) {
          if(z_real * z_real + z_imaginary * z_imaginary > 4.0) {
            break;
          }
          double temp_real = z_real*z_real - z_imaginary*z_imaginary;
          double temp_imaginary = 2.0*z_real*z_imaginary;
          z_real = c_real + temp_real;
          z_imaginary = c_imaginary + temp_imaginary;
          ++depth;
        }
        output[col_lo*width + row_lo2] = static_cast<unsigned char>(static_cast<double>(depth) / max_depth * 255);
      }
      row_lo = row_lo2;
      if (! (row_lo < row_hi)) {
        break;
      }
      if (unlikely(heartbeat)) {
        if (row_loop_handler(x0, y0, x1, y1, width, height, max_depth, output, xstep, ystep, col_lo, col_hi, row_lo, row_hi, p)) {
          return;
        }
      }
    }
    col_lo++;
    if (! (col_lo < col_hi)) {
      break;
    }
    if (unlikely(heartbeat)) {
      if (col_loop_handler(x0, y0, x1, y1, width, height, max_depth, output, xstep, ystep, col_lo, col_hi, p)) {
        return;
      }
    }
  }
}

extern
int row_row_loop_handler(
  double x0, double y0, double x1, double y1,
  int width, int height, int max_depth,
  unsigned char* output, double xstep, double ystep,
  int col_lo, int col_hi, int row_lo, int row_hi, void* p);

void mandelbrot_interrupt_row_loop(double x0, double y0, double x1, double y1,
                                  int width, int height, int max_depth,
                                  unsigned char* output, double xstep, double ystep,
                                  int col_lo, int col_hi, int row_lo, int row_hi, void* p) {
  if (! (row_lo < row_hi)) {
    return;
  }
  for (; ; ) {
    int row_lo2 = row_lo;
    int row_hi2 = std::min(row_lo + D_row, row_hi);
    for (; row_lo2 < row_hi2; ++row_lo2) { // row loop
      double z_real = x0 + row_lo2*xstep;
      double z_imaginary = y0 + col_lo*ystep;
      double c_real = z_real;
      double c_imaginary = z_imaginary;
      double depth = 0;
      while(depth < max_depth) {
        if(z_real * z_real + z_imaginary * z_imaginary > 4.0) {
          break;
        }
        double temp_real = z_real*z_real - z_imaginary*z_imaginary;
        double temp_imaginary = 2.0*z_real*z_imaginary;
        z_real = c_real + temp_real;
        z_imaginary = c_imaginary + temp_imaginary;
        ++depth;
      }
      output[col_lo*width + row_lo2] = static_cast<unsigned char>(static_cast<double>(depth) / max_depth * 255);
    }
    row_lo = row_lo2;
    if (! (row_lo < row_hi)) {
      break;
    }
    if (unlikely(heartbeat)) {
      if (row_row_loop_handler(x0, y0, x1, y1, width, height, max_depth, output, xstep, ystep, col_lo, col_hi, row_lo, row_hi, p)) {
        return;
      }
    }
  }
}

unsigned char* mandelbrot_interrupt(double x0, double y0, double x1, double y1,
                                 int width, int height, int max_depth, void* p) {
  double xstep = (x1 - x0) / width;
  double ystep = (y1 - y0) / height;
  //unsigned char* output = static_cast<unsigned char*>(_mm_malloc(width * height * sizeof(unsigned char), 64));
  unsigned char* output = (unsigned char*)malloc(width * height * sizeof(unsigned char));
  mandelbrot_interrupt_col_loop(x0, y0, x1, y1, width, height, max_depth, output, xstep, ystep, 0, height, p);
  return output;
}
