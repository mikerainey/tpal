#pragma once

#ifdef USE_CILK_PLUS
#include <cilk/cilk.h>
#include <cilk/cilk_api.h>
#endif

#include "tpalrts_scheduler.hpp"
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
          typename Bench_pre, typename Bench_post, typename Bench_body>
void launch1(std::size_t nb_workers,
	     const Bench_pre& bench_pre,
	     const Bench_post& bench_post,
             const Bench_body& bench_body) {
  logging::initialize();
  mcsl::fjnative_of_function f_pre([&] {
    bench_pre(); 
    initialize_rollfoward_table();
    stats::start_collecting();
    logging::log_event(mcsl::enter_algo);
    start_time = mcsl::clock::now();
    start_cycle = mcsl::cycles::now();
  });
  mcsl::fjnative_of_function f_body([&] {
    bench_body();
  });
  mcsl::fjnative_of_function f_post([&] {
    elapsed_cycles = mcsl::cycles::since(start_cycle);
    elapsed_time = mcsl::clock::since(start_time);
    logging::log_event(mcsl::exit_algo);
    stats::report(nb_workers);
    destroy_rollfoward_table();
    bench_post();
  });
  auto f_term = new mcsl::terminal_fiber<Scheduler>();
  mcsl::fiber<Scheduler>::add_edge((mcsl::fiber<Scheduler>*)&f_pre, (mcsl::fiber<Scheduler>*)&f_body);
  mcsl::fiber<Scheduler>::add_edge((mcsl::fiber<Scheduler>*)&f_body, (mcsl::fiber<Scheduler>*)&f_post);
  mcsl::fiber<Scheduler>::add_edge((mcsl::fiber<Scheduler>*)&f_post, (mcsl::fiber<Scheduler>*)f_term);
  f_pre.release();
  f_body.release();
  f_post.release();
  f_term->release();
  using fiber = fjnative
  using scheduler = mcsl::chase_lev_work_stealing_scheduler<Scheduler, fiber, stats, logging, mcsl::minimal_elastic, Worker, Interrupt>;
  scheduler::launch(nb_workers);
}

template <typename Bench_pre,
          typename Bench_body_heartbeat,
          typename Bench_body_serial,
          typename Bench_post,
          typename Bench_body_cilk>
void launch2(const Bench_pre& bench_pre,
	     const Bench_body_heartbeat& bench_body_heartbeat,
	     const Bench_body_serial& bench_body_serial,
	     const Bench_post& bench_post,
	     const Bench_body_cilk& bench_body_cilk) {
  mcsl::initialize_machine();
  cilk_set_nb_workers(mcsl::nb_workers);
  {
    auto cpu_freq_khz = mcsl::load_cpu_frequency_khz();
    printf("cpu_freq_khz %lu\n", cpu_freq_khz);
    assign_kappa(cpu_freq_khz, deepsea::cmdline::parse_or_default_int("kappa_usec", dflt_kappa_usec));
  }
  deepsea::cmdline::dispatcher d;
  d.add("cilk", [&] {
    bench_pre();
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
    bench_post();
  });
  d.add("serial", [&] {
    using scheduler = mcsl::minimal_scheduler<stats, logging, mcsl::minimal_elastic, tpal_worker, mcsl::minimal_interrupt>;
    launch1<scheduler, tpal_worker, mcsl::minimal_interrupt>(mcsl::nb_workers, bench_pre, bench_post, bench_body_serial);
  });
  d.add("heartbeat_ping_thread", [&] {
    using scheduler = mcsl::minimal_scheduler<stats, logging, mcsl::minimal_elastic, ping_thread_worker, ping_thread_interrupt>;
    launch1<scheduler, ping_thread_worker, ping_thread_interrupt>(mcsl::nb_workers, bench_pre, bench_post, bench_body_heartbeat);
  });
  d.dispatch_or_default("scheduler_configuration", "serial");
  mcsl::teardown_machine();
}

template <typename Bench_pre,
          typename Bench_body_heartbeat,
          typename Bench_body_serial,
          typename Bench_post,
          typename Bench_body_cilk>
void launch(const Bench_pre& bench_pre,
	    const Bench_body_heartbeat& bench_body_heartbeat,
	    const Bench_body_serial& bench_body_serial,
	    const Bench_post& bench_post,
	    const Bench_body_cilk& bench_body_cilk) {
  launch2(std::function<void()>(bench_pre),
	  std::function<void()>(bench_body_heartbeat),
	  std::function<void()>(bench_body_serial),
	  std::function<void()>(bench_post),
	  std::function<void()>(bench_body_cilk));
}

} // end namespace
