#pragma once

#if defined(MCSL_LINUX)
#include <thread>
#include <condition_variable>
#include <papi.h>
#include <sys/timerfd.h>
#include <unistd.h>
#include <sys/signal.h>
#include <sys/syscall.h>
#elif defined(MCSL_NAUTILUS)
struct nk_timer_s;
using nk_timer_t = struct nk_timer_s;
using nemo_event_id_t = int;
typedef void (*nemo_action_t)(struct excp_entry_state *, void * priv);
extern "C"
uint64_t nk_sched_get_realtime();
extern "C"
void nk_sleep(uint64_t);
extern "C"
nemo_event_id_t nk_nemo_register_event_action(nemo_action_t func, void * priv_data);
extern "C"
void nk_timer_cancel(nk_timer_t* timer);
extern "C"
int nk_timer_reset(nk_timer_t *t,
		   uint64_t ns);
extern "C"
int nk_timer_start(nk_timer_t *t);
extern "C"
nk_timer_t *nk_timer_create(char *name);
extern "C"
void nk_nemo_event_notify(nemo_event_id_t eid, int cpu);
extern "C"
int nk_timer_set(nk_timer_t *t, 
                 uint64_t ns, 
                 uint64_t flags,
                 void (*callback)(void *p), 
                 void *p,
                 uint32_t cpu);
#define NK_TIMER_CALLBACK  0x8  // thread continue immediately,
#endif

//#include "mcsl_scheduler.hpp"

#include "tpalrts_util.hpp"
#include "tpalrts_rollforward.hpp"

namespace tpalrts {

/*---------------------------------------------------------------------*/
/* TPAL basic worker-thread configuration */

using tpal_worker = mcsl::minimal_worker;

/*---------------------------------------------------------------------*/
/* Interrupt-based worker launch routine */

#if defined(MCSL_LINUX)
  
static
mcsl::perworker::array<pthread_t> pthreads;

template <typename Body, typename Initialize_worker, typename Destroy_worker>
void launch_interrupt_worker_thread(std::size_t id, const Body& b,
				    const Initialize_worker& initialize_worker,
				    const Destroy_worker& destroy_worker) {
  auto b2 = [id, &b, &initialize_worker, &destroy_worker] {
    mcsl::perworker::unique_id::initialize_worker(id);
    mcsl::pin_calling_worker();
    initialize_worker();
    b(id);
    destroy_worker();
  };
  if (id == 0) {
    b2();
    return;
  }
  auto t = std::thread(b2);
  pthreads[id] = t.native_handle();
  t.detach();
}

#endif

/*---------------------------------------------------------------------*/
/* Ping-thread scheduler configuration */

using ping_thread_status_type = enum ping_thread_status_enum {
  ping_thread_status_active,
  ping_thread_status_exit_launch,
  ping_thread_status_exited
};
  
#if defined(MCSL_LINUX)
    
class ping_thread_worker {
public:

  static
  void initialize(std::size_t nb_workers) { }

  static
  void destroy() { }

  static
  void initialize_worker() {
    sigset_t mask, prev_mask;
    if (pthread_sigmask(SIG_SETMASK, NULL, &prev_mask)) {
      exit(0);
    }
    struct sigaction sa, prev_sa;
    sa.sa_sigaction = heartbeat_interrupt_handler;
    sa.sa_flags = SA_RESTART | SA_SIGINFO;
    sa.sa_mask = prev_mask;
    sigdelset(&sa.sa_mask, SIGUSR1);
    if (sigaction(SIGUSR1, &sa, &prev_sa)) {
      exit(0);
    }
    sigemptyset(&mask);
    sigaddset(&mask, SIGUSR1);
  }

  template <typename Body>
  static
  void launch_worker_thread(std::size_t id, const Body& b) {
    launch_interrupt_worker_thread(id, b, [] { initialize_worker(); }, [] { });
  }
  
  using worker_exit_barrier = typename mcsl::minimal_worker::worker_exit_barrier;
  
  using termination_detection_type = mcsl::minimal_termination_detection;

};

class ping_thread_interrupt {
public:
  
  static
  int timerfd;
  
  static
  ping_thread_status_type ping_thread_status;
  
  static
  std::mutex ping_thread_lock;
  
  static
  std::condition_variable ping_thread_condition_variable;

  static
  void initialize_signal_handler() {
    pthreads[0] = pthread_self();
  }
  
  static
  void wait_to_terminate_ping_thread() {
    std::unique_lock<std::mutex> lk(ping_thread_lock);
    if (ping_thread_status == ping_thread_status_active) {
      ping_thread_status = ping_thread_status_exit_launch;
    }
    ping_thread_condition_variable.wait(lk, [&] { return ping_thread_status == ping_thread_status_exited; });
  }
  
  static
  void launch_ping_thread(std::size_t nb_workers) {
    auto pthreadsp = &pthreads;
    auto statusp = &ping_thread_status;
    auto ping_thread_lockp = &ping_thread_lock;
    auto cvp = &ping_thread_condition_variable;
    auto t = std::thread([=] {
      mcsl::perworker::array<pthread_t>& pthreads = *pthreadsp;
      ping_thread_status_type& status = *statusp;
      std::mutex& ping_thread_lock = *ping_thread_lockp;
      std::condition_variable& cv = *cvp;
      unsigned int ns;
      unsigned int sec;
      struct itimerspec itval;
      timerfd = timerfd_create(CLOCK_MONOTONIC, 0);
      if (timerfd == -1) {
        mcsl::die("failed to properly initialize timerfd");
      }
      {
        auto one_million = 1000000;
        sec = kappa_usec / one_million;
        ns = (kappa_usec - (sec * one_million)) * 1000;
        itval.it_interval.tv_sec = sec;
        itval.it_interval.tv_nsec = ns;
        itval.it_value.tv_sec = sec;
        itval.it_value.tv_nsec = ns;
      }
      timerfd_settime(timerfd, 0, &itval, nullptr);
      while (status == ping_thread_status_active) {
        unsigned long long missed;
        int ret = read(timerfd, &missed, sizeof(missed));
        if (ret == -1) {
          mcsl::die("read timer");
          return;
        }
        for (std::size_t i = 0; i < nb_workers; ++i) {
          pthread_kill(pthreads[i], SIGUSR1);
        }
      }
      std::unique_lock<std::mutex> lk(ping_thread_lock);
      status = ping_thread_status_exited;
      cv.notify_all();
    });
    t.detach();
  }
  
};

ping_thread_status_type ping_thread_interrupt::ping_thread_status = ping_thread_status_active;

std::mutex ping_thread_interrupt::ping_thread_lock;

std::condition_variable ping_thread_interrupt::ping_thread_condition_variable;

int ping_thread_interrupt::timerfd;

#elif defined(MCSL_NAUTILUS)

using ping_thread_worker = mcsl::minimal_worker;
  
class ping_thread_interrupt {
public:

  static
  nk_timer_t* timer;

  static
  nemo_event_id_t nemo_event_id;

  static
  std::atomic<ping_thread_status_type> ping_thread_status;
  
  static
  void initialize_signal_handler() {
    nemo_event_id = nk_nemo_register_event_action(heartbeat_interrupt_handler, NULL);
    // todo: check for error condition
  }
  
  static
  void wait_to_terminate_ping_thread() {
    auto s = ping_thread_status.load();
    if (mcsl::perworker::unique_id::get_my_id() == 0) {
      assert(s == ping_thread_status_active);
      ping_thread_status.store(ping_thread_status_exit_launch);
    }
    while (s != ping_thread_status_exited) {
      s = ping_thread_status.load();
    }
  }

  static
  uint64_t start_time, last_time;

  static
  void heartbeat_timer_callback(void *) {
    auto s = ping_thread_status.load();
    if (s == ping_thread_status_exit_launch) {
      nk_timer_cancel(timer);
      ping_thread_status.store(ping_thread_status_exited);
      return;
    }
    assert(s == ping_thread_status_active);
    auto nb_workers = mcsl::perworker::unique_id::get_nb_workers();
    for (std::size_t id = 0; id != nb_workers; id++) {
      int remote_core = mcsl::cpu_pinning_assignments[id];
      nk_nemo_event_notify(nemo_event_id, remote_core);
    }
    uint64_t kappa_ns = (1000l * kappa_usec);
    uint64_t cur_time = nk_sched_get_realtime();
    uint64_t cur_goal = last_time + kappa_ns;
    uint64_t next_goal = cur_goal + kappa_ns;
    uint64_t next_target = next_goal > cur_time ? next_goal : cur_time;
    uint64_t deadline = next_target - cur_time;
    last_time = cur_time;
    nk_timer_reset(timer, deadline);
    nk_timer_start(timer);
  }

  static
  void launch_ping_thread(std::size_t nb_workers) {
    std::function<void(std::size_t)> f = [=] (std::size_t) {
      start_time = last_time = nk_sched_get_realtime();
      timer = nk_timer_create("heartbeat_timer");
      uint64_t kappa_ns = (1000l * kappa_usec);
      nk_timer_set(timer, kappa_ns, NK_TIMER_CALLBACK, heartbeat_timer_callback, (void*)naut_get_cur_thread(), 0);
      nk_timer_start(timer);
      while (ping_thread_status.load() != ping_thread_status_exited) {
        nk_sleep(100000l);
      }
    };
    auto p = new nk_worker_activation_type(nb_workers, f);
    int remote_core = mcsl::ping_thread_remote_core;
    nk_thread_start(nk_thread_init_fn, (void*)p, 0, 0, TSTACK_DEFAULT, 0, remote_core);
  }
  
};

nk_timer_t* ping_thread_interrupt::timer;

uint64_t ping_thread_interrupt::last_time;

uint64_t ping_thread_interrupt::start_time;
  
std::atomic<ping_thread_status_type> ping_thread_interrupt::ping_thread_status(ping_thread_status_active);

nemo_event_id_t ping_thread_interrupt::nemo_event_id;
  
#endif

/*---------------------------------------------------------------------*/
/* Pthread-direct interrupt configuration (Linux specific) */

#if defined(MCSL_LINUX)

std::mutex pthread_init_mutex;
  
class pthread_direct_worker {
public:

  static
  void initialize(std::size_t nb_workers) { }

  static
  void destroy() { }

  static
  mcsl::perworker::array<timer_t> timerid;
  static
  mcsl::perworker::array<struct sigevent> sev;
  static
  mcsl::perworker::array<struct itimerspec> itval;

  static
  void initialize_worker() {
    std::lock_guard<std::mutex> guard(pthread_init_mutex);
    unsigned int ns;
    unsigned int sec;
    auto& my_sev = sev.mine();
    auto& my_itval = itval.mine();
    my_sev.sigev_notify = SIGEV_THREAD_ID;
    my_sev._sigev_un._tid = syscall(SYS_gettid);
    my_sev.sigev_signo = SIGUSR1; 
    my_sev.sigev_value.sival_ptr = &timerid.mine();
    {
      auto one_million = 1000000;
      sec = kappa_usec / one_million;
      ns = (kappa_usec - (sec * one_million)) * 1000;
      my_itval.it_interval.tv_sec = sec;
      my_itval.it_interval.tv_nsec = ns;
      my_itval.it_value.tv_sec = sec;
      my_itval.it_value.tv_nsec = ns;
    }
    if (timer_create(CLOCK_REALTIME, &my_sev, &timerid.mine()) == -1) {
      printf("timer_create failed: %d: %s\n", errno, strerror(errno));
    }
    timer_settime(timerid.mine(), 0, &my_itval, NULL);
  }
  
  template <typename Body>
  static
  void launch_worker_thread(std::size_t id, const Body& b) {
    launch_interrupt_worker_thread(id, b,
				   [] { initialize_worker(); },
				   [] { timer_delete(timerid.mine()); });
  }

  using worker_exit_barrier = typename mcsl::minimal_worker::worker_exit_barrier;
  
  using termination_detection_type = mcsl::minimal_termination_detection;

};

mcsl::perworker::array<timer_t> pthread_direct_worker::timerid;
mcsl::perworker::array<struct sigevent> pthread_direct_worker::sev;
mcsl::perworker::array<struct itimerspec> pthread_direct_worker::itval;
  
class pthread_direct_interrupt {
public:

  static
  sigset_t mask;

  static
  sigset_t prev_mask;

  static
  struct sigaction sa;

  static
  struct sigaction prev_sa;

  static
  void initialize_signal_handler() {
    if (pthread_sigmask(SIG_SETMASK, NULL, &prev_mask)) {
      exit(0);
    }
    sa.sa_sigaction = heartbeat_interrupt_handler;
    sa.sa_flags = SA_RESTART | SA_SIGINFO;
    sa.sa_mask = prev_mask;
    sigdelset(&sa.sa_mask, SIGUSR1);
    if (sigaction(SIGUSR1, &sa, &prev_sa)) {
      exit(0);
    }
    sigemptyset(&mask);
    sigaddset(&mask, SIGUSR1);

    return;
    
    struct sigaction act;
    memset(&act, 0, sizeof(struct sigaction));
    sigemptyset(&act.sa_mask);
    act.sa_sigaction = tpalrts::heartbeat_interrupt_handler;
    act.sa_flags = SA_SIGINFO | SA_RESTART;
    sigaction(SIGUSR1, &act, NULL);
  }

  static
  void wait_to_terminate_ping_thread() { }
  
  static
  void launch_ping_thread(std::size_t nb_workers) { }
  
};

sigset_t pthread_direct_interrupt::mask;
sigset_t pthread_direct_interrupt::prev_mask;
struct sigaction pthread_direct_interrupt::sa;
struct sigaction pthread_direct_interrupt::prev_sa;

#endif
  
/*---------------------------------------------------------------------*/
/* PAPI interrupt configuration */

#if defined(MCSL_LINUX)

static
void papi_interrupt_handler(int, void*, long long, void *context) {
  heartbeat_interrupt_handler(0, nullptr, context);
}

std::mutex papi_init_mutex;

std::mutex papi_destroy_mutex;

// guide: https://icl.cs.utk.edu/papi/docs/dc/d7e/examples_2overflow__pthreads_8c_source.html

class papi_worker {
public:

  static
  mcsl::perworker::array<int> event_set;

  static
  void initialize(std::size_t nb_workers) { }

  static
  void destroy() { }

  static
  void initialize_worker() {
    int retval;
    std::lock_guard<std::mutex> guard(papi_init_mutex);
    if ( (retval = PAPI_create_eventset(&(event_set.mine()))) != PAPI_OK) {
      mcsl::die("papi worker initialization failed");
    }
    if ((retval=PAPI_query_event(PAPI_TOT_CYC)) != PAPI_OK) {
      mcsl::die("papi worker initialization failed");
    }
    if ( (retval = PAPI_add_event(event_set.mine(), PAPI_TOT_CYC)) != PAPI_OK) {
      mcsl::die("papi worker initialization failed");
    }
    if((retval = PAPI_overflow(event_set.mine(), PAPI_TOT_CYC, kappa_cycles, 0, papi_interrupt_handler)) != PAPI_OK) {
      mcsl::die("papi worker initialization failed");
    }
    if((retval = PAPI_start(event_set.mine())) != PAPI_OK) {
      mcsl::die("papi worker initialization failed");
    }
  }

  static
  void destroy_worker() {
    int retval;
    long long values[2];
    std::lock_guard<std::mutex> guard(papi_init_mutex);
    if ((retval = PAPI_stop(event_set.mine(), values))!=PAPI_OK) {
      mcsl::die("papi worker stop failed");
    }
    retval = PAPI_overflow(event_set.mine(), PAPI_TOT_CYC, 0, 0, papi_interrupt_handler);
    if(retval !=PAPI_OK) {
      mcsl::die("papi worker deinitialization1 failed");
    }
    retval = PAPI_remove_event(event_set.mine(), PAPI_TOT_CYC);
    if (retval != PAPI_OK) {
      mcsl::die("papi worker deinitialization failed");
    }
  }

  template <typename Body>
  static
  void launch_worker_thread(std::size_t id, const Body& b) {
    launch_interrupt_worker_thread(id, b,
				   [] { initialize_worker(); },
				   [] { destroy_worker(); });
  }

  using worker_exit_barrier = typename mcsl::minimal_worker::worker_exit_barrier;
  
  using termination_detection_type = mcsl::minimal_termination_detection;

};

mcsl::perworker::array<int> papi_worker::event_set;
  
#endif

} // end namespace

/*---------------------------------------------------------------------*/

#include <sys/time.h>
#include <sys/resource.h>
#include <map>

#include "mcsl_fiber.hpp"
#include "mcsl_chaselev.hpp"
#include "mcsl_stats.hpp"
#include "mcsl_logging.hpp"
#include "mcsl_elastic.hpp"
#include "mcsl_machine.hpp"

/*---------------------------------------------------------------------*/
/* Stats */

namespace mcsl {

class fjnative_stats_configuration {
public:

#ifdef MCSL_ENABLE_STATS
  static constexpr
  bool enabled = true;
#else
  static constexpr
  bool enabled = false;
#endif

  using counter_id_type = enum counter_id_enum {
    nb_fibers,
    nb_steals,
    nb_sleeps,
    nb_counters
  };

  static
  const char* name_of_counter(counter_id_type id) {
    std::map<counter_id_type, const char*> names;
    names[nb_fibers] = "nb_fibers";
    names[nb_steals] = "nb_steals";
    names[nb_sleeps] = "nb_sleeps";
    return names[id];
  }
  
};

using fjnative_stats = stats_base<fjnative_stats_configuration>;

/*---------------------------------------------------------------------*/
/* Logging */

#ifdef MCSL_ENABLE_LOGGING
using fjnative_logging = logging_base<true>;
#else
using fjnative_logging = logging_base<false>;
#endif

/*---------------------------------------------------------------------*/
/* Elastic work stealing */

#if defined(MCSL_DISABLE_ELASTIC)
template <typename Stats, typename Logging>
using fjnative_elastic = minimal_elastic<Stats, Logging>;
#elif defined(MCSL_ELASTIC_SPINSLEEP)
template <typename Stats, typename Logging>
using fjnative_elastic = elastic<Stats, Logging, spinning_binary_semaphore>;
#else
template <typename Stats, typename Logging>
using fjnative_elastic = elastic<Stats, Logging>;
#endif

/*---------------------------------------------------------------------*/
/* Worker-thread configuration */

using fjnative_worker = mcsl::minimal_worker;
  
/*---------------------------------------------------------------------*/
/* Scheduler configuration */

using fjnative_scheduler = minimal_scheduler<tpalrts::stats, tpalrts::logging, mcsl::minimal_elastic, tpalrts::ping_thread_worker, tpalrts::ping_thread_interrupt>;

} // end namespace

/*---------------------------------------------------------------------*/
/* Context switching */

using _context_pointer = char*;

extern "C"
void* _mcsl_ctx_save(_context_pointer);
asm(R"(
.globl _mcsl_ctx_save
        .type _mcsl_ctx_save, @function
        .align 16
_mcsl_ctx_save:
        .cfi_startproc
        movq %rbx, 0(%rdi)
        movq %rbp, 8(%rdi)
        movq %r12, 16(%rdi)
        movq %r13, 24(%rdi)
        movq %r14, 32(%rdi)
        movq %r15, 40(%rdi)
        leaq 8(%rsp), %rdx
        movq %rdx, 48(%rdi)
        movq (%rsp), %rax
        movq %rax, 56(%rdi)
        xorq %rax, %rax
        ret
        .size _mcsl_ctx_save, .-_mcsl_ctx_save
        .cfi_endproc
)");

extern "C"
void _mcsl_ctx_restore(_context_pointer ctx, void* t);
asm(R"(
.globl _mcsl_ctx_restore
        .type _mcsl_ctx_restore, @function
        .align 16
_mcsl_ctx_restore:
        .cfi_startproc
        movq 0(%rdi), %rbx
        movq 8(%rdi), %rbp
        movq 16(%rdi), %r12
        movq 24(%rdi), %r13
        movq 32(%rdi), %r14
        movq 40(%rdi), %r15
        test %rsi, %rsi
        mov $01, %rax
        cmove %rax, %rsi
        mov %rsi, %rax
        movq 56(%rdi), %rdx
        movq 48(%rdi), %rsp
        jmpq *%rdx
        .size _mcsl_ctx_restore, .-_mcsl_ctx_restore
        .cfi_endproc
)");

namespace mcsl {

static constexpr
std::size_t stack_alignb = 16;

static constexpr
std::size_t thread_stack_szb = stack_alignb * (1<<12);

class context {  
public:
  
  typedef char context_type[8*8];
  
  using context_pointer = _context_pointer;
  
  template <class X>
  static
  context_pointer addr(X r) {
    return r;
  }
  
  template <class Value>
  static
  void throw_to(context_pointer ctx, Value val) {
    _mcsl_ctx_restore(ctx, (void*)val);
  }
  
  template <class Value>
  static
  void swap(context_pointer ctx1, context_pointer ctx2, Value val2) {
    if (_mcsl_ctx_save(ctx1)) {
      return;
    }
    _mcsl_ctx_restore(ctx2, val2);
  }
  
  // register number 6
#define _X86_64_SP_OFFSET   6
  
  template <class Value>
  static
  Value capture(context_pointer ctx) {
    void* r = _mcsl_ctx_save(ctx);
    return (Value)r;
  }
  
  template <class Value>
  static
  char* spawn(context_pointer ctx, Value val) {
    Value target;
    if (target = (Value)_mcsl_ctx_save(ctx)) {
      target->enter(target);
      assert(false);
    }
    char* stack = (char*)malloc(thread_stack_szb);
    char* stack_end = &stack[thread_stack_szb];
    stack_end -= (std::size_t)stack_end % stack_alignb;
    void** _ctx = (void**)ctx;    
    _ctx[_X86_64_SP_OFFSET] = stack_end;
    return stack;
  }
  
};

class context_wrapper_type {
public:
  context::context_type ctx;
};

static
perworker::array<context_wrapper_type> ctxs;

static
context::context_pointer my_ctx() {
  return context::addr(ctxs.mine().ctx);
}

/*---------------------------------------------------------------------*/
/* Native fork join */

class forkable_fiber {
public:

  virtual
  void fork2(forkable_fiber*, forkable_fiber*) = 0;

};

static
perworker::array<forkable_fiber*> current_fiber;

class fjnative : public fiber<fjnative_scheduler>, public forkable_fiber {
public:

  using context_type = context::context_type;

  // declaration of dummy-pointer constants
  static
  char dummy1, dummy2;
  
  static constexpr
  char* notaptr = &dummy1;
  /* indicates to a thread that the thread does not need to deallocate
   * the call stack on which it is running
   */
  static constexpr
  char* notownstackptr = &dummy2;

  fiber_status_type status = fiber_status_finish;

  // pointer to the call stack of this thread
  char* stack = nullptr;
  // CPU context of this thread
  context_type ctx;

  void swap_with_scheduler() {
    context::swap(context::addr(ctx), my_ctx(), notaptr);
  }

  static
  void exit_to_scheduler() {
    context::throw_to(my_ctx(), notaptr);
  }

  virtual
  void run2() = 0;  

  fiber_status_type run() {
    run2();
    return status;
  }

  // point of entry from the scheduler to the body of this thread
  // the scheduler may reenter this fiber via this method
  fiber_status_type exec() {
    if (stack == nullptr) {
      // initial entry by the scheduler into the body of this thread
      stack = context::spawn(context::addr(ctx), this);
    }
    current_fiber.mine() = this;
    // jump into body of this thread
    context::swap(my_ctx(), context::addr(ctx), this);
    return status;
  }

  // point of entry to this thread to be called by the `context::spawn` routine
  static
  void enter(fjnative* t) {
    assert(t != nullptr);
    assert(t != (fjnative*)notaptr);
    t->run();
    // terminate thread by exiting to scheduler
    exit_to_scheduler();
  }

  fjnative() : fiber() { }

  void finish() {
    notify();
  } 

  ~fjnative() {
    if ((stack == nullptr) || (stack == notownstackptr)) {
      return;
    }
    auto s = stack;
    stack = nullptr;
    free(s);
  }

  void fork2(forkable_fiber* _f1, forkable_fiber* _f2) {
    mcsl::fjnative_stats::increment(mcsl::fjnative_stats_configuration::nb_fibers);
    mcsl::fjnative_stats::increment(mcsl::fjnative_stats_configuration::nb_fibers);
    fjnative* f1 = (fjnative*)_f1;
    fjnative* f2 = (fjnative*)_f2;
    status = fiber_status_pause;
    add_edge(f2, this);
    add_edge(f1, this);
    f2->release();
    f1->release();
    if (context::capture<fjnative*>(context::addr(ctx))) {
      //      util::atomic::aprintf("steal happened: executing join continuation\n");
      return;
    }
    // know f1 stays on my stack
    f1->stack = notownstackptr;
    f1->swap_with_scheduler();
    // sched is popping f1
    // run begin of sched->exec(f1) until f1->exec()
    f1->run();
    // if f2 was not stolen, then it can run in the same stack as parent
    auto f = fjnative_scheduler::take<fiber>();
    if (f == nullptr) {
      status = fiber_status_finish;
      //      util::atomic::aprintf("%d %d detected steal of %p\n",id,util::worker::get_my_id(),f2);
      exit_to_scheduler();
      return; // unreachable
    }
    //    util::atomic::aprintf("%d %d ran %p; going to run f %p\n",id,util::worker::get_my_id(),f1,f2);
    // prepare f2 for local run
    assert(f == f2);
    assert(f2->stack == nullptr);
    f2->stack = notownstackptr;
    f2->swap_with_scheduler();
    //    util::atomic::aprintf("%d %d this=%p f1=%p f2=%p\n",id,util::worker::get_my_id(),this, f1, f2);
    //    printf("ran %p and %p locally\n",f1,f2);
    // run end of sched->exec() starting after f1->exec()
    // run begin of sched->exec(f2) until f2->exec()
    f2->run();
    status = fiber_status_finish;
    swap_with_scheduler();
    // run end of sched->exec() starting after f2->exec()
  }

};

char fjnative::dummy1;
char fjnative::dummy2;

template <typename F>
class fjnative_of_function : public fjnative {
public:

  fjnative_of_function(const F& f) : fjnative(), f(f) { }

  F f;

  void run2() {
    f();
  }
};

} // end namespace
