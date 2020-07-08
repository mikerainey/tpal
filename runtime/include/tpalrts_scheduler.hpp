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
static constexpr
uint64_t dflt_timer_us = 20;
static constexpr
uint64_t dflt_timer_ns = 1000 * dflt_timer_us;
uint64_t nk_heartbeat_timer_ns;
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
#define NK_TIMER_CALLBACK  0x4  // thread continue immediately,
#endif

#include "mcsl_scheduler.hpp"
#include "mcsl_machine.hpp"

#include "tpalrts_util.hpp"
#include "tpalrts_rollforward.hpp"

namespace tpalrts {

/*---------------------------------------------------------------------*/
/* TPAL worker-thread configuration */

class tpal_worker {
public:

  static
  void initialize_worker() {
    mcsl::pin_calling_worker();
  }

  template <typename Body>
  static
  void launch_worker_thread(std::size_t i, const Body& b) {
    mcsl::minimal_worker::launch_worker_thread(i, b);
  }

  using worker_exit_barrier = typename mcsl::minimal_worker::worker_exit_barrier;
  
  using termination_detection_type = mcsl::minimal_termination_detection;

};

/*---------------------------------------------------------------------*/
/* Ping-thread scheduler configuration */

using ping_thread_status_type = enum ping_thread_status_enum {
  ping_thread_status_active,
  ping_thread_status_exit_launch,
  ping_thread_status_exited
};
  
#if defined(MCSL_LINUX)
  
static
mcsl::perworker::array<pthread_t> pthreads;

class ping_thread_worker {
public:

  static
  void initialize_worker() {
    mcsl::pin_calling_worker();
    sigset_t mask, prev_mask;
    if (pthread_sigmask(SIG_SETMASK, NULL, &prev_mask)) {
      exit(0);
    }
    struct sigaction sa, prev_sa;
    sa.sa_sigaction = heartbeat_interrupt_handler;
    sa.sa_flags = SA_RESTART | SA_NODEFER | SA_SIGINFO;
    sa.sa_mask = prev_mask;
    sigdelset(&sa.sa_mask, SIGUSR1);
    if(sigaction(SIGUSR1, &sa, &prev_sa)) {
      exit(0);
    }
    sigemptyset(&mask);
    sigaddset(&mask, SIGUSR1);
  }

  template <typename Body>
  static
  void launch_worker_thread(std::size_t id, const Body& b) {
    auto t = std::thread([id, &b] {
      mcsl::perworker::unique_id::initialize_worker(id);
      b(id);
    });
    pthreads[id] = t.native_handle();
    t.detach();
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
  
class ping_thread_worker {
public:

  static
  void initialize_worker() {
    threads.mine() = naut_get_cur_thread();
  }

  template <typename Body>
  static
  void launch_worker_thread(std::size_t id, const Body& b) {
    // todo: assert that i+1 < nb_cpus
    std::function<void(std::size_t)> f = [&] (std::size_t id) {
      mcsl::perworker::unique_id::initialize_worker(id);
      b(id);
    };
    auto p = new nk_worker_activation_type(id, f);
    int remote_core = id;
    nk_thread_start(nk_thread_init_fn, (void*)p, 0, 0, TSTACK_DEFAULT, 0, remote_core);
  }

  using worker_exit_barrier = typename mcsl::minimal_worker::worker_exit_barrier;
  
  using termination_detection_type = mcsl::minimal_termination_detection;

};
  
class ping_thread_interrupt {
public:

  static
  nk_timer_t* timer;

  static
  nemo_event_id_t id;

  static
  std::atomic<ping_thread_status_type> ping_thread_status;
  
  static
  void initialize_signal_handler() {
    id = nk_nemo_register_event_action(heartbeat_interrupt_handler, NULL);
  }
  
  static
  void wait_to_terminate_ping_thread() {
    auto s = ping_thread_status.load();
    if (s == ping_thread_status_active) {
      ping_thread_status.compare_exchange_strong(s, ping_thread_status_exit_launch);
    }
    while (ping_thread_status.load() != ping_thread_status_exited) { }
  }

  static
  uint64_t last_time;

  static
  uint64_t counter;

  static uint64_t start_time;

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
    for (std::size_t i = 0; i != nb_workers; i++) {
      nk_nemo_event_notify(id, i);
    }
    uint64_t cur_time = nk_sched_get_realtime();
    uint64_t cur_goal = last_time + nk_heartbeat_timer_ns;
    uint64_t next_goal = cur_goal + nk_heartbeat_timer_ns;
    uint64_t next_target = next_goal > cur_time ? next_goal : cur_time;
    uint64_t deadline = next_target - cur_time;
    last_time = cur_time;
    nk_timer_reset(timer, deadline);
    nk_timer_start(timer);
    counter++;
  }

  static
  void launch_ping_thread(std::size_t nb_workers) {
    counter = 0;
    std::function<void(std::size_t)> f = [=] (std::size_t id) {
      start_time = last_time = nk_sched_get_realtime();
      timer = nk_timer_create("heartbeat_timer");
      nk_timer_set(timer, nk_heartbeat_timer_ns, NK_TIMER_CALLBACK, heartbeat_timer_callback, (void*)naut_get_cur_thread(), 0);
      nk_timer_start(timer);
      while (ping_thread_status.load() == ping_thread_status_active) {
        nk_sleep(1000000000l);
      }
    };
    auto p = new nk_worker_activation_type(id, f);
    nk_thread_start(nk_thread_init_fn, (void*)p, 0, 0, TSTACK_DEFAULT, 0, nb_workers);
  }
  
};

nk_timer_t* ping_thread_interrupt::timer;

uint64_t ping_thread_interrupt::last_time;

uint64_t ping_thread_interrupt::start_time;
  
uint64_t ping_thread_interrupt::counter;
  
std::atomic<ping_thread_status_type> ping_thread_interrupt::ping_thread_status(ping_thread_status_active);

nemo_event_id_t ping_thread_interrupt::id;
  
#endif

/*---------------------------------------------------------------------*/
/* Pthread-direct interrupt configuration (Linux specific) */

#if defined(MCSL_LINUX)
  
class pthread_direct_worker {
public:

  template <typename Body>
  static
  void launch_worker_thread(std::size_t id, const Body& b) {
    mcsl::minimal_worker::launch_worker_thread(id, b);
  }
  
  static
  void initialize_worker() {
    mcsl::pin_calling_worker();
    unsigned int ns;
    unsigned int sec;
    timer_t timerid;
    struct sigevent sev;
    struct itimerspec itval;
    sev.sigev_notify = SIGEV_THREAD_ID;
    sev._sigev_un._tid = syscall(SYS_gettid);
    sev.sigev_signo = SIGUSR1; 
    sev.sigev_value.sival_ptr = &timerid;
    {
      auto one_million = 1000000;
      sec = kappa_usec / one_million;
      ns = (kappa_usec - (sec * one_million)) * 1000;
      itval.it_interval.tv_sec = sec;
      itval.it_interval.tv_nsec = ns;
      itval.it_value.tv_sec = sec;
      itval.it_value.tv_nsec = ns;
    }
    if (timer_create(CLOCK_REALTIME, &sev, &timerid) == -1) {
      printf("timer_create failed: %d: %s\n", errno, strerror(errno));
    }
    timer_settime(timerid, 0, &itval, NULL);
  }

  using worker_exit_barrier = typename mcsl::minimal_worker::worker_exit_barrier;
  
  using termination_detection_type = mcsl::minimal_termination_detection;

};

class pthread_direct_interrupt {
public:
  
  static
  void initialize_signal_handler() {
    struct sigaction act;
    memset(&act, 0, sizeof(struct sigaction));
    sigemptyset(&act.sa_mask);
    act.sa_sigaction = tpalrts::heartbeat_interrupt_handler;
    act.sa_flags = SA_SIGINFO | SA_ONSTACK;
    sigaction(SIGUSR1, &act, NULL);
  }

  static
  void wait_to_terminate_ping_thread() { }
  
  static
  void launch_ping_thread(std::size_t nb_workers) { }
  
};

#endif
  
/*---------------------------------------------------------------------*/
/* PAPI interrupt configuration */

#if defined(MCSL_LINUX)
  
static
void papi_interrupt_handler(int, void*, long long, void *context) {
  heartbeat_interrupt_handler(0, nullptr, context);
}

class papi_interrupt {
public:

  static
  void initialize_signal_handler() {
    int retval;
    int event_set = PAPI_NULL;
    if ( (retval = PAPI_create_eventset(&event_set))!=PAPI_OK) {
      mcsl::die("papi worker initialization failed");
    }
    if ((retval=PAPI_query_event(PAPI_TOT_CYC)) != PAPI_OK) {
      mcsl::die("papi worker initialization failed");
    }
    if ( (retval = PAPI_add_event(event_set, PAPI_TOT_CYC)) != PAPI_OK) {
      mcsl::die("papi worker initialization failed");
    }
    if((retval = PAPI_overflow(event_set, PAPI_TOT_CYC, kappa_cycles, 0, papi_interrupt_handler)) != PAPI_OK) {
      mcsl::die("papi worker initialization failed");
    }
    if((retval = PAPI_start(event_set)) != PAPI_OK) {
      mcsl::die("papi worker initialization failed");
    }
  }

  static
  void wait_to_terminate_ping_thread() { }

  static
  void launch_ping_thread(std::size_t) { }

};

#endif

} // end namespace
