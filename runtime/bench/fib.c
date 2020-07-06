void fib(uint64_t n, uint64_t* dst) {
  snew(sp, dflt_stack_szb);
  uint64_t f;

  salloc(sp, 1);
  sstore(sp, 0, void*, &&exitk);

 loop:
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

 exitk:
  sfree(sp, 1);
  *dst = f;

  assert(sp == &stack[dflt_stack_szb - 1]);
}
