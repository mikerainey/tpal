#pragma once

#include <functional>

#include "mcsl_scheduler.hpp"

#include "tpalrts_util.hpp"

namespace tpalrts {

/*---------------------------------------------------------------------*/
/* Promotable fibers (signature) */
  
class promotable {
public:

  virtual
  void async_finish_promote(std::function<void(promotable*)>) = 0;

  virtual
  void fork_join_promote(std::function<void(promotable*)>,
			 std::function<void(promotable*)>) = 0;

};

/*---------------------------------------------------------------------*/
/* Fibers */

template <typename Scheduler>
class fiber : public promotable {
private:

  alignas(MCSL_CACHE_LINE_SZB)
  std::atomic<std::size_t> incounter;

  alignas(MCSL_CACHE_LINE_SZB)
  fiber* outedge;

  std::function<void(promotable*)> body;
  
public:

  fiber(std::function<void(promotable*)> body)
    : body(body), incounter(1), outedge(nullptr) { }

  ~fiber() {
    assert(outedge == nullptr);
  }

  virtual
  mcsl::fiber_status_type exec() {
    body(this);
    return mcsl::fiber_status_finish;
  }

  bool is_ready() {
    return incounter.load() == 0;
  }

  void release() {
    if (--incounter == 0) {
      Scheduler::schedule(this);
    }
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

  virtual
  void notify() {
    assert(is_ready());
    auto fo = outedge;
    outedge = nullptr;
    if (fo != nullptr) {
      fo->release();
    }
  }

  virtual
  void finish() {
    notify();
    delete this;
  }

  void async_finish_promote(std::function<void(promotable*)> body) {
    auto b = new tpalrts::fiber<Scheduler>(body);
    add_edge(b, outedge);
    b->release();
    Scheduler::commit(this);
    stats::increment(stats_configuration::nb_promotions);
  }

  void fork_join_promote(std::function<void(promotable*)> body,
			 std::function<void(promotable*)> combine) {
    auto b = new tpalrts::fiber<Scheduler>(body);
    auto c = new tpalrts::fiber<Scheduler>(combine);
    c->outedge = capture_continuation();
    add_edge(this, c);
    add_edge(b, c);
    b->release();
    c->release();
    Scheduler::commit(this);
    stats::increment(stats_configuration::nb_promotions);
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
    return mcsl::fiber_status_terminate;
  }
  
};

} // end namespace
