#include "benchmark.hpp"
#include "plus_reduce_array.hpp"

namespace tpalrts {

using namespace plus_reduce_array;
  
void launch() {
  plus_reduce_array::nb_items = deepsea::cmdline::parse_or_default_long("n", plus_reduce_array::nb_items);
  plus_reduce_array_manual_T = deepsea::cmdline::parse_or_default_int("plus_reduce_array_manual_T", plus_reduce_array_manual_T);
  using microbench_scheduler_type = mcsl::minimal_scheduler<stats, logging, mcsl::minimal_elastic, tpal_worker>;
  auto bench_body_manual = new plus_reduce_array_manual<microbench_scheduler_type>(a, 0, nb_items, &result);
  launch(bench_pre, bench_body_interrupt, bench_body_software_polling, bench_body_serial,
         bench_post, bench_body_manual, bench_body_cilk);
}

} // end namespace

int sorter(const void* v1,const void* v2) {
  return *((uint64_t*)v1)-*((uint64_t*)v2);
}

int main() {
  qsort(rollforward_table, rollforward_table_size, 16, sorter);
  qsort(rollback_table, rollforward_table_size, 16, sorter);
  tpalrts::launch();
  return 0;
}
