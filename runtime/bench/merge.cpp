#define TPALRTS_USE_INTERRUPT_FLAGS 1

#include "benchmark.hpp"
#include "merge.hpp"

namespace tpalrts {
  
void launch() {
  rollforward_table = {
                       // later: fill
  };
  uint64_t n = deepsea::cmdline::parse_or_default_long("n", 20);
  int64_t software_polling_K = deepsea::cmdline::parse_or_default_int("software_polling_K", 128);
  uint64_t* xs = (uint64_t*)malloc(sizeof(uint64_t) * n);
  uint64_t* ys = (uint64_t*)malloc(sizeof(uint64_t) * n);
  uint64_t* tmp = (uint64_t*)malloc(sizeof(uint64_t) * 2 * n);
  tpalrts::stack_type s;
  auto bench_pre = [=] {
    uint64_t xs_i = 0;
    uint64_t ys_i = 1;
    for (std::size_t i = 0; i != n; i++) {
      xs[i] = xs_i;
      ys[i] = ys_i;
      xs_i += mcsl::hash(xs_i) % 1000;
      ys_i += mcsl::hash(ys_i) % 2000;
    }
  };
  auto bench_body_interrupt = [&] (promotable* p) {
    s = tpalrts::snew();
    merge_par(xs, ys, tmp, 0, n, 0, n, 0, p, s);
  };
  auto bench_body_software_polling = [&] (promotable* p) {
    s = tpalrts::snew();
    merge_par(xs, ys, tmp, 0, n, 0, n, 0, p, s, software_polling_K);
  }; 
  auto bench_body_serial = [&] (promotable* p) {
    s = tpalrts::snew();
    merge_seq(xs, ys, tmp, 0, n, 0, n, 0, compare);
  };
  auto bench_post = [&]   {
#ifndef NDEBUG
    uint64_t* tmp2 = (uint64_t*)malloc(sizeof(uint64_t) * 2 * n);
    merge_seq(xs, ys, tmp2, 0, n, 0, n, 0, compare);
    std::size_t nb_diffs = 0;
    for (std::size_t i = 0; i != (2*n); i++) {
      if (tmp[i] != tmp2[i]) {
        nb_diffs++;
      }
    }
    printf("nb_diffs %lu\n", nb_diffs);
    free(tmp2);
#endif
    free(xs);
    free(ys);
    free(tmp);
  };
  using microbench_scheduler_type = mcsl::minimal_scheduler<stats, logging, mcsl::minimal_elastic, tpal_worker>;
  auto bench_body_manual = new merge_manual<microbench_scheduler_type>();
  auto bench_body_cilk = [&] {
    merge_cilk(xs, ys, tmp, 0, n, 0, n, 0, compare);
  };
  launch(bench_pre, bench_body_interrupt, bench_body_software_polling, bench_body_serial,
         bench_post, bench_body_manual, bench_body_cilk);
}

} // end namespace

int main() {
  tpalrts::launch();
  return 0;
}
