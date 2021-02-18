#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <string>
#include <iostream>
#include <functional>
#include <vector>

/* ----------------------------------------- */
/* Binary tree data structure */

class node {
public:
  int value;
  node* left;
  node* right;

  node(int value)
    : value(value), left(nullptr), right(nullptr) { }
  node(int value, node* left, node* right)
    : value(value), left(left), right(right) { }
};

/* ----------------------------------------- */
/* Cilk program */

namespace cilk {

  auto sum(node* n) -> int {
    if (n == nullptr) {
      return 0;
    } else {
      auto s0 = /* spawn */ sum(n->left);
      auto s1 = /* spawn */ sum(n->right);
      /* sync; */
      return s0 + s1 + n->value;
    }
  }
  
} // end namespace

/* ----------------------------------------- */
/* Convert to continuation-passing style */

namespace cps {

  auto sum(node* n, std::function<void(int)> k) -> void {
    if (n == nullptr) {
      k(0);
    } else {
      sum(n->left, [&] (int s0) {
	sum(n->right, [&] (int s1) {
	  k(s0 + s1 + n->value);
	});
      });
    }
  }
  
} // end namespace

/* ----------------------------------------- */
/* Defunctionalize */

int answer = -1;

using kont_label = enum kont_enum {
  A1, A2, A3, A4, A5, nb_kont
};

class task;

class kont {
public:
  kont_label label;
  node* n;
  int s0;
  int* s;
  task* tjk;
  kont* k;

  kont(kont_label label, node* n, kont* k)
    : label(label), n(n), k(k) { }
  kont(kont_label label, int s0, node* n, kont* k)
    : label(label), s0(s0), n(n), k(k) { }
  kont(kont_label label, int* s, task* tjk)
    : label(label), s(s), tjk(tjk), k(nullptr) { }
  kont(kont_label label)
    : label(label), k(nullptr) { }
};

namespace defunc {

  auto apply(kont* k, int s) -> void;
  
  auto sum(node* n, kont* k) -> void {
    if (n == nullptr) {
      apply(k, 0);
    } else {
      sum(n->left, new kont(A1, n, k));
    }
  }

  auto apply(kont* k, int s) -> void {
    if (k->label == A1) {
      sum(k->n->right, new kont(A2, s, k->n, k->k));
    } else if (k->label == A2) {
      apply(k->k, k->s0 + s + k->n->value);
    } else if (k->label == A5) {
      answer = s;
    }
  }
  
} // end namespace

/* ----------------------------------------- */
/* Tail-call elimination of apply */

namespace tailcallelimapply {

  auto apply(kont* k, int s) -> void;
  
  auto sum(node* n, kont* k) -> void {
    if (n == nullptr) {
      apply(k, 0);
    } else {
      sum(n->left, new kont(A1, n, k));
    }
  }

  auto apply(kont* k, int s) -> void {
    while (true) {
      if (k->label == A1) {
	sum(k->n->right, new kont(A2, s, k->n, k->k));
	return;
      } else if (k->label == A2) {
	s = k->s0 + s + k->n->value;
	k = k->k;
      } else if (k->label == A5) {
	answer = s;
	return;
      }
    }
  }
  
} // end namespace

/* ----------------------------------------- */
/* Inline apply */

namespace inlineapply {
  
  auto sum(node* n, kont* k) -> void {
    if (n == nullptr) {
      int s = 0;
      while (true) {
	if (k->label == A1) {
	  sum(k->n->right, new kont(A2, s, k->n, k->k));
	  return;
	} else if (k->label == A2) {
	  s = k->s0 + s + k->n->value;
	  k = k->k;
	} else if (k->label == A5) {
	  answer = s;
	  return;
	}
      }
    } else {
      sum(n->left, new kont(A1, n, k));
    }
  }

} // end namespace

/* ----------------------------------------- */
/* Tail-call elimination of sum */

namespace tailcallelimsum {
  
  auto sum(node* n, kont* k) -> void {
    while (true) {
      if (n == nullptr) {
	int s = 0;
	while (true) {
	  if (k->label == A1) {
	    n = k->n->right;
	    k = new kont(A2, s, k->n, k->k);
	    break;
	  } else if (k->label == A2) {
	    s = k->s0 + s + k->n->value;
	    k = k->k;
	  } else if (k->label == A5) {
	    answer = s;
	    return;
	  }
	}
      } else {
	k = new kont(A1, n, k);
	n = n->left;
      }
    }
  }

} // end namespace

/* ----------------------------------------- */
/* Task scheduler */

class task {
public:
  int in;
  std::function<void()> body;

  task(std::function<void()> body)
    : body(body), in(1) { }
};

namespace scheduler {

  std::vector<task*> tasks;

  auto join(task* t) -> void {
    auto in = --t->in;
    if (in == 0) {
      tasks.push_back(t);
    }
  }

  auto release(task* t) -> void {
    join(t);
  }
  
  auto fork(task* t, task* k) -> void {
    k->in++;
    release(t);    
  }

  auto loop() -> void {
    while (! tasks.empty()) {
      auto t = tasks.back();
      tasks.pop_back();
      t->body();
    }
  }

  auto launch(task* t) -> void {
    release(t);
    loop();
  }
  
} // end namespace

/* ----------------------------------------- */
/* Task-parallel sum */

namespace taskpar {

  using namespace scheduler;

  auto sum(node* n, std::function<void(int)> k) -> void {
    if (n == nullptr) {
      k(0);
    } else {
      auto s = new int[2];
      auto tjk = new task([=] {	k(s[0] + s[1] + n->value); });
      fork(new task([=] { sum(n->right, [=] (int s0) { s[0] = s0; join(tjk); }); }), tjk);
      fork(new task([=] { sum(n->left,  [=] (int s1) { s[1] = s1; join(tjk); }); }), tjk);
      release(tjk);
    }
  }

} // end namespace

/* ----------------------------------------- */
/* Defunctionalized task-parallel sum */

namespace taskpardefunc {

  using namespace scheduler;

  auto apply(kont* k, int s) -> void;
  
  auto sum(node* n, kont* k) -> void {
    if (n == nullptr) {
      apply(k, 0);
    } else {
      auto s = new int[2];
      auto tjk = new task([=] {	apply(k, s[0] + s[1] + n->value); });
      fork(new task([=] { sum(n->right, new kont(A4, s, tjk)); }), tjk);
      fork(new task([=] { sum(n->left,  new kont(A3, s, tjk)); }), tjk);
      release(tjk);
    }
  }

  auto apply(kont* k, int s) -> void {
    if (k->label == A3) {
      k->s[0] = s;
      join(k->tjk);
    } else if (k->label == A4) {
      k->s[1] = s;
      join(k->tjk);
    } else if (k->label == A5) {
      answer = s;
    }
  }

} // end namespace

/* ----------------------------------------- */
/* Heartbeat task-parallel sum */

namespace heartbeat {

  using namespace scheduler;

  int counter = 0;

  constexpr
  int H = 3;

  auto heartbeat() -> bool {
    if (counter++ == H) {
      counter = 0;
      return true;
    }
    return false;
  }

  auto try_split(kont* k) -> std::pair<kont*,kont*> {
    if (k->label == A5) {
      return std::make_pair(nullptr, nullptr);
    }
    auto p = try_split(k);
    kont* k1, * k2;
    std::tie(k1, k2) = p;
    if (k1 != nullptr) {
      return (k2 == nullptr) ? std::make_pair(k1, k) : p;
    }
    if (k->label == A1) {
      return std::make_pair(k, nullptr);
    }
    return p;
  }

  auto sum(node* n, kont* k) -> void;

  auto try_promote(kont* k) -> kont*{
    kont* k1, * k2;
    std::tie(k1, k2) = try_split(k);
    if (k1 == nullptr) {
      return k;
    }
    auto n = k1->n;
    auto kj = k1->k;
    auto s = new int[2];
    auto tjk = new task([=] { sum(nullptr, new kont(A2, s[0] + s[1], n, kj)); });
    auto kr1 = new kont(A3, s, tjk);
    if (k2 != nullptr) {
      k1->k = kr1;
      kr1 = k1;
    }
    auto kr2 = new kont(A4, s, tjk);
    fork(new task([=] { sum(n, kr2); }), tjk);
    release(tjk);
    return kr1;
  }

  auto sum(node* n, kont* k) -> void {
    while (true) {
      if (heartbeat()) {
	k = try_promote(k);
      }
      if (n == nullptr) {
	int s = 0;
	while (true) {
	  if (k->label == A1) {
	    n = k->n->right;
	    k = new kont(A2, s, k->n, k->k);
	    break;
	  } else if (k->label == A2) {
	    s = k->s0 + s + k->n->value;
	    k = k->k;
	  } else if (k->label == A3) {
	    k->s[0] = s;
	    join(k->tjk);
	    return;
	  } else if (k->label == A4) {
	    k->s[1] = s;
	    join(k->tjk);
	    return;
	  } else if (k->label == A5) {
	    answer = s;
	    return;
	  }
	}
      } else {
	k = new kont(A1, n, k);
	n = n->left;
      }
    }
  }

} // end namespace

/* ----------------------------------------- */
/* Driver */

int main() {

  auto algos = std::vector<std::function<void(node*)>>(
    {
     [&] (node* n) { cps::sum(n, [&] (int s) { answer = s; }); },
     [&] (node* n) { defunc::sum(n, new kont(A5)); },
     [&] (node* n) { tailcallelimapply::sum(n, new kont(A5)); },
     [&] (node* n) { inlineapply::sum(n, new kont(A5)); },
     [&] (node* n) { tailcallelimsum::sum(n, new kont(A5)); },
     [&] (node* n) {
       scheduler::launch(new task([&] { taskpar::sum(n, [&] (int sf) { answer = sf; }); }));
     },
     [&] (node* n) {
       scheduler::launch(new task([&] { taskpardefunc::sum(n, new kont(A5)); }));
     }
    });

  auto ns = std::vector<node*>(
    {
      new node(1, new node(2), new node(3))
    });

  for (auto n : ns) {
    for (auto& a : algos) {
      answer = -1;
      a(n);
      if (cilk::sum(n) != answer) {
	std::cerr << "wrong answer: " << answer << std::endl;
	exit(0);
      }
    }
  }
  
  return 0;
}
