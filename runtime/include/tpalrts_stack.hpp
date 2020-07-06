#pragma once

namespace tpalrts {

using word_type = void*;

using stack_type = struct stack_struct {
public:
  stack_struct(char* stack, char* sp, char* prmhd, char* prmtl)
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
  char* prmhd = NULL;
  char* prmtl = NULL;
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
  {if (prmtl == NULL) { \
    sstore(sp, (off) + prmhdoff, char*, NULL); \
    prmtl = prmhd = saddr(sp, (off) + prmhdoff); \
  } else { \
    sstore(sp, (off) + prmhdoff, char*, prmtl); \
    sstore(prmtl, prmtloff, char*, saddr(sp, (off) + prmhdoff)); \
    prmtl = saddr(sp, (off) + prmhdoff); \
  } \
  sstore(sp, (off) + prmtloff, char*, NULL);}

#define prmpop(sp, off, prmtl, prmhd) \
  {if (prmtl == prmhd) { \
    prmtl = prmhd = NULL; \
  } else { \
    prmtl = (char*)sload(sp, (off) + prmhdoff, void*); \
  } \
  sstore(sp, (off) + prmhdoff, char*, NULL);   \
  sstore(sp, (off) + prmtloff, char*, NULL);}

#define prmpophd(prmtl, prmhd) \
  {char* __hd = prmhd; \
  if (prmtl == prmhd) { \
    prmtl = prmhd = NULL; \
  } else { \
    prmhd = (char*)sload(prmhd, prmtloff, void*); \
  } \
  sstore(__hd, prmhdoff, char*, NULL); \
  sstore(__hd, prmtloff, char*, NULL);}


#define prmempty(prmtl, prmhd) \
  (prmtl == NULL)

#define prmsplit(sp, prmtl, prmhd, sp_cont, top) \
  sp_cont = (char*)saddr(prmhd, 1); \
  top = (uint64_t)(prmhd - sp - sizeof(tpalrts::word_type)); \
  prmpophd(prmtl, prmhd);
  
