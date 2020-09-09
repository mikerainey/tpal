#pragma once

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

class stack_buffer_type {
public:
  char* stack = nullptr;
  ~stack_buffer_type() {
    if (stack != nullptr) {
      free(stack);
    }
  }
};

mcsl::perworker::array<stack_buffer_type> stack_buffers;

char* alloc_stack() {
  char* stack;
  stack_buffer_type& b = stack_buffers.mine();
  if (b.stack == nullptr) {
    stack = (char*)malloc(tpalrts::dflt_stack_szb);
  } else {
    stack = b.stack;
    b.stack = nullptr;
  }
  return stack;
}

void free_stack(char* stack) {
  stack_buffer_type& b = stack_buffers.mine();
  if (b.stack == nullptr) {
    b.stack = stack;
  } else {
    free(stack);
  }
}

stack_type snew() {
  char* stack = nullptr;
  char* sp = nullptr;
  char* prmhd = nullptr;
  char* prmtl = nullptr;
  return stack_type(stack, sp, prmhd, prmtl);
}

void sdelete(stack_type& s) {
  if (s.stack == nullptr) {
    return;
  }
  free_stack(s.stack);
  s.stack = nullptr;
}
  
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
  
