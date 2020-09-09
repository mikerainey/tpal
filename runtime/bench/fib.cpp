#define TPALRTS_USE_INTERRUPT_FLAGS 1

#include "benchmark.hpp"
#include "fib.hpp"

namespace tpalrts {
  
void launch() {
  rollforward_table = {
    #include "fib_rollforward_map.hpp"
  };
  uint64_t n = deepsea::cmdline::parse_or_default_long("n", 20);
  uint64_t r = 0;
  tpalrts::stack_type s;
  auto bench_pre = [=] {  };
  auto bench_body_interrupt = [&] (promotable* p) {
    s = tpalrts::snew();
    fib_interrupt(n, &r, s, p, nullptr, 0);
  };
  auto bench_body_software_polling = [&] (promotable* p) {
    s = tpalrts::snew();

  }; 
  auto bench_body_serial = [&] (promotable* p) {
    s = tpalrts::snew();
    r = fib_serial(n, s);
  };
  auto bench_post = [&]   {
    assert(r == fib_serial2(n));
  };
  using microbench_scheduler_type = mcsl::minimal_scheduler<stats, logging, mcsl::minimal_elastic, tpal_worker>;
  auto bench_body_manual = new fib_manual<microbench_scheduler_type>(n, &r);
  auto bench_body_cilk = [&] {
    r = fib_cilk(n);
  };
  launch(bench_pre, bench_body_interrupt, bench_body_software_polling, bench_body_serial,
         bench_post, bench_body_manual, bench_body_cilk);
}

} // end namespace

int main() {
  tpalrts::launch();
  return 0;
}
