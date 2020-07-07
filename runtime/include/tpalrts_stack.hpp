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
int dflt_stack_szb = 1 << 20;

static inline
stack_type snew(int stack_szb=dflt_stack_szb) {
  char* stack = (char*)malloc(stack_szb);
  char* sp = &stack[stack_szb - 1];
  char* prmhd = nullptr;
  char* prmtl = nullptr;
  return stack_type(stack, sp, prmhd, prmtl);
}

static inline
void sdelete(stack_type s) {
  free(s.stack);
}
  
} // end namespace

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
  
