#pragma once

#include <sys/signal.h>

#include "tpalrts_util.hpp"

#if defined(MCSL_NAUTILUS)
struct excp_entry_state;
using excp_entry_t = struct excp_entry_state;
struct nk_thread_s;
using nk_thread_t = struct nk_thread_s;
extern "C"
int naut_my_cpu_id();
extern "C"
nk_thread_t* naut_get_cur_thread();
typedef unsigned long ulong_t;
struct nk_regs {
    ulong_t r15;
    ulong_t r14;
    ulong_t r13;
    ulong_t r12;
    ulong_t r11;
    ulong_t r10;
    ulong_t r9;
    ulong_t r8;
    ulong_t rbp;
    ulong_t rdi;
    ulong_t rsi;
    ulong_t rdx;
    ulong_t rcx;
    ulong_t rbx;
    ulong_t rax;
    ulong_t vector;
    ulong_t err_code;
    ulong_t rip;
    ulong_t cs;
    ulong_t rflags;
    ulong_t rsp;
    ulong_t ss;
};
#endif

namespace tpalrts {

/*---------------------------------------------------------------------*/
/* Rollforward table */

#if defined(MCSL_LINUX)
using register_type = greg_t;
#elif defined(MCSL_NAUTILUS)
using register_type = ulong_t*;
#endif

using rollforward_edge_type = std::pair<register_type, register_type>;

using rollforward_lookup_table_type = std::vector<rollforward_edge_type>;

auto rollforward_edge_less = [] (const rollforward_edge_type& e1, const rollforward_edge_type& e2) {
  return e1.first < e2.first;
};

template <typename L>
auto mk_rollforward_entry(L src, L dst) -> rollforward_edge_type {
  return std::make_pair((register_type)src, (register_type)dst);
}

#if !defined(NDEBUG) || defined(MCSL_NAUTILUS)
auto reference_lookup_rollforward_entry(const rollforward_lookup_table_type& t, register_type src)
  -> register_type {
  for (const auto& p : t) {
    if (src == p.first) {
      return p.second;
    }
  }
  return src;
}
#endif

// returns the entry dst, if (src, dst) is in the rollforward table t, and src otherwise
static inline
auto lookup_rollforward_entry(const rollforward_lookup_table_type& t, register_type src)
  -> register_type {
  auto dst = src;
  size_t n = t.size();
  if (n == 0) {
    return src;
  }
  static constexpr
  int64_t not_found = -1;
  int64_t k;
  {
    int64_t i = 0, j = (int64_t)n - 1;
    while (i <= j) {
      k = i + ((j - i) / 2);
      if (t[k].first == src) {
	goto exit;
      } else if (t[k].first < src) {
	i = k + 1;
      } else {
	j = k - 1;
      }
    }
    k = not_found;
  }
  exit:
  if (k != not_found) {
    dst = t[k].second;
  }
  assert(dst == reference_lookup_rollforward_entry(t, src));
  return dst;
}
  
// returns the entry src, if (src, dst) is in the rollforward table t, and dst otherwise
auto reverse_lookup_rollforward_entry(const rollforward_lookup_table_type& t, register_type dst)
  -> register_type {
  for (const auto& p : t) {
    if (dst == p.second) {
      return p.first;
    }
  }
  return dst;
}
  
template <class T>
void try_to_initiate_rollforward(const T& t, register_type* rip) {
  auto ip = *rip;
  auto dst = lookup_rollforward_entry(t, ip);
  if (dst != ip) {
    *rip = dst;
  }
}

rollforward_lookup_table_type rollforward_table;

auto reverse_lookup_rollforward_entry(void* dst) -> void* {
  return (void*)reverse_lookup_rollforward_entry(rollforward_table, (register_type)dst);
}

auto initialize_rollfoward_table() {
  std::sort(rollforward_table.begin(), rollforward_table.end(), rollforward_edge_less);
}

auto destroy_rollfoward_table() {
  rollforward_table.clear();
}
  
#if defined(MCSL_LINUX)

void heartbeat_interrupt_handler(int, siginfo_t*, void* uap) {
  mcontext_t* mctx = &((ucontext_t *)uap)->uc_mcontext;
  register_type* rip = &mctx->gregs[16];
  try_to_initiate_rollforward(rollforward_table, rip);
}

#elif defined(MCSL_NAUTILUS)

void heartbeat_interrupt_handler(excp_entry_t* e, void* priv) {
  struct nk_regs* r = (struct nk_regs*)((char*)e - 128);
  try_to_initiate_rollforward(rollforward_table, (register_type*)&(r->rip));
}
  
#endif
  
} // end namespace
