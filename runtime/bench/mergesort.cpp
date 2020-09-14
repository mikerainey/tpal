#include "benchmark.hpp"
#include "mergesort.hpp"

namespace tpalrts {
  
void launch() {
  rollforward_table = {
    #include "mergesort_rollforward_map.hpp"
  };
  uint64_t n = deepsea::cmdline::parse_or_default_long("n", 20);
  int64_t software_polling_K = deepsea::cmdline::parse_or_default_int("software_polling_K", 128);
  uint64_t* xs = (uint64_t*)malloc(sizeof(uint64_t) * n);
  uint64_t* tmp = (uint64_t*)malloc(sizeof(uint64_t) * n);
  auto compare = std::less<uint64_t>();
  tpalrts::stack_type s;
  auto fill_xs = [&] (uint64_t* _xs) {
    uint64_t xs_i = 0;
    for (std::size_t i = 0; i != n; i++) {
      _xs[i] = xs_i;
      xs_i = mcsl::hash(xs_i) % 1000;
    }
  };
  auto bench_pre = [=] {
    fill_xs(xs);
  };
  auto bench_body_interrupt = [&] (promotable* p) {
    s = tpalrts::snew();
    mergesort_interrupt(xs, tmp, 0, n, p, s, nullptr, nullptr, nullptr);
  };
  auto bench_body_software_polling = [&] (promotable* p) {

  }; 
  auto bench_body_serial = [&] (promotable* p) {
    s = tpalrts::snew();

  };
  auto bench_post = [&]   {
#ifndef NDEBUG
    uint64_t* xs2 = (uint64_t*)malloc(sizeof(uint64_t) * n);
    fill_xs(xs2);
    std::sort(&xs2[0], &xs2[n], compare);
    std::size_t nb_diffs = 0;
    for (std::size_t i = 0; i != n; i++) {
      if (xs[i] != xs2[i]) {
        nb_diffs++;
      }
    }
    printf("nb_diffs %lu\n", nb_diffs);
    free(xs2);
#endif
    free(xs);
    free(tmp);
  };
  using microbench_scheduler_type = mcsl::minimal_scheduler<stats, logging, mcsl::minimal_elastic, tpal_worker>;
  auto bench_body_manual = new tpalrts::terminal_fiber<microbench_scheduler_type>();
  auto bench_body_cilk = [&] {
    mergesort_cilk(xs, tmp, 0, n, compare);
  };
  launch(bench_pre, bench_body_interrupt, bench_body_software_polling, bench_body_serial,
         bench_post, bench_body_manual, bench_body_cilk);
}

} // end namespace

int main() {
  tpalrts::launch();
  return 0;
}
