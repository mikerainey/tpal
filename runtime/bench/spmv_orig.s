_Z11spmv_serialPdPmS0_S_S_m:
        testq   %r9, %r9
        je      .L23
        pushq   %r14
        xorpd   %xmm2, %xmm2
        pushq   %r13
        pushq   %r12
        xorl    %r12d, %r12d
        pushq   %rbp
        movq    %rsi, %rbp
        movq    %rdx, %rsi
        pushq   %rbx
.L7:
        movq    0(%rbp,%r12,8), %rbx
        movq    8(%rbp,%r12,8), %rdx
        cmpq    %rdx, %rbx
        movq    %rbx, %r10
        jnb     .L8
        leaq    -7(%rdx), %r14
        leaq    1(%rbx), %rax
        cmpq    %rax, %r14
        jbe     .L9
        cmpq    $6, %rdx
        jbe     .L9
        leaq    128(,%rbx,8), %rax
        movsd   %xmm2, %xmm1
        leaq    (%rdi,%rax), %r11
        addq    %rsi, %rax
.L5:
        movq    -128(%rax), %r10
        movq    %rbx, %r13
        prefetcht0      (%r11)
        addq    $9, %r13
        addq    $64, %r11
        prefetcht0      (%rax)
        addq    $64, %rax
        movlpd  (%rcx,%r10,8), %xmm0
        movq    -184(%rax), %r10
        mulsd   -192(%r11), %xmm0
        addsd   %xmm0, %xmm1
        movlpd  (%rcx,%r10,8), %xmm0
        movq    -176(%rax), %r10
        mulsd   -184(%r11), %xmm0
        addsd   %xmm1, %xmm0
        movlpd  (%rcx,%r10,8), %xmm1
        movq    -168(%rax), %r10
        mulsd   -176(%r11), %xmm1
        addsd   %xmm1, %xmm0
        movlpd  (%rcx,%r10,8), %xmm1
        movq    -160(%rax), %r10
        mulsd   -168(%r11), %xmm1
        addsd   %xmm0, %xmm1
        movlpd  (%rcx,%r10,8), %xmm0
        movq    -152(%rax), %r10
        mulsd   -160(%r11), %xmm0
        addsd   %xmm0, %xmm1
        movlpd  (%rcx,%r10,8), %xmm0
        movq    -144(%rax), %r10
        mulsd   -152(%r11), %xmm0
        addsd   %xmm1, %xmm0
        movlpd  (%rcx,%r10,8), %xmm1
        movq    -136(%rax), %r10
        mulsd   -144(%r11), %xmm1
        addsd   %xmm1, %xmm0
        movlpd  (%rcx,%r10,8), %xmm1
        leaq    8(%rbx), %r10
        mulsd   -136(%r11), %xmm1
        cmpq    %r13, %r14
        movq    %r10, %rbx
        addsd   %xmm0, %xmm1
        ja      .L5
        leaq    1(%r10), %rax
        jmp     .L6
.L27:
        incq    %rax
.L6:
        movq    (%rsi,%r10,8), %r11
        cmpq    %rax, %rdx
        movlpd  (%rcx,%r11,8), %xmm0
        mulsd   (%rdi,%r10,8), %xmm0
        movq    %rax, %r10
        addsd   %xmm0, %xmm1
        ja      .L27
        movsd   %xmm1, (%r8,%r12,8)
        incq    %r12
        cmpq    %r9, %r12
        jne     .L7
.L28:
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        ret
.L8:
        movsd   %xmm2, %xmm1
        movsd   %xmm1, (%r8,%r12,8)
        incq    %r12
        cmpq    %r9, %r12
        jne     .L7
        jmp     .L28
.L9:
        movsd   %xmm2, %xmm1
        jmp     .L6
.L23:
        rep ret
_Z14spmv_interruptPdPmS0_S_S_mmPv:
        pushq   %r15
        pushq   %r14
        pushq   %r13
        pushq   %r12
        pushq   %rbp
        pushq   %rbx
        subq    $72, %rsp
        cmpq    128(%rsp), %r9
        jnb     .L29
        movq    %rdi, %r12
        movq    %rdx, %r13
        movq    %rcx, %rbp
        jmp     .L40
.L31:
        cmpq    128(%rsp), %r15
        movsd   %xmm1, -8(%r8,%r15,8)
        jnb     .L29
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L39
.L41:
        movq    %r15, %r9
.L40:
        xorpd   %xmm1, %xmm1
        leaq    1(%r9), %r15
        movq    (%rsi,%r9,8), %rax
        movq    (%rsi,%r15,8), %r14
        cmpq    %rax, %r14
        jbe     .L31
        movq    %r15, 56(%rsp)
        movq    %rsi, %r15
.L32:
        leaq    1024(%rax), %rbx
        cmpq    %r14, %rbx
        cmova   %r14, %rbx
        cmpq    %rbx, %rax
        jnb     .L43
        leaq    -7(%rbx), %r10
        leaq    1(%rax), %rdx
        cmpq    %rdx, %r10
        jbe     .L36
        cmpq    $6, %rbx
        jbe     .L36
        leaq    128(,%rax,8), %rdx
        leaq    (%r12,%rdx), %rcx
        addq    %r13, %rdx
.L35:
        movq    -128(%rdx), %rsi
        prefetcht0      (%rcx)
        prefetcht0      (%rdx)
        addq    $64, %rcx
        addq    $64, %rdx
        movlpd  0(%rbp,%rsi,8), %xmm0
        movq    -184(%rdx), %rsi
        mulsd   -192(%rcx), %xmm0
        addsd   %xmm0, %xmm1
        movlpd  0(%rbp,%rsi,8), %xmm0
        movq    -176(%rdx), %rsi
        mulsd   -184(%rcx), %xmm0
        movsd   %xmm0, %xmm2
        movlpd  0(%rbp,%rsi,8), %xmm0
        movq    -168(%rdx), %rsi
        addsd   %xmm1, %xmm2
        movlpd  -176(%rcx), %xmm1
        mulsd   %xmm0, %xmm1
        addsd   %xmm2, %xmm1
        movsd   %xmm1, %xmm0
        movlpd  0(%rbp,%rsi,8), %xmm1
        movq    -160(%rdx), %rsi
        mulsd   -168(%rcx), %xmm1
        addsd   %xmm0, %xmm1
        movlpd  0(%rbp,%rsi,8), %xmm0
        movq    -152(%rdx), %rsi
        mulsd   -160(%rcx), %xmm0
        addsd   %xmm0, %xmm1
        movlpd  0(%rbp,%rsi,8), %xmm0
        movq    -144(%rdx), %rsi
        mulsd   -152(%rcx), %xmm0
        addsd   %xmm1, %xmm0
        movlpd  0(%rbp,%rsi,8), %xmm1
        movq    -136(%rdx), %rsi
        mulsd   -144(%rcx), %xmm1
        addsd   %xmm1, %xmm0
        movlpd  0(%rbp,%rsi,8), %xmm1
        movq    %rax, %rsi
        addq    $9, %rsi
        addq    $8, %rax
        mulsd   -136(%rcx), %xmm1
        cmpq    %rsi, %r10
        addsd   %xmm0, %xmm1
        ja      .L35
        leaq    1(%rax), %rdx
        jmp     .L36
.L63:
        incq    %rdx
.L36:
        movq    0(%r13,%rax,8), %rcx
        cmpq    %rdx, %rbx
        movlpd  0(%rbp,%rcx,8), %xmm0
        mulsd   (%r12,%rax,8), %xmm0
        movq    %rdx, %rax
        addsd   %xmm0, %xmm1
        ja      .L63
        cmpq    %rbx, %r14
        jbe     .L61
.L65:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L64
.L37:
        movq    %rbx, %rax
        jmp     .L32
.L43:
        movq    %rax, %rbx
        cmpq    %rbx, %r14
        ja      .L65
.L61:
        movq    %r15, %rsi
        movq    56(%rsp), %r15
        jmp     .L31
.L64:
        movq    136(%rsp), %rax
        movsd   %xmm1, %xmm0
        movq    %r14, 16(%rsp)
        movq    %rbx, 8(%rsp)
        movq    %rbp, %rcx
        movq    %r13, %rdx
        movq    %r15, %rsi
        movq    %r12, %rdi
        movsd   %xmm1, 48(%rsp)
        movq    %rax, 24(%rsp)
        movq    128(%rsp), %rax
        movq    %r9, 40(%rsp)
        movq    %r8, 32(%rsp)
        movq    %rax, (%rsp)
        call    _Z16col_loop_handlerPdPmS0_S_S_mmmmdPv
        testl   %eax, %eax
        movq    32(%rsp), %r8
        movq    40(%rsp), %r9
        movlpd  48(%rsp), %xmm1
        je      .L37
.L29:
        addq    $72, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L39:
        movq    136(%rsp), %rax
        movq    %r15, %r9
        movq    %rbp, %rcx
        movq    %r13, %rdx
        movq    %r12, %rdi
        movq    %r8, 40(%rsp)
        movq    %rsi, 32(%rsp)
        movq    %rax, 8(%rsp)
        movq    128(%rsp), %rax
        movq    %rax, (%rsp)
        call    _Z16row_loop_handlerPdPmS0_S_S_mmPv
        testl   %eax, %eax
        movq    32(%rsp), %rsi
        movq    40(%rsp), %r8
        je      .L41
        jmp     .L29
_Z23spmv_interrupt_col_loopPdPmS0_S_S_mmdS_Pv:
        pushq   %r15
        pushq   %r14
        pushq   %r13
        pushq   %r12
        pushq   %rbp
        pushq   %rbx
        subq    $56, %rsp
        movq    112(%rsp), %r15
        cmpq    %r15, %r9
        jnb     .L67
        movq    %rdi, %r13
        movq    %rsi, %r14
        movq    %rdx, %r12
        movq    %rcx, %rbp
.L68:
        leaq    1024(%r9), %rbx
        cmpq    %r15, %rbx
        cmova   %r15, %rbx
        cmpq    %rbx, %r9
        jnb     .L75
        leaq    -7(%rbx), %rdi
        leaq    1(%r9), %rax
        cmpq    %rax, %rdi
        jbe     .L72
        cmpq    $6, %rbx
        jbe     .L72
        leaq    128(,%r9,8), %rax
        leaq    0(%r13,%rax), %rdx
        addq    %r12, %rax
.L71:
        movq    -128(%rax), %rcx
        prefetcht0      (%rdx)
        prefetcht0      (%rax)
        addq    $64, %rdx
        addq    $64, %rax
        movlpd  0(%rbp,%rcx,8), %xmm1
        movq    -184(%rax), %rcx
        mulsd   -192(%rdx), %xmm1
        addsd   %xmm1, %xmm0
        movlpd  0(%rbp,%rcx,8), %xmm1
        movq    -176(%rax), %rcx
        mulsd   -184(%rdx), %xmm1
        addsd   %xmm0, %xmm1
        movlpd  0(%rbp,%rcx,8), %xmm0
        movq    -168(%rax), %rcx
        mulsd   -176(%rdx), %xmm0
        addsd   %xmm0, %xmm1
        movlpd  0(%rbp,%rcx,8), %xmm0
        movq    -160(%rax), %rcx
        mulsd   -168(%rdx), %xmm0
        addsd   %xmm1, %xmm0
        movlpd  0(%rbp,%rcx,8), %xmm1
        movq    -152(%rax), %rcx
        mulsd   -160(%rdx), %xmm1
        addsd   %xmm1, %xmm0
        movlpd  0(%rbp,%rcx,8), %xmm1
        movq    -144(%rax), %rcx
        mulsd   -152(%rdx), %xmm1
        addsd   %xmm0, %xmm1
        movlpd  0(%rbp,%rcx,8), %xmm0
        movq    -136(%rax), %rcx
        mulsd   -144(%rdx), %xmm0
        addsd   %xmm0, %xmm1
        movlpd  0(%rbp,%rcx,8), %xmm0
        movq    %r9, %rcx
        addq    $9, %rcx
        addq    $8, %r9
        mulsd   -136(%rdx), %xmm0
        cmpq    %rcx, %rdi
        addsd   %xmm1, %xmm0
        ja      .L71
        leaq    1(%r9), %rax
        jmp     .L72
.L89:
        incq    %rax
.L72:
        movq    (%r12,%r9,8), %rdx
        cmpq    %rax, %rbx
        movlpd  0(%rbp,%rdx,8), %xmm1
        mulsd   0(%r13,%r9,8), %xmm1
        movq    %rax, %r9
        addsd   %xmm1, %xmm0
        ja      .L89
        cmpq    %rbx, %r15
        jbe     .L67
.L91:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L90
.L73:
        movq    %rbx, %r9
        jmp     .L68
.L75:
        movq    %r9, %rbx
        cmpq    %rbx, %r15
        ja      .L91
.L67:
        movq    120(%rsp), %rax
        movsd   %xmm0, (%rax)
.L66:
        addq    $56, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L90:
        movq    128(%rsp), %rax
        movq    %r15, (%rsp)
        movq    %rbx, %r9
        movq    %rbp, %rcx
        movq    %r12, %rdx
        movq    %r14, %rsi
        movq    %r13, %rdi
        movsd   %xmm0, 40(%rsp)
        movq    %r8, 32(%rsp)
        movq    %rax, 16(%rsp)
        movq    120(%rsp), %rax
        movq    %rax, 8(%rsp)
        call    _Z25col_loop_handler_col_loopPdPmS0_S_S_mmdS_Pv
        testl   %eax, %eax
        movq    32(%rsp), %r8
        movlpd  40(%rsp), %xmm0
        je      .L73
        jmp     .L66
