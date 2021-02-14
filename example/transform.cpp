#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <string>
#include <iostream>
#include <functional>
#include <vector>

/* ----------------------------------------- */
/* Type declaration of trees */

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

namespace original {

  int sum(node* n) {
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

  void sum(node* n, std::function<void(int)> k) {
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

using kont_label = enum kont_enum {
  A1, A2, A3, A4, A5, nb_kont
};

class kont {
public:
  kont_label label;
  node* n;
  int s0;
  kont* k;

  kont(kont_label label, node* n, kont* k)
    : label(label), n(n), k(k) { }
  kont(kont_label label, int s0, node* n, kont* k)
    : label(label), s0(s0), n(n), k(k) { }
  kont(kont_label label)
    : label(label), k(nullptr) { }
};

namespace defunc {

  void apply(kont* k, int s);
  
  void sum(node* n, kont* k) {
    if (n == nullptr) {
      apply(k, 0);
    } else {
      sum(n->left, new kont(A1, n, k));
    }
  }

  void apply(kont* k, int s) {
    if (k->label == A1) {
      sum(k->n->right, new kont(A2, s, k->n, k->k));
    } else if (k->label == A2) {
      apply(k->k, k->s0 + s + k->n->value);
    } else if (k->label == A5) {
      std::cout << "defunc::sum(n0) = " << s << std::endl;
    }
  }
  
} // end namespace

/* ----------------------------------------- */
/* Tail-call elimination of apply */

namespace tailcallelimapply {

  void apply(kont* k, int s);
  
  void sum(node* n, kont* k) {
    if (n == nullptr) {
      apply(k, 0);
    } else {
      sum(n->left, new kont(A1, n, k));
    }
  }

  void apply(kont* k, int s) {
    while (true) {
      if (k->label == A1) {
	sum(k->n->right, new kont(A2, s, k->n, k->k));
	return;
      } else if (k->label == A2) {
	s = k->s0 + s + k->n->value;
	k = k->k;
      } else if (k->label == A5) {
	std::cout << "tailcallelimapply::sum(n0) = " << s << std::endl;
	return;
      }
    }
  }
  
} // end namespace

/* ----------------------------------------- */
/* Inline apply */

namespace inlineapply {
  
  void sum(node* n, kont* k) {
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
	  std::cout << "inlineapply::sum(n0) = " << s << std::endl;
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
  
  void sum(node* n, kont* k) {
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
	    std::cout << "tailcallelimsum::sum(n0) = " << s << std::endl;
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

namespace scheduler {

  class task {
  public:
    int in;
    std::function<void()> body;

    task(std::function<void()> body)
      : body(body), in(1) { }
  };

  std::vector<task*> tasks;

  void join(task* t) {
    auto in = --t->in;
    if (in == 0) {
      tasks.push_back(t);
    }
  }

  void release(task* t) {
    join(t);
  }
  
  void fork(task* t, task* k) {
    k->in++;
    release(t);    
  }

  void loop() {
    while (! tasks.empty()) {
      auto t = tasks.back();
      tasks.pop_back();
      t->body();
    }
  }
  
} // end namespace

/* ----------------------------------------- */

namespace taskpar {

  using namespace scheduler;

  void sum(node* n, int* dst, std::function<void()> k) {
    if (n == nullptr) {
      *dst = 0;
      k();
    } else {
      auto s = new int[2];
      auto tjk = new task([=] {
	*dst = s[0] + s[1] + n->value;
	k();
      });
      fork(new task([=] { sum(n->right, &s[1], [=] { join(tjk); }); }), tjk);
      fork(new task([=] { sum(n->left, &s[0], [=] { join(tjk); }); }), tjk);
      release(tjk);
    }
  }

} // end namespace

/* ----------------------------------------- */

namespace heartbeat {

  using namespace scheduler;

  int counter = 0;

  constexpr
  int H = 128;

  bool tick() {
    if (counter++ == H) {
      counter = 0;
      return true;
    }
    return false;
  }

  kont* try_promote(kont* k) {
    auto k0 = k;
    while (true) {
      if (k->label == A1) {

      } else if (k->label == A5) {
	k = k0;
	break;
      }
      k = k->k;
    }
    return k;
  }

  void sum(node* n, kont* k) {
    while (true) {
      if (tick()) {
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
	  } else if (k->label == A5) {
	    std::cout << "heartbeat::sum(n0) = " << s << std::endl;
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

int main() {
  auto n0 = new node(1, new node(2), new node(3));
  std::cout << "original::sum(n0) = " << original::sum(n0) << std::endl;
  cps::sum(n0, [&] (int v) {
    std::cout << "cps::sum(n0) = " << v << std::endl;
  });
  defunc::sum(n0, new kont(A5));
  tailcallelimapply::sum(n0, new kont(A5));
  inlineapply::sum(n0, new kont(A5));
  tailcallelimsum::sum(n0, new kont(A5));
  int s = 0;
  auto tk = new scheduler::task([&] { std::cout << "taskpar::sum(n0) = " << s << std::endl; });
  scheduler::fork(new scheduler::task([&] { taskpar::sum(n0, &s, [=] { scheduler::join(tk); }); }), tk);
  scheduler::release(tk);
  scheduler::loop();
  return 0;
}
