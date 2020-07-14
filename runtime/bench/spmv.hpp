#pragma once

#ifdef USE_CILK_PLUS
#include <cilk/cilk.h>
#include <cilk/cilk_api.h>
#include <cilk/reducer_opadd.h>
#endif
#include <cstdint>

#include "mcsl_util.hpp"

#include "tpalrts_fiber.hpp"

#include "spmv_offsets.hpp"

/*---------------------------------------------------------------------*/
/* Manual version */

void spmv_serial(double* val,
		 int64_t* row_ptr,
		 int64_t* col_ind,
		 double* x,
		 double* y,
		 int64_t n) {
  for (int64_t i = 0; i < n; i++) {  // row loop
    double t = 0.0;
    for (int64_t k = row_ptr[i]; k < row_ptr[i+1]; k++) { // col loop
      t += val[k] * x[col_ind[k]];
    }
    y[i] = t;
  }
}

static
void spmv_software_polling_col_loop(double* val,
                                    int64_t* row_ptr,
                                    int64_t* col_ind,
                                    double* x,
                                    int64_t k_lo,
                                    int64_t k_hi,
                                    double* dst);

static
void spmv_software_polling_row_loop(double* val,
                                    int64_t* row_ptr,
                                    int64_t* col_ind,
                                    double* x,
                                    double* y,
                                    int64_t i_lo,
                                    int64_t i_hi,
                                    tpalrts::promotable* p);

int64_t spmv_manual_col_T = 1000;

template <typename Scheduler>
class spmv_manual : public tpalrts::fiber<Scheduler> {
public:

  using trampoline_type = enum { entry, col_loop, col_loop_combine, exit };

  trampoline_type trampoline = entry;
  
  double* val; int64_t* row_ptr; int64_t* col_ind; double* x; double* y;
  int64_t i_lo; int64_t i_hi; int64_t k_lo; int64_t k_hi;
  double* dst; double dst1, dst2;
  
  spmv_manual(double* val,
              int64_t* row_ptr,
              int64_t* col_ind,
              double* x,
              double* y,
              int64_t i_lo,
              int64_t i_hi,
              int64_t k_lo,
              int64_t k_hi)
    : tpalrts::fiber<Scheduler>([] (tpalrts::promotable*) { return mcsl::fiber_status_finish; }),
      val(val), row_ptr(row_ptr), col_ind(col_ind), x(x), y(y), i_lo(i_lo), i_hi(i_hi), k_lo(k_lo), k_hi(k_hi)
  { }

    mcsl::fiber_status_type exec() {
      switch (trampoline) {
      case entry: {
        auto n = i_hi-i_lo;
        if (n == 0) {
          break;
        } else if (n == 1) {
          k_lo = row_ptr[i_lo];
          k_hi = row_ptr[i_lo+1];
          dst = &y[i_lo];
          trampoline = col_loop;
          return mcsl::fiber_status_continue;
        } else {
          auto i_mid = (i_lo + i_hi) / 2;
          auto f1 = new spmv_manual(val, row_ptr, col_ind, x, y, i_lo, i_mid, 0, 0);
          auto f2 = new spmv_manual(val, row_ptr, col_ind, x, y, i_mid, i_hi, 0, 0);
          tpalrts::fiber<Scheduler>::add_edge(f1, this);
	  tpalrts::fiber<Scheduler>::add_edge(f2, this);
	  f1->release();
	  f2->release();
	  tpalrts::stats::increment(tpalrts::stats_configuration::nb_promotions);
	  tpalrts::stats::increment(tpalrts::stats_configuration::nb_promotions);
	  trampoline = exit;
	  return mcsl::fiber_status_pause;
        }
      }
      case col_loop: {
        auto n = k_hi-k_lo;
        if (n == 0) {
          break;
        } else if (n <= spmv_manual_col_T) {
          spmv_software_polling_col_loop(val, row_ptr, col_ind, x, k_lo, k_hi, dst);
        } else {
          auto k_mid = (k_lo + k_hi) / 2;
          auto f1 = new spmv_manual(val, row_ptr, col_ind, x, y, i_lo, i_hi, k_lo, k_mid);
          auto f2 = new spmv_manual(val, row_ptr, col_ind, x, y, i_lo, i_hi, k_mid, k_hi);
          f1->trampoline = col_loop; f1->dst = &dst1;
          f2->trampoline = col_loop; f2->dst = &dst2;
          tpalrts::fiber<Scheduler>::add_edge(f1, this);
	  tpalrts::fiber<Scheduler>::add_edge(f2, this);
	  f1->release();
	  f2->release();
	  tpalrts::stats::increment(tpalrts::stats_configuration::nb_promotions);
	  tpalrts::stats::increment(tpalrts::stats_configuration::nb_promotions);
	  trampoline = col_loop_combine;
	  return mcsl::fiber_status_pause;
        }
	break;
      }
      case col_loop_combine: {
        *dst = dst1 + dst2;
	break;
      }
      case exit: {
	break;
      }
      }
      return mcsl::fiber_status_finish;
    }

};

/*---------------------------------------------------------------------*/
/* Hardware-interrupt version */

extern "C"
void spmv_l0();
extern "C"
void spmv_l1();
extern "C"
void spmv_l2();
extern "C"
void spmv_l3();
extern "C"
void spmv_l4();
extern "C"
void spmv_l5();
extern "C"
void spmv_l6();
extern "C"
void spmv_l7();
extern "C"
void spmv_l8();
extern "C"
void spmv_l9();
extern "C"
void spmv_l10();
extern "C"
void spmv_l11();
extern "C"
void spmv_l12();
extern "C"
void spmv_l13();
extern "C"
void spmv_l14();
extern "C"
void spmv_l15();

extern "C"
void spmv_rf_l0();
extern "C"
void spmv_rf_l1();
extern "C"
void spmv_rf_l2();
extern "C"
void spmv_rf_l3();
extern "C"
void spmv_rf_l4();
extern "C"
void spmv_rf_l5();
extern "C"
void spmv_rf_l6();
extern "C"
void spmv_rf_l7();
extern "C"
void spmv_rf_l8();
extern "C"
void spmv_rf_l9();
extern "C"
void spmv_rf_l10();
extern "C"
void spmv_rf_l11();
extern "C"
void spmv_rf_l12();
extern "C"
void spmv_rf_l13();
extern "C"
void spmv_rf_l14();
extern "C"
void spmv_rf_l15();

extern "C"
void spmv_col_l0();
extern "C"
void spmv_col_l1();
extern "C"
void spmv_col_l2();
extern "C"
void spmv_col_l3();
extern "C"
void spmv_col_l4();
extern "C"
void spmv_col_l5();
extern "C"
void spmv_col_l6();

extern "C"
void spmv_col_rf_l0();
extern "C"
void spmv_col_rf_l1();
extern "C"
void spmv_col_rf_l2();
extern "C"
void spmv_col_rf_l3();
extern "C"
void spmv_col_rf_l4();
extern "C"
void spmv_col_rf_l5();
extern "C"
void spmv_col_rf_l6();

extern "C"
void spmv_interrupt(char*);
extern "C"
void spmv_interrupt_row_loop(char*);
extern "C"
void spmv_interrupt_col_loop(char*);
extern "C"
void spmv_interrupt_promote(char*);
extern "C"
void spmv_col_interrupt_promote(char*);

void spmv_interrupt_promote(char* env) {
  double* val = GET_FROM_ENV(double*,SPMV_OFF01,env);   
  int64_t* row_ptr = GET_FROM_ENV(int64_t*,SPMV_OFF02,env); 
  int64_t* col_ind = GET_FROM_ENV(int64_t*,SPMV_OFF03,env);
  double* x = GET_FROM_ENV(double*,SPMV_OFF04,env);
  double* y = GET_FROM_ENV(double*,SPMV_OFF05,env);
  int64_t i = GET_FROM_ENV(int64_t,SPMV_OFF06,env); 
  int64_t* ptr_n = GET_ADDR_FROM_ENV(int64_t,SPMV_OFF07,env);
  int64_t k = GET_FROM_ENV(int64_t,SPMV_OFF08,env); 
  int64_t* ptr_khi = GET_ADDR_FROM_ENV(int64_t,SPMV_OFF09,env);
  tpalrts::promotable* p = GET_FROM_ENV(tpalrts::promotable*,SPMV_OFF10,env);
  auto n = *ptr_n;
  auto khi = *ptr_khi;
  if (n-i >= 1) {
    auto mid = (n+i)/2;
    *ptr_n = mid;
    p->async_finish_promote([=] (tpalrts::promotable* p) {
      char env[SPMV_SZB];
      GET_FROM_ENV(double*, SPMV_OFF01, env) = val;
      GET_FROM_ENV(int64_t*, SPMV_OFF02, env) = row_ptr;
      GET_FROM_ENV(int64_t*, SPMV_OFF03, env) = col_ind;
      GET_FROM_ENV(double*, SPMV_OFF04, env) = x;
      GET_FROM_ENV(double*, SPMV_OFF05, env) = y;
      GET_FROM_ENV(int64_t, SPMV_OFF06, env) = mid;
      GET_FROM_ENV(int64_t, SPMV_OFF07, env) = n;
      GET_FROM_ENV(tpalrts::promotable*, SPMV_OFF10, env) = p;
      GET_FROM_ENV(double*, SPMV_OFF12, env) = nullptr;
      spmv_interrupt_row_loop(env);
    });
  } else if (khi-k >= 2) {
    double* r1 = new double;
    double* r2 = new double;
    auto mid = (khi+k)/2;
    *ptr_khi = mid;
    GET_FROM_ENV(double*, SPMV_OFF12, env) = r1;
    p->fork_join_promote([=] (tpalrts::promotable* p2) {
      char env2[SPMV_SZB];
      GET_FROM_ENV(double*, SPMV_OFF01, env2) = val;
      GET_FROM_ENV(int64_t*, SPMV_OFF02, env2) = row_ptr;
      GET_FROM_ENV(int64_t*, SPMV_OFF03, env2) = col_ind;
      GET_FROM_ENV(double*, SPMV_OFF04, env2) = x;
      GET_FROM_ENV(double*, SPMV_OFF05, env2) = y;
      GET_FROM_ENV(int64_t, SPMV_OFF06, env2) = i;
      GET_FROM_ENV(int64_t, SPMV_OFF07, env2) = n;
      GET_FROM_ENV(int64_t, SPMV_OFF08, env2) = mid;
      GET_FROM_ENV(int64_t, SPMV_OFF09, env2) = khi;
      GET_FROM_ENV(tpalrts::promotable*, SPMV_OFF10, env2) = p2;
      GET_FROM_ENV(double*, SPMV_OFF12, env2) = r2;
      spmv_interrupt_col_loop(env2);
    }, [=] (tpalrts::promotable*) {
      y[i] = *r1 + *r2;
      delete r1;
      delete r2;
    });
  }
}

void spmv_col_interrupt_promote(char* env) {
  double* val = GET_FROM_ENV(double*,SPMV_OFF01,env);   
  int64_t* row_ptr = GET_FROM_ENV(int64_t*,SPMV_OFF02,env); 
  int64_t* col_ind = GET_FROM_ENV(int64_t*,SPMV_OFF03,env);
  double* x = GET_FROM_ENV(double*,SPMV_OFF04,env);
  double* y = GET_FROM_ENV(double*,SPMV_OFF05,env);
  int64_t i = GET_FROM_ENV(int64_t,SPMV_OFF06,env); 
  int64_t* ptr_n = GET_ADDR_FROM_ENV(int64_t,SPMV_OFF07,env);
  int64_t k = GET_FROM_ENV(int64_t,SPMV_OFF08,env); 
  int64_t* ptr_khi = GET_ADDR_FROM_ENV(int64_t,SPMV_OFF09,env);
  tpalrts::promotable* p = GET_FROM_ENV(tpalrts::promotable*,SPMV_OFF10,env);
  double* dst = GET_FROM_ENV(double*,SPMV_OFF12,env);
  auto khi = *ptr_khi;
  if (khi-k >= 2) {
    double* r1 = new double;
    double* r2 = new double;
    auto mid = (khi+k)/2;
    *ptr_khi = mid;
    GET_FROM_ENV(double*, SPMV_OFF12, env) = r1;
    p->fork_join_promote([=] (tpalrts::promotable* p2) {
      char env2[SPMV_SZB];
      GET_FROM_ENV(double*, SPMV_OFF01, env2) = val;
      GET_FROM_ENV(int64_t*, SPMV_OFF02, env2) = row_ptr;
      GET_FROM_ENV(int64_t*, SPMV_OFF03, env2) = col_ind;
      GET_FROM_ENV(double*, SPMV_OFF04, env2) = x;
      GET_FROM_ENV(double*, SPMV_OFF05, env2) = y;
      GET_FROM_ENV(int64_t, SPMV_OFF06, env2) = i;
      GET_FROM_ENV(int64_t, SPMV_OFF07, env2) = *ptr_n;
      GET_FROM_ENV(int64_t, SPMV_OFF08, env2) = mid;
      GET_FROM_ENV(int64_t, SPMV_OFF09, env2) = khi;
      GET_FROM_ENV(tpalrts::promotable*, SPMV_OFF10, env2) = p2;
      GET_FROM_ENV(double*, SPMV_OFF12, env2) = r2;
      spmv_interrupt_col_loop(env2);
    }, [=] (tpalrts::promotable*) {
      *dst = *r1 + *r2;
      delete r1;
      delete r2;
    });
  }
}

/*---------------------------------------------------------------------*/
/* Software-polling version */

static
void spmv_software_polling_col_loop(double* val,
                                    int64_t* row_ptr,
                                    int64_t* col_ind,
                                    double* x,
                                    int64_t k_lo,
                                    int64_t k_hi,
                                    double* dst) {
  double t = 0.0;
  for (int64_t k = k_lo; k < k_hi; k++) { // col loop
    t += val[k] * x[col_ind[k]];
  }
  *dst = t;
}

static
void spmv_software_polling_col_loop_par(int64_t K,
                                        double* val,
                                        int64_t* row_ptr,
                                        int64_t* col_ind,
                                        double* x,
                                        int64_t k_lo,
                                        int64_t k_hi,
                                        double* dst,
                                        tpalrts::promotable* p) {
  uint64_t promotion_prev = mcsl::cycles::now();
  int64_t lo_outer = k_lo;
  double t = 0.0;
  while (lo_outer != k_hi) {
    int64_t hi_outer = std::min(k_hi, lo_outer + K);
    {
      double t2;
      spmv_software_polling_col_loop(val, row_ptr, col_ind, x, lo_outer, hi_outer, &t2);
      t += t2;
    }
    lo_outer = hi_outer;
    { // polling
      auto cur = mcsl::cycles::now();
      if (mcsl::cycles::diff(promotion_prev, cur) > tpalrts::kappa_cycles) {
        // try to promote
        promotion_prev = cur;
        tpalrts::stats::increment(tpalrts::stats_configuration::nb_heartbeats);
        if (k_hi-lo_outer <= 1) {
          continue;
        }
        // promotion successful
        auto mid = (lo_outer+k_hi)/2;
	auto dst1 = new double;
	auto dst2 = new double;
	auto dst0 = dst;
	dst = dst1;
        p->fork_join_promote([=] (tpalrts::promotable* p2) {
          spmv_software_polling_col_loop_par(K, val, row_ptr, col_ind, x, mid, k_hi, dst2, p2);
        }, [=] (tpalrts::promotable*) {
          *dst0 = *dst1 + *dst2;
	  delete dst1;
	  delete dst2;
	});
        k_hi = mid;
      }
    }
  }
  *dst = t;
}

static
void spmv_software_polling_row_loop(double* val,
                                    int64_t* row_ptr,
                                    int64_t* col_ind,
                                    double* x,
                                    double* y,
                                    int64_t i_lo,
                                    int64_t i_hi,
                                    tpalrts::promotable* p,
                                    int64_t software_polling_K=tpalrts::dflt_software_polling_K) {
  int64_t K = software_polling_K;
  uint64_t promotion_prev = mcsl::cycles::now();
  int64_t N = K;
  int64_t k_lo, k_hi;
  double t;
  while (i_lo < i_hi) { // row loop
    k_lo = row_ptr[i_lo];
    k_hi = row_ptr[i_lo+1];
    t = 0.0;
    while (k_lo < k_hi) { // col loop
      int64_t k_hi_inner = std::min(k_hi, k_lo + N);
      {
        double t2;
        spmv_software_polling_col_loop(val, row_ptr, col_ind, x, k_lo, k_hi_inner, &t2);
        t += t2;
      }
      N -= (k_hi_inner - k_lo);
      k_lo = k_hi_inner;
      if (N == 0) { // begin polling
        N = K;
        auto cur = mcsl::cycles::now();
        if (mcsl::cycles::diff(promotion_prev, cur) > tpalrts::kappa_cycles) {
        tpalrts::stats::increment(tpalrts::stats_configuration::nb_heartbeats);
          // try to promote
          promotion_prev = cur;
          if (i_hi-i_lo <= 1) {
            if (k_hi-k_lo >= 2) { // promote col loop
              // promotion successful
              double* tmp = new double;
              *tmp = 0.0;
              p->fork_join_promote([=] (tpalrts::promotable* p2) {
               spmv_software_polling_col_loop_par(K, val, row_ptr, col_ind, x, k_lo, k_hi, tmp, p2);
              }, [=] (tpalrts::promotable*) {
                y[i_lo] = t + *tmp;
                delete tmp;
              });
              return;
            } // end promote col loop
            continue;
          }
          // promotion successful
          auto i_mid = (i_lo+i_hi)/2;
          p->async_finish_promote([=] (tpalrts::promotable* p) {
            spmv_software_polling_row_loop(val, row_ptr, col_ind, x, y, i_mid, i_hi, p, K);
          });
          i_hi = i_mid;
        }
      } // end polling
    }
    y[i_lo] = t;
    i_lo++;
  }
}

static
void spmv_software_polling(double* val,
                           int64_t* row_ptr,
                           int64_t* col_ind,
                           double* x,
                           double* y,
                           int64_t n,
                           tpalrts::promotable* p,
                           int64_t software_polling_K=tpalrts::dflt_software_polling_K) {
  spmv_software_polling_row_loop(val, row_ptr, col_ind, x, y, 0, n, p, software_polling_K);
}

/*---------------------------------------------------------------------*/
/* Cilk version */

void spmv_cilk(double* val,
               int64_t* row_ptr,
               int64_t* col_ind,
               double* x,
               double* y,
               int64_t n) {
#if defined(USE_CILK_PLUS)
  cilk_for (int64_t i = 0; i < n; i++) {  // row loop
    cilk::reducer_opadd<double> t(0.0);
    cilk_for (int64_t k = row_ptr[i]; k < row_ptr[i+1]; k++) { // col loop
      *t += val[k] * x[col_ind[k]];
    }
    y[i] = t.get_value();
  }
#else
  //  mcsl::die("Cilk unsupported\n");
#endif
}
