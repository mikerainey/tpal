#pragma once

#define SPMV_OFF01 0       // val      (%rdi)
#define SPMV_OFF02 8       // row_ptr  (%rsi)
#define SPMV_OFF03 16      // col_ind  (%rdx)
#define SPMV_OFF04 24      // x        (%rcx)
#define SPMV_OFF05 32      // y        (%r8)
#define SPMV_OFF06 40      // i        (%rbx)
#define SPMV_OFF07 48      // n        (%r9)
#define SPMV_OFF08 56      // k        (%rax)
#define SPMV_OFF09 64      // khi      (%r11)
#define SPMV_OFF10 72      // p
#define SPMV_OFF11 80      // t        (%xmm1)
#define SPMV_OFF12 88      // ptr_t

#define SPMV_SZB 96

#define GET_FROM_ENV(ty, off, env) (*((ty*)(env+off)))
#define GET_ADDR_FROM_ENV(ty, off, env) ((ty*)(env+off))

#define SPMV_ENV_REG %r15
