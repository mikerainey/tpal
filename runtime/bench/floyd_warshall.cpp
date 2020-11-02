#include "benchmark.hpp"
#include "floyd_warshall.hpp"

namespace tpalrts {

using namespace floyd_warshall;
  
void launch() {
  vertices = deepsea::cmdline::parse_or_default_int("vertices", vertices);
  using microbench_scheduler_type = mcsl::minimal_scheduler<stats, logging, mcsl::minimal_elastic, tpal_worker>;
  auto bench_body_manual = new tpalrts::terminal_fiber<microbench_scheduler_type>();
  deepsea::cmdline::dispatcher d;
  d.add("onek_vertices", [&] {
    vertices = 1024;
    launch(bench_pre, bench_body_interrupt, bench_body_software_polling, bench_body_serial,
	   bench_post, bench_body_manual, bench_body_cilk);
  });
  d.add("twok_vertices", [&] {
    vertices = 2048;
    launch(bench_pre, bench_body_interrupt, bench_body_software_polling, bench_body_serial,
	   bench_post, bench_body_manual, bench_body_cilk);
  });
  d.dispatch_or_default("inputname", "onek_vertices");
}

} // end namespace

int main() {
  tpalrts::launch();
  return 0;
}
