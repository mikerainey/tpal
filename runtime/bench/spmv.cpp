#include "benchmark.hpp"
#include "spmv.hpp"

namespace tpalrts {

using namespace spmv;
  
void launch() {
  spmv_manual_col_T = deepsea::cmdline::parse_or_default_int("spmv_manual_col_T", spmv_manual_col_T);
  using microbench_scheduler_type = mcsl::minimal_scheduler<stats, logging, mcsl::minimal_elastic, tpal_worker>;
  auto bench_body_manual = new spmv_manual<microbench_scheduler_type>(val, row_ptr, col_ind, x, y, 0, nb_rows, 0, 0);

  deepsea::cmdline::dispatcher d;
  d.add("bigrows", [&] {
    n_bigrows = deepsea::cmdline::parse_or_default_long("n", n_bigrows);
    degree_bigrows = deepsea::cmdline::parse_or_default_long("degree", std::max((uint64_t)2, degree_bigrows));
    launch(bench_pre_bigrows, bench_body_interrupt, bench_body_software_polling, bench_body_serial,
	   bench_post, bench_body_manual, bench_body_cilk);
  });
  d.add("bigcols", [&] {
    n_bigcols = deepsea::cmdline::parse_or_default_long("n", n_bigcols);
    launch(bench_pre_bigcols, bench_body_interrupt, bench_body_software_polling, bench_body_serial,
	   bench_post, bench_body_manual, bench_body_cilk);
  });
  d.add("arrowhead", [&] {
    n_arrowhead = deepsea::cmdline::parse_or_default_long("n", n_arrowhead);
    launch(bench_pre_arrowhead, bench_body_interrupt, bench_body_software_polling, bench_body_serial,
	   bench_post, bench_body_manual, bench_body_cilk);
  });
  d.dispatch_or_default("inputname", "bigrows");
}

} // end namespace

int main() {
  tpalrts::launch();
  return 0;
}
