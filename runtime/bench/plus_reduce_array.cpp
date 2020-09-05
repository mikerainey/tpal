#include "benchmark.hpp"
#include "plus_reduce_array.hpp"

namespace tpalrts {
  
void launch() {
  rollforward_table = {
    #include "plus_reduce_array_rollforward_map.hpp"
    /*    mk_rollforward_entry(plus_reduce_array_interrupt_l0, plus_reduce_array_interrupt_rf_l0),
    mk_rollforward_entry(plus_reduce_array_interrupt_l1, plus_reduce_array_interrupt_rf_l1),
    mk_rollforward_entry(plus_reduce_array_interrupt_l2, plus_reduce_array_interrupt_rf_l2),
    mk_rollforward_entry(plus_reduce_array_interrupt_l3, plus_reduce_array_interrupt_rf_l3), */
  };
  int64_t software_polling_K = deepsea::cmdline::parse_or_default_int("software_polling_K", 128);
  uint64_t nb_items = deepsea::cmdline::parse_or_default_long("n", 20000000);
  int64_t* a = (int64_t*)malloc(sizeof(int64_t)*nb_items);
  int64_t result = 0;
  auto bench_pre = [=] {
    for (int64_t i = 0; i < nb_items; i++) {
      a[i] = 1;
    }
  };
  auto bench_body_interrupt = [&] (promotable* p) {
    plus_reduce_array_interrupt(a, 0, nb_items, 0, &result, p);
  };
  auto bench_body_software_polling = [&] (promotable* p) {
    plus_reduce_array_software_polling(a, 0, nb_items, &result, p, software_polling_K);
  };
  auto bench_body_serial = [&] (promotable* p) {
    result = plus_reduce_array_serial(a, 0, nb_items);
  };
  auto bench_post = [&]   {
    if (result != nb_items) { printf("OOPS\n"); }
    assert(result == nb_items);
    free(a);
  };
  plus_reduce_array_manual_T = deepsea::cmdline::parse_or_default_int("plus_reduce_array_manual_T", plus_reduce_array_manual_T);
  using microbench_scheduler_type = mcsl::minimal_scheduler<stats, logging, mcsl::minimal_elastic, tpal_worker>;
  auto bench_body_manual = new plus_reduce_array_manual<microbench_scheduler_type>(a, 0, nb_items, &result);
  auto bench_body_cilk = [&] {
    result = plus_reduce_array_cilk(a, 0, nb_items);
  };
  launch(bench_pre, bench_body_interrupt, bench_body_software_polling, bench_body_serial,
         bench_post, bench_body_manual, bench_body_cilk);
}

} // end namespace

int main() {
  tpalrts::launch();
  return 0;
}
