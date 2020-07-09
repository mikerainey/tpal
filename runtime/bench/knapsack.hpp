#pragma once

#ifdef USE_CILK_PLUS
#include <cilk/cilk.h>
#include <cilk/cilk_api.h>
#include <cilk/reducer_opadd.h>
#endif
#include <cstdint>
#include <assert.h>

#include "mcsl_util.hpp"

#include "tpalrts_fiber.hpp"
#include "tpalrts_stack.hpp"

/* every item in the knapsack has a weight and a value */
#define MAX_ITEMS 256

struct item {
  int value;
  int weight;
};

volatile
int best_so_far = INT_MIN;

int compare(struct item *a, struct item *b)
{
     double c = ((double) a->value / a->weight) -
     ((double) b->value / b->weight);

     if (c > 0)
	  return -1;
     if (c < 0)
	  return 1;
     return 0;
}

/*---------------------------------------------------------------------*/
/* Manual version */

int knapsack_serial(struct item *e, int c, int n, int v) {
  int best;
   /* base case: full knapsack or no items */
   if (c < 0) {
     return INT_MIN;
   }
   if (n == 0 || c == 0) {
     return v;		/* feasible solution, with value v */
   }

   double ub = (double) v + c * e->value / e->weight;

   if (ub < best_so_far) {
     /* prune ! */
     return INT_MIN;
   }
   /* 
    * compute the best solution without the current item in the knapsack 
    */
   int without = knapsack_serial(e + 1, c, n - 1, v);

   /* compute the best solution with the current item in the knapsack */
   int with = knapsack_serial(e + 1, c - e->weight, n - 1, v + e->value);

   best = with > without ? with : without;

   /* 
    * notice the race condition here. The program is still
    * correct, in the sense that the best solution so far
    * is at least best_so_far. Moreover best_so_far gets updated
    * when returning, so eventually it should get the right
    * value. The program is highly non-deterministic.
    */
   if (best > best_so_far) {
     best_so_far = best;
   }
     
     return best;
}


template <typename Scheduler>
class knapsack_manual : public tpalrts::fiber<Scheduler> {
public:

  using trampoline_type = enum { entry, exit };

  trampoline_type trampoline = entry;

  knapsack_manual()
    : tpalrts::fiber<Scheduler>([] (tpalrts::promotable*) { return mcsl::fiber_status_finish; }) { }

  mcsl::fiber_status_type run() {
    return mcsl::fiber_status_finish;
  }

};

/*---------------------------------------------------------------------*/
/* Cilk version */

using pair_ints_type = std::pair<int,int>;

int knapsack_custom_stack_serial(struct item *e, int c, int n, int v, tpalrts::stack_type s) {
  char* stack = s.stack;
  char* sp = s.sp;
  char* prmhd = s.prmhd;
  char* prmtl = s.prmtl;
  int best = 0;
  double ub;

 entry:
  salloc(sp, 1);
  sstore(sp, 0, void*, &&exitk);
  
 loop:
  if (c < 0) {
    best = INT_MIN;
    goto retk;
  }
  if ((n == 0) || (c == 0)) {
    best = v;
    goto retk;
  }
  ub = (double) v + c * e->value / e->weight;
  if (ub < best_so_far) {
    best = INT_MIN;
    goto retk;
  }
  salloc(sp, 4);
  sstore(sp, 0, void*, &&branch1);
  sstore(sp, 1, struct item*, e + 1);
  {
    auto p = std::make_pair(c - e->weight, n - 1);
    sstore(sp, 2, pair_ints_type, p);
  }
  sstore(sp, 3, int, v + e->value);
  e++;
  n--;
  goto loop;

 branch1:
  e = sload(sp, 1, struct item*);
  std::tie(c, n) = sload(sp, 2, pair_ints_type);
  v = sload(sp, 3, int);
  sstore(sp, 0, void*, &&branch2);
  sstore(sp, 1, int, best); 
  goto loop;

 branch2:
  {
    auto with = best;
    auto without = sload(sp, 1, int);
    best = with > without ? with : without;
  }
  if (best > best_so_far) {
    best_so_far = best;
  }
  sfree(sp, 4);
  goto retk;
  
 retk:
  goto *sload(sp, 0, void*);
  
 exitk:
  sfree(sp, 1);
  return best;
  
}

int knapsack_cilk(struct item *e, int c, int n, int v) {
  int best;
#if defined(USE_CILK_PLUS)

   /* base case: full knapsack or no items */
   if (c < 0) {
     return INT_MIN;
   }
   if (n == 0 || c == 0) {
     return v;		/* feasible solution, with value v */
   }

   double ub = (double) v + c * e->value / e->weight;

   if (ub < best_so_far) {
     /* prune ! */
     return INT_MIN;
   }
   /* 
    * compute the best solution without the current item in the knapsack 
    */
   int without = cilk_spawn knapsack_cilk(e + 1, c, n - 1, v);

   /* compute the best solution with the current item in the knapsack */
   int with = knapsack_cilk(e + 1, c - e->weight, n - 1, v + e->value);

   cilk_sync;

   best = with > without ? with : without;

   /* 
    * notice the race condition here. The program is still
    * correct, in the sense that the best solution so far
    * is at least best_so_far. Moreover best_so_far gets updated
    * when returning, so eventually it should get the right
    * value. The program is highly non-deterministic.
    */
   if (best > best_so_far) {
     best_so_far = best;
   }

#endif
     
     return best;
}
