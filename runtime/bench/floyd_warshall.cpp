#define TPALRTS_USE_INTERRUPT_FLAGS 1

#include "benchmark.hpp"
#include "floyd_warshall.hpp"

namespace tpalrts {
  
void launch() {
  rollforward_table = {
                       // later: fill
  };
  uint64_t n = deepsea::cmdline::parse_or_default_long("n", 500);
  if (n > max_vertices) {
    mcsl::die("max vertices is %d\n",max_vertices);
  }
  int64_t software_polling_K = deepsea::cmdline::parse_or_default_int("software_polling_K", 128);
  tpalrts::stack_type s;
  auto bench_pre = [=] {
    int vertices = n;
    for(int i = 0 ; i < vertices ; i++) {
      for(int j = 0 ; j< vertices; j++) {
        if (i == j)
          dist[i][j] = 0;
        else {
          int num = i + j;
          if (num % 3 == 0)
            dist[i][j] = num / 2;
          else if (num % 2 == 0)
            dist[i][j] = num * 2;
          else
            dist[i][j] = num;
        }
      }
    }
    for(int i = 0; i < vertices; i++) {
      for(int j = 0; j < vertices; j++) {
        dist[i][j] = (i == j) ? 0 : INF;
      }
    }
  };
  auto bench_body_interrupt = [&] (promotable* p) {
    s = tpalrts::snew();

  };
  auto bench_body_software_polling = [&] (promotable* p) {
    s = tpalrts::snew();

  }; 
  auto bench_body_serial = [&] (promotable* p) {
    floyd_warshall_serial(n);
  };
  auto bench_post = [&]   {
  };
  using microbench_scheduler_type = mcsl::minimal_scheduler<stats, logging, mcsl::minimal_elastic, tpal_worker>;
  auto bench_body_manual = new tpalrts::terminal_fiber<microbench_scheduler_type>();
  auto bench_body_cilk = [&] {
    floyd_warshall_cilk(n);
  };
  launch(bench_pre, bench_body_interrupt, bench_body_software_polling, bench_body_serial,
         bench_post, bench_body_manual, bench_body_cilk);
}

} // end namespace

int main() {
  tpalrts::launch();
  return 0;
}
