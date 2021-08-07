#pragma once

#include "tpalrts_util.hpp"

namespace tpalrts {

/*---------------------------------------------------------------------*/
/* Arena allocation */

static constexpr
int arena_block_szb = 1 << 14;

class arena_block_type {
public:

  std::atomic<std::size_t> refcount;
  
  std::size_t next;
  
  typename std::aligned_storage<sizeof(char), 64>::type block[arena_block_szb] __attribute__ ((aligned (64)));

  arena_block_type() : refcount(1), next(0) { }
  
};

mcsl::perworker::array<arena_block_type*> arena_blocks;

void decr_arena_block(arena_block_type* b) {
  assert(b != nullptr);
  auto c = --(b->refcount);
  if (c == 0) {
    assert(b != nullptr);
    delete b;
  }
}

std::pair<void*, arena_block_type*> alloc_arena_block(std::size_t szb) {
  szb += szb % sizeof(void*);
  assert((szb % sizeof(void*)) == 0);
  auto& b = arena_blocks.mine();
  if (b == nullptr) {
    stats::increment(stats_configuration::nb_block_allocs);
    b = new arena_block_type;
  }
  assert(szb <= arena_block_szb);
  auto ap = b->next;
  auto ap2 = ap + szb;
  if (ap2 >= arena_block_szb) {
    stats::increment(stats_configuration::nb_block_allocs);
    decr_arena_block(b);
    b = new arena_block_type;
    ap = b->next;
    ap2 = ap + szb;
  }
  assert(ap2 < arena_block_szb);
  (b->refcount)++;
  b->next = ap2;
  return std::make_pair((void*)reinterpret_cast<char*>(b->block + ap), b);
}

template <typename M>
std::pair<M*, arena_block_type*> alloc_arena() {
  auto p = alloc_arena_block(sizeof(M));
  return std::make_pair((M*)p.first, p.second);
}

} // end namespace
