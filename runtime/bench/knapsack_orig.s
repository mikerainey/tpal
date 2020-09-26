_Z15knapsack_serialRiP4itemiiiN7tpalrts12stack_structE:
        pushq   %r13
        movq    %rsi, %r13
        pushq   %rbp
        movl    %ecx, %ebp
        pushq   %rbx
        movl    %edx, %ebx
        subq    $16, %rsp
        cmpq    $0, 48(%rsp)
        movq    56(%rsp), %rax
        je      .L18
.L2:
        leaq    -8(%rax), %r9
        movq    $.L3, -8(%rax)
.L4:
        testl   %ebx, %ebx
        js      .L12
        testl   %ebp, %ebp
        je      .L6
        testl   %ebx, %ebx
        je      .L6
        movl    0(%r13), %ecx
        movl    4(%r13), %esi
        cvtsi2sdl       %r8d, %xmm2
        cvtsi2sdl       (%rdi), %xmm1
        movl    %ecx, %eax
        imull   %ebx, %eax
        cltd
        idivl   %esi
        cvtsi2sdl       %eax, %xmm0
        addsd   %xmm2, %xmm0
        comisd  %xmm0, %xmm1
        jbe     .L19
.L12:
        movl    $-2147483648, %r8d
        jmp     *(%r9)
.L3:
        addq    $16, %rsp
        movl    %r8d, %eax
        popq    %rbx
        popq    %rbp
        popq    %r13
        ret
.L10:
        movl    8(%r9), %eax
        cmpl    %eax, %r8d
        cmovl   %eax, %r8d
        cmpl    (%rdi), %r8d
        jle     .L11
        addq    $32, %r9
        movl    %r8d, (%rdi)
        jmp     *(%r9)
.L8:
        movq    8(%r9), %r13
        movl    16(%r9), %ebx
        movl    %r8d, 8(%r9)
        movl    20(%r9), %ebp
        movl    24(%r9), %r8d
        movq    $.L10, (%r9)
        jmp     .L4
.L6:
        jmp     *(%r9)
.L11:
        addq    $32, %r9
        jmp     *(%r9)
.L19:
        movl    %ebx, %eax
        addq    $8, %r13
        decl    %ebp
        subl    %esi, %eax
        addl    %r8d, %ecx
        movq    $.L8, -32(%r9)
        movq    %r13, -24(%r9)
        movl    %eax, -16(%r9)
        subq    $32, %r9
        movl    %ebp, 20(%r9)
        movl    %ecx, 24(%r9)
        jmp     .L4
.L18:
        movl    %r8d, 12(%rsp)
        movq    %rdi, (%rsp)
        call    _ZN7tpalrts11alloc_stackEv
        movl    12(%rsp), %r8d
        movq    (%rsp), %rdi
        addq    $8191, %rax
        jmp     .L2
_Z18knapsack_interruptRSt6atomicIiEP4itemiiiPiPvN7tpalrts12stack_structES5_i:
        pushq   %r15
        pushq   %r14
        pushq   %r13
        movl    %r8d, %r13d
        pushq   %r12
        movl    %ecx, %r12d
        pushq   %rbp
        movl    %edx, %ebp
        pushq   %rbx
        movq    %rsi, %rbx
        subq    $168, %rsp
        cmpq    $0, 232(%rsp)
        movq    264(%rsp), %r14
        movl    272(%rsp), %r15d
        movq    %r9, 120(%rsp)
        je      .L22
        movq    240(%rsp), %rax
.L23:
        movq    %rax, 136(%rsp)
        movq    248(%rsp), %rax
        testq   %r14, %r14
        movq    %rax, 144(%rsp)
        movq    256(%rsp), %rax
        movq    %rax, 152(%rsp)
        movl    $.L21, %eax
        cmove   %rax, %r14
        jmp     *%r14
.L36:
        movq    136(%rsp), %rax
        movl    8(%rax), %eax
        cmpl    %eax, %r15d
        cmovl   %eax, %r15d
        movl    (%rdi), %eax
        cmpl    %eax, %r15d
        jg      .L39
.L40:
        addq    $48, 136(%rsp)
.L32:
        movq    136(%rsp), %rax
        movq    (%rax), %rax
        jmp     *%rax
.L26:
        movq    120(%rsp), %rax
        leaq    232(%rsp), %rdi
        addq    $8, 136(%rsp)
        movl    %r15d, (%rax)
        call    _ZN7tpalrts7sdeleteERNS_12stack_structE
.L20:
        addq    $168, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L30:
        movq    136(%rsp), %rax
        leaq    -8(%rax), %rdx
        movq    %rdx, 136(%rsp)
        movq    $.L31, -8(%rax)
.L28:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L56
.L29:
        testl   %ebp, %ebp
        js      .L47
.L57:
        testl   %r12d, %r12d
        je      .L46
        testl   %ebp, %ebp
        je      .L46
        movl    (%rbx), %eax
        cvtsi2sdl       %r13d, %xmm1
        imull   %ebp, %eax
        cltd
        idivl   4(%rbx)
        cvtsi2sdl       %eax, %xmm0
        movl    (%rdi), %eax
        addsd   %xmm1, %xmm0
        cvtsi2sdl       %eax, %xmm1
        comisd  %xmm0, %xmm1
        ja      .L47
        movq    136(%rsp), %rax
        addq    $8, %rbx
        decl    %r12d
        leaq    -48(%rax), %rdx
        movq    %rdx, 136(%rsp)
        movl    %ebp, %edx
        subl    -4(%rbx), %edx
        movq    $.L33, -48(%rax)
        movq    136(%rsp), %rax
        movl    %edx, 16(%rax)
        movl    %r12d, 20(%rax)
        leaq    32(%rax), %rcx
        movl    -8(%rbx), %edx
        movq    %rbx, 8(%rax)
        movq    $0, 40(%rax)
        addl    %r13d, %edx
        movl    %edx, 24(%rax)
        movq    152(%rsp), %rdx
        testq   %rdx, %rdx
        movq    %rdx, 32(%rax)
        je      .L34
        movq    %rcx, 8(%rdx)
.L34:
        cmpq    $0, 144(%rsp)
        movq    %rcx, 152(%rsp)
        jne     .L28
        movl    heartbeat(%rip), %eax
        movq    %rcx, 144(%rsp)
        testl   %eax, %eax
        je      .L29
.L56:
        movq    224(%rsp), %rax
        leaq    120(%rsp), %r9
        movq    %rdi, 112(%rsp)
        movl    %r15d, 96(%rsp)
        movq    %r14, 88(%rsp)
        movl    %r13d, %r8d
        movq    $.L30, 80(%rsp)
        movq    $.L31, 72(%rsp)
        movl    %r12d, %ecx
        movq    %rax, 104(%rsp)
        leaq    152(%rsp), %rax
        movq    $.L32, 64(%rsp)
        movq    $.L21, 56(%rsp)
        movl    %ebp, %edx
        movq    %rbx, %rsi
        movq    %rax, 48(%rsp)
        leaq    144(%rsp), %rax
        movq    %rax, 40(%rsp)
        leaq    136(%rsp), %rax
        movq    %rax, 32(%rsp)
        movq    232(%rsp), %rax
        movq    %rax, (%rsp)
        movq    240(%rsp), %rax
        movq    %rax, 8(%rsp)
        movq    248(%rsp), %rax
        movq    %rax, 16(%rsp)
        movq    256(%rsp), %rax
        movq    %rax, 24(%rsp)
        call    _Z16knapsack_handlerRSt6atomicIiEP4itemiiiRPiN7tpalrts12stack_structERPcS9_S9_PvSA_SA_SA_SA_iSA_
        testl   %ebp, %ebp
        movq    112(%rsp), %rdi
        jns     .L57
.L47:
        movq    136(%rsp), %rax
        movl    $-2147483648, %r15d
        movq    (%rax), %rax
        jmp     *%rax
.L31:
        movq    136(%rsp), %rax
        movq    $.L30, (%rax)
        movq    120(%rsp), %rax
        movl    %r15d, (%rax)
        jmp     .L20
.L33:
        movq    136(%rsp), %rax
        movq    $.L36, (%rax)
        movq    8(%rax), %rbx
        movl    16(%rax), %ebp
        movl    20(%rax), %r12d
        movl    24(%rax), %r13d
        movq    152(%rsp), %rdx
        movq    136(%rsp), %rax
        movl    %r15d, 8(%rax)
        movq    (%rdx), %rax
        testq   %rax, %rax
        je      .L58
        movq    $0, 8(%rax)
        movq    $0, (%rdx)
.L38:
        movq    %rax, 152(%rsp)
        jmp     .L28
.L21:
        movq    136(%rsp), %rax
        leaq    -8(%rax), %rdx
        movq    %rdx, 136(%rsp)
        movq    $.L26, -8(%rax)
        jmp     .L28
.L46:
        movq    136(%rsp), %rax
        movl    %r13d, %r15d
        movq    (%rax), %rax
        jmp     *%rax
.L58:
        movq    $0, 144(%rsp)
        jmp     .L38
.L39:
        movl    (%rdi), %eax
        cmpl    %eax, %r13d
        jle     .L40
.L41:
        lock cmpxchgl   %r13d, (%rdi)
        cmpl    %eax, %r13d
        jg      .L41
        jmp     .L40
.L22:
        movq    %rdi, 112(%rsp)
        call    _ZN7tpalrts11alloc_stackEv
        movq    %rax, 232(%rsp)
        addq    $8191, %rax
        movq    112(%rsp), %rdi
        movq    %rax, 240(%rsp)
        jmp     .L23
