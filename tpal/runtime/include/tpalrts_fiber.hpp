#pragma once

#include <functional>

#include "mcsl_scheduler.hpp"

#include "tpalrts_arena.hpp"

namespace tpalrts {

/*---------------------------------------------------------------------*/
/* Executable objects (interface) */

class promotable;

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

/*---------------------------------------------------------------------*/
/* Promotable objects (interface) */

class promotable {
public:

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
