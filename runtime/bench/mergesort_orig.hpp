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
#include <cstring>

extern volatile
int heartbeat;

#define likely(x)      __builtin_expect(!!(x), 1)
#define unlikely(x)    __builtin_expect(!!(x), 0)


using Item = uint64_t;

auto compare = std::less<Item>();

template<class InputIt, class OutputIt>
OutputIt stl_copy(InputIt first, InputIt last, OutputIt d_first) {
  while (first != last) {
    *d_first++ = *first++;
  }
  return d_first;
}

template<class InputIt1, class InputIt2,
         class OutputIt, class Compare>
OutputIt stl_merge(InputIt1 first1, InputIt1 last1,
               InputIt2 first2, InputIt2 last2,
               OutputIt d_first, Compare comp)
{
    for (; first1 != last1; ++d_first) {
        if (first2 == last2) {
            return stl_copy(first1, last1, d_first);
        }
        if (comp(*first2, *first1)) {
            *d_first = *first2;
            ++first2;
        } else {
            *d_first = *first1;
            ++first1;
        }
    }
    return stl_copy(first2, last2, d_first);
}

template<class ForwardIt, class T, class Compare>
ForwardIt stl_lower_bound(ForwardIt first, ForwardIt last, const T& value, Compare comp)
{
    ForwardIt it;
    typename std::iterator_traits<ForwardIt>::difference_type count, step;
    count = std::distance(first, last);
 
    while (count > 0) {
        it = first;
        step = count / 2;
        std::advance(it, step);
        if (comp(*it, value)) {
            first = ++it;
            count -= step + 1;
        }
        else
            count = step;
    }
    return first;
}

template<typename T>
  inline void copy_memory(T& a, const T &b) {
    std::memcpy(&a, &b, sizeof(T));
  }

 template<typename T>
  inline void move_uninitialized(T& a, const T b) {
    new (static_cast<void*>(std::addressof(a))) T(std::move(b));
  }

template <class E, class BinPred>
  void insertion_sort(E* A, size_t n, const BinPred& f) {
    for (size_t i=0; i < n; i++) {
      E v = std::move(A[i]); 
      E* B = A + i;
      while (--B >= A && f(v,*B)) copy_memory(*(B+1), *B);
      move_uninitialized(*(B+1), v);
    }
  }

template <class Item>
void copy(const Item* src, Item* dst,
          size_t lo_src, size_t hi_src, size_t lo_dst) {
  if ((hi_src - lo_src) > 0) {
    stl_copy(&src[lo_src], &src[hi_src-1]+1, &dst[lo_dst]);
  }
}

template <class Item, class Compare>
void merge_serial(const Item* xs, const Item* ys, Item* tmp,
               size_t lo_xs, size_t hi_xs,
               size_t lo_ys, size_t hi_ys,
               size_t lo_tmp,
               const Compare& compare) {
  stl_merge(&xs[lo_xs], &xs[hi_xs], &ys[lo_ys], &ys[hi_ys], &tmp[lo_tmp], compare);
}

template <class Item, class Compare>
size_t lower_bound(const Item* xs, size_t lo, size_t hi, const Item& val, const Compare& compare) {
  const Item* first_xs = &xs[0];
  return stl_lower_bound(first_xs + lo, first_xs + hi, val, compare) - first_xs;
}

static constexpr
int heartbeat_mergesort_thresh = 24;

static constexpr
int heartbeat_merge_thresh = 2000;

static constexpr
int cp_chunk = 2000;

using merge_args_type = struct merge_args_struct {
  Item* mg_xs; Item* mg_ys; Item* mg_tmp;
  size_t mg_lo_xs; size_t mg_hi_xs;
  size_t mg_lo_ys; size_t mg_hi_ys;
  size_t mg_lo_tmp;
};

using copy_args_type = std::pair<size_t, size_t>;

int mergesort_handler(
		      Item* ms_xs,
		      Item* ms_tmp,
		      size_t ms_lo,
		      size_t ms_hi,
		      size_t cp_lo,
		      size_t& cp_hi,
		      void* _p,
		      tpalrts::stack_type s, char*& sp, char*& prmhd, char*& prmtl,
		      void* __ms_entry,
		      void* __ms_retk,
		      void* __ms_joink,
		      void* __ms_clonek,
		      void* __ms_branch1,
		      void* __ms_branch2,
		      void* __ms_branch3,
  		      void* __mg_entry,
		      void* __mg_entry2,
		      void* __mg_branch1,
		      void* __mg_branch2,
		      void* __mg_retk,
		      void* __mg_joink,
		      void* __mg_clonek,
		      void* __cp_par,
		      void* __cp_joink,
		      void*& pc);

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
#include <cstring>

extern volatile
int heartbeat;

#define likely(x)      __builtin_expect(!!(x), 1)
#define unlikely(x)    __builtin_expect(!!(x), 0)


using Item = uint64_t;

auto compare = std::less<Item>();

template<class InputIt, class OutputIt>
OutputIt stl_copy(InputIt first, InputIt last, OutputIt d_first) {
  while (first != last) {
    *d_first++ = *first++;
  }
  return d_first;
}

template<class InputIt1, class InputIt2,
         class OutputIt, class Compare>
OutputIt stl_merge(InputIt1 first1, InputIt1 last1,
               InputIt2 first2, InputIt2 last2,
               OutputIt d_first, Compare comp)
{
    for (; first1 != last1; ++d_first) {
        if (first2 == last2) {
            return stl_copy(first1, last1, d_first);
        }
        if (comp(*first2, *first1)) {
            *d_first = *first2;
            ++first2;
        } else {
            *d_first = *first1;
            ++first1;
        }
    }
    return stl_copy(first2, last2, d_first);
}

template<class ForwardIt, class T, class Compare>
ForwardIt stl_lower_bound(ForwardIt first, ForwardIt last, const T& value, Compare comp)
{
    ForwardIt it;
    typename std::iterator_traits<ForwardIt>::difference_type count, step;
    count = std::distance(first, last);
 
    while (count > 0) {
        it = first;
        step = count / 2;
        std::advance(it, step);
        if (comp(*it, value)) {
            first = ++it;
            count -= step + 1;
        }
        else
            count = step;
    }
    return first;
}

template<typename T>
  inline void copy_memory(T& a, const T &b) {
    std::memcpy(&a, &b, sizeof(T));
  }

 template<typename T>
  inline void move_uninitialized(T& a, const T b) {
    new (static_cast<void*>(std::addressof(a))) T(std::move(b));
  }

template <class E, class BinPred>
  void insertion_sort(E* A, size_t n, const BinPred& f) {
    for (size_t i=0; i < n; i++) {
      E v = std::move(A[i]); 
      E* B = A + i;
      while (--B >= A && f(v,*B)) copy_memory(*(B+1), *B);
      move_uninitialized(*(B+1), v);
    }
  }

template <class Item>
void copy(const Item* src, Item* dst,
          size_t lo_src, size_t hi_src, size_t lo_dst) {
  if ((hi_src - lo_src) > 0) {
    stl_copy(&src[lo_src], &src[hi_src-1]+1, &dst[lo_dst]);
  }
}

template <class Item, class Compare>
void merge_serial(const Item* xs, const Item* ys, Item* tmp,
               size_t lo_xs, size_t hi_xs,
               size_t lo_ys, size_t hi_ys,
               size_t lo_tmp,
               const Compare& compare) {
  stl_merge(&xs[lo_xs], &xs[hi_xs], &ys[lo_ys], &ys[hi_ys], &tmp[lo_tmp], compare);
}

template <class Item, class Compare>
size_t lower_bound(const Item* xs, size_t lo, size_t hi, const Item& val, const Compare& compare) {
  const Item* first_xs = &xs[0];
  return stl_lower_bound(first_xs + lo, first_xs + hi, val, compare) - first_xs;
}

static constexpr
int heartbeat_mergesort_thresh = 24;

static constexpr
int heartbeat_merge_thresh = 2000;

static constexpr
int cp_chunk = 2000;

using merge_args_type = struct merge_args_struct {
  Item* mg_xs; Item* mg_ys; Item* mg_tmp;
  size_t mg_lo_xs; size_t mg_hi_xs;
  size_t mg_lo_ys; size_t mg_hi_ys;
  size_t mg_lo_tmp;
};

using copy_args_type = std::pair<size_t, size_t>;

int mergesort_handler(
		      Item* ms_xs,
		      Item* ms_tmp,
		      size_t ms_lo,
		      size_t ms_hi,
		      size_t cp_lo,
		      size_t& cp_hi,
		      void* _p,
		      tpalrts::stack_type s, char*& sp, char*& prmhd, char*& prmtl,
		      void* __ms_entry,
		      void* __ms_retk,
		      void* __ms_joink,
		      void* __ms_clonek,
		      void* __ms_branch1,
		      void* __ms_branch2,
		      void* __ms_branch3,
  		    void* __mg_entry,
		      void* __mg_entry2,
		      void* __mg_branch1,
		      void* __mg_branch2,
		      void* __mg_retk,
		      void* __mg_joink,
		      void* __mg_clonek,
		      void* __cp_par,
		      void* __cp_joink,
		      void*& pc);

void mergesort_interrupt(
                   Item* ms_xs,
                   Item* ms_tmp,
                   size_t ms_lo, size_t ms_hi,
                   void* p,
                   tpalrts::stack_type s,
                   void* pc = nullptr,
                   merge_args_type* merge_args = nullptr,
                   copy_args_type* copy_args = nullptr) {
  sunpack(s);

  size_t mid, n1, n2;

  Item* mg_xs; Item* mg_ys; Item* mg_tmp;
  size_t mg_lo_xs; size_t mg_hi_xs;
  size_t mg_lo_ys; size_t mg_hi_ys;
  size_t mg_lo_tmp;

  if (merge_args != nullptr) {
    mg_xs = merge_args->mg_xs; mg_ys = merge_args->mg_ys; mg_tmp = merge_args->mg_tmp;
    mg_lo_xs = merge_args->mg_lo_xs; mg_hi_xs = merge_args->mg_hi_xs;
    mg_lo_ys = merge_args->mg_lo_ys; mg_hi_ys = merge_args->mg_hi_ys;
    mg_lo_tmp = merge_args->mg_lo_tmp; 
  }

  size_t cp_lo = 0, cp_hi = 0;

  if (copy_args != nullptr) {
    cp_lo = copy_args->first;
    cp_hi = copy_args->second;
  }
    
  void* __ms_entry = &&ms_entry;
  void* __ms_retk = &&ms_retk;
  void* __ms_joink = &&ms_joink;
  void* __ms_clonek = &&ms_clonek;
  void* __ms_branch1 = &&ms_branch1;
  void* __ms_branch2 = &&ms_branch2;
  void* __ms_branch3 = &&ms_branch3;
  void* __ms_exitk = &&ms_exitk;
  
  void* __mg_entry = &&mg_entry;
  void* __mg_entry2 = &&mg_entry2;
  void* __mg_branch1 = &&mg_branch1;
  void* __mg_branch2 = &&mg_branch2;
  void* __mg_retk = &&mg_retk;
  void* __mg_joink = &&mg_joink;
  void* __mg_clonek = &&mg_clonek;
  void* __mg_exitk = &&mg_exitk;
  void* __mg_exitk2 = &&mg_exitk2;

  void* __cp_entry = &&cp_entry;
  void* __cp_par = &&cp_par;
  void* __cp_joink = &&cp_joink;

  pc = (pc == nullptr) ? __ms_entry : pc;

  goto *pc;

  // start parallel mergesort

 ms_entry:
  salloc(sp, 1);
  sstore(sp, 0, void*, __ms_exitk);

 ms_loop:
  if (unlikely(heartbeat)) {
    mergesort_handler(ms_xs, ms_tmp, ms_lo, ms_hi, cp_lo, cp_hi, p,
		      s, sp, prmhd, prmtl,
		      __ms_entry, __ms_retk, __ms_joink, __ms_clonek, __ms_branch1, __ms_branch2, __ms_branch3,
		      __mg_entry, __mg_entry2, __mg_branch1, __mg_branch2, __mg_retk, __mg_joink, __mg_clonek,
		      __cp_par, __cp_joink, pc);
  }
  auto ms_nb = ms_hi - ms_lo;
  if (ms_nb < heartbeat_mergesort_thresh) {
    insertion_sort(&ms_xs[ms_lo], ms_nb, compare);
    goto ms_retk;
  }
  mid = (ms_lo + ms_hi) / 2;
  salloc(sp, 8);
  sstore(sp, 0, void*, __ms_branch1);
  prmpush(sp, 1, prmtl, prmhd);
  sstore(sp, 3, Item*, ms_xs);
  sstore(sp, 4, Item*, ms_tmp);
  sstore(sp, 5, size_t, mid);
  sstore(sp, 6, size_t, ms_hi);
  sstore(sp, 7, size_t, ms_lo);
  ms_hi = mid;
  goto ms_loop;

 ms_branch1:
  sstore(sp, 0, void*, __ms_branch2);
  prmpop(sp, 1, prmtl, prmhd);
  ms_xs = sload(sp, 3, Item*);
  ms_tmp = sload(sp, 4, Item*);
  ms_lo = sload(sp, 5, size_t);
  ms_hi = sload(sp, 6, size_t);
  goto ms_loop;

 ms_branch2:
  sstore(sp, 0, void*, __ms_branch3);
  mg_xs = ms_xs;
  mg_ys = ms_xs;
  mg_tmp = ms_tmp;
  mg_lo_xs = sload(sp, 7, size_t);
  mg_hi_xs = sload(sp, 5, size_t);
  mg_lo_ys = mg_hi_xs;
  mg_hi_ys = sload(sp, 6, size_t);
  mg_lo_tmp = mg_lo_xs;
  goto mg_entry;

 ms_branch3:
  ms_xs = sload(sp, 3, Item*);
  ms_tmp = sload(sp, 4, Item*);
  ms_lo = sload(sp, 7, size_t);
  ms_hi = sload(sp, 6, size_t);
  cp_lo = ms_lo;
  cp_hi = ms_hi;
  goto cp_entry;

 ms_joink:
  sstore(sp, 0, void*, __ms_clonek);
  sfree(sp, 1);
  return;

 ms_clonek:
  salloc(sp, 1);
  sstore(sp, 0, void*, __ms_joink);
  goto ms_loop;

 ms_retk:
  goto *sload(sp, 0, void*);

 ms_exitk:
  sfree(sp, 1);
  sdelete(s);
  return;

  // start parallel copy

 cp_entry:
  if (unlikely(heartbeat)) {
    pc = __cp_entry;
    mergesort_handler(ms_xs, ms_tmp, ms_lo, ms_hi, cp_lo, cp_hi, p,
		      s, sp, prmhd, prmtl,
		      __ms_entry, __ms_retk, __ms_joink, __ms_clonek, __ms_branch1, __ms_branch2, __ms_branch3,
		      __mg_entry, __mg_entry2, __mg_branch1, __mg_branch2, __mg_retk, __mg_joink, __mg_clonek,
		      __cp_par, __cp_joink, pc);
    goto *pc;
  }
  if (cp_lo == cp_hi) {
    goto cp_joink;
  }
  {
    size_t cp_k = std::min(cp_hi, cp_lo + cp_chunk);
    stl_copy(&ms_tmp[cp_lo], &ms_tmp[cp_k], &ms_xs[cp_lo]);
    cp_lo = cp_k;
  }
  goto cp_entry;

 cp_par:
  if (unlikely(heartbeat)) {
    pc = __cp_par;
    mergesort_handler(ms_xs, ms_tmp, ms_lo, ms_hi, cp_lo, cp_hi, p,
		      s, sp, prmhd, prmtl,
		      __ms_entry, __ms_retk, __ms_joink, __ms_clonek, __ms_branch1, __ms_branch2, __ms_branch3,
		      __mg_entry, __mg_entry2, __mg_branch1, __mg_branch2, __mg_retk, __mg_joink, __mg_clonek,
		      __cp_par, __cp_joink, pc);
    goto *pc;
  } 
  if (cp_lo == cp_hi) {
    return;
  }
  {
    size_t cp_k = std::min(cp_hi, cp_lo + cp_chunk);
    stl_copy(&ms_tmp[cp_lo], &ms_tmp[cp_k], &ms_xs[cp_lo]);
    cp_lo = cp_k;
  }
  goto cp_par;  

 cp_joink:
  sfree(sp, 8);
  goto ms_retk;  
  
  // start parallel merge

 mg_entry:
  salloc(sp, 1);
  sstore(sp, 0, void*, __mg_exitk);
  
 mg_loop:
  n1 = mg_hi_xs - mg_lo_xs;
  n2 = mg_hi_ys - mg_lo_ys;
  if (n1 < n2) {
    std::swap(mg_xs, mg_ys);
    std::swap(mg_lo_xs, mg_lo_ys);
    std::swap(mg_hi_xs, mg_hi_ys);
    goto mg_loop;
  }
  if (unlikely(heartbeat)) {
    mergesort_handler(ms_xs, ms_tmp, ms_lo, ms_hi, cp_lo, cp_hi, p,
		      s, sp, prmhd, prmtl,
		      __ms_entry, __ms_retk, __ms_joink, __ms_clonek, __ms_branch1, __ms_branch2, __ms_branch3,
		      __mg_entry, __mg_entry2, __mg_branch1, __mg_branch2, __mg_retk, __mg_joink, __mg_clonek,
		      __cp_par, __cp_joink, pc);
  }  
  if (n1 == 0) {
    // mg_xs and mg_ys empty
    goto mg_retk;
  } else if (n1 == 1) {
    if (n2 == 0) {
      // mg_xs singleton; mg_ys empty
      mg_tmp[mg_lo_tmp] = mg_xs[mg_lo_xs];
    } else {
      // both singletons
      mg_tmp[mg_lo_tmp+0] = std::min(mg_xs[mg_lo_xs], mg_ys[mg_lo_ys], compare);
      mg_tmp[mg_lo_tmp+1] = std::max(mg_xs[mg_lo_xs], mg_ys[mg_lo_ys], compare);
    }
    goto mg_retk;
  } else if (n1 < heartbeat_merge_thresh) {
    merge_serial(mg_xs, mg_ys, mg_tmp, mg_lo_xs, mg_hi_xs, mg_lo_ys, mg_hi_ys, mg_lo_tmp, compare);
    goto mg_retk;
  } else {
    // select pivot positions
    size_t mid_xs = (mg_lo_xs + mg_hi_xs) / 2;
    size_t mid_ys = lower_bound(mg_ys, mg_lo_ys, mg_hi_ys, mg_xs[mid_xs], compare);
    // number of items to be treated by the first parallel call
    size_t k = (mid_xs - mg_lo_xs) + (mid_ys - mg_lo_ys);
    salloc(sp, 11);
    sstore(sp, 0, void*, __mg_branch1);
    prmpush(sp, 1, prmtl, prmhd);
    sstore(sp, 3, Item*, mg_xs);
    sstore(sp, 4, Item*, mg_ys);
    sstore(sp, 5, Item*, mg_tmp);
    sstore(sp, 6, size_t, mid_xs);
    sstore(sp, 7, size_t, mg_hi_xs);
    sstore(sp, 8, size_t, mid_ys);
    sstore(sp, 9, size_t, mg_hi_ys);
    sstore(sp, 10, size_t, (mg_lo_tmp + k));
    mg_hi_xs = mid_xs;
    mg_hi_ys = mid_ys;
    goto mg_loop;
  }

 mg_branch1:
  sstore(sp, 0, void*, __mg_branch2);
  prmpop(sp, 1, prmtl, prmhd);
  mg_xs = sload(sp, 3, Item*);
  mg_ys = sload(sp, 4, Item*);
  mg_tmp = sload(sp, 5, Item*);
  mg_lo_xs = sload(sp, 6, size_t);
  mg_hi_xs = sload(sp, 7, size_t);
  mg_lo_ys = sload(sp, 8, size_t);
  mg_hi_ys = sload(sp, 9, size_t);
  mg_lo_tmp = sload(sp, 10, size_t);
  goto mg_loop;

 mg_branch2:
  sfree(sp, 11);
  goto mg_retk;
  
 mg_retk:
  goto *sload(sp, 0, void*);

 mg_joink:
  sstore(sp, 0, void*, __mg_clonek);
  sfree(sp, 1);
  return;

 mg_clonek:
  salloc(sp, 1);
  sstore(sp, 0, void*, __mg_joink);
  goto mg_loop;

 mg_exitk:
  sfree(sp, 1);
  goto mg_retk;

 mg_entry2:
  salloc(sp, 1);
  sstore(sp, 0, void*, __mg_exitk2);
  goto mg_loop;

 mg_exitk2:
  sfree(sp, 1);
  return;

}
