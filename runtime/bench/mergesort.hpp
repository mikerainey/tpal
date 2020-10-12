#pragma once

#ifdef USE_CILK_PLUS
#include <cilk/cilk.h>
#include <cilk/cilk_api.h>
#include <cilk/reducer_opadd.h>
#endif
#include <cstdint>
#include <assert.h>
#include <cstring>

#include "mcsl_util.hpp"

#include "tpalrts_fiber.hpp"
#include "tpalrts_stack.hpp"

#include "mergesort_rollforward_decls.hpp"

size_t mergesort_cilk_cutoff = 24;

template <typename Scheduler>
class mergesort_manual : public tpalrts::fiber<Scheduler> {
public:

  using trampoline_type = enum { entry, exit };

  trampoline_type trampoline = entry;

  mergesort_manual()
    : tpalrts::fiber<Scheduler>([] (tpalrts::promotable*) { return mcsl::fiber_status_finish; }) { }

  mcsl::fiber_status_type run() {
    return mcsl::fiber_status_finish;
  }

};

using Item = uint64_t;

//auto compare = std::less<Item>();

template<class InputIt, class OutputIt>
OutputIt stl_copy(InputIt first, InputIt last, OutputIt d_first) {
  while (first != last) {
    *d_first++ = *first++;
  }
  return d_first;
}

template<class InputIt1, class InputIt2,
         class OutputIt, class Compare>
OutputIt stl_merge(InputIt1 first1, InputIt1 last1,
               InputIt2 first2, InputIt2 last2,
               OutputIt d_first, Compare comp)
{
    for (; first1 != last1; ++d_first) {
        if (first2 == last2) {
            return stl_copy(first1, last1, d_first);
        }
        if (comp(*first2, *first1)) {
            *d_first = *first2;
            ++first2;
        } else {
            *d_first = *first1;
            ++first1;
        }
    }
    return stl_copy(first2, last2, d_first);
}

template<class ForwardIt, class T, class Compare>
ForwardIt stl_lower_bound(ForwardIt first, ForwardIt last, const T& value, Compare comp)
{
    ForwardIt it;
    typename std::iterator_traits<ForwardIt>::difference_type count, step;
    count = std::distance(first, last);
 
    while (count > 0) {
        it = first;
        step = count / 2;
        std::advance(it, step);
        if (comp(*it, value)) {
            first = ++it;
            count -= step + 1;
        }
        else
            count = step;
    }
    return first;
}

template<typename T>
  inline void copy_memory(T& a, const T &b) {
    std::memcpy(&a, &b, sizeof(T));
  }

 template<typename T>
  inline void move_uninitialized(T& a, const T b) {
    new (static_cast<void*>(std::addressof(a))) T(std::move(b));
  }

template <class E, class BinPred>
  void insertion_sort(E* A, size_t n, const BinPred& f) {
    for (size_t i=0; i < n; i++) {
      E v = std::move(A[i]); 
      E* B = A + i;
      while (--B >= A && f(v,*B)) copy_memory(*(B+1), *B);
      move_uninitialized(*(B+1), v);
    }
  }

template <class Item>
void copy(const Item* src, Item* dst,
          size_t lo_src, size_t hi_src, size_t lo_dst) {
  if ((hi_src - lo_src) > 0) {
    stl_copy(&src[lo_src], &src[hi_src-1]+1, &dst[lo_dst]);
  }
}

template <class Item, class Compare>
void merge_serial(const Item* xs, const Item* ys, Item* tmp,
               size_t lo_xs, size_t hi_xs,
               size_t lo_ys, size_t hi_ys,
               size_t lo_tmp,
               const Compare& compare) {
  stl_merge(&xs[lo_xs], &xs[hi_xs], &ys[lo_ys], &ys[hi_ys], &tmp[lo_tmp], compare);
}

template <class Item, class Compare>
void mergesort_serial(Item* xs, Item* tmp, size_t lo, size_t hi, const Compare& compare) {
  auto n = hi - lo;
  if (n <= 1) {
    return;
  }
  if (n <= mergesort_cilk_cutoff) {
    insertion_sort(&xs[lo], n, compare);
    //std::sort(xs + lo, xs + hi, compare);
    return;
  }
  auto mid = (hi + lo) / 2;
  mergesort_serial(xs, tmp, lo, mid, compare);
  mergesort_serial(xs, tmp, mid, hi, compare);
  merge_serial(xs, xs, tmp, lo, mid, mid, hi, lo, compare);
  stl_copy(&tmp[lo], &tmp[hi], &xs[lo]);
}


template <class Item, class Compare>
size_t lower_bound(const Item* xs, size_t lo, size_t hi, const Item& val, const Compare& compare) {
  const Item* first_xs = &xs[0];
  return stl_lower_bound(first_xs + lo, first_xs + hi, val, compare) - first_xs;
}

using merge_args_type = struct merge_args_struct {
  Item* mg_xs; Item* mg_ys; Item* mg_tmp;
  size_t mg_lo_xs; size_t mg_hi_xs;
  size_t mg_lo_ys; size_t mg_hi_ys;
  size_t mg_lo_tmp;
};

using copy_args_type = std::pair<size_t, size_t>;

extern
void mergesort_interrupt(
                   Item* ms_xs,
                   Item* ms_tmp,
                   size_t ms_lo, size_t ms_hi,
                   void* p,
                   tpalrts::stack_type s,
                   void* pc,
                   merge_args_type* merge_args,
                   copy_args_type* copy_args);

int mergesort_handler(
		      Item* ms_xs,
		      Item* ms_tmp,
		      size_t ms_lo,
		      size_t ms_hi,
		      size_t cp_lo,
		      size_t& cp_hi,
		      void* _p,
		      tpalrts::stack_type s, char*& sp, char*& prmhd, char*& prmtl,
		      void* __ms_entry,
		      void* __ms_retk,
		      void* __ms_joink,
		      void* __ms_clonek,
		      void* __ms_branch1,
		      void* __ms_branch2,
		      void* __ms_branch3,
  		      void* __mg_entry,
		      void* __mg_entry2,
		      void* __mg_branch1,
		      void* __mg_branch2,
		      void* __mg_retk,
		      void* __mg_joink,
		      void* __mg_clonek,
		      void* __cp_par,
		      void* __cp_joink,
		      void*& pc) {
  tpalrts::promotable* p = (tpalrts::promotable*)_p;
  tpalrts::stats::increment(tpalrts::stats_configuration::nb_heartbeats);
  pc = tpalrts::reverse_lookup_rollforward_entry(pc);
  if (prmempty(prmtl, prmhd)) {
    if (cp_lo == cp_hi) {
      return 0;
    }
    assert(cp_lo < cp_hi);
    auto mid = (cp_lo + cp_hi) / 2;
    copy_args_type* cp_args2;
    tpalrts::arena_block_type* blk;
    std::tie(cp_args2, blk) = tpalrts::alloc_arena<copy_args_type>();
    cp_args2->first = mid;
    cp_args2->second = cp_hi;
    if (pc == __cp_par) {
      p->async_finish_promote([=] (tpalrts::promotable* p2) {
	tpalrts::stack_type s2 = tpalrts::snew();
	mergesort_interrupt(ms_xs, ms_tmp, ms_lo, ms_hi, p2, s2, __cp_par, nullptr, cp_args2);
      });
    } else {
      p->fork_join_promote([=] (tpalrts::promotable* p2) {
	tpalrts::stack_type s2 = tpalrts::snew();
	mergesort_interrupt(ms_xs, ms_tmp, ms_lo, ms_hi, p2, s2, __cp_par, nullptr, cp_args2);
      }, [=] (tpalrts::promotable* p2) {
	decr_arena_block(blk);
	auto sj = tpalrts::stack_type(s.stack, sp, prmhd, prmtl);
	mergesort_interrupt(ms_xs, ms_tmp, ms_lo, ms_hi, p2, sj, __cp_joink, nullptr, nullptr);
      });
    }
    pc = __cp_par;
    cp_hi = mid;
    return 1;
  }
  char* sp_cont;
  uint64_t top;
  prmsplit(sp, prmtl, prmhd, sp_cont, top);
  char* sp_top = sp + top;
  auto pc_top = tpalrts::reverse_lookup_rollforward_entry(sload(sp_top, 0, void*));
  if (pc_top == __ms_branch1) { // promotion for mergesort
    sstore(sp_top, 0, void*, __ms_joink);
    auto ms_xs2 = sload(sp_top, 3, Item*);
    auto ms_tmp2 = sload(sp_top, 4, Item*);
    auto ms_lo2 = sload(sp_top, 5, size_t);
    auto ms_hi2 = sload(sp_top, 6, size_t);
    p->fork_join_promote([=] (tpalrts::promotable* p2) {
      tpalrts::stack_type s2 = tpalrts::snew();
      void* pc2;
      auto t = tpalrts::reverse_lookup_rollforward_entry(sload(sp_top, 0, void*));
      if (t != __ms_clonek) { // slow clone
	pc2 = __ms_entry;
      } else { // fast clone
	pc2 = __ms_clonek;
	s2 = s;
	s2.sp = sp_top;
      }
      mergesort_interrupt(ms_xs2, ms_tmp2, ms_lo2, ms_hi2, p2, s2, pc2, nullptr, nullptr);
    }, [=] (tpalrts::promotable* p2) {
      auto sj = s;
      sj.sp = sp_top;
      mergesort_interrupt(ms_xs2, ms_tmp2, ms_lo2, ms_hi2, p2, sj, __ms_branch2, nullptr, nullptr);
    });
  } else if (pc_top == __mg_branch1) { // promotion for merge
    sstore(sp_top, 0, void*, __mg_joink);
    merge_args_type* merge_args2;
    tpalrts::arena_block_type* blk;
    std::tie(merge_args2, blk) = tpalrts::alloc_arena<merge_args_type>();
    merge_args2->mg_xs = sload(sp_top, 3, Item*); merge_args2->mg_ys = sload(sp_top, 4, Item*);
    merge_args2->mg_tmp = sload(sp_top, 5, Item*);
    merge_args2->mg_lo_xs = sload(sp_top, 6, size_t); merge_args2->mg_hi_xs = sload(sp_top, 7, size_t);
    merge_args2->mg_lo_ys = sload(sp_top, 8, size_t); merge_args2->mg_hi_ys = sload(sp_top, 9, size_t);
    merge_args2->mg_lo_tmp = sload(sp_top, 10, size_t);
    p->fork_join_promote([=] (tpalrts::promotable* p2) {
      tpalrts::stack_type s2 = tpalrts::snew();
      void* pc2;
      auto t = tpalrts::reverse_lookup_rollforward_entry(sload(sp_top, 0, void*));
      if (t != __mg_clonek) { // slow clone
	pc2 = __mg_entry2;
      } else { // fast clone
	pc2 = __mg_clonek;
	s2 = s;
	s2.sp = sp_top;
      }
      mergesort_interrupt(ms_xs, ms_tmp, ms_lo, ms_hi, p2, s2, pc2, merge_args2, nullptr);
    }, [=] (tpalrts::promotable* p2) {
      decr_arena_block(blk);
      auto sj = s;
      sj.sp = sp_top;
      mergesort_interrupt(ms_xs, ms_tmp, ms_lo, ms_hi, p2, sj, __mg_branch2, nullptr, nullptr);
    });
  } else {
    //aprintf("pc_top=%p b2=%p\n",pc_top, __mg_branch2);
    assert(false);
    return 0;
  }
  return 1;
}

size_t merge_cilk_cutoff = 2000;

size_t copy_cilk_cutoff = 2000;

template<class InputIt, class OutputIt>
void copy(InputIt first, InputIt last, OutputIt d_first) {
#if defined(USE_CILK_PLUS)
  size_t n = last - first;
  if (n <= copy_cilk_cutoff) {
    stl_copy(first, last, d_first);
    return;
  }
  size_t mid = n / 2;
  cilk_spawn copy(first, first + mid, d_first);
             copy(first + mid, last, d_first + mid);
  cilk_sync;
#endif
}

template <class Item, class Compare>
void merge_cilk(const Item* xs, const Item* ys, Item* tmp,
               size_t lo_xs, size_t hi_xs,
               size_t lo_ys, size_t hi_ys,
               size_t lo_tmp,
               const Compare& compare) {
#if defined(USE_CILK_PLUS)
  size_t n1 = hi_xs - lo_xs;
  size_t n2 = hi_ys - lo_ys;
  if (n1 < n2) {
    // to ensure that the first subarray being sorted is the larger or the two
    merge_cilk(ys, xs, tmp, lo_ys, hi_ys, lo_xs, hi_xs, lo_tmp, compare);
  } else if (n1 == 0) {
    // xs and ys empty
  } else if (n1 == 1) {
    if (n2 == 0) {
      // xs singleton; ys empty
      tmp[lo_tmp] = xs[lo_xs];
    } else {
      // both singletons
      tmp[lo_tmp+0] = std::min(xs[lo_xs], ys[lo_ys], compare);
      tmp[lo_tmp+1] = std::max(xs[lo_xs], ys[lo_ys], compare);
    }
  } else if (n1 < merge_cilk_cutoff) {
    merge_serial(xs, ys, tmp, lo_xs, hi_xs, lo_ys, hi_ys, lo_tmp, compare);
  } else {
    // select pivot positions
    size_t mid_xs = (lo_xs + hi_xs) / 2;
    size_t mid_ys = lower_bound(ys, lo_ys, hi_ys, xs[mid_xs], compare);
    // number of items to be treated by the first parallel call
    size_t k = (mid_xs - lo_xs) + (mid_ys - lo_ys);
    cilk_spawn merge_cilk(xs, ys, tmp, lo_xs, mid_xs, lo_ys, mid_ys, lo_tmp, compare);
    merge_cilk(xs, ys, tmp, mid_xs, hi_xs, mid_ys, hi_ys, lo_tmp + k, compare);
    cilk_sync;
  }
#endif
}

template <class Item, class Compare>
void mergesort_cilk(Item* xs, Item* tmp, size_t lo, size_t hi, const Compare& compare) {
#if defined(USE_CILK_PLUS)
  auto n = hi - lo;
  if (n <= 1) {
    return;
  }
  if (n <= mergesort_cilk_cutoff) {
    insertion_sort(&xs[lo], n, compare);
    //std::sort(xs + lo, xs + hi, compare);
    return;
  }
  auto mid = (hi + lo) / 2;
  cilk_spawn mergesort_cilk(xs, tmp, lo, mid, compare);
             mergesort_cilk(xs, tmp, mid, hi, compare);
  cilk_sync;
  merge_cilk(xs, xs, tmp, lo, mid, mid, hi, lo, compare);
  copy(&tmp[lo], &tmp[hi], &xs[lo]);
#endif
}

namespace mergesort {

using namespace tpalrts;

char* name = "mergesort";

uint64_t n = 20000000;
uint64_t* xs;
uint64_t* tmp;
auto compare = std::less<uint64_t>();

tpalrts::stack_type s;

auto fill_xs(uint64_t* _xs) {
  uint64_t xs_i = 1233332;
  for (std::size_t i = 0; i != n; i++) {
    _xs[i] = xs_i;
    xs_i = mcsl::hash(xs_i) % 1000;
  }
};

auto bench_pre(promotable* p) {
  rollforward_table = {
    #include "mergesort_rollforward_map.hpp"
  };
  xs = (uint64_t*)malloc(sizeof(uint64_t) * n);
  tmp = (uint64_t*)malloc(sizeof(uint64_t) * n);
  fill_xs(xs);
};

auto bench_body_interrupt(promotable* p) {
  s = tpalrts::snew();
  mergesort_interrupt(xs, tmp, 0, n, p, s, nullptr, nullptr, nullptr);
};

auto bench_body_software_polling(promotable* p) {

};

auto bench_body_serial(promotable* p) {
  mergesort_serial(xs, tmp, 0, n, compare);
};

auto bench_post(promotable* p) {
#if ! defined(NDEBUG) && defined(TPALRTS_LINUX)
  uint64_t* xs2 = (uint64_t*)malloc(sizeof(uint64_t) * n);
  fill_xs(xs2);
  std::sort(&xs2[0], &xs2[n], compare);
  std::size_t nb_diffs = 0;
  for (std::size_t i = 0; i != n; i++) {
    if (xs[i] != xs2[i]) {
      nb_diffs++;
    }
  }
  printf("nb_diffs %lu\n", nb_diffs);
  free(xs2);
#endif
  free(xs);
  free(tmp);
};

auto bench_body_cilk() {
  mergesort_cilk(xs, tmp, 0, n, compare);
};

  
}
