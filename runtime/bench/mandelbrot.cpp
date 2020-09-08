#include "benchmark.hpp"
#include "mandelbrot.hpp"

namespace tpalrts {
  
void launch() {
  rollforward_table = {
    #include "mandelbrot_rollforward_map.hpp"
  };
  uint64_t nb_items = deepsea::cmdline::parse_or_default_long("n", 20000000);
  unsigned char* output = nullptr;
  double x0 = -2.5;
  double y0 = -0.875;
  double x1 = 1;
  double y1 = 0.875;
  int height = 10240;
  // Width should be a multiple of 8
  int width = 20480;
  assert(width%8==0);
  int max_depth = 100;
  double g = 2.0;
  for (int i = 0; i < 100; i++) {
    g /= sin(g);
  }
  auto bench_pre = [=] {
    
  };
  auto bench_body_interrupt = [&] (promotable* p) {
    output = mandelbrot_interrupt(x0, y0, x1, y1, width, height, max_depth, p);
  };
  auto bench_body_software_polling = [=] (promotable* p) {

  };
  auto bench_body_serial = [&] (promotable* p) {
    output = mandelbrot_serial(x0, y0, x1, y1, width, height, max_depth);
  };
  auto bench_post = [=]   {
    _mm_free(output);
  };
  using microbench_scheduler_type = mcsl::minimal_scheduler<stats, logging, mcsl::minimal_elastic, tpal_worker>;
  auto bench_body_manual = new terminal_fiber<microbench_scheduler_type>;
  auto bench_body_cilk = [&] {
    output = mandelbrot_cilk(x0, y0, x1, y1, width, height, max_depth);
  };
  launch(bench_pre, bench_body_interrupt, bench_body_software_polling, bench_body_serial,
         bench_post, bench_body_manual, bench_body_cilk);
}

} // end namespace

int main() {
  tpalrts::launch();
  return 0;
}
