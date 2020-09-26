#include "benchmark.hpp"
#include "incr_array.hpp"

namespace tpalrts {

using namespace incr_array;
  
void launch() {
  incr_array::nb_items = deepsea::cmdline::parse_or_default_long("n", incr_array::nb_items);
  incr_array_manual_T = deepsea::cmdline::parse_or_default_int("incr_array_manual_T", incr_array_manual_T);
  using microbench_scheduler_type = mcsl::minimal_scheduler<stats, logging, mcsl::minimal_elastic, tpal_worker>;
  auto bench_body_manual = new incr_array_manual<microbench_scheduler_type>(a, 0, nb_items);
  launch(bench_pre, bench_body_interrupt, bench_body_software_polling, bench_body_serial,
         bench_post, bench_body_manual, bench_body_cilk);
}

} // end namespace

int main() {
  tpalrts::launch();
  return 0;
}
