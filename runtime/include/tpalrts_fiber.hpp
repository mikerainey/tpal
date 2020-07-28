#pragma once

#include <functional>

#include "mcsl_scheduler.hpp"

#include "tpalrts_util.hpp"

namespace tpalrts {

/*---------------------------------------------------------------------*/
/* Promotable fibers (signature) */

class promotable;
  
static constexpr
int arena_block_szb = 1 << 12;

  // later: refactor arena_block_type so that it's possible to pick block size
  // later: make sure that in nautilus the leftover blocks in arena_blocks are deallocated
  
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
    delete b;
  }
}

std::pair<void*, arena_block_type*> alloc_arena_block(std::size_t szb) {
  szb += szb % sizeof(void*);
  assert((szb % sizeof(void*)) == 0);
  auto& b = arena_blocks.mine();
  if (b == nullptr) {
    b = new arena_block_type;
  }
  assert(szb <= arena_block_szb);
  auto ap = b->next;
  auto ap2 = ap + szb;
  if (ap2 >= arena_block_szb) {
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

class execable {
public:

  arena_block_type* block = nullptr;

  virtual
  mcsl::fiber_status_type exec(promotable*) = 0;

};

template <typename F>
class execable_function : public execable {
public:
  
  F f;
  
  execable_function(const F& f, arena_block_type* _block) : f(f) {
    block = _block;
  }
  
  mcsl::fiber_status_type exec(promotable* p) {
    f(p);
    decr_arena_block(block);
    return mcsl::fiber_status_finish;
  }
  
};

class promotable {
public:

  template <typename F>
  void async_finish_promote(const F& f) {
    using ty = execable_function<F>;
    ty* ap;
    arena_block_type* b;
    std::tie(ap, b) = alloc_arena<ty>();
    new (ap) ty(f, b);
    async_finish_promote3(ap);
  }

  template <typename Body, typename Combine>
  void fork_join_promote(const Body& body, const Combine& combine) {
    using body_ty = execable_function<Body>;
    using combine_ty = execable_function<Combine>;
    body_ty* fbody = nullptr;
    combine_ty* fcombine = nullptr;
    {
      body_ty* ap;
      arena_block_type* b;
      std::tie(ap, b) = alloc_arena<body_ty>();
      new (ap) body_ty(body, b);
      fbody = ap;
    }
    {
      combine_ty* ap;
      arena_block_type* b;
      std::tie(ap, b) = alloc_arena<combine_ty>();
      new (ap) combine_ty(combine, b);
      fcombine = ap;
    }
    fork_join_promote3(fbody, fcombine);
  }

  virtual
  void async_finish_promote3(execable*) = 0;

  virtual
  void fork_join_promote3(execable*, execable*) = 0;

};

/*---------------------------------------------------------------------*/
/* Fibers */

using dflt_function_type = std::function<void(promotable*)>;

template <typename Scheduler, typename Function=dflt_function_type>
class fiber : public promotable {
private:

  alignas(MCSL_CACHE_LINE_SZB)
  std::atomic<std::size_t> incounter;

  alignas(MCSL_CACHE_LINE_SZB)
  fiber* outedge;

  Function body;
  
  arena_block_type* block = nullptr;
  
public:

  fiber(const Function& body)
    : incounter(1), outedge(nullptr), body(body) { }

  virtual
  mcsl::fiber_status_type exec() {
    body(this);
    return mcsl::fiber_status_finish;
  }

  bool is_ready() {
    return incounter.load() == 0;
  }

  fiber* capture_continuation() {
    auto oe = outedge;
    outedge = nullptr;
    return oe;
  }

  static
  void add_edge(fiber* src, fiber* dst) {
    assert(src->outedge == nullptr);
    src->outedge = dst;
    dst->incounter++;
  }

  void release() {
    if (--incounter == 0) {
      Scheduler::schedule(this);
    }
  }

  void commit() {
    Scheduler::commit(this);
  }

  virtual
  void notify() {
    auto fo = outedge;
    outedge = nullptr;
    if (fo != nullptr) {
      fo->release();
    }
  }

  virtual
  void finish() {
    notify();
    if (block == nullptr) {
      delete this;
    } else {
      decr_arena_block(block);      
    }
  }

  static
  tpalrts::fiber<Scheduler>* arena_allocate(execable* e) {
    using ty = tpalrts::fiber<Scheduler>;
    ty* ap;
    arena_block_type* b;
    std::tie(ap, b) = alloc_arena<ty>();
    new (ap) ty([e] (promotable* p) { return e->exec(p); });
    ap->block = b;
    return ap;
  }

  void async_finish_promote3(execable* b) {
    async_finish_promote2(arena_allocate(b));
  }

  void async_finish_promote2(fiber* b) {
    add_edge(b, outedge);
    b->release();
    commit();
    stats::increment(stats_configuration::nb_promotions);
  }
    
  void fork_join_promote3(execable* body, execable* combine) {
    fork_join_promote2(arena_allocate(body), arena_allocate(combine));
  }
      
  void fork_join_promote2(fiber* b, fiber* c) {
    c->outedge = capture_continuation();
    add_edge(this, c);
    add_edge(b, c);
    b->release();
    c->release();
    commit();
    stats::increment(stats_configuration::nb_promotions);
  }
  
  /*
  void* operator new(size_t size) {
    printf("hi\n");
    return ::operator new(size);
  }

  void operator delete(void * p) {
    free(p); 
  }
  */
  
};

/* A fiber that, when executed, initiates the teardown of the 
 * scheduler. 
 */
  
template <typename Scheduler>
class terminal_fiber : public fiber<Scheduler> {
public:
  
  terminal_fiber()
    : fiber<Scheduler>([] (promotable*) { return mcsl::fiber_status_finish; }) { }
  
  mcsl::fiber_status_type exec() {
    return mcsl::fiber_status_exit_launch;
  }
  
};


  
} // end namespace
