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

extern "C" {
#include <heartbeat.h>
}

extern
uint64_t rollforward_table_size;
uint64_t rollback_table_size;
extern
struct hb_rollforward rollforward_table[];
extern
struct hb_rollforward rollback_table[];

namespace tpalrts {

/*---------------------------------------------------------------------*/
/* Rollforward table */

#if defined(MCSL_LINUX)
using register_type = greg_t;
#elif defined(MCSL_NAUTILUS)
using register_type = ulong_t*;
#endif

void try_to_initiate_rollforward(void** rip) {
  void* ra_src = *rip;
  void* ra_dst = nullptr;
  for (uint64_t i = 0; i < rollforward_table_size; i++) {
    if (rollforward_table[i].from == ra_src) {
      ra_dst = rollforward_table[i].to;
      break;
    }
  }
  // Binary search over the rollforward keys
  /*  {
    int64_t i = 0, j = (int64_t)rollforward_table_size - 1;
    int64_t k;
    while (i <= j) {
      k = i + ((j - i) / 2);
      if ((uint64_t)rollforward_table[k].from == (uint64_t)ra_src) {
	ra_dst = rollforward_table[k].to;
	break;
      } else if ((uint64_t)rollforward_table[k].from < (uint64_t)ra_src) {
	i = k + 1;
      } else {
	j = k - 1;
      }
    }
    } */
  if (ra_dst != NULL) {
    *rip = ra_dst;
  }
}

#if defined(MCSL_LINUX)

void heartbeat_interrupt_handler(int, siginfo_t*, void* uap) {
  stats::increment(tpalrts::stats_configuration::nb_heartbeats);
  mcontext_t* mctx = &((ucontext_t *)uap)->uc_mcontext;
  void** rip = (void**)&mctx->gregs[16];
  try_to_initiate_rollforward(rip);
}

#elif defined(MCSL_NAUTILUS)

void heartbeat_interrupt_handler(excp_entry_t* e, void* priv) {
#ifdef TPALRTS_STATS
  auto id = naut_my_cpu_id();
  stats::increment(tpalrts::stats_configuration::nb_heartbeats, id > 0 ? id - 1 : id);
#endif
  struct nk_regs* r = (struct nk_regs*)((char*)e - 128);
  try_to_initiate_rollforward((void**)&(r->rip));
}
  
#endif

} // end namespace
