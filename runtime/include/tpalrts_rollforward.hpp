#pragma once

#include <sys/signal.h>

#if defined(MCSL_NAUTILUS)
struct excp_entry_state;
using excp_entry_t = struct excp_entry_state;
struct nk_thread_s;
using nk_thread_t = struct nk_thread_s;
extern "C"
nk_thread_t* naut_get_cur_thread();
#endif

namespace tpalrts {
  
/*---------------------------------------------------------------------*/
/* Rollforward table */

#if defined(MCSL_LINUX)
using register_type = greg_t;
#elif defined(MCSL_NAUTILUS)
using register_type = char*;
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
}

#if defined(MCSL_LINUX)

void heartbeat_interrupt_handler(int, siginfo_t*, void* uap) {
  mcontext_t* mctx = &((ucontext_t *)uap)->uc_mcontext;
  register_type* rip = &mctx->gregs[16];
  try_to_initiate_rollforward(rollforward_table, rip);
}

#elif defined(MCSL_NAUTILUS)

static
mcsl::perworker::array<nk_thread_t*> threads;

void heartbeat_interrupt_handler(excp_entry_t* e, void* priv) {
  if (naut_get_cur_thread() == threads.mine()) {
    // on the right thread
    register_type* rip = (register_type*)((char*)e - 128);
    try_to_initiate_rollforward(rollforward_table, rip);
  }
}

  
#endif
  
} // end namespace
