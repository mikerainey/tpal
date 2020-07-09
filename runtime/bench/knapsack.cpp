#define TPALRTS_USE_INTERRUPT_FLAGS 1

#include "benchmark.hpp"
#include "knapsack.hpp"

namespace tpalrts {
  
void launch() {
  rollforward_table = {
                       // later: fill
  };
  int n, capacity, sol;
  tpalrts::stack_type s;
  struct item items[MAX_ITEMS];
  n = 3;
  capacity = 90;
  items[0].value = 100;
  items[0].weight = 80;
  items[1].value = 80;
  items[1].weight = 45;
  items[2].value = 80;
  items[2].weight = 45;
  
  auto bench_pre = [=] {  };
  auto bench_body_interrupt = [&] (promotable* p) {
  };
  auto bench_body_software_polling = [&] (promotable* p) {
  }; 
  auto bench_body_serial = [&] (promotable* p) {
    s = tpalrts::snew();
    sol = knapsack_custom_stack_serial(items, capacity, n, 0, s);
  };
  auto bench_post = [&]   {
    best_so_far = INT_MIN;
    assert(sol == knapsack_serial(items, capacity, n, 0));
  };
  using microbench_scheduler_type = mcsl::minimal_scheduler<stats, logging, mcsl::minimal_elastic, tpal_worker>;
  auto bench_body_manual = new knapsack_manual<microbench_scheduler_type>();
  auto bench_body_cilk = [&] {
     sol = knapsack_cilk(items, capacity, n, 0);
  };
  launch(bench_pre, bench_body_interrupt, bench_body_software_polling, bench_body_serial,
         bench_post, bench_body_manual, bench_body_cilk);
}

} // end namespace

int main() {
  tpalrts::launch();
  return 0;
}
