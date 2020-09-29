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

#include "mcsl_scheduler.hpp"

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
  
class ping_thread_worker {
public:

  template <typename Body>
  static
  void launch_worker_thread(std::size_t id, const Body& b) {
    std::function<void(std::size_t)> f = [=] (std::size_t id) {
      mcsl::perworker::unique_id::initialize_worker(id);
      b(id);
    };
    auto p = new nk_worker_activation_type(id, f);
    int remote_core = mcsl::cpu_pinning_assignments[id];
    if (remote_core == 0) {
      mcsl::perworker::unique_id::initialize_worker(id);
      b(id);
      return;
    }
    nk_thread_start(nk_thread_init_fn, (void*)p, 0, 0, TSTACK_DEFAULT, 0, remote_core);
    if (id == 0) {
      nk_join_all_children(0);
    }
  }

  using worker_exit_barrier = typename mcsl::minimal_worker::worker_exit_barrier;
  
  using termination_detection_type = mcsl::minimal_termination_detection;

};
  
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
  
class pthread_direct_worker {
public:

  static
  mcsl::perworker::array<timer_t> timerid;

  static
  void initialize_worker() {
    unsigned int ns;
    unsigned int sec;
    struct sigevent sev;
    struct itimerspec itval;
    sev.sigev_notify = SIGEV_THREAD_ID;
    sev._sigev_un._tid = syscall(SYS_gettid);
    sev.sigev_signo = SIGUSR1; 
    sev.sigev_value.sival_ptr = &timerid.mine();
    {
      auto one_million = 1000000;
      sec = kappa_usec / one_million;
      ns = (kappa_usec - (sec * one_million)) * 1000;
      itval.it_interval.tv_sec = sec;
      itval.it_interval.tv_nsec = ns;
      itval.it_value.tv_sec = sec;
      itval.it_value.tv_nsec = ns;
    }
    if (timer_create(CLOCK_REALTIME, &sev, &timerid.mine()) == -1) {
      printf("timer_create failed: %d: %s\n", errno, strerror(errno));
    }
    timer_settime(timerid.mine(), 0, &itval, NULL);
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

class pthread_direct_interrupt {
public:
  
  static
  void initialize_signal_handler() {
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

#endif
  
/*---------------------------------------------------------------------*/
/* PAPI interrupt configuration */

#if defined(MCSL_LINUX)

static
void papi_interrupt_handler(int, void*, long long, void *context) {
  heartbeat_interrupt_handler(0, nullptr, context);
}

std::mutex papi_init_mutex;

// guide: https://icl.cs.utk.edu/papi/docs/dc/d7e/examples_2overflow__pthreads_8c_source.html

class papi_worker {
public:

  static
  mcsl::perworker::array<int> event_set;

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
    if ((retval = PAPI_stop(event_set.mine(), values))!=PAPI_OK) {
      mcsl::die("papi worker stop failed");
    }
    retval = PAPI_overflow(event_set.mine(), PAPI_TOT_CYC, 0, 0, papi_interrupt_handler);
    if(retval !=PAPI_OK) {
      mcsl::die("papi worker deinitialization1 failed");
    }
    /*
    retval = PAPI_remove_event(event_set.mine(), PAPI_TOT_CYC);
    if (retval != PAPI_OK) {
      mcsl::die("papi worker deinitialization failed");
      }*/
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
