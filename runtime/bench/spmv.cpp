#include "benchmark.hpp"
#include "spmv.hpp"

namespace tpalrts {

uint64_t hash64(uint64_t u) {
  uint64_t v = u * 3935559000370003845ul + 2691343689449507681ul;
  v ^= v >> 21;
  v ^= v << 37;
  v ^= v >>  4;
  v *= 4768777513237032717ul;
  v ^= v << 20;
  v ^= v >> 41;
  v ^= v <<  5;
  return v;
}

void launch() {
  rollforward_table = {
    #include "spmv_rollforward_map.hpp"    
  };
  int64_t software_polling_K = deepsea::cmdline::parse_or_default_int("software_polling_K", 128);
  int64_t n = deepsea::cmdline::parse_or_default_long("n", 2000);
  int64_t row_len = deepsea::cmdline::parse_or_default_long("row_len", std::min(n, (int64_t)1000));
  size_t nb_rows = n / row_len;
  auto nb_vals = n;
  double* val = (double*)malloc(sizeof(double) * nb_vals);
  uint64_t* row_ptr = (uint64_t*)malloc(sizeof(uint64_t) * (nb_rows + 1));
  uint64_t* col_ind = (uint64_t*)malloc(sizeof(uint64_t) * nb_vals);
  double* x = (double*)malloc(sizeof(double) * nb_rows);
  double* y = (double*)malloc(sizeof(double) * nb_rows);
  auto bench_pre = [=] {
    {
      int64_t a = 0;
      for (int64_t i = 0; i != nb_rows; i++) {
        row_ptr[i] = a;
        a += row_len;
      }
      row_ptr[nb_rows] = a;
    }
    for (int64_t i = 0; i != nb_vals; i++) {
      col_ind[i] = hash64(i) % nb_rows;
    }
    for (int64_t i = 0; i != nb_rows; i++) {
      x[i] = 1.0;
      y[i] = 0.0;
    }
    for (int64_t i = 0; i != nb_vals; i++) {
      val[i] = 1.0;
    }
  };
  auto bench_body_interrupt = [=] (promotable* p) {
    spmv_interrupt(val, row_ptr, col_ind, x, y, 0, nb_rows, p);
  };
  auto bench_body_software_polling = [&] (promotable* p) {
    spmv_software_polling(val, row_ptr, col_ind, x, y, nb_rows, p, software_polling_K);
  };
  auto bench_body_serial = [&] (promotable* p) {
    spmv_serial(val, row_ptr, col_ind, x, y, nb_rows);
  };
  auto bench_post = [=]   {
#ifndef NDEBUG
    double* yref = (double*)malloc(sizeof(double) * nb_rows);
    {
      for (int64_t i = 0; i != nb_rows; i++) {
        yref[i] = 1.0;
      }
      spmv_serial(val, row_ptr, col_ind, x, yref, nb_rows);
    }
    int64_t nb_diffs = 0;
    double epsilon = 0.01;
    for (int64_t i = 0; i != nb_rows; i++) {
      auto diff = std::abs(y[i] - yref[i]);
      if (diff > epsilon) {
        //printf("diff=%f y[i]=%f yref[i]=%f at i=%ld\n", diff, y[i], yref[i], i);
        nb_diffs++;
      }
    }
    printf("nb_diffs %ld\n", nb_diffs);
    free(yref);
#endif
    free(val);
    free(row_ptr);
    free(x);
    free(y);
  };
  spmv_manual_col_T = deepsea::cmdline::parse_or_default_int("spmv_manual_col_T", spmv_manual_col_T);
  using microbench_scheduler_type = mcsl::minimal_scheduler<stats, logging, mcsl::minimal_elastic, tpal_worker>;
  auto bench_body_manual = new spmv_manual<microbench_scheduler_type>(val, row_ptr, col_ind, x, y, 0, nb_rows, 0, 0);
  auto bench_body_cilk = [&] {
    spmv_cilk(val, row_ptr, col_ind, x, y, nb_rows);
  };
  launch(bench_pre, bench_body_interrupt, bench_body_software_polling, bench_body_serial,
         bench_post, bench_body_manual, bench_body_cilk);
}

} // end namespace

int main() {
  tpalrts::launch();
  return 0;
}
