#pragma once

#include <sys/signal.h>

namespace tpalrts {
  
/*---------------------------------------------------------------------*/
/* Rollforward table */
  
using register_type = greg_t;

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
  mcontext_t *mctx = &((ucontext_t *)uap)->uc_mcontext;
  register_type *rip = &mctx->gregs[16];
  try_to_initiate_rollforward(rollforward_table, rip);
}

#elif defined(MCSL_NAUTILUS)

#endif
  
} // end namespace
