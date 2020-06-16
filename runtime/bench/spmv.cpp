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
    mk_rollforward_entry(spmv_l0, spmv_rf_l0),
    mk_rollforward_entry(spmv_l1, spmv_rf_l1),
    mk_rollforward_entry(spmv_l2, spmv_rf_l2),
    mk_rollforward_entry(spmv_l3, spmv_rf_l3),
    mk_rollforward_entry(spmv_l4, spmv_rf_l4),
    mk_rollforward_entry(spmv_l5, spmv_rf_l5),
    mk_rollforward_entry(spmv_l6, spmv_rf_l6),
    mk_rollforward_entry(spmv_l7, spmv_rf_l7),
    mk_rollforward_entry(spmv_l8, spmv_rf_l8),
    mk_rollforward_entry(spmv_l9, spmv_rf_l9),
    mk_rollforward_entry(spmv_l10, spmv_rf_l10),
    mk_rollforward_entry(spmv_l11, spmv_rf_l11),
    mk_rollforward_entry(spmv_l12, spmv_rf_l12),
    mk_rollforward_entry(spmv_l13, spmv_rf_l13),
    mk_rollforward_entry(spmv_l14, spmv_rf_l14),
    mk_rollforward_entry(spmv_l15, spmv_rf_l15), 

    mk_rollforward_entry(spmv_col_l0, spmv_col_rf_l0),
    mk_rollforward_entry(spmv_col_l1, spmv_col_rf_l1),
    mk_rollforward_entry(spmv_col_l2, spmv_col_rf_l2),
    mk_rollforward_entry(spmv_col_l3, spmv_col_rf_l3),
    mk_rollforward_entry(spmv_col_l4, spmv_col_rf_l4),
    mk_rollforward_entry(spmv_col_l5, spmv_col_rf_l5),
    mk_rollforward_entry(spmv_col_l6, spmv_col_rf_l6),
  };
  int64_t n = deepsea::cmdline::parse_or_default_long("n", 2000);
  int64_t row_len = deepsea::cmdline::parse_or_default_long("row_len", std::min(n, (int64_t)1000));
  size_t nb_rows = n / row_len;
  auto nb_vals = n;
  double* val = (double*)malloc(sizeof(double) * nb_vals);
  int64_t* row_ptr = (int64_t*)malloc(sizeof(int64_t) * (nb_rows + 1));
  int64_t* col_ind = (int64_t*)malloc(sizeof(int64_t) * nb_vals);
  double* x = (double*)malloc(sizeof(double) * nb_rows);
  double* y = (double*)malloc(sizeof(double) * nb_rows);
  char* env = (char*)malloc(SPMV_SZB);
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
    GET_FROM_ENV(double*, SPMV_OFF01, env) = val;
    GET_FROM_ENV(int64_t*, SPMV_OFF02, env) = row_ptr;
    GET_FROM_ENV(int64_t*, SPMV_OFF03, env) = col_ind;
    GET_FROM_ENV(double*, SPMV_OFF04, env) = x;
    GET_FROM_ENV(double*, SPMV_OFF05, env) = y;
    GET_FROM_ENV(int64_t, SPMV_OFF06, env) = 0;
    GET_FROM_ENV(int64_t, SPMV_OFF07, env) = nb_rows;
    GET_FROM_ENV(promotable*, SPMV_OFF10, env) = p;
    GET_FROM_ENV(double*, SPMV_OFF12, env) = nullptr;
    spmv_interrupt(env);
  };
  auto bench_body_software_polling = [&] (promotable* p) {
    spmv_software_polling(val, row_ptr, col_ind, x, y, nb_rows, p);
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
    free(env);
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
