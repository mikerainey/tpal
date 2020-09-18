#include "benchmark.hpp"
#include "kmeans.hpp"

namespace tpalrts {
  
void launch() {
  rollforward_table = {
    #include "kmeans_rollforward_map.hpp"
  };
  int numObjects = deepsea::cmdline::parse_or_default_int("n", 1000);
  auto in = kmeans_inputgen(numObjects);
  float** attributes = in.attributes;
  int numAttributes = in.nFeat;
  int nclusters=5;
  float   threshold = 0.001;
  float **cluster_centres=NULL;
  auto bench_pre = [=] {
  };
  auto bench_body_interrupt = [&] (promotable* p) {
    cluster_interrupt(numObjects, numAttributes, attributes, nclusters, threshold, &cluster_centres, p);
  };
  auto bench_body_software_polling = [=] (promotable* p) {

  };
  auto bench_body_serial = [&] (promotable* p) {
    cluster_serial(numObjects, numAttributes, attributes, nclusters, threshold, &cluster_centres);
  };
  auto bench_post = [=]   {
  };
  using microbench_scheduler_type = mcsl::minimal_scheduler<stats, logging, mcsl::minimal_elastic, tpal_worker>;
  auto bench_body_manual = new tpalrts::terminal_fiber<microbench_scheduler_type>();
  auto bench_body_cilk = [&] {
    cluster_cilk(numObjects, numAttributes, attributes, nclusters, threshold, &cluster_centres);
  };
  launch(bench_pre, bench_body_interrupt, bench_body_software_polling, bench_body_serial,
         bench_post, bench_body_manual, bench_body_cilk);
}

} // end namespace

int main() {
  tpalrts::launch();
  return 0;
}
