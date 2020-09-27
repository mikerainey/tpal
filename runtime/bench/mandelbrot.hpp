#pragma once

#include <cstdint>
#include <cmath>
#include <complex>
#include <emmintrin.h>

#include "mcsl_util.hpp"

#include "tpalrts_fiber.hpp"
#include "mandelbrot_rollforward_decls.hpp"

extern
unsigned char* mandelbrot_serial(double x0, double y0, double x1, double y1,
                                 int width, int height, int max_depth);

extern
void mandelbrot_interrupt_row_loop(double x0, double y0, double x1, double y1,
				   int width, int height, int max_depth,
				   unsigned char* output, double xstep, double ystep,
				   int col_lo, int col_hi, int row_lo, int row_hi, void* p);

extern
void mandelbrot_interrupt_col_loop(double x0, double y0, double x1, double y1,
				   int width, int height, int max_depth,
				   unsigned char* output, double xstep, double ystep,
				   int col_lo, int col_hi, void* p);

extern
unsigned char* mandelbrot_interrupt(double x0, double y0, double x1, double y1,
				    int width, int height, int max_depth, void* p);

int col_loop_handler(
  double x0, double y0, double x1, double y1,
  int width, int height, int max_depth,
  unsigned char* output, double xstep, double ystep,
  int col_lo, int col_hi, void* _p) {
  tpalrts::promotable* p = (tpalrts::promotable*)_p;
  tpalrts::stats::increment(tpalrts::stats_configuration::nb_heartbeats);
  if ((col_hi - col_lo) <= 1) {
    return 0;
  }
  auto col_mid = (col_lo + col_hi) / 2;
  p->fork_join_promote2([=] (tpalrts::promotable* p2) {
    mandelbrot_interrupt_col_loop(x0, y0, x1, y1, width, height, max_depth, output, xstep, ystep, col_lo, col_mid, p2);    
  }, [=] (tpalrts::promotable* p2) {
    mandelbrot_interrupt_col_loop(x0, y0, x1, y1, width, height, max_depth, output, xstep, ystep, col_mid, col_hi, p2);    
  }, [=] (tpalrts::promotable*) {
    // nothing to do
  });
  return 1;
}

int row_loop_handler(
  double x0, double y0, double x1, double y1,
  int width, int height, int max_depth,
  unsigned char* output, double xstep, double ystep,
  int col_lo, int col_hi, int row_lo, int row_hi, void* _p) {
  tpalrts::promotable* p = (tpalrts::promotable*)_p;
  tpalrts::stats::increment(tpalrts::stats_configuration::nb_heartbeats);
  auto nb_cols = col_hi - col_lo;
  if (nb_cols == 0) {
    return 0;
  }
  auto rf = [=] (tpalrts::promotable* p2) {
    mandelbrot_interrupt_row_loop(x0, y0, x1, y1, width, height, max_depth, output, xstep, ystep, col_lo, col_hi, row_lo, row_hi, p2);
  };
  if (nb_cols == 1) {
    p->async_finish_promote(rf);
    return 1;
  }
  col_lo++;
  if (nb_cols == 2) {
    p->fork_join_promote2(rf, [=] (tpalrts::promotable* p2) {
      mandelbrot_interrupt_col_loop(x0, y0, x1, y1, width, height, max_depth, output, xstep, ystep, col_lo, col_hi, p2);
    }, [=] (tpalrts::promotable*) {
      // nothing left to do
    });
  } else {
    auto col_mid = (col_lo + col_hi) / 2;
    p->fork_join_promote3(rf, [=] (tpalrts::promotable* p2) {
      mandelbrot_interrupt_col_loop(x0, y0, x1, y1, width, height, max_depth, output, xstep, ystep, col_lo, col_mid, p2);
    }, [=] (tpalrts::promotable* p2) {
      mandelbrot_interrupt_col_loop(x0, y0, x1, y1, width, height, max_depth, output, xstep, ystep, col_mid, col_hi, p2);
    }, [=] (tpalrts::promotable*) {
      // nothing left to do
    });    
  }
  return 1;
}

int row_row_loop_handler(
  double x0, double y0, double x1, double y1,
  int width, int height, int max_depth,
  unsigned char* output, double xstep, double ystep,
  int col_lo, int col_hi, int row_lo, int row_hi, void* _p) {
  tpalrts::promotable* p = (tpalrts::promotable*)_p;
  tpalrts::stats::increment(tpalrts::stats_configuration::nb_heartbeats);
  if ((row_hi - row_lo) <= 1) {
    return 0;
  }
  auto row_mid = (row_lo + row_hi) / 2;
  p->fork_join_promote2([=] (tpalrts::promotable* p2) {
    mandelbrot_interrupt_row_loop(x0, y0, x1, y1, width, height, max_depth, output, xstep, ystep, col_lo, col_hi, row_lo, row_mid, p2);
  }, [=] (tpalrts::promotable* p2) {
    mandelbrot_interrupt_row_loop(x0, y0, x1, y1, width, height, max_depth, output, xstep, ystep, col_lo, col_hi, row_mid, row_hi, p2);
  }, [=] (tpalrts::promotable*) {
    // nothing left to do
  });
  return 1;

}

unsigned char* mandelbrot_cilk(double x0, double y0, double x1, double y1,
                               int width, int height, int max_depth) {
  double xstep = (x1 - x0) / width;
  double ystep = (y1 - y0) / height;
  unsigned char* output = (unsigned char*)malloc(width * height * sizeof(unsigned char));
  //unsigned char* output = static_cast<unsigned char*>(_mm_malloc(width * height * sizeof(unsigned char), 64));
#if defined(USE_CILK_PLUS)
  // Traverse the sample space in equally spaced steps with width * height samples
  cilk_for(int j = 0; j < height; ++j) {
    cilk_for (int i = 0; i < width; ++i) {
      double z_real = x0 + i*xstep;
      double z_imaginary = y0 + j*ystep;
      double c_real = z_real;
      double c_imaginary = z_imaginary;

      // depth should be an int, but the vectorizer will not vectorize, complaining about mixed data types
      // switching it to double is worth the small cost in performance to let the vectorizer work
      double depth = 0;
      // Figures out how many recurrences are required before divergence, up to max_depth
      while(depth < max_depth) {
        if(z_real * z_real + z_imaginary * z_imaginary > 4.0) {
          break; // Escape from a circle of radius 2
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
#endif
  return output;
}

namespace mandelbrot {

using namespace tpalrts;

uint64_t nb_items;
unsigned char* output = nullptr;
double x0 = -2.5;
double y0 = -0.875;
double x1 = 1;
double y1 = 0.875;
int height = 10240;
// Width should be a multiple of 8
int width = 1024;
int max_depth = 100;
double g = 2.0;
  
auto bench_pre(promotable* p) {
  for (int i = 0; i < 100; i++) {
    g /= sin(g);
  }
};
  
auto bench_body_interrupt(promotable* p) {
  rollforward_table = {
    #include "mandelbrot_rollforward_map.hpp"
  };
  output = mandelbrot_interrupt(x0, y0, x1, y1, width, height, max_depth, p);
};
  
auto bench_body_software_polling(promotable* p) {

};

auto bench_body_serial(promotable* p) {
  output = mandelbrot_serial(x0, y0, x1, y1, width, height, max_depth);
};

auto bench_post(promotable* p) {
  _mm_free(output);
};

auto bench_body_cilk() {
  output = mandelbrot_cilk(x0, y0, x1, y1, width, height, max_depth);
};
  
}
