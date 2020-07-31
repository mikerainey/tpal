#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <string.h>

#define TPALRTS_USE_INTERRUPT_FLAGS 1

#include "benchmark.hpp"
#include "knapsack.hpp"
#include "knapsack_input.hpp"

#define MAX_ITEMS 256

int read_input(const char *filename, struct item *items, int *capacity, int *n)
{
     int i;
     FILE *f;

     if (filename == NULL) filename = "\0";
     f = fopen(filename, "r");
     if (f == NULL)
     {
       fprintf(stderr, "open_input(\"%s\") failed\n", filename);
       exit(1);
     }
     /* format of the input: #items capacity value1 weight1 ... */
     int err1 = fscanf(f, "%d", n);
     int err2 = fscanf(f, "%d", capacity);

     for (i = 0; i < *n; ++i)
     {
       int err3 = fscanf(f, "%d %d", &items[i].value, &items[i].weight);
     }

     fclose(f);

     /* sort the items on decreasing order of value/weight */
     /* cilk2c is fascist in dealing with pointers, whence the ugly cast */
     qsort(items, *n, sizeof(struct item), (int (*)(const void *, const void *)) compare);
     return 0;
}

void print_input(struct item* items, int capacity, int n) {
  printf("int capacity = %d;\n", capacity);
  printf("int n = %d;\n", n);
  for (int i = 0; i < n; i++) {
    printf("items[%d].value = %d;\n", i, items[i].value);
    printf("items[%d].weight = %d;\n", i, items[i].weight);
  }
}

namespace tpalrts {
  
void launch() {
  rollforward_table = {
                       // later: fill
  };
  int n, capacity;
  int sol = INT_MIN;
  tpalrts::stack_type s;
  std::string inputfile = deepsea::cmdline::parse_or_default_string("infile", "");
  struct item items[MAX_ITEMS];
  auto bench_pre = [&] {
    if (inputfile != "") {
      read_input(inputfile.c_str(), items, &capacity, &n);
    } else {
      n = knapsack_n;
      capacity = knapsack_capacity;
      knapsack_init(items);
    }
    //    print_input(items, capacity, n);
  };
  auto bench_body_interrupt = [&] (promotable* p) {
    s = tpalrts::snew();
    knapsack_heartbeat<knapsack_heartbeat_mechanism_hardware_interrupt>(items, capacity, n, 0, &sol, p, s);
  };
  auto bench_body_software_polling = [&] (promotable* p) {
    s = tpalrts::snew();
    knapsack_heartbeat<knapsack_heartbeat_mechanism_software_polling>(items, capacity, n, 0, &sol, p, s);
  }; 
  auto bench_body_serial = [&] (promotable* p) {
                             knapsack_seq(items, capacity, n, 0, &sol);
			     //    s = tpalrts::snew();
			     //    sol = knapsack_custom_stack_serial(items, capacity, n, 0, s);
  };
  auto bench_post = [&]   {
                      //    best_so_far = INT_MIN;
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
