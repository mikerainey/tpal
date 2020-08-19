#pragma once

#ifdef USE_CILK_PLUS
#include <cilk/cilk.h>
#include <cilk/cilk_api.h>
#include <cilk/reducer_opadd.h>
#endif
#include <cstdint>
#include <assert.h>

#include "mcsl_util.hpp"

#include "tpalrts_fiber.hpp"
#include "tpalrts_stack.hpp"

using Item = uint64_t;
auto compare = std::less<Item>();

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

template <class Item>
void copy(const Item* src, Item* dst,
          size_t lo_src, size_t hi_src, size_t lo_dst) {
  if ((hi_src - lo_src) > 0) {
    std::copy(&src[lo_src], &src[hi_src-1]+1, &dst[lo_dst]);
  }
}

template <class Item, class Compare>
void merge_seq(const Item* xs, const Item* ys, Item* tmp,
               size_t lo_xs, size_t hi_xs,
               size_t lo_ys, size_t hi_ys,
               size_t lo_tmp,
               const Compare& compare) {
  std::merge(&xs[lo_xs], &xs[hi_xs], &ys[lo_ys], &ys[hi_ys], &tmp[lo_tmp], compare);
}

template <class Item, class Compare>
size_t lower_bound(const Item* xs, size_t lo, size_t hi, const Item& val, const Compare& compare) {
  const Item* first_xs = &xs[0];
  return std::lower_bound(first_xs + lo, first_xs + hi, val, compare) - first_xs;
}

using heartbeat_mechanism_type = enum heartbeat_mechanism_struct {
  heartbeat_mechanism_software_polling,
  heartbeat_mechanism_hardware_interrupt
};

static constexpr
int heartbeat_merge_thresh = 64;

static constexpr
int cp_chunk = 1024;

using merge_args_type = struct merge_args_struct {
  Item* mg_xs; Item* mg_ys; Item* mg_tmp;
  size_t mg_lo_xs; size_t mg_hi_xs;
  size_t mg_lo_ys; size_t mg_hi_ys;
  size_t mg_lo_tmp;
};

using copy_args_type = std::pair<size_t, size_t>;

void mergesort_par(
                   Item* ms_xs,
                   Item* ms_tmp,
                   size_t ms_lo, size_t ms_hi,
                   tpalrts::promotable* p,
                   tpalrts::stack_type s,
                   int64_t K=tpalrts::dflt_software_polling_K,
                   void* pc = nullptr,
                   merge_args_type* merge_args = nullptr,
                   copy_args_type* copy_args = nullptr) {
  sunpack(s);
  int heartbeat=heartbeat_mechanism_software_polling;

  size_t mid, n1, n2;

  Item* mg_xs; Item* mg_ys; Item* mg_tmp;
  size_t mg_lo_xs; size_t mg_hi_xs;
  size_t mg_lo_ys; size_t mg_hi_ys;
  size_t mg_lo_tmp;

  if (merge_args != nullptr) {
    mg_xs = merge_args->mg_xs; mg_ys = merge_args->mg_ys; mg_tmp = merge_args->mg_tmp;
    mg_lo_xs = merge_args->mg_lo_xs; mg_hi_xs = merge_args->mg_hi_xs;
    mg_lo_ys = merge_args->mg_lo_ys; mg_hi_ys = merge_args->mg_hi_ys;
    mg_lo_tmp = merge_args->mg_lo_tmp; 
  }

  size_t cp_lo = 0, cp_hi = 0;

  if (copy_args != nullptr) {
    cp_lo = copy_args->first;
    cp_hi = copy_args->second;
  }
    
  void* __ms_entry = &&ms_entry;
  void* __ms_retk = &&ms_retk;
  void* __ms_joink = &&ms_joink;
  void* __ms_clonek = &&ms_clonek;
  void* __ms_branch1 = &&ms_branch1;
  void* __ms_branch2 = &&ms_branch2;
  void* __ms_branch3 = &&ms_branch3;
  
  void* __mg_entry = &&mg_entry;
  void* __mg_entry2 = &&mg_entry2;
  void* __mg_branch1 = &&mg_branch1;
  void* __mg_branch2 = &&mg_branch2;
  void* __mg_retk = &&mg_retk;
  void* __mg_joink = &&mg_joink;
  void* __mg_clonek = &&mg_clonek;

  void* __cp_par = &&cp_par;
  void* __cp_joink = &&cp_joink;

  pc = (pc == nullptr) ? __ms_entry : pc;

  auto try_promote = [&] {
    if (prmempty(prmtl, prmhd)) {
      if (cp_lo == cp_hi) {
        return;
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
          mergesort_par(ms_xs, ms_tmp, ms_lo, ms_hi, p2, s2, K, __cp_par, nullptr, cp_args2);
        });
      } else {
        p->fork_join_promote([=] (tpalrts::promotable* p2) {
          tpalrts::stack_type s2 = tpalrts::snew();
          mergesort_par(ms_xs, ms_tmp, ms_lo, ms_hi, p2, s2, K, __cp_par, nullptr, cp_args2);
        }, [=] (tpalrts::promotable* p2) {
          decr_arena_block(blk);
          auto sj = tpalrts::stack_type(stack, sp, prmhd, prmtl);
          mergesort_par(ms_xs, ms_tmp, ms_lo, ms_hi, p2, sj, K, __cp_joink);
        });
      }
      pc = __cp_par;
      cp_hi = mid;
      return;
    }
    char* sp_cont;
    uint64_t top;
    prmsplit(sp, prmtl, prmhd, sp_cont, top);
    char* sp_top = sp + top;
    auto pc_top = sload(sp_top, 0, void*);
    if (pc_top == __ms_branch1) { // promotion for mergesort
      sstore(sp_top, 0, void*, __ms_joink);
      auto ms_xs2 = sload(sp_top, 3, Item*);
      auto ms_tmp2 = sload(sp_top, 4, Item*);
      auto ms_lo2 = sload(sp_top, 5, size_t);
      auto ms_hi2 = sload(sp_top, 6, size_t);
      p->fork_join_promote([=] (tpalrts::promotable* p2) {
        tpalrts::stack_type s2 = tpalrts::snew();
        void* pc2;
        if (sload(sp_top, 0, void*) != __ms_clonek) { // slow clone
          pc2 = __ms_entry;
        } else { // fast clone
          pc2 = __ms_clonek;
          s2 = s;
          s2.sp = sp_top;
        }
        mergesort_par(ms_xs2, ms_tmp2, ms_lo2, ms_hi2, p2, s2, K, pc2);
      }, [=] (tpalrts::promotable* p2) {
        auto sj = s;
        sj.sp = sp_top;
        mergesort_par(ms_xs2, ms_tmp2, ms_lo2, ms_hi2, p2, sj, K, __ms_branch2);
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
        if (sload(sp_top, 0, void*) != __mg_clonek) { // slow clone
          pc2 = __mg_entry2;
        } else { // fast clone
          pc2 = __mg_clonek;
          s2 = s;
          s2.sp = sp_top;
        }
        mergesort_par(ms_xs, ms_tmp, ms_lo, ms_hi, p2, s2, K, pc2, merge_args2);
      }, [=] (tpalrts::promotable* p2) {
        decr_arena_block(blk);
        auto sj = s;
        sj.sp = sp_top;
        mergesort_par(ms_xs, ms_tmp, ms_lo, ms_hi, p2, sj, K, __mg_branch2);
      });
    } else {
      assert(false);
    }
  };

  uint64_t promotion_prev = (heartbeat == heartbeat_mechanism_software_polling) ? mcsl::cycles::now() : 0;
  uint64_t k = K;

  goto *pc;

  // start parallel mergesort

 ms_entry:
  salloc(sp, 1);
  sstore(sp, 0, void*, &&ms_exitk);

 ms_loop:
  if (--k == 0) {
    k = K;
    if (heartbeat == heartbeat_mechanism_software_polling) {
      auto cur = mcsl::cycles::now();
      if (mcsl::cycles::diff(promotion_prev, cur) > tpalrts::kappa_cycles) {
        promotion_prev = cur;
        tpalrts::stats::increment(tpalrts::stats_configuration::nb_heartbeats);
        try_promote();
      }
    } else if (heartbeat == heartbeat_mechanism_hardware_interrupt) {
      if (tpalrts::flags.mine().load()) {
        tpalrts::flags.mine().store(false);
        try_promote();
      }
    }
  }
  if ((ms_hi - ms_lo) < 64) {
    std::sort(&ms_xs[ms_lo], &ms_xs[ms_hi], compare);
    goto ms_retk;
  }
  mid = (ms_lo + ms_hi) / 2;
  salloc(sp, 8);
  sstore(sp, 0, void*, &&ms_branch1);
  prmpush(sp, 1, prmtl, prmhd);
  sstore(sp, 3, Item*, ms_xs);
  sstore(sp, 4, Item*, ms_tmp);
  sstore(sp, 5, size_t, mid);
  sstore(sp, 6, size_t, ms_hi);
  sstore(sp, 7, size_t, ms_lo);
  ms_hi = mid;
  goto ms_loop;

 ms_branch1:
  sstore(sp, 0, void*, &&ms_branch2);
  prmpop(sp, 1, prmtl, prmhd);
  ms_xs = sload(sp, 3, Item*);
  ms_tmp = sload(sp, 4, Item*);
  ms_lo = sload(sp, 5, size_t);
  ms_hi = sload(sp, 6, size_t);
  goto ms_loop;

 ms_branch2:
  sstore(sp, 0, void*, &&ms_branch3);
  mg_xs = ms_xs;
  mg_ys = ms_xs;
  mg_tmp = ms_tmp;
  mg_lo_xs = sload(sp, 7, size_t);
  mg_hi_xs = sload(sp, 5, size_t);
  mg_lo_ys = mg_hi_xs;
  mg_hi_ys = sload(sp, 6, size_t);
  mg_lo_tmp = mg_lo_xs;
  goto mg_entry;

 ms_branch3:
  ms_xs = sload(sp, 3, Item*);
  ms_tmp = sload(sp, 4, Item*);
  ms_lo = sload(sp, 7, size_t);
  ms_hi = sload(sp, 6, size_t);
  cp_lo = ms_lo;
  cp_hi = ms_hi;
  goto cp_entry;

 ms_joink:
  sstore(sp, 0, void*, &&ms_clonek);
  sfree(sp, 1);
  return;

 ms_clonek:
  salloc(sp, 1);
  sstore(sp, 0, void*, &&ms_joink);
  goto ms_loop;

 ms_retk:
  goto *sload(sp, 0, void*);

 ms_exitk:
  sfree(sp, 1);
  sdelete(s);
  return;

  // start parallel copy

 cp_entry:
  if (--k == 0) {
    k = K;
    pc = &&cp_entry;
    if (heartbeat == heartbeat_mechanism_software_polling) {
      auto cur = mcsl::cycles::now();
      if (mcsl::cycles::diff(promotion_prev, cur) > tpalrts::kappa_cycles) {
        promotion_prev = cur;
        tpalrts::stats::increment(tpalrts::stats_configuration::nb_heartbeats);
        try_promote();
        goto *pc;
      }
    } else if (heartbeat == heartbeat_mechanism_hardware_interrupt) {
      if (tpalrts::flags.mine().load()) {
        tpalrts::flags.mine().store(false);
        try_promote();
        goto *pc;
      }
    }
  } 
  if (cp_lo == cp_hi) {
    goto cp_joink;
  }
  {
    size_t cp_k = std::min(cp_hi, cp_lo + cp_chunk);
    std::copy(&ms_tmp[cp_lo], &ms_tmp[cp_k], &ms_xs[cp_lo]);
    cp_lo = cp_k;
  }
  goto cp_entry;

 cp_par:
  if (--k == 0) {
    k = K;
    pc = &&cp_par;
    if (heartbeat == heartbeat_mechanism_software_polling) {
      auto cur = mcsl::cycles::now();
      if (mcsl::cycles::diff(promotion_prev, cur) > tpalrts::kappa_cycles) {
        promotion_prev = cur;
        tpalrts::stats::increment(tpalrts::stats_configuration::nb_heartbeats);
        try_promote();
        goto *pc;
      }
    } else if (heartbeat == heartbeat_mechanism_hardware_interrupt) {
      if (tpalrts::flags.mine().load()) {
        tpalrts::flags.mine().store(false);
        try_promote();
        goto *pc;
      }
    }
  } 
  if (cp_lo == cp_hi) {
    return;
  }
  {
    size_t cp_k = std::min(cp_hi, cp_lo + cp_chunk);
    std::copy(&ms_tmp[cp_lo], &ms_tmp[cp_k], &ms_xs[cp_lo]);
    cp_lo = cp_k;
  }
  goto cp_par;  

 cp_joink:
  sfree(sp, 8);
  goto ms_retk;  
  
  // start parallel merge

 mg_entry:
  salloc(sp, 1);
  sstore(sp, 0, void*, &&mg_exitk);
  
 mg_loop:
  n1 = mg_hi_xs - mg_lo_xs;
  n2 = mg_hi_ys - mg_lo_ys;
  if (n1 < n2) {
    std::swap(mg_xs, mg_ys);
    std::swap(mg_lo_xs, mg_lo_ys);
    std::swap(mg_hi_xs, mg_hi_ys);
    goto mg_loop;
  }
  if (--k == 0) {
    k = K;
    if (heartbeat == heartbeat_mechanism_software_polling) {
      auto cur = mcsl::cycles::now();
      if (mcsl::cycles::diff(promotion_prev, cur) > tpalrts::kappa_cycles) {
        promotion_prev = cur;
        tpalrts::stats::increment(tpalrts::stats_configuration::nb_heartbeats);
        try_promote();
      }
    } else if (heartbeat == heartbeat_mechanism_hardware_interrupt) {
      if (tpalrts::flags.mine().load()) {
        tpalrts::flags.mine().store(false);
        try_promote();
      }
    }
  }  
  if (n1 == 0) {
    // mg_xs and mg_ys empty
    goto mg_retk;
  } else if (n1 == 1) {
    if (n2 == 0) {
      // mg_xs singleton; mg_ys empty
      mg_tmp[mg_lo_tmp] = mg_xs[mg_lo_xs];
    } else {
      // both singletons
      mg_tmp[mg_lo_tmp+0] = std::min(mg_xs[mg_lo_xs], mg_ys[mg_lo_ys], compare);
      mg_tmp[mg_lo_tmp+1] = std::max(mg_xs[mg_lo_xs], mg_ys[mg_lo_ys], compare);
    }
    goto mg_retk;
  } else if (n1 < heartbeat_merge_thresh) {
    merge_seq(mg_xs, mg_ys, mg_tmp, mg_lo_xs, mg_hi_xs, mg_lo_ys, mg_hi_ys, mg_lo_tmp, compare);
    goto mg_retk;
  } else {
    // select pivot positions
    size_t mid_xs = (mg_lo_xs + mg_hi_xs) / 2;
    size_t mid_ys = lower_bound(mg_ys, mg_lo_ys, mg_hi_ys, mg_xs[mid_xs], compare);
    // number of items to be treated by the first parallel call
    size_t k = (mid_xs - mg_lo_xs) + (mid_ys - mg_lo_ys);
    salloc(sp, 11);
    sstore(sp, 0, void*, &&mg_branch1);
    prmpush(sp, 1, prmtl, prmhd);
    sstore(sp, 3, Item*, mg_xs);
    sstore(sp, 4, Item*, mg_ys);
    sstore(sp, 5, Item*, mg_tmp);
    sstore(sp, 6, size_t, mid_xs);
    sstore(sp, 7, size_t, mg_hi_xs);
    sstore(sp, 8, size_t, mid_ys);
    sstore(sp, 9, size_t, mg_hi_ys);
    sstore(sp, 10, size_t, (mg_lo_tmp + k));
    mg_hi_xs = mid_xs;
    mg_hi_ys = mid_ys;
    goto mg_loop;
  }

 mg_branch1:
  sstore(sp, 0, void*, &&mg_branch2);
  prmpop(sp, 1, prmtl, prmhd);
  mg_xs = sload(sp, 3, Item*);
  mg_ys = sload(sp, 4, Item*);
  mg_tmp = sload(sp, 5, Item*);
  mg_lo_xs = sload(sp, 6, size_t);
  mg_hi_xs = sload(sp, 7, size_t);
  mg_lo_ys = sload(sp, 8, size_t);
  mg_hi_ys = sload(sp, 9, size_t);
  mg_lo_tmp = sload(sp, 10, size_t);
  goto mg_loop;

 mg_branch2:
  sfree(sp, 11);
  goto mg_retk;
  
 mg_retk:
  goto *sload(sp, 0, void*);

 mg_joink:
  sstore(sp, 0, void*, &&mg_clonek);
  sfree(sp, 1);
  return;

 mg_clonek:
  salloc(sp, 1);
  sstore(sp, 0, void*, &&mg_joink);
  goto mg_loop;

 mg_exitk:
  sfree(sp, 1);
  goto mg_retk;

 mg_entry2:
  salloc(sp, 1);
  sstore(sp, 0, void*, &&mg_exitk2);
  goto mg_loop;

 mg_exitk2:
  sfree(sp, 1);
  return;

}

size_t merge_cilk_cutoff = 10000;

size_t mergesort_cilk_cutoff = 10000;

size_t copy_cilk_cutoff = 10000;

template<class InputIt, class OutputIt>
void copy(InputIt first, InputIt last, OutputIt d_first) {
#if defined(USE_CILK_PLUS)
  size_t n = last - first;
  if (n <= copy_cilk_cutoff) {
    std::copy(first, last, d_first);
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
    merge_seq(xs, ys, tmp, lo_xs, hi_xs, lo_ys, hi_ys, lo_tmp, compare);
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
    std::sort(xs + lo, xs + hi, compare);
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
