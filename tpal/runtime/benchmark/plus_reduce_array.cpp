#include "benchmark.hpp"
#include "plus_reduce_array.hpp"

namespace tpalrts {

using namespace plus_reduce_array;
  
void launch() {
  plus_reduce_array::nb_items = deepsea::cmdline::parse_or_default_long("n", plus_reduce_array::nb_items);
  launch(bench_pre, bench_body_heartbeat, bench_body_serial, bench_post, bench_body_cilk);
}

} // end namespace

int main() {
  tpalrts::launch();
  return 0;
}

