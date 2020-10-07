#pragma once

#if defined(MCSL_LINUX)
#include <cmath>
double mypow(double x, double y) {
  return std::pow(x, y);
}
#elif defined(MCSL_NAUTILUS)
extern "C"
double pow(double x, double y);
double mypow(double x, double y) {
  return pow(x, y);
}
#endif

#ifdef USE_CILK_PLUS
#include <cilk/cilk.h>
#include <cilk/cilk_api.h>
#include <cilk/reducer_opadd.h>
#endif
#include <cstdint>

#include "mcsl_util.hpp"

#include "tpalrts_fiber.hpp"

#include "spmv_rollforward_decls.hpp"

/*---------------------------------------------------------------------*/
/* Manual version */

extern
void spmv_serial(
  double* val,
  uint64_t* row_ptr,
  uint64_t* col_ind,
  double* x,
  double* y,
  uint64_t n);

static
void spmv_software_polling_col_loop(double* val,
                                    uint64_t* row_ptr,
                                    uint64_t* col_ind,
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

uint64_t spmv_manual_col_T = 1000;

template <typename Scheduler>
class spmv_manual : public tpalrts::fiber<Scheduler> {
public:

  using trampoline_type = enum { entry, col_loop, col_loop_combine, exit };

  trampoline_type trampoline = entry;
  
  double* val; uint64_t* row_ptr; uint64_t* col_ind; double* x; double* y;
  int64_t i_lo; int64_t i_hi; int64_t k_lo; int64_t k_hi;
  double* dst; double dst1, dst2;
  
  spmv_manual(double* val,
              uint64_t* row_ptr,
              uint64_t* col_ind,
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
	  tpalrts::stats::increment(tpalrts::stats_configuration::nb_heartbeats);
	  tpalrts::stats::increment(tpalrts::stats_configuration::nb_heartbeats);
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
	  tpalrts::stats::increment(tpalrts::stats_configuration::nb_heartbeats);
	  tpalrts::stats::increment(tpalrts::stats_configuration::nb_heartbeats);
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

extern
void spmv_interrupt(
  double* val,
  uint64_t* row_ptr,
  uint64_t* col_ind,
  double* x,
  double* y,
  uint64_t row_lo,
  uint64_t row_hi,
  void* p);

extern
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
  void* p);

int row_loop_handler(
  double* val,
  uint64_t* row_ptr,
  uint64_t* col_ind,
  double* x,
  double* y,
  uint64_t row_lo,
  uint64_t row_hi,
  void* _p) {
  tpalrts::promotable* p = (tpalrts::promotable*)_p;
  tpalrts::stats::increment(tpalrts::stats_configuration::nb_heartbeats);
  if ((row_hi - row_lo) <= 1) {
    return 0;
  }
  auto mid = (row_lo + row_hi) / 2;
  p->fork_join_promote2([=] (tpalrts::promotable* p2) {
    spmv_interrupt(val, row_ptr, col_ind, x, y, row_lo, mid, p2);
  }, [=] (tpalrts::promotable* p2) {
    spmv_interrupt(val, row_ptr, col_ind, x, y, mid, row_hi, p2);
  }, [=] (tpalrts::promotable*) {

  });
  return 1;
}

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
  void* _p) {
  tpalrts::promotable* p = (tpalrts::promotable*)_p;
  tpalrts::stats::increment(tpalrts::stats_configuration::nb_heartbeats);
  auto nb_rows = row_hi - row_lo;
  if (nb_rows == 0) {
    return 0;
  }
  auto cf = [=] (tpalrts::promotable* p2) {
    spmv_interrupt_col_loop(val, row_ptr, col_ind, x, y, col_lo, col_hi, t, &y[row_lo], p2);
  };
  if (nb_rows == 1) {
    p->async_finish_promote(cf);
    return 1;
  }
  row_lo++;
  if (nb_rows == 2) {
    p->fork_join_promote2(cf, [=] (tpalrts::promotable* p2) {
      spmv_interrupt(val, row_ptr, col_ind, x, y, row_lo, row_hi, p2);
    }, [=] (tpalrts::promotable*) {
      // nothing left to do
    });
  } else {
    auto row_mid = (row_lo + row_hi) / 2;
    p->fork_join_promote3(cf, [=] (tpalrts::promotable* p2) {
      spmv_interrupt(val, row_ptr, col_ind, x, y, row_lo, row_mid, p2);
    }, [=] (tpalrts::promotable* p2) {
      spmv_interrupt(val, row_ptr, col_ind, x, y, row_mid, row_hi, p2);
    }, [=] (tpalrts::promotable*) {
      // nothing left to do
    });    
  }
  return 1;
}

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
  void* _p) {
  tpalrts::promotable* p = (tpalrts::promotable*)_p;
  tpalrts::stats::increment(tpalrts::stats_configuration::nb_heartbeats);
  if ((col_hi - col_lo) <= 1) {
    return 0;
  }
  auto col_mid = (col_lo + col_hi) / 2;
  using dst_rec_type = std::pair<double, double>;
  dst_rec_type* dst_rec;
  tpalrts::arena_block_type* dst_blk;
  std::tie(dst_rec, dst_blk) = tpalrts::alloc_arena<dst_rec_type>();
  p->fork_join_promote2([=] (tpalrts::promotable* p2) {
    spmv_interrupt_col_loop(val, row_ptr, col_ind, x, y, col_lo, col_mid, t, &(dst_rec->first), p2);
  }, [=] (tpalrts::promotable* p2) {
    spmv_interrupt_col_loop(val, row_ptr, col_ind, x, y, col_mid, col_hi, 0.0, &(dst_rec->second), p2);
  }, [=] (tpalrts::promotable*) {
    *dst = dst_rec->first + dst_rec->second;
    decr_arena_block(dst_blk);
  });
  return 1;
}

/*---------------------------------------------------------------------*/
/* Software-polling version */

static
void spmv_software_polling_col_loop(double* val,
                                    uint64_t* row_ptr,
                                    uint64_t* col_ind,
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
                                        uint64_t* row_ptr,
                                        uint64_t* col_ind,
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
        using dst_rec_type = std::pair<double, double>;
        dst_rec_type* dst_rec;
        tpalrts::arena_block_type* dst_blk;
        std::tie(dst_rec, dst_blk) = tpalrts::alloc_arena<dst_rec_type>();
	auto dst0 = dst;
	dst = &(dst_rec->first);
        p->fork_join_promote([=] (tpalrts::promotable* p2) {
          spmv_software_polling_col_loop_par(K, val, row_ptr, col_ind, x, mid, k_hi, &(dst_rec->second), p2);
        }, [=] (tpalrts::promotable*) {
          *dst0 = dst_rec->first + dst_rec->second;
          decr_arena_block(dst_blk);
	});
        k_hi = mid;
      }
    }
  }
  *dst = t;
}

static
void spmv_software_polling_row_loop(double* val,
                                    uint64_t* row_ptr,
                                    uint64_t* col_ind,
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
              using dst_rec_type = double;
              dst_rec_type* dst_rec;
              tpalrts::arena_block_type* dst_blk;
              std::tie(dst_rec, dst_blk) = tpalrts::alloc_arena<dst_rec_type>();
              *dst_rec = 0.0;
              p->fork_join_promote([=] (tpalrts::promotable* p2) {
               spmv_software_polling_col_loop_par(K, val, row_ptr, col_ind, x, k_lo, k_hi, dst_rec, p2);
              }, [=] (tpalrts::promotable*) {
                y[i_lo] = t + *dst_rec;
                decr_arena_block(dst_blk);
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
                           uint64_t* row_ptr,
                           uint64_t* col_ind,
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
               uint64_t* row_ptr,
               uint64_t* col_ind,
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

/*---------------------------------------------------------------------*/

namespace spmv {

using namespace tpalrts;

char* name = "spmv";

char* random_bigrows_input = "random_bigrows";
char* random_bigcols_input = "random_bigcols";
char* arrowhead_input = "arrowhead";

uint64_t n_bigrows = 3000000;
uint64_t degree_bigrows = 100;
uint64_t n_bigcols = 10000000;
uint64_t n_arrowhead = 100000000;
  
uint64_t row_len = 1000;
uint64_t degree = 4;
uint64_t dim = 5;
uint64_t nb_rows;
uint64_t nb_vals;
double* val;
uint64_t* row_ptr;
uint64_t* col_ind;
double* x;
double* y;

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

auto rand_double(size_t i) -> double {
  int m = 1000000;
  double v = hash64(i) % m;
  return v / m;
}

using edge_type = std::pair<uint64_t, uint64_t>;

using edgelist_type = std::vector<edge_type>;

auto mk_random_local_edgelist(size_t dim, size_t degree, size_t num_rows)
  -> edgelist_type {
  size_t non_zeros = num_rows*degree;
  edgelist_type edges;
  for (size_t k = 0; k < non_zeros; k++) {
    size_t i = k / degree;
    size_t j;
    if (dim==0) {
      size_t h = k;
      do {
	j = ((h = hash64(h)) % num_rows);
      } while (j == i);
    } else {
      size_t _pow = dim+2;
      size_t h = k;
      do {
	while ((((h = hash64(h)) % 1000003) < 500001)) _pow += dim;
	j = (i + ((h = hash64(h)) % (((long) 1) << _pow))) % num_rows;
      } while (j == i);
    }
    edges.push_back(std::make_pair(i, j));
  }
  return edges;
}

static float powerlaw_random(size_t i, float dmin, float dmax, float n) {
  float r = (float)hash64(i) / RAND_MAX;
  return mypow((mypow(dmax, n) - mypow(dmin, n)) * mypow(r, 3) + mypow(dmin, n), 1.0 / n);
}

std::vector<int> siteSizes(size_t n) {
  std::vector<int> site_sizes;
  for (int i = 0; i < n;) {
    int c = powerlaw_random(i, 1,
                            std::min(50000, (int) (100000. * n / 100e6)),
                            0.001);
    c = (c==0)?1:c;
    site_sizes.push_back(c);
    i += c;
  }
  return site_sizes;
}

auto mk_powerlaw_edgelist(size_t num_rows) {
  edgelist_type edges;
  size_t n = num_rows;
  size_t inRatio = 10;
  size_t degree = 15;
  std::vector<int> site_sizes = siteSizes(n);
  size_t sites = site_sizes.size();
  size_t *sizes = (size_t*)malloc(sizeof(size_t) * sites);
  size_t *offsets = (size_t*)malloc(sizeof(size_t) * sites);
  size_t o = 0;
  for (size_t i=0; i < sites; i++) {
    sizes[i] = site_sizes[i];
    offsets[i] = o;
    o += sizes[i];
    if (o > n) sizes[i] = std::max<size_t>(0,sizes[i] + n - o);
  }
  for (size_t i=0; i < sites; i++) {
    for (size_t j =0; j < sizes[i]; j++) {
      for (size_t k = 0; k < degree; k++) {
	auto h1 = hash64(i+j+k);
	auto h2 = hash64(h1);
	auto h3 = hash64(h2);
	size_t target_site = (h1 % inRatio != 0) ? i : (h2 % sites);
	size_t site_id = h3 % sizes[target_site];
	size_t idx = offsets[i] + j;
	edges.push_back(std::make_pair(idx, offsets[target_site] + site_id));
      }
    }
  }
  free(sizes);
  free(offsets);
  return edges;
}

auto mk_arrowhead_edgelist(size_t n) {
  edgelist_type edges;
  for (size_t i = 0; i < n; i++) {
    edges.push_back(std::make_pair(i, 0));
  }
  for (size_t i = 0; i < n; i++) {
    edges.push_back(std::make_pair(0, i));
  }
  for (size_t i = 0; i < n; i++) {
    edges.push_back(std::make_pair(i, i));
  }
  return edges;
}

auto csr_of_edgelist(edgelist_type& edges) {
  std::sort(edges.begin(), edges.end(), std::less<edge_type>());
  {
    edgelist_type edges2;
    edge_type prev = edges.back();
    for (auto& e : edges) {
      if (e != prev) {
	edges2.push_back(e);
      }
      prev = e;
    }
    edges2.swap(edges);
    edges2.clear();
  }
  nb_vals = edges.size();
  row_ptr = (uint64_t*)malloc(sizeof(uint64_t) * (nb_rows + 1));
  for (size_t i = 0; i < nb_rows + 1; i++) {
    row_ptr[i] = 0;
  }
  for (auto& e : edges) {
    assert((e.first >= 0) && (e.first < nb_rows));
    row_ptr[e.first]++;
  }
  { // initialize column indices
    col_ind = (uint64_t*)malloc(sizeof(uint64_t) * nb_vals);
    uint64_t i = 0;
    for (auto& e : edges) {
      col_ind[i++] = e.second;
    }
  }
  edges.clear();
  { // initialize row pointers
    uint64_t a = 0;
    for (size_t i = 0; i < nb_rows; i++) {
      auto e = row_ptr[i];
      row_ptr[i] = a;
      a += e;
    }
    row_ptr[nb_rows] = a;
  }
  { // initialize nonzero values array
    val = (double*)malloc(sizeof(double) * nb_vals);
    for (size_t i = 0; i < nb_vals; i++) {
      val[i] = rand_double(i);
    }
  } 
  { /*
    for (auto& e : edges) {
      std::cout << e.first << "," << e.second << " ";
    }
    std::cout << std::endl;
    for (size_t i = 0; i < nb_rows+1; i++) {
      std::cout << "r[" << i << "]=" << row_ptr[i] << " ";
    }
    std::cout << std::endl;
    for (size_t i = 0; i < nb_vals; i++) {
      std::cout << "c[" << i << "]=" << col_ind[i] << " ";
    }
    std::cout << std::endl;  */
  } 
}

template <typename Gen_matrix>
auto bench_pre_shared(promotable*, const Gen_matrix& gen_matrix) {
  rollforward_table = {
    #include "spmv_rollforward_map.hpp"    
  };
  gen_matrix();
  x = (double*)malloc(sizeof(double) * nb_rows);
  y = (double*)malloc(sizeof(double) * nb_rows);
  if ((val == nullptr) || (row_ptr == nullptr) || (col_ind == nullptr) || (x == nullptr) || (y == nullptr)) {
    exit(1);
  }
  // initialize x and y vectors
  {
    for (size_t i = 0; i < nb_rows; i++) {
      x[i] = rand_double(i);
    }
    tpalrts::zero_init(y, nb_rows);
  }  
};

auto bench_pre_bigrows(promotable* p) {
  nb_rows = n_bigrows;
  degree = degree_bigrows;
  bench_pre_shared(p, [&] {
    auto edges = mk_random_local_edgelist(dim, degree, nb_rows);
    csr_of_edgelist(edges);
  });
}

auto bench_pre_bigcols(promotable* p) {
  nb_rows = n_bigcols;
  bench_pre_shared(p, [&] {
    auto edges = mk_powerlaw_edgelist(nb_rows);
    csr_of_edgelist(edges);
  });
}

auto bench_pre_arrowhead(promotable* p) {
  nb_rows = n_arrowhead;
  bench_pre_shared(p, [&] {
    auto edges = mk_arrowhead_edgelist(nb_rows);
    csr_of_edgelist(edges);
  });
}

auto bench_body_interrupt(promotable* p) {
  spmv_interrupt(val, row_ptr, col_ind, x, y, 0, nb_rows, p);
};
  
auto bench_body_software_polling(promotable* p) {

};
  
auto bench_body_serial(promotable*) {
  spmv_serial(val, row_ptr, col_ind, x, y, nb_rows);
};
  
auto bench_post(promotable*) {
#ifndef NDEBUG
  double* yref = (double*)malloc(sizeof(double) * nb_rows);
  {
    for (uint64_t i = 0; i != nb_rows; i++) {
      yref[i] = 1.0;
    }
    spmv_serial(val, row_ptr, col_ind, x, yref, nb_rows);
  }
  uint64_t nb_diffs = 0;
  double epsilon = 0.01;
  for (uint64_t i = 0; i != nb_rows; i++) {
    auto diff = std::abs(y[i] - yref[i]);
    if (diff > epsilon) {
      //printf("diff=%f y[i]=%f yref[i]=%f at i=%ld\n", diff, y[i], yref[i], i);
      nb_diffs++;
    }
  }
  //aprintf("nb_diffs %ld\n", nb_diffs);
  free(yref);
#endif
  free(val);
  free(row_ptr);
  free(col_ind);
  free(x);
  free(y);
};

auto bench_body_cilk() {
  spmv_cilk(val, row_ptr, col_ind, x, y, nb_rows);
};


}
