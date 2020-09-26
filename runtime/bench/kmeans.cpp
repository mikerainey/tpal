#include "benchmark.hpp"
#include "kmeans.hpp"

namespace tpalrts {

using namespace kmeans;
  
void launch() {
  numObjects = deepsea::cmdline::parse_or_default_int("n", numObjects);
  using microbench_scheduler_type = mcsl::minimal_scheduler<stats, logging, mcsl::minimal_elastic, tpal_worker>;
  auto bench_body_manual = new tpalrts::terminal_fiber<microbench_scheduler_type>();
  launch(bench_pre, bench_body_interrupt, bench_body_software_polling, bench_body_serial,
         bench_post, bench_body_manual, bench_body_cilk);
}

} // end namespace

int main() {
  tpalrts::launch();
  return 0;
}
