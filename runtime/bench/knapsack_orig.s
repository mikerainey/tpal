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
        movq    %rdi, %r13
        pushq   %r12
        movl    %ecx, %r12d
        pushq   %rbp
        movl    %edx, %ebp
        pushq   %rbx
        movq    %rsi, %rbx
        subq    $136, %rsp
        cmpq    $0, 200(%rsp)
        movq    232(%rsp), %r14
        movl    240(%rsp), %r15d
        movq    %r9, 88(%rsp)
        je      .L21
        movq    208(%rsp), %rax
.L22:
        movq    %rax, 104(%rsp)
        movq    216(%rsp), %rax
        cmpq    $0, __entry(%rip)
        movq    %rax, 112(%rsp)
        movq    224(%rsp), %rax
        movq    %rax, 120(%rsp)
        je      .L56
.L23:
        testq   %r14, %r14
        cmove   __entry(%rip), %r14
        jmp     *%r14
.L30:
        movq    104(%rsp), %rax
        movl    24(%rax), %eax
        cmpl    %eax, %r15d
        cmovl   %eax, %r15d
        movl    0(%r13), %eax
        cmpl    %eax, %r15d
        jg      .L40
.L41:
        addq    $48, 104(%rsp)
.L26:
        movq    104(%rsp), %rax
        movq    (%rax), %rax
        jmp     *%rax
.L25:
        movq    88(%rsp), %rax
        leaq    200(%rsp), %rdi
        addq    $8, 104(%rsp)
        movl    %r15d, (%rax)
        call    _ZN7tpalrts7sdeleteERNS_12stack_structE
.L20:
        addq    $136, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L28:
        movq    104(%rsp), %rax
        leaq    -8(%rax), %rdx
        movq    %rdx, 104(%rsp)
        movq    __joink(%rip), %rdx
        movq    %rdx, -8(%rax)
        jmp     .L37
.L36:
        addq    $8, %rbx
        movl    %ebp, %edx
        decl    %r12d
        subl    -4(%rbx), %edx
        movl    %r12d, 36(%rax)
        movq    %rbx, 24(%rax)
        movl    %edx, 32(%rax)
        movl    -8(%rbx), %edx
        addl    %r8d, %edx
        movl    %edx, 40(%rax)
.L37:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L57
.L34:
        testl   %ebp, %ebp
        js      .L47
.L59:
        testl   %r12d, %r12d
        je      .L46
        testl   %ebp, %ebp
        je      .L46
        movl    (%rbx), %eax
        cvtsi2sdl       %r8d, %xmm1
        imull   %ebp, %eax
        cltd
        idivl   4(%rbx)
        cvtsi2sdl       %eax, %xmm0
        movl    0(%r13), %eax
        addsd   %xmm1, %xmm0
        cvtsi2sdl       %eax, %xmm1
        comisd  %xmm0, %xmm1
        ja      .L47
        movq    104(%rsp), %rax
        leaq    -48(%rax), %rdx
        movq    %rdx, 104(%rsp)
        movq    __branch1(%rip), %rdx
        movq    %rdx, -48(%rax)
        movq    120(%rsp), %rdx
        movq    104(%rsp), %rax
        testq   %rdx, %rdx
        leaq    8(%rax), %rcx
        movq    %rdx, 8(%rax)
        movq    $0, 16(%rax)
        je      .L35
        movq    %rcx, 8(%rdx)
.L35:
        cmpq    $0, 112(%rsp)
        movq    %rcx, 120(%rsp)
        jne     .L36
        movq    %rcx, 112(%rsp)
        jmp     .L36
.L27:
        movq    104(%rsp), %rax
        movq    __clonek(%rip), %rdx
        movq    %rdx, (%rax)
        movq    88(%rsp), %rax
        movl    %r15d, (%rax)
        jmp     .L20
.L29:
        movq    104(%rsp), %rax
        movq    __branch2(%rip), %rdx
        movq    24(%rax), %rbx
        movq    %rdx, (%rax)
        movl    32(%rax), %ebp
        movl    36(%rax), %r12d
        movl    40(%rax), %r8d
        movq    120(%rsp), %rdx
        movq    104(%rsp), %rax
        movl    %r15d, 24(%rax)
        movq    (%rdx), %rax
        testq   %rax, %rax
        je      .L58
        movq    $0, 8(%rax)
        movq    $0, (%rdx)
.L39:
        movq    %rax, 120(%rsp)
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        je      .L34
.L57:
        movq    192(%rsp), %rax
        leaq    88(%rsp), %r9
        movl    %r8d, 84(%rsp)
        movl    %r15d, 64(%rsp)
        movq    %r14, 56(%rsp)
        movl    %r12d, %ecx
        movl    %ebp, %edx
        movq    %rbx, %rsi
        movq    %r13, %rdi
        movq    %rax, 72(%rsp)
        leaq    120(%rsp), %rax
        movq    %rax, 48(%rsp)
        leaq    112(%rsp), %rax
        movq    %rax, 40(%rsp)
        leaq    104(%rsp), %rax
        movq    %rax, 32(%rsp)
        movq    200(%rsp), %rax
        movq    %rax, (%rsp)
        movq    208(%rsp), %rax
        movq    %rax, 8(%rsp)
        movq    216(%rsp), %rax
        movq    %rax, 16(%rsp)
        movq    224(%rsp), %rax
        movq    %rax, 24(%rsp)
        call    _Z16knapsack_handlerRSt6atomicIiEP4itemiiiRPiN7tpalrts12stack_structERPcS9_S9_PviSA_
        testl   %ebp, %ebp
        movl    84(%rsp), %r8d
        jns     .L59
.L47:
        movq    104(%rsp), %rax
        movl    $-2147483648, %r15d
        movq    (%rax), %rax
        jmp     *%rax
.L24:
        movq    104(%rsp), %rax
        leaq    -8(%rax), %rdx
        movq    %rdx, 104(%rsp)
        movq    __exitk(%rip), %rdx
        movq    %rdx, -8(%rax)
        jmp     .L37
.L46:
        movq    104(%rsp), %rax
        movl    %r8d, %r15d
        movq    (%rax), %rax
        jmp     *%rax
.L58:
        movq    $0, 112(%rsp)
        jmp     .L39
.L40:
        movl    0(%r13), %eax
        cmpl    %eax, %r8d
        jle     .L41
.L42:
        lock cmpxchgl   %r8d, 0(%r13)
        cmpl    %eax, %r8d
        jg      .L42
        jmp     .L41
.L21:
        movl    %r8d, 84(%rsp)
        call    _ZN7tpalrts11alloc_stackEv
        movq    %rax, 200(%rsp)
        addq    $8191, %rax
        movl    84(%rsp), %r8d
        movq    %rax, 208(%rsp)
        jmp     .L22
.L56:
        movl    $.L24, %edi
        movl    %r8d, 84(%rsp)
        call    _Z14sanitize_labelPv
        movl    $.L25, %edi
        movq    %rax, __entry(%rip)
        call    _Z14sanitize_labelPv
        movl    $.L26, %edi
        movq    %rax, __exitk(%rip)
        call    _Z14sanitize_labelPv
        movl    $.L27, %edi
        movq    %rax, __retk(%rip)
        call    _Z14sanitize_labelPv
        movl    $.L28, %edi
        movq    %rax, __joink(%rip)
        call    _Z14sanitize_labelPv
        movl    $.L29, %edi
        movq    %rax, __clonek(%rip)
        call    _Z14sanitize_labelPv
        movl    $.L30, %edi
        movq    %rax, __branch1(%rip)
        call    _Z14sanitize_labelPv
        movl    84(%rsp), %r8d
        movq    %rax, __branch2(%rip)
        jmp     .L23
