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
/* Manually checked interrupt flags (alternative to rollforward)  */
  
#ifdef TPALRTS_USE_INTERRUPT_FLAGS
using heartbeat_polling_result_type = enum heartbeat_polling_result_enum {
          heartbeat_polling_result_ready,
          heartbeat_polling_result_pending };

mcsl::perworker::array<std::atomic<heartbeat_polling_result_type>> heartbeat_polling;

heartbeat_polling_result_type check_heartbeat_polling_result() {
  if (heartbeat_polling.mine().load() == heartbeat_polling_result_ready) {
    heartbeat_polling.mine().store(heartbeat_polling_result_pending);
    return heartbeat_polling_result_ready;
  }
  return heartbeat_polling_result_pending;
}
#endif
  
/*---------------------------------------------------------------------*/
/* Rollforward table */

#if defined(MCSL_LINUX)
using register_type = greg_t;
#elif defined(MCSL_NAUTILUS)
using register_type = ulong_t*;
#endif

using rollforward_table_item_type = std::pair<register_type, register_type>;

using rollforward_lookup_table_type = std::vector<rollforward_table_item_type>;

template <typename L>
auto mk_rollforward_entry(L src, L dst) -> rollforward_table_item_type {
  return std::make_pair((register_type)src, (register_type)dst);
};

rollforward_lookup_table_type rollforward_table;
  
template <class T>
void try_to_initiate_rollforward(const T& t, register_type* rip) {
  for (const auto& e : t) {
    if (*rip == e.first) {
      *rip = e.second;
      break;
    }
  }
#if defined(TPALRTS_USE_INTERRUPT_FLAGS) && defined(MCSL_LINUX)
  heartbeat_polling.mine().store(heartbeat_polling_result_ready);
#elif defined(TPALRTS_USE_INTERRUPT_FLAGS) && defined(MCSL_NAUTILUS)
  // todo
#endif
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
