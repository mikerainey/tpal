uint64_t fib_serial(uint64_t n, tpalrts::stack_type s) {
  sunpack(s);
  
  uint64_t f = 0;

 entry:
  salloc(sp, 1);
  sstore(sp, 0, void*, &&exitk);

 loop:
  f = n;
  if (n < 2) {
    goto retk;
  }
  f = 0;
  salloc(sp, 2);
  sstore(sp, 0, void*, &&branch1);
  sstore(sp, 1, uint64_t, n - 2);
  n--;
  goto loop;

 branch1:
  n = sload(sp, 1, uint64_t);
  sstore(sp, 0, void*, &&branch2);
  sstore(sp, 1, uint64_t, f);
  goto loop;

 branch2:
  f += sload(sp, 1, uint64_t);
  sfree(sp, 2);
  goto retk;

 retk:
  goto *sload(sp, 0, void*);

 exitk:
  sfree(sp, 1);
  return f;
  
}

extern
int fib_handler(uint64_t n, uint64_t*& dst,
		tpalrts::stack_type s, char*& sp, char*& prmhd, char*& prmtl,
		void* pc, uint64_t f,
		void* __entry, void* __retk, void* __joink, void* __clonek,
		void* _p);

void fib_interrupt(uint64_t n, uint64_t* dst, tpalrts::promotable* p,
                   tpalrts::stack_type s, void* pc, uint64_t f) {
  sunpack(s);

  void* __entry = &&entry;
  void* __retk = &&retk;
  void* __joink = &&joink;
  void* __clonek = &&clonek;

  pc = (pc == nullptr) ? __entry : pc;
  
  goto *pc;
    
 entry:
  salloc(sp, 1);
  sstore(sp, 0, void*, &&exitk);

 loop:
  if (unlikely(heartbeat)) {
    fib_handler(n, dst, s, sp, prmhd, prmtl, pc, f, __entry, __retk, __joink, __clonek, p);
  }
  f = n;
  if (n < 2) {
    goto retk;
  }
  f = 0;
  salloc(sp, 4);
  sstore(sp, 0, void*, &&branch1);
  sstore(sp, 1, uint64_t, n - 2);
  prmpush(sp, 2, prmtl, prmhd);
  n--;
  goto loop;

 branch1:
  n = sload(sp, 1, uint64_t);
  sstore(sp, 0, void*, &&branch2);
  sstore(sp, 1, uint64_t, f);
  prmpop(sp, 2, prmtl, prmhd);
  goto loop;

 branch2:
  f += sload(sp, 1, uint64_t);
  sfree(sp, 4);
  goto retk;

 retk:
  goto *sload(sp, 0, void*);

 joink:
  sstore(sp, 0, void*, &&clonek);
  sfree(sp, 1);
  *dst = f;
  return;

 clonek:
  salloc(sp, 1);
  sstore(sp, 0, void*, &&joink);
  goto loop;
  
 exitk:
  sfree(sp, 1);
  *dst = f;
  sdelete(s);
  
}
