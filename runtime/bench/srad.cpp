#include "benchmark.hpp"
#include "srad.hpp"

namespace tpalrts {

using namespace srad;
  
void launch() {
  rollforward_table = {
    #include "srad_rollforward_map.hpp"
  };

  rows = deepsea::cmdline::parse_or_default_long("rows", cols);
  cols = deepsea::cmdline::parse_or_default_long("cols", rows);
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
