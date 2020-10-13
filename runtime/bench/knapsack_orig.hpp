namespace tpalrts {

using word_type = void*;

using stack_type = struct stack_struct {
public:
  stack_struct(char* stack=nullptr, char* sp=nullptr, char* prmhd=nullptr, char* prmtl=nullptr)
    : stack(stack), sp(sp), prmhd(prmhd), prmtl(prmtl) { }
  char* stack;
  char* sp;
  char* prmhd;
  char* prmtl;
};

const
int dflt_stack_szb = 1 << 13;

extern
char* alloc_stack();

extern
void free_stack(char* stack);
  
extern
void sdelete(stack_type& s);

} // end namespace

#define sunpack(s) \
  if (s.stack == nullptr) { \
    s.stack = tpalrts::alloc_stack();             \
    s.sp = &s.stack[tpalrts::dflt_stack_szb - 1]; \
  } \
  char* stack = s.stack; \
  char* sp = s.sp; \
  char* prmhd = s.prmhd; \
  char* prmtl = s.prmtl; 

#define sallocb(sp, szb) \
  sp -= szb;

#define sfreeb(sp, szb) \
  sp += szb;


#define salloc(sp, nb) \
  sallocb(sp, (nb) * sizeof(tpalrts::word_type));

#define sfree(sp, nb) \
  sfreeb(sp, (nb) * sizeof(tpalrts::word_type));


#define saddrb(sp, offb) \
  ((char*)sp + (offb))

#define sstoreb(sp, offb, ty, v) \
  *((ty*)saddrb(sp, offb)) = v;

#define sloadb(sp, offb, ty) \
  *((ty*)saddrb(sp, offb))


#define saddr(sp, off) \
  saddrb(sp, (off) * sizeof(tpalrts::word_type))

#define sstore(sp, off, ty, v) \
  sstoreb(sp, (off) * sizeof(tpalrts::word_type), ty, v);

#define sload(sp, off, ty) \
  sloadb(sp, (off) * sizeof(tpalrts::word_type), ty)

#define sstorelabel(sp, off, lab) \
  sstore(sp, off, void*, lab)

#define sloadlabel(sp, off) \
  *sload(sp, off, void*)


#define prmhdoff 0
#define prmtloff 1


#define prmpush(sp, off, prmtl, prmhd) \
  {char* __m = saddr(sp, (off) + prmhdoff); \
  sstore(sp, (off) + prmhdoff, char*, prmtl);  \
  sstore(sp, (off) + prmtloff, char*, nullptr); \
  if (prmtl != nullptr) { \
    sstore(prmtl, prmtloff, char*, __m); \
  } \
  prmtl = __m; \
  if (prmhd == nullptr) { \
    prmhd = prmtl; \
  }}

#define prmpop(sp, off, prmtl, prmhd) \
  {char* __p = (char*)sload(prmtl, prmhdoff, void*); \
  if (__p == nullptr) { \
    prmhd = nullptr; \
  } else { \
    sstore(__p, prmtloff, char*, nullptr); \
    sstore(prmtl, prmhdoff, char*, nullptr); \
  } \
  prmtl = __p;}

#define prmpophd(prmtl, prmhd) \
  {char* __p = (char*)sload(prmhd, prmtloff, void*); \
  if (__p == nullptr) { \
    prmtl = nullptr; \
  } else { \
    sstore(__p, prmhdoff, char*, nullptr); \
    sstore(prmhd, prmtloff, char*, nullptr); \
  } \
  prmhd = __p;}

#define prmempty(prmtl, prmhd) \
  (prmtl == nullptr)

#define prmsplit(sp, prmtl, prmhd, sp_cont, top) \
  sp_cont = (char*)saddr(prmhd, prmtloff + 1); \
  top = (uint64_t)(prmhd - sp - sizeof(tpalrts::word_type)); \
  prmpophd(prmtl, prmhd);
  
extern volatile
int heartbeat;

#include <atomic>
#include <assert.h>
#include <algorithm>
#include <climits>

struct item {
  int value;
  int weight;
};

using pair_ints_type = std::pair<int,int>;

int knapsack_serial(int& best_so_far, struct item *e, int c, int n, int v, tpalrts::stack_type s) {
  sunpack(s);
  
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
  sstorelabel(sp, 0, &&branch1);
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
  sstorelabel(sp, 0, &&branch2);
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
  goto sloadlabel(sp, 0);
  
 exitk:
  sfree(sp, 1);
  return best;
  
}

#define unlikely(x)    __builtin_expect(!!(x), 0)

static inline
void update_best_so_far(std::atomic<int>& best_so_far, int val) {
  int curr = best_so_far.load(std::memory_order_relaxed);

  while (val > curr) {
    bool b = best_so_far.compare_exchange_weak(curr, val, std::memory_order_relaxed, std::memory_order_relaxed);
  }
}

extern
void* sanitize_label(void*);

extern
void* __entry;
extern
void* __exitk;
extern
void* __retk;
extern
void* __joink;
extern
void* __clonek;
extern
void* __branch1;
extern
void* __branch2;

extern
int knapsack_handler(std::atomic<int>& best_so_far, struct item *e, int c, int n, int v, int*& dst,
		     tpalrts::stack_type s, char*& sp, char*& prmhd, char*& prmtl,
		     void* pc, int best, void* _p);

void knapsack_interrupt(std::atomic<int>& best_so_far, struct item *e, int c, int n, int v, int* dst,
                        void* p, tpalrts::stack_type s, void* pc, int best) {
  sunpack(s);
  
  double ub;

  if (__entry == nullptr) {
    __entry = sanitize_label(&&entry);
    __exitk = sanitize_label(&&exitk);
    __retk = sanitize_label(&&retk);
    __joink = sanitize_label(&&joink);
    __clonek = sanitize_label(&&clonek);
    __branch1 = sanitize_label(&&branch1);
    __branch2 = sanitize_label(&&branch2);
  }
  assert(__entry != nullptr);
							     
  pc = (pc == nullptr) ? __entry : pc;
  
  goto *pc;
  
 entry:
  salloc(sp, 1);
  sstore(sp, 0, void*, __exitk);
  
 loop:
  if (unlikely(heartbeat)) {
    knapsack_handler(best_so_far, e, c, n, v, dst, s, sp, prmhd, prmtl, pc, best, p);
  }
  if (c < 0) {
    best = INT_MIN;
    goto retk;
  }
  if ((n == 0) || (c == 0)) {
    best = v;
    goto retk;
  }
  ub = (double) v + c * e->value / e->weight;
  if (ub < best_so_far.load(std::memory_order_relaxed)) {
    best = INT_MIN;
    goto retk;
  }
  salloc(sp, 6);
  sstorelabel(sp, 0, __branch1);
  prmpush(sp, 1, prmtl, prmhd);
  sstore(sp, 3, struct item*, e + 1);
  sstore(sp, 4, pair_ints_type, std::make_pair(c - e->weight, n - 1));
  sstore(sp, 5, int, v + e->value);
  e++;
  n--;
  goto loop;

 branch1:
  e = sload(sp, 3, struct item*);
  std::tie(c, n) = sload(sp, 4, pair_ints_type);
  v = sload(sp, 5, int);
  sstorelabel(sp, 0, __branch2);
  sstore(sp, 3, int, best);
  prmpop(sp, 1, prmtl, prmhd);
  goto loop;

 branch2:
  {
    auto with = best;
    auto without = sload(sp, 3, int);
    best = with > without ? with : without;
  }
  if (best > best_so_far.load(std::memory_order_relaxed)) {
    update_best_so_far(best_so_far, v);
  }
  sfree(sp, 6);
  goto retk;
  
 retk:
  goto sloadlabel(sp, 0);

 joink:
  sstorelabel(sp, 0, __clonek);
  sfree(sp, 1);
  *dst = best;
  return;

 clonek:
  salloc(sp, 1);
  sstorelabel(sp, 0, __joink);
  goto loop;

 exitk:
  sfree(sp, 1);
  *dst = best;
  sdelete(s);

}
