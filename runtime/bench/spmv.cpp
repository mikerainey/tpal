#include "benchmark.hpp"
#include "spmv.hpp"

namespace tpalrts {

using namespace spmv;
  
void launch() {
  n = deepsea::cmdline::parse_or_default_long("n", n);
  row_len = deepsea::cmdline::parse_or_default_long("row_len", std::min(n, row_len));
  spmv_manual_col_T = deepsea::cmdline::parse_or_default_int("spmv_manual_col_T", spmv_manual_col_T);
  using microbench_scheduler_type = mcsl::minimal_scheduler<stats, logging, mcsl::minimal_elastic, tpal_worker>;
  auto bench_body_manual = new spmv_manual<microbench_scheduler_type>(val, row_ptr, col_ind, x, y, 0, nb_rows, 0, 0);
  launch(bench_pre, bench_body_interrupt, bench_body_software_polling, bench_body_serial,
         bench_post, bench_body_manual, bench_body_cilk);
}

} // end namespace

int main() {
  tpalrts::launch();
  return 0;
}
