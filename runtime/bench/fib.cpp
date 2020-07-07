#include "benchmark.hpp"
#include "fib.hpp"

namespace tpalrts {
  
void launch() {
  rollforward_table = {
                       // later: fill
  };
  uint64_t n = deepsea::cmdline::parse_or_default_long("n", 20);
  uint64_t r = 0;
  auto bench_pre = [=] {  };
  auto bench_body_interrupt = [=] (promotable* p) {
                                // later: fill
  };
  tpalrts::stack_type s;
  auto bench_body_software_polling = [&] (promotable* p) {
    s = tpalrts::snew();
    fib_software_polling_loop(n, &r, p, 128, s, fib_software_polling_entry, 0);
  }; 
  auto bench_body_serial = [&] (promotable* p) {
    r = fib_serial(n);
  };
  auto bench_post = [&]   {
    if (s.stack != nullptr) {
      sdelete(s);
    }
    assert(r == fib_serial(n));
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
