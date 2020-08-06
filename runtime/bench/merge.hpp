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
class merge_manual : public tpalrts::fiber<Scheduler> {
public:

  using trampoline_type = enum { entry, exit };

  trampoline_type trampoline = entry;

  merge_manual()
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

void merge_par(Item* xs, Item* ys, Item* tmp,
               size_t lo_xs, size_t hi_xs,
               size_t lo_ys, size_t hi_ys,
               size_t lo_tmp,
               tpalrts::promotable* p,
               tpalrts::stack_type s,
               int64_t K=tpalrts::dflt_software_polling_K,
               void* pc = nullptr) {
  sunpack(s);
  int heartbeat=heartbeat_mechanism_software_polling;
    
  size_t n1;
  size_t n2;

  void* __entry = &&entry;
  void* __retk = &&retk;
  void* __joink = &&joink;
  void* __clonek = &&clonek;

  pc = (pc == nullptr) ? __entry : pc;
    
  auto try_promote = [&] {
    if (prmempty(prmtl, prmhd)) {
      return;
    }
    char* sp_cont;
    uint64_t top;
    prmsplit(sp, prmtl, prmhd, sp_cont, top);
    char* sp_top = sp + top;
    sstore(sp_top, -8l, void*, __joink);
    Item* xs2 = sload(sp_top, -7l, Item*);
    Item* ys2 = sload(sp_top, -6l, Item*);
    Item* tmp2 = sload(sp_top, -5l, Item*);
    size_t lo_xs2 = sload(sp_top, -4l, size_t);
    size_t hi_xs2 = sload(sp_top, -3l, size_t);
    size_t lo_ys2 = sload(sp_top, -2l, size_t);
    size_t hi_ys2 = sload(sp_top, -1l, size_t);
    size_t lo_tmp2 = sload(sp_top, 0, size_t);
    p->async_finish_promote([=] (tpalrts::promotable* p2) {
      tpalrts::stack_type s2 = tpalrts::snew();
      void* pc2;
      if (sload(sp_top, -1l, void*) != __clonek) { // slow clone
        pc2 = __entry;
      } else { // fast clone
        pc2 = __clonek;
        s2.stack = s.stack;
        s2.sp = saddr(sp_top, -1l);
      }
      merge_par(xs2, ys2, tmp2, lo_xs2, hi_xs2, lo_ys2, hi_ys2, lo_tmp2, p2, s2, K, pc2);
    });
  };

  uint64_t promotion_prev = (heartbeat == heartbeat_mechanism_software_polling) ? mcsl::cycles::now() : 0;
  uint64_t k = K;

  goto *pc;
  
 entry:
  salloc(sp, 1);
  sstore(sp, 0, void*, &&exitk);

 loop:
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
  n1 = hi_xs - lo_xs;
  n2 = hi_ys - lo_ys;
  if (n1 < n2) {
    std::swap(xs, ys);
    std::swap(lo_xs, lo_ys);
    std::swap(hi_xs, hi_ys);
    goto loop;
  } else if (n1 == 0) {
    // xs and ys empty
    goto retk;
  } else if (n1 == 1) {
    if (n2 == 0) {
      // xs singleton; ys empty
      tmp[lo_tmp] = xs[lo_xs];
    } else {
      // both singletons
      tmp[lo_tmp+0] = std::min(xs[lo_xs], ys[lo_ys], compare);
      tmp[lo_tmp+1] = std::max(xs[lo_xs], ys[lo_ys], compare);
    }
    goto retk;
  } else if (n1 < heartbeat_merge_thresh) {
    merge_seq(xs, ys, tmp, lo_xs, hi_xs, lo_ys, hi_ys, lo_tmp, compare);
    goto retk;
  } else {
    // select pivot positions
    size_t mid_xs = (lo_xs + hi_xs) / 2;
    size_t mid_ys = lower_bound(ys, lo_ys, hi_ys, xs[mid_xs], compare);
    // number of items to be treated by the first parallel call
    size_t k = (mid_xs - lo_xs) + (mid_ys - lo_ys);
    salloc(sp, 11);
    sstore(sp, 0, void*, &&branch1);
    sstore(sp, 1, Item*, xs);
    sstore(sp, 2, Item*, ys);
    sstore(sp, 3, Item*, tmp);
    sstore(sp, 4, size_t, mid_xs);
    sstore(sp, 5, size_t, hi_xs);
    sstore(sp, 6, size_t, mid_ys);
    sstore(sp, 7, size_t, hi_ys);
    sstore(sp, 8, size_t, (lo_tmp + k));
    prmpush(sp, 9, prmtl, prmhd);
    hi_xs = mid_xs;
    hi_ys = mid_ys;
    goto loop;
  }

 branch1:
  sstore(sp, 0, void*, &&branch2);
  xs = sload(sp, 1, Item*);
  ys = sload(sp, 2, Item*);
  tmp = sload(sp, 3, Item*);
  lo_xs = sload(sp, 4, size_t);
  hi_xs = sload(sp, 5, size_t);
  lo_ys = sload(sp, 6, size_t);
  hi_ys = sload(sp, 7, size_t);
  lo_tmp = sload(sp, 8, size_t);
  prmpop(sp, 9, prmtl, prmhd);
  goto loop;

 branch2:
  sfree(sp, 11);
  goto retk;
  
 retk:
  goto *sload(sp, 0, void*);

 joink:
  sstore(sp, 0, void*, &&clonek);
  sfree(sp, 1);
  return;

 clonek:
  salloc(sp, 1);
  sstore(sp, 0, void*, &&joink);
  goto loop;

 exitk:
  sfree(sp, 1);
  sdelete(s);
  
}

size_t merge_cilk_cutoff = 10000;

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
