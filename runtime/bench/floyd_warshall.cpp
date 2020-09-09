#include "benchmark.hpp"
#include "floyd_warshall.hpp"

namespace tpalrts {
  
void launch() {
  rollforward_table = {
    #include "floyd_warshall_rollforward_map.hpp"
  };
  int vertices = deepsea::cmdline::parse_or_default_int("n", 128);
  int64_t software_polling_K = deepsea::cmdline::parse_or_default_int("software_polling_K", 128);
  int* dist = nullptr;
  tpalrts::stack_type s;
  auto init_input = [] (int vertices) {
    int* dist = (int*)malloc(sizeof(int) * vertices * vertices);
    for(int i = 0; i < vertices; i++) {
      for(int j = 0; j < vertices; j++) {
        SUB(dist, vertices, i, j) = ((i == j) ? 0 : INF);
      }
    }
    for (int i = 0 ; i < vertices ; i++) {
      for (int j = 0 ; j< vertices; j++) {
        if (i == j) {
          SUB(dist, vertices, i, j) = 0;
        } else {
          int num = i + j;
          if (num % 3 == 0) {
            SUB(dist, vertices, i, j) = num / 2;
	  } else if (num % 2 == 0) {
            SUB(dist, vertices, i, j) = num * 2;
	  } else {
            SUB(dist, vertices, i, j) = num;
	  }
        }
      }
    }
    return dist;
  };
  auto bench_pre = [&] {
    dist = init_input(vertices);
  };
  auto bench_body_interrupt = [&] (promotable* p) {
    floyd_warshall_interrupt(dist, vertices, 0, vertices, p);
  };
  auto bench_body_software_polling = [&] (promotable* p) {

  }; 
  auto bench_body_serial = [&] (promotable* p) {
    floyd_warshall_serial(dist, vertices);
  };
  auto bench_post = [&]   {
    bool check = deepsea::cmdline::parse_or_default_bool("check", false);
    if (check) {
      auto dist2 = init_input(vertices);
      floyd_warshall_serial(dist2, vertices);
      int nb_diffs = 0;
      for (int i = 0; i < vertices; i++) {
	for (int j = 0; j < vertices; j++) {
	  if (SUB(dist, vertices, i, j) != SUB(dist2, vertices, i, j)) {
	    nb_diffs++;
	  }
	}
      }
      printf("nb_diffs %d\n", nb_diffs);
      free(dist2);
    }
    free(dist);
  };
  using microbench_scheduler_type = mcsl::minimal_scheduler<stats, logging, mcsl::minimal_elastic, tpal_worker>;
  auto bench_body_manual = new tpalrts::terminal_fiber<microbench_scheduler_type>();
  auto bench_body_cilk = [&] {
    floyd_warshall_cilk(dist, vertices);
  };
  launch(bench_pre, bench_body_interrupt, bench_body_software_polling, bench_body_serial,
         bench_post, bench_body_manual, bench_body_cilk);
}

} // end namespace

int main() {
  tpalrts::launch();
  return 0;
}
