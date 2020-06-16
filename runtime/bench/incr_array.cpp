#include "benchmark.hpp"
#include "incr_array.hpp"

namespace tpalrts {
  
void launch() {
  rollforward_table = {
    mk_rollforward_entry(incr_array_interrupt_l0, incr_array_interrupt_rf_l0),
    mk_rollforward_entry(incr_array_interrupt_l1, incr_array_interrupt_rf_l1),
    mk_rollforward_entry(incr_array_interrupt_l2, incr_array_interrupt_rf_l2),
    mk_rollforward_entry(incr_array_interrupt_l3, incr_array_interrupt_rf_l3),
  };
  uint64_t nb_items = deepsea::cmdline::parse_or_default_long("n", 20000000);
  int64_t* a = (int64_t*)malloc(sizeof(int64_t)*nb_items);
  auto bench_pre = [=] {
    for (int64_t i = 0; i < nb_items; i++) {
      a[i] = 0;
    }
  };
  auto bench_body_interrupt = [=] (promotable* p) {
    incr_array_interrupt(a, 0, nb_items, p);
  };
  auto bench_body_software_polling = [=] (promotable* p) {
    incr_array_software_polling(a, 0, nb_items, p);
  };
  auto bench_body_serial = [=] (promotable* p) {
    incr_array_serial(a, 0, nb_items);
  };
  auto bench_post = [=]   {
    int64_t m = 0;
    for (int64_t i = 0; i < nb_items; i++) {
      m += a[i];
    }
    assert(m == nb_items);
    free(a);
  };
  incr_array_manual_T = deepsea::cmdline::parse_or_default_int("incr_array_manual_T", incr_array_manual_T);
  using microbench_scheduler_type = mcsl::minimal_scheduler<stats, logging, mcsl::minimal_elastic, tpal_worker>;
  auto bench_body_manual = new incr_array_manual<microbench_scheduler_type>(a, 0, nb_items);
  auto bench_body_cilk = [=] {
    incr_array_cilk(a, 0, nb_items);
  };
  launch(bench_pre, bench_body_interrupt, bench_body_software_polling, bench_body_serial,
         bench_post, bench_body_manual, bench_body_cilk);
}

} // end namespace

int main() {
  tpalrts::launch();
  return 0;
}
