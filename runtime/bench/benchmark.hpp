#ifdef USE_CILK_PLUS
#include <cilk/cilk.h>
#include <cilk/cilk_api.h>
#endif

#if defined(TPALRTS_LINUX)
#include "cmdline.hpp"
#include "mcsl_chaselev.hpp"
#include "mcsl_machine.hpp"
#endif

#include "tpalrts_scheduler.hpp"
#include "tpalrts_fiber.hpp"
#include "tpalrts_rollforward.hpp"

namespace tpalrts {

mcsl::clock::time_point_type start_time;
double elapsed_time;
uint64_t start_cycle, elapsed_cycles;
  
static
void cilk_set_nb_workers(int nb_workers) {
#if defined(USE_CILK_PLUS)                  
  int cilk_failed = __cilkrts_set_param("nworkers", std::to_string(nb_workers).c_str());
  if (cilk_failed) {
    mcsl::die("Failed to set number of processors to %d in Cilk runtime", nb_workers);
  }
#endif
}

#ifdef CILK_RUNTIME_WITH_STATS
void trigger_cilk() {
  printf("");
}
#endif
  
template <typename Scheduler, typename Worker, typename Interrupt,
          typename Bench_pre, typename Bench_post, typename Fiber_body>
void launch0(std::size_t nb_workers,
	     const Bench_pre& bench_pre,
	     const Bench_post& bench_post,
	     Fiber_body f_body) {
  logging::initialize();
  {
    auto f_pre = new fiber<Scheduler>([=] (promotable* p) {
      bench_pre(p);
      initialize_rollfoward_table();
      stats::start_collecting();
      logging::log_event(mcsl::enter_algo);
      start_time = mcsl::clock::now();
      start_cycle = mcsl::cycles::now();
    });
    auto f_cont = new fiber<Scheduler>([=] (promotable* p) {
      elapsed_cycles = mcsl::cycles::since(start_cycle);
      elapsed_time = mcsl::clock::since(start_time);
      logging::log_event(mcsl::exit_algo);
      stats::report(nb_workers);
      destroy_rollfoward_table();
      bench_post(p);
    });
    auto f_term = new terminal_fiber<Scheduler>();
    fiber<Scheduler>::add_edge(f_pre, f_body);
    fiber<Scheduler>::add_edge(f_body, f_cont);
    fiber<Scheduler>::add_edge(f_cont, f_term);
    f_pre->release();
    f_body->release();
    f_cont->release();
    f_term->release();
  }
  using scheduler_type = mcsl::chase_lev_work_stealing_scheduler<Scheduler, fiber, stats, logging, mcsl::minimal_elastic, Worker, Interrupt>;
  scheduler_type::launch(nb_workers);
  printf("opsys linux\n");
  printf("exectime %.3f\n", elapsed_time);
  printf("execcycles %lu\n", elapsed_cycles);
  auto et = mcsl::seconds_of(mcsl::load_cpu_frequency_khz(), elapsed_cycles);
  printf("exectime_via_cycles %lu.%03lu\n", et.seconds, et.milliseconds);
  printf("kappa_usec %lu\n", kappa_usec);
  printf("kappa_cycles %lu\n", kappa_cycles);
  logging::output(nb_workers);
}

template <typename Worker, typename Interrupt,
          typename Bench_pre, typename Bench_post, typename Bench_body>
void launch1(std::size_t nb_workers,
             const Bench_pre& bench_pre,
             const Bench_post& bench_post,
             const Bench_body& bench_body) {
  using microbench_scheduler_type = mcsl::minimal_scheduler<stats, logging, mcsl::minimal_elastic, Worker, Interrupt>;
  auto f_body = new fiber<microbench_scheduler_type>([=] (promotable* p) {
    bench_body(p);
  });
  launch0<microbench_scheduler_type, Worker, Interrupt, Bench_pre, Bench_post, decltype(f_body)>(nb_workers, bench_pre, bench_post, f_body);
}
  
template <typename Bench_pre,
          typename Bench_body_interrupt,
          typename Bench_body_software_polling,
          typename Bench_body_serial,
          typename Bench_post,
          typename Bench_body_manual,
          typename Bench_body_cilk>
void launch2(size_t nb_workers,
             const Bench_pre& bench_pre,
             const Bench_body_interrupt& bench_body_interrupt,
             const Bench_body_software_polling& bench_body_software_polling,
             const Bench_body_serial& bench_body_serial,
             const Bench_post& bench_post,
             Bench_body_manual bench_body_manual,
             const Bench_body_cilk& bench_body_cilk) {
  auto papi_init = [] {
    auto& es = tpalrts::papi_worker::event_set;
    for (std::size_t i = 0; i != es.size(); i++) {
      es[i] = PAPI_NULL;
    }
    int retval;
    if ((retval=PAPI_library_init(PAPI_VER_CURRENT)) != PAPI_VER_CURRENT) {
      mcsl::die("papi initialization failed");
    }
    if ((retval=PAPI_thread_init((unsigned long(*)(void))(pthread_self))) != PAPI_OK) {
      mcsl::die("papi initialization failed");
    }
  };
  auto papi_deinit = [] {
    PAPI_shutdown();
  };
  deepsea::cmdline::dispatcher d;
  d.add("interrupt_ping_thread", [&] {
    launch1<ping_thread_worker, ping_thread_interrupt>(nb_workers, bench_pre, bench_post, bench_body_interrupt);
  });
  d.add("interrupt_pthread", [&] {
    launch1<pthread_direct_worker, pthread_direct_interrupt>(nb_workers, bench_pre, bench_post, bench_body_interrupt);
  });
  d.add("interrupt_papi", [&] {
    papi_init();
    launch1<papi_worker, mcsl::minimal_interrupt>(nb_workers, bench_pre, bench_post, bench_body_interrupt);
    papi_deinit();
  });
  d.add("serial_interrupt_ping_thread", [&] {
    launch1<ping_thread_worker, ping_thread_interrupt>(nb_workers, bench_pre, bench_post, bench_body_serial);
  });
  d.add("serial_interrupt_pthread", [&] {
    launch1<pthread_direct_worker, pthread_direct_interrupt>(nb_workers, bench_pre, bench_post, bench_body_serial);
  });
  d.add("serial_interrupt_papi", [&] {
    papi_init();
    launch1<papi_worker, mcsl::minimal_interrupt>(nb_workers, bench_pre, bench_post, bench_body_serial);
    papi_deinit();
  });
  d.add("nopromote_interrupt", [&] {
    launch1<tpal_worker, mcsl::minimal_interrupt>(nb_workers, bench_pre, bench_post, bench_body_interrupt);
  });  
  d.add("software_polling", [&] {
    launch1<tpal_worker, mcsl::minimal_interrupt>(nb_workers, bench_pre, bench_post, bench_body_software_polling);
  });
  d.add("manual", [&] {
    using microbench_scheduler_type = mcsl::minimal_scheduler<stats, logging, mcsl::minimal_elastic, tpal_worker>;
    launch0<microbench_scheduler_type, tpal_worker, mcsl::minimal_interrupt, Bench_pre, Bench_post, Bench_body_manual>(nb_workers, bench_pre, bench_post, bench_body_manual);
  });
  d.add("cilk", [&] {
    bench_pre(nullptr);
#ifdef CILK_RUNTIME_WITH_STATS
    cilk_spawn trigger_cilk();
    cilk_sync;
  __cilkg_take_snapshot_for_stats();
#endif
    start_time = mcsl::clock::now();
    start_cycle = mcsl::cycles::now();
    bench_body_cilk();
    elapsed_cycles = mcsl::cycles::since(start_cycle);
    elapsed_time = mcsl::clock::since(start_time);
#ifdef CILK_RUNTIME_WITH_STATS
    __cilkg_dump_encore_stats_to_stderr();
#endif
    printf("execcycles %lu\n", elapsed_cycles);
    auto et = mcsl::seconds_of(mcsl::load_cpu_frequency_khz(), elapsed_cycles);
    printf("exectime_via_cycles %lu.%03lu\n", et.seconds, et.milliseconds);
    printf("exectime %.3f\n", elapsed_time);
    bench_post(nullptr);
  });
  d.add("serial", [&] {
    launch1<tpal_worker, mcsl::minimal_interrupt>(nb_workers, bench_pre, bench_post, bench_body_serial);
  });  
  d.dispatch_or_default("scheduler_configuration", "serial");
}

template <typename Bench_pre,
          typename Bench_body_interrupt,
          typename Bench_body_software_polling,
          typename Bench_body_serial,
          typename Bench_post,
          typename Bench_body_manual,
          typename Bench_body_cilk>
void launch(const Bench_pre& bench_pre,
            const Bench_body_interrupt& bench_body_interrupt,
            const Bench_body_software_polling& bench_body_software_polling,
            const Bench_body_serial& bench_body_serial,
            const Bench_post& bench_post,
            Bench_body_manual bench_body_manual,
            const Bench_body_cilk& bench_body_cilk) {
  mcsl::initialize_machine();
  cilk_set_nb_workers(mcsl::nb_workers);
  {
    auto cpu_freq_khz = mcsl::load_cpu_frequency_khz();
    printf("cpu_freq_khz %lu\n", cpu_freq_khz);
    assign_kappa(cpu_freq_khz, deepsea::cmdline::parse_or_default_int("kappa_usec", dflt_kappa_usec));
  }
  launch2(mcsl::nb_workers,
          std::function<void(promotable*)>(bench_pre),
	  std::function<void(promotable*)>(bench_body_interrupt),
	  std::function<void(promotable*)>(bench_body_software_polling),
	  std::function<void(promotable*)>(bench_body_serial),
	  std::function<void(promotable*)>(bench_post),
	  bench_body_manual,
	  std::function<void()>(bench_body_cilk));
  mcsl::teardown_machine();
  for (std::size_t i = 0; i != arena_blocks.size(); i++) {
    auto b = arena_blocks[i];
    if (b != nullptr) {
      decr_arena_block(b);
    }
  }
}

} // end namespace
