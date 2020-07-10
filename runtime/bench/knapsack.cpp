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
  n = deepsea::cmdline::parse_or_default_int("n", 100);
  capacity = deepsea::cmdline::parse_or_default_int("capacity", 100);
  struct item* items = (struct item*)malloc(sizeof(item) * n);
  auto bench_pre = [=] {
    uint64_t h1 = mcsl::hash(n);
    uint64_t h2 = mcsl::hash(n+1);
    for (std::size_t i = 0; i < n; i++) {
      items[i].value = h1 % 1000;
      items[i].weight = std::max(3ul, h2 % capacity);
      h1 = mcsl::hash(h1);
      h2 = mcsl::hash(h2);
    }
  };
  auto bench_body_interrupt = [&] (promotable* p) {
    s = tpalrts::snew();
    knapsack_heartbeat<heartbeat_mechanism_hardware_interrupt>(items, capacity, n, 0, &sol, p, s);
  };
  auto bench_body_software_polling = [&] (promotable* p) {
    s = tpalrts::snew();
    knapsack_heartbeat<heartbeat_mechanism_software_polling>(items, capacity, n, 0, &sol, p, s);
  }; 
  auto bench_body_serial = [&] (promotable* p) {
    s = tpalrts::snew();
    sol = knapsack_custom_stack_serial(items, capacity, n, 0, s);
  };
  auto bench_post = [&]   {
    best_so_far = INT_MIN;
    //    assert(sol == knapsack_serial(items, capacity, n, 0));
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
