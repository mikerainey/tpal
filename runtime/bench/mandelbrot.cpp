#include "benchmark.hpp"
#include "mandelbrot.hpp"

namespace tpalrts {

using namespace mandelbrot;
  
void launch() {
  height = deepsea::cmdline::parse_or_default_long("height", mandelbrot::height);
  width = deepsea::cmdline::parse_or_default_long("width", mandelbrot::width);
  using microbench_scheduler_type = mcsl::minimal_scheduler<stats, logging, mcsl::minimal_elastic, tpal_worker>;
  auto bench_body_manual = new terminal_fiber<microbench_scheduler_type>;
  launch(bench_pre, bench_body_interrupt, bench_body_software_polling, bench_body_serial,
         bench_post, bench_body_manual, bench_body_cilk);
}

} // end namespace

int main() {
  tpalrts::launch();
  return 0;
}
