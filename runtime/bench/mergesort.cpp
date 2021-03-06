#include "benchmark.hpp"
#include "mergesort.hpp"

namespace tpalrts {

using namespace mergesort;
  
void launch() {
  n = deepsea::cmdline::parse_or_default_long("n", n);
  using microbench_scheduler_type = mcsl::minimal_scheduler<stats, logging, mcsl::minimal_elastic, tpal_worker>;
  auto bench_body_manual = new tpalrts::terminal_fiber<microbench_scheduler_type>();
  deepsea::cmdline::dispatcher d;
  d.add("uniformdist", [&] {
    launch(bench_pre_uniformdist, bench_body_interrupt, bench_body_software_polling, bench_body_serial,
	   bench_post, bench_body_manual, bench_body_cilk);
  });
  d.add("expdist", [&] {
    launch(bench_pre_expdist, bench_body_interrupt, bench_body_software_polling, bench_body_serial,
	   bench_post, bench_body_manual, bench_body_cilk);
  });
  d.dispatch_or_default("inputname", "uniformdist");
}

} // end namespace

int main() {
  tpalrts::launch();
  return 0;
}
