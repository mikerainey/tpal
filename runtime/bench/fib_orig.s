_Z10fib_serialmN7tpalrts12stack_structE:
        pushq   %r12
        cmpq    $0, 16(%rsp)
        movq    %rdi, %r12
        movq    24(%rsp), %rdx
        je      .L13
.L2:
        leaq    -8(%rdx), %rax
        movq    $.L3, -8(%rdx)
.L4:
        cmpq    $1, %r12
        ja      .L14
.L5:
        jmp     *(%rax)
.L3:
        movq    %r12, %rax
        vzeroupper
        popq    %r12
        ret
.L8:
        addq    8(%rax), %r12
        addq    $16, %rax
        jmp     *(%rax)
.L6:
        movq    8(%rax), %rdx
        movq    %r12, 8(%rax)
        movq    $.L8, (%rax)
        movq    %rdx, %r12
        cmpq    $1, %r12
        jbe     .L5
.L14:
        leaq    -2(%r12), %rdx
        movq    $.L6, -16(%rax)
        decq    %r12
        subq    $16, %rax
        movq    %rdx, 8(%rax)
        jmp     .L4
.L13:
        call    _ZN7tpalrts11alloc_stackEv
        leaq    8191(%rax), %rdx
        jmp     .L2
_Z13fib_interruptmPmN7tpalrts12stack_structEPvS2_m:
        pushq   %r15
        movq    %rcx, %r15
        pushq   %r14
        pushq   %r13
        pushq   %r12
        movq    %rdx, %r12
        pushq   %rbp
        movq    %rdi, %rbp
        pushq   %rbx
        subq    $136, %rsp
        movq    192(%rsp), %r13
        movq    200(%rsp), %r14
        movq    %rsi, 88(%rsp)
        testq   %r13, %r13
        je      .L50
.L17:
        movq    208(%rsp), %rax
        testq   %r15, %r15
        movq    %r14, 104(%rsp)
        movq    %rax, 112(%rsp)
        movq    216(%rsp), %rax
        movq    %rax, 120(%rsp)
        movl    $.L16, %eax
        cmove   %rax, %r15
        jmp     *%r15
.L31:
        movq    104(%rsp), %rax
        addq    8(%rax), %r8
        addq    $32, %rax
        movq    %rax, 104(%rsp)
.L25:
        movq    104(%rsp), %rax
        movq    (%rax), %rax
        jmp     *%rax
.L20:
        movq    88(%rsp), %rax
        addq    $8, 104(%rsp)
        testq   %r13, %r13
        movq    %r8, (%rax)
        je      .L46
        movq    %r13, %rdi
        vzeroupper
        call    _ZN7tpalrts10free_stackEPc
        jmp     .L47
.L23:
        movq    104(%rsp), %rax
        leaq    -8(%rax), %rdx
        movq    %rdx, 104(%rsp)
        movq    $.L24, -8(%rax)
.L21:
        movq    %rbp, %rbx
        jmp     .L30
.L29:
        decq    %rbx
        xorl    %r8d, %r8d
.L30:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L51
.L22:
        cmpq    $1, %rbx
        jbe     .L52
        movq    104(%rsp), %rax
        leaq    -32(%rax), %rdx
        movq    %rdx, 104(%rsp)
        movq    $.L27, -32(%rax)
        leaq    -2(%rbx), %rdx
        movq    104(%rsp), %rax
        movq    %rdx, 8(%rax)
        movq    120(%rsp), %rdx
        leaq    16(%rax), %rcx
        movq    $0, 24(%rax)
        testq   %rdx, %rdx
        movq    %rdx, 16(%rax)
        je      .L28
        movq    %rcx, 8(%rdx)
.L28:
        cmpq    $0, 112(%rsp)
        movq    %rcx, 120(%rsp)
        jne     .L29
        movq    %rcx, 112(%rsp)
        jmp     .L29
.L24:
        movq    104(%rsp), %rax
        movq    $.L23, (%rax)
        movq    88(%rsp), %rax
        movq    %r8, (%rax)
        vzeroupper
.L47:
        addq    $136, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L27:
        movq    104(%rsp), %rax
        movq    $.L31, (%rax)
        movq    8(%rax), %rbp
        movq    120(%rsp), %rdx
        movq    104(%rsp), %rax
        movq    %r8, 8(%rax)
        movq    (%rdx), %rax
        testq   %rax, %rax
        je      .L53
        movq    $0, 8(%rax)
        movq    $0, (%rdx)
.L33:
        movq    %rax, 120(%rsp)
        jmp     .L21
.L16:
        movq    104(%rsp), %rax
        leaq    -8(%rax), %rdx
        movq    %rdx, 104(%rsp)
        movq    $.L20, -8(%rax)
        jmp     .L21
.L52:
        movl    $1, %eax
        testq   %rbp, %rbp
        cmovne  %rax, %rbp
        movq    104(%rsp), %rax
        movq    %rbp, %r8
        movq    (%rax), %rax
        jmp     *%rax
.L51:
        movq    208(%rsp), %rax
        movq    %r8, 32(%rsp)
        leaq    112(%rsp), %rcx
        leaq    120(%rsp), %r8
        leaq    104(%rsp), %rdx
        leaq    88(%rsp), %rsi
        movq    %r15, %r9
        movq    %rbx, %rdi
        movq    %r13, 192(%rsp)
        movq    %rax, 16(%rsp)
        movq    216(%rsp), %rax
        movq    %r14, 200(%rsp)
        movq    %r12, 72(%rsp)
        movq    $.L23, 64(%rsp)
        movq    $.L24, 56(%rsp)
        movq    $.L25, 48(%rsp)
        movq    $.L16, 40(%rsp)
        movq    %r13, (%rsp)
        movq    %r14, 8(%rsp)
        movq    %rax, 24(%rsp)
        vzeroupper
        call    _Z11fib_handlermRPmN7tpalrts12stack_structERPcS4_S4_PvmS5_S5_S5_S5_S5_
        jmp     .L22
.L46:
        vzeroupper
        jmp     .L47
.L53:
        movq    $0, 112(%rsp)
        jmp     .L33
.L50:
        movq    %r8, 80(%rsp)
        call    _ZN7tpalrts11alloc_stackEv
        movq    80(%rsp), %r8
        leaq    8191(%rax), %r14
        movq    %rax, %r13
        jmp     .L17
