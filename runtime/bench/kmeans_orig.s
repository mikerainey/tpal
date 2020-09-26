_Z8mycallocm:
        pushq   %rbx
        movq    %rdi, %rbx
        call    malloc
        shrq    $2, %rbx
        movq    %rax, %r8
        je      .L1
        leaq    0(,%rbx,4), %rdx
        xorl    %esi, %esi
        movq    %rax, %rdi
        call    memset
        movq    %rax, %r8
.L1:
        movq    %r8, %rax
        popq    %rbx
        ret
_Z13kmeans_serialPPfiiifPi:
        pushq   %r15
        movslq  %ecx, %rax
        leaq    0(,%rax,8), %r15
        pushq   %r14
        movl    %ecx, %r14d
        pushq   %r13
        pushq   %r12
        pushq   %rbp
        movl    %esi, %ebp
        pushq   %rbx
        movq    %rax, %rbx
        imull   %ebp, %ebx
        subq    $120, %rsp
        movq    %rdi, 56(%rsp)
        movq    %r15, %rdi
        movss   %xmm0, 92(%rsp)
        movslq  %ebx, %rbx
        movl    %edx, 88(%rsp)
        movl    %ecx, 28(%rsp)
        salq    $2, %rbx
        movq    %r8, 8(%rsp)
        movq    %rax, (%rsp)
        call    malloc
        movq    %rbx, %rdi
        movq    %rax, %r13
        call    malloc
        decl    %r14d
        movq    %rax, 0(%r13)
        jle     .L118
        movl    28(%rsp), %r11d
        movslq  %ebp, %rsi
        movq    %rax, %rdx
        leaq    0(,%rsi,4), %rdi
        cmpl    $9, %r11d
        jle     .L72
        leal    -10(%r11), %r8d
        movq    %rsi, %r9
        movq    %rsi, %r14
        leaq    0(,%rsi,8), %r10
        salq    $4, %r9
        leaq    (%rsi,%rsi,2), %rsi
        andl    $-8, %r8d
        leaq    192(%r13), %rcx
        leaq    (%rax,%r9), %rax
        leal    9(%r8), %r11d
        salq    $5, %r14
        movl    %r11d, 24(%rsp)
        leaq    0(,%rsi,4), %r11
        movl    $1, %esi
.L14:
        leaq    (%rdi,%rdx), %r8
        movq    %rax, -160(%rcx)
        addq    %rdi, %rax
        movq    %rax, -152(%rcx)
        addq    %rdi, %rax
        addl    $8, %esi
        movq    %r8, -184(%rcx)
        leaq    (%rdx,%r10), %r8
        movq    %rax, -144(%rcx)
        addq    %rdi, %rax
        prefetcht0      (%rcx)
        addq    $64, %rcx
        movq    %r8, -240(%rcx)
        leaq    (%rdx,%r11), %r8
        movq    %rax, -200(%rcx)
        addq    %rdi, %rax
        addq    %r14, %rdx
        movq    %rax, -192(%rcx)
        movq    %r8, -232(%rcx)
        addq    %r9, %rax
        cmpl    24(%rsp), %esi
        jne     .L14
.L13:
        movslq  %esi, %rsi
        addq    %rdi, %rdx
.L16:
        movq    %rdx, 0(%r13,%rsi,8)
        incq    %rsi
        addq    %rdi, %rdx
        cmpl    %esi, 28(%rsp)
        jg      .L16
.L15:
        testl   %ebp, %ebp
        jle     .L117
        movl    %ebp, %r9d
        movl    %ebp, %r11d
        xorl    %r10d, %r10d
        shrl    $2, %r9d
        andl    $-4, %r11d
        leal    -5(%r9), %eax
        movl    %r11d, %r14d
        salq    $2, %r14
        andl    $-4, %eax
        movl    %eax, 64(%rsp)
        addl    $4, %eax
        movl    %eax, 72(%rsp)
        leal    1(%r11), %eax
        movl    %eax, 32(%rsp)
        salq    $2, %rax
        movq    %rax, 40(%rsp)
        leal    2(%r11), %eax
        movl    %eax, 16(%rsp)
        salq    $2, %rax
        movq    %rax, 48(%rsp)
        leal    -1(%rbp), %eax
        movl    %eax, 24(%rsp)
        leal    -17(%rbp), %eax
        andl    $-16, %eax
        addl    $16, %eax
        movl    %eax, 80(%rsp)
.L12:
        movq    56(%rsp), %rax
        movq    0(%r13,%r10,8), %r8
        movq    (%rax,%r10,8), %rdi
        leaq    15(%rdi), %rax
        subq    %r8, %rax
        cmpq    $30, %rax
        jbe     .L19
        cmpl    $8, 24(%rsp)
        jbe     .L19
        cmpl    $4, %r9d
        movq    %r8, %rdx
        movq    %rdi, %rcx
        jbe     .L73
        xorl    %eax, %eax
.L24:
        movlps  (%rcx), %xmm0
        prefetcht0      464(%rcx)
        movl    %eax, %esi
        addq    $64, %rcx
        addl    $4, %eax
        prefetcht0      464(%rdx)
        movhps  -56(%rcx), %xmm0
        addq    $64, %rdx
        movlps  %xmm0, -64(%rdx)
        movhps  %xmm0, -56(%rdx)
        movlps  -48(%rcx), %xmm0
        movhps  -40(%rcx), %xmm0
        movlps  %xmm0, -48(%rdx)
        movhps  %xmm0, -40(%rdx)
        movlps  -32(%rcx), %xmm0
        movhps  -24(%rcx), %xmm0
        movlps  %xmm0, -32(%rdx)
        movhps  %xmm0, -24(%rdx)
        movlps  -16(%rcx), %xmm0
        movhps  -8(%rcx), %xmm0
        movlps  %xmm0, -16(%rdx)
        movhps  %xmm0, -8(%rdx)
        cmpl    64(%rsp), %esi
        jne     .L24
        movl    72(%rsp), %esi
.L23:
        xorl    %eax, %eax
.L25:
        movlps  (%rcx,%rax), %xmm0
        incl    %esi
        movhps  8(%rcx,%rax), %xmm0
        movlps  %xmm0, (%rdx,%rax)
        movhps  %xmm0, 8(%rdx,%rax)
        addq    $16, %rax
        cmpl    %esi, %r9d
        ja      .L25
        cmpl    %r11d, %ebp
        je      .L29
        cmpl    32(%rsp), %ebp
        movss   (%rdi,%r14), %xmm0
        movss   %xmm0, (%r8,%r14)
        jle     .L29
        movq    40(%rsp), %rax
        cmpl    16(%rsp), %ebp
        movss   (%rdi,%rax), %xmm0
        movss   %xmm0, (%r8,%rax)
        jle     .L29
        movq    48(%rsp), %rax
        movss   (%rdi,%rax), %xmm0
        movss   %xmm0, (%r8,%rax)
.L29:
        incq    %r10
        cmpl    %r10d, 28(%rsp)
        jg      .L12
.L10:
        movl    88(%rsp), %ecx
        testl   %ecx, %ecx
        jle     .L31
        movl    88(%rsp), %eax
        movq    8(%rsp), %rdi
        movl    $255, %esi
        decl    %eax
        leaq    4(,%rax,4), %rdx
        call    memset
.L31:
        movq    (%rsp), %r14
        salq    $2, %r14
        movq    %r14, %rdi
        call    malloc
        movq    %r14, %rdx
        movq    %rax, 40(%rsp)
        shrq    $2, %rdx
        je      .L21
        movq    %rax, %rdi
        salq    $2, %rdx
        xorl    %esi, %esi
        call    memset
.L21:
        movq    %r15, %rdi
        call    malloc
        movq    %rbx, %rdi
        movq    %rax, 32(%rsp)
        call    malloc
        shrq    $2, %rbx
        movq    %rax, 72(%rsp)
        movq    %rbx, %rdx
        je      .L32
        movq    %rax, %rdi
        salq    $2, %rdx
        xorl    %esi, %esi
        call    memset
.L32:
        cmpl    $1, 28(%rsp)
        movq    32(%rsp), %rax
        movq    72(%rsp), %rbx
        movq    %rbx, (%rax)
        jle     .L34
        movl    28(%rsp), %ebx
        movslq  %ebp, %rdx
        leaq    0(,%rdx,4), %rcx
        cmpl    $9, %ebx
        jle     .L75
        movq    72(%rsp), %r15
        leal    -10(%rbx), %esi
        movq    %rdx, %r8
        movq    %rdx, %r11
        leaq    0(,%rdx,8), %r9
        salq    $4, %r8
        leaq    (%rdx,%rdx,2), %rdx
        andl    $-8, %esi
        addq    $192, %rax
        leaq    (%r15,%r8), %rdi
        leal    9(%rsi), %ebx
        salq    $5, %r11
        leaq    0(,%rdx,4), %r10
        movq    %r15, %rsi
        movl    $1, %edx
.L37:
        leaq    (%rcx,%rsi), %r14
        movq    %rdi, -160(%rax)
        addq    %rcx, %rdi
        movq    %rdi, -152(%rax)
        addq    %rcx, %rdi
        addl    $8, %edx
        movq    %r14, -184(%rax)
        leaq    (%rsi,%r9), %r14
        movq    %rdi, -144(%rax)
        addq    %rcx, %rdi
        prefetcht0      (%rax)
        addq    $64, %rax
        movq    %r14, -240(%rax)
        leaq    (%rsi,%r10), %r14
        movq    %rdi, -200(%rax)
        addq    %rcx, %rdi
        addq    %r11, %rsi
        movq    %rdi, -192(%rax)
        movq    %r14, -232(%rax)
        addq    %r8, %rdi
        cmpl    %ebx, %edx
        jne     .L37
        movq    %rsi, 72(%rsp)
.L36:
        movq    72(%rsp), %rax
        movslq  %edx, %rdx
        addq    %rcx, %rax
.L38:
        movq    32(%rsp), %rbx
        movq    %rax, (%rbx,%rdx,8)
        incq    %rdx
        addq    %rcx, %rax
        cmpl    %edx, 28(%rsp)
        jg      .L38
        movq    (%rbx), %rax
        movq    %rax, 72(%rsp)
.L34:
        xorps   %xmm4, %xmm4
        movl    %ebp, %ebx
        movl    %ebp, %r15d
        shrl    $2, %ebx
        andl    $-4, %r15d
        leal    -5(%rbx), %eax
        andl    $-4, %eax
        movl    %eax, (%rsp)
        addl    $4, %eax
        movl    %eax, 48(%rsp)
        movl    24(%rsp), %eax
        leaq    4(,%rax,4), %rax
        movq    %rax, 80(%rsp)
        movl    88(%rsp), %eax
        decl    %eax
        movl    %eax, 96(%rsp)
.L41:
        movl    88(%rsp), %edx
        testl   %edx, %edx
        jle     .L119
        movaps  %xmm4, %xmm5
        movl    96(%rsp), %eax
        xorl    %r14d, %r14d
        movss   .LC1(%rip), %xmm6
        movss   .LC2(%rip), %xmm7
        movq    %rax, 64(%rsp)
        movl    28(%rsp), %eax
        leal    -1(%rax), %r11d
.L56:
        movq    56(%rsp), %rax
        movq    (%rax,%r14,8), %r9
        movl    28(%rsp), %eax
        testl   %eax, %eax
        jle     .L43
        movaps  %xmm6, %xmm3
        xorl    %edi, %edi
        testl   %ebp, %ebp
        movq    %r14, 16(%rsp)
        movq    0(%r13,%rdi,8), %r8
        movl    %edi, %r10d
        movl    24(%rsp), %r14d
        jle     .L76
.L121:
        cmpl    $2, %r14d
        jbe     .L77
        cmpl    $4, %ebx
        movq    %r8, %rdx
        movq    %r9, %rcx
        jbe     .L78
        movaps  %xmm4, %xmm1
        xorl    %eax, %eax
.L47:
        movlps  (%rcx), %xmm8
        movlps  (%rdx), %xmm0
        movl    %eax, %esi
        prefetcht0      256(%rcx)
        addl    $4, %eax
        addq    $64, %rcx
        movhps  8(%rdx), %xmm0
        movhps  -56(%rcx), %xmm8
        prefetcht0      256(%rdx)
        addq    $64, %rdx
        subps   %xmm0, %xmm8
        mulps   %xmm8, %xmm8
        addss   %xmm8, %xmm1
        movaps  %xmm8, %xmm2
        shufps  $85, %xmm8, %xmm2
        addss   %xmm2, %xmm1
        movaps  %xmm8, %xmm2
        unpckhps        %xmm8, %xmm2
        shufps  $255, %xmm8, %xmm8
        movaps  %xmm2, %xmm0
        movlps  -48(%rdx), %xmm2
        addss   %xmm1, %xmm0
        movlps  -48(%rcx), %xmm1
        movhps  -40(%rdx), %xmm2
        movhps  -40(%rcx), %xmm1
        subps   %xmm2, %xmm1
        addss   %xmm8, %xmm0
        mulps   %xmm1, %xmm1
        addss   %xmm1, %xmm0
        movaps  %xmm1, %xmm2
        shufps  $85, %xmm1, %xmm2
        addss   %xmm2, %xmm0
        movaps  %xmm1, %xmm2
        unpckhps        %xmm1, %xmm2
        shufps  $255, %xmm1, %xmm1
        addss   %xmm2, %xmm0
        movlps  -32(%rdx), %xmm2
        movhps  -24(%rdx), %xmm2
        addss   %xmm1, %xmm0
        movlps  -32(%rcx), %xmm1
        movhps  -24(%rcx), %xmm1
        subps   %xmm2, %xmm1
        mulps   %xmm1, %xmm1
        addss   %xmm1, %xmm0
        movaps  %xmm1, %xmm2
        shufps  $85, %xmm1, %xmm2
        addss   %xmm2, %xmm0
        movaps  %xmm1, %xmm2
        unpckhps        %xmm1, %xmm2
        shufps  $255, %xmm1, %xmm1
        addss   %xmm2, %xmm0
        movlps  -16(%rcx), %xmm2
        movhps  -8(%rcx), %xmm2
        addss   %xmm1, %xmm0
        movlps  -16(%rdx), %xmm1
        movhps  -8(%rdx), %xmm1
        cmpl    (%rsp), %esi
        subps   %xmm1, %xmm2
        mulps   %xmm2, %xmm2
        addss   %xmm2, %xmm0
        movaps  %xmm2, %xmm1
        shufps  $85, %xmm2, %xmm1
        addss   %xmm1, %xmm0
        movaps  %xmm2, %xmm1
        unpckhps        %xmm2, %xmm1
        shufps  $255, %xmm2, %xmm2
        addss   %xmm1, %xmm0
        movaps  %xmm2, %xmm1
        addss   %xmm0, %xmm1
        jne     .L47
        movl    48(%rsp), %esi
.L46:
        xorl    %eax, %eax
.L48:
        movlps  (%rcx,%rax), %xmm0
        movlps  (%rdx,%rax), %xmm2
        incl    %esi
        movhps  8(%rdx,%rax), %xmm2
        movhps  8(%rcx,%rax), %xmm0
        addq    $16, %rax
        cmpl    %esi, %ebx
        subps   %xmm2, %xmm0
        mulps   %xmm0, %xmm0
        addss   %xmm0, %xmm1
        movaps  %xmm0, %xmm2
        shufps  $85, %xmm0, %xmm2
        addss   %xmm2, %xmm1
        movaps  %xmm0, %xmm2
        unpckhps        %xmm0, %xmm2
        shufps  $255, %xmm0, %xmm0
        addss   %xmm2, %xmm1
        addss   %xmm0, %xmm1
        ja      .L48
        cmpl    %ebp, %r15d
        movl    %r15d, %eax
        je      .L44
.L45:
        movslq  %eax, %rcx
        movss   (%r9,%rcx,4), %xmm0
        leaq    0(,%rcx,4), %rdx
        subss   (%r8,%rcx,4), %xmm0
        leal    1(%rax), %ecx
        cmpl    %ecx, %ebp
        mulss   %xmm0, %xmm0
        addss   %xmm0, %xmm1
        jle     .L44
        movss   4(%r9,%rdx), %xmm0
        addl    $2, %eax
        subss   4(%r8,%rdx), %xmm0
        cmpl    %eax, %ebp
        mulss   %xmm0, %xmm0
        addss   %xmm0, %xmm1
        jle     .L44
        movss   8(%r9,%rdx), %xmm0
        subss   8(%r8,%rdx), %xmm0
        mulss   %xmm0, %xmm0
        addss   %xmm0, %xmm1
.L44:
        comiss  %xmm1, %xmm3
        minss   %xmm3, %xmm1
        leaq    1(%rdi), %rax
        cmova   %r10d, %r12d
        cmpq    %rdi, %r11
        movaps  %xmm1, %xmm3
        je      .L120
        movq    %rax, %rdi
        testl   %ebp, %ebp
        movq    0(%r13,%rdi,8), %r8
        movl    %edi, %r10d
        jg      .L121
.L76:
        movaps  %xmm4, %xmm1
        jmp     .L44
.L19:
        cmpl    $16, %ebp
        jle     .L74
        leaq    100(%rdi), %rdx
        leaq    100(%r8), %rax
        xorl    %ecx, %ecx
.L28:
        movss   -100(%rdx), %xmm0
        prefetcht0      (%rdx)
        prefetcht0      (%rax)
        movss   %xmm0, -100(%rax)
        addl    $16, %ecx
        addq    $64, %rdx
        addq    $64, %rax
        movss   -160(%rdx), %xmm0
        movss   %xmm0, -160(%rax)
        movss   -156(%rdx), %xmm0
        movss   %xmm0, -156(%rax)
        movss   -152(%rdx), %xmm0
        movss   %xmm0, -152(%rax)
        movss   -148(%rdx), %xmm0
        movss   %xmm0, -148(%rax)
        movss   -144(%rdx), %xmm0
        movss   %xmm0, -144(%rax)
        movss   -140(%rdx), %xmm0
        movss   %xmm0, -140(%rax)
        movss   -136(%rdx), %xmm0
        movss   %xmm0, -136(%rax)
        movss   -132(%rdx), %xmm0
        movss   %xmm0, -132(%rax)
        movss   -128(%rdx), %xmm0
        movss   %xmm0, -128(%rax)
        movss   -124(%rdx), %xmm0
        movss   %xmm0, -124(%rax)
        movss   -120(%rdx), %xmm0
        movss   %xmm0, -120(%rax)
        movss   -116(%rdx), %xmm0
        movss   %xmm0, -116(%rax)
        movss   -112(%rdx), %xmm0
        movss   %xmm0, -112(%rax)
        movss   -108(%rdx), %xmm0
        movss   %xmm0, -108(%rax)
        movss   -104(%rdx), %xmm0
        movss   %xmm0, -104(%rax)
        cmpl    80(%rsp), %ecx
        jne     .L28
.L27:
        movslq  %ecx, %rcx
.L30:
        movss   (%rdi,%rcx,4), %xmm0
        movss   %xmm0, (%r8,%rcx,4)
        incq    %rcx
        cmpl    %ecx, %ebp
        jg      .L30
        jmp     .L29
.L120:
        movq    16(%rsp), %r14
.L43:
        movq    8(%rsp), %rax
        cmpl    %r12d, (%rax,%r14,4)
        je      .L53
        addss   %xmm7, %xmm5
.L53:
        movq    8(%rsp), %rax
        movq    40(%rsp), %rdi
        movl    %r12d, (%rax,%r14,4)
        movslq  %r12d, %rax
        incl    (%rdi,%rax,4)
        testl   %ebp, %ebp
        jle     .L60
        cmpl    $2, 24(%rsp)
        movq    32(%rsp), %rdi
        movq    (%rdi,%rax,8), %r8
        jbe     .L80
        cmpl    $4, %ebx
        jbe     .L81
        movq    %r9, %rcx
        movq    %r8, %rdx
        xorl    %esi, %esi
.L59:
        movlps  (%rcx), %xmm0
        movlps  (%rdx), %xmm1
        prefetcht0      320(%rcx)
        movl    %esi, %eax
        addq    $64, %rcx
        addl    $4, %esi
        movhps  8(%rdx), %xmm1
        movhps  -56(%rcx), %xmm0
        prefetcht0      320(%rdx)
        addq    $64, %rdx
        addps   %xmm1, %xmm0
        movlps  -48(%rcx), %xmm1
        movhps  -40(%rcx), %xmm1
        movlps  %xmm0, -64(%rdx)
        movhps  %xmm0, -56(%rdx)
        movlps  -48(%rdx), %xmm0
        movhps  -40(%rdx), %xmm0
        addps   %xmm1, %xmm0
        movlps  -32(%rcx), %xmm1
        movhps  -24(%rcx), %xmm1
        movlps  %xmm0, -48(%rdx)
        movhps  %xmm0, -40(%rdx)
        movlps  -32(%rdx), %xmm0
        movhps  -24(%rdx), %xmm0
        addps   %xmm1, %xmm0
        movlps  -16(%rcx), %xmm1
        movhps  -8(%rcx), %xmm1
        movlps  %xmm0, -32(%rdx)
        movhps  %xmm0, -24(%rdx)
        movlps  -16(%rdx), %xmm0
        movhps  -8(%rdx), %xmm0
        addps   %xmm1, %xmm0
        movlps  %xmm0, -16(%rdx)
        movhps  %xmm0, -8(%rdx)
        cmpl    (%rsp), %eax
        movq    %rdx, %rdi
        jne     .L59
        movl    48(%rsp), %esi
.L58:
        xorl    %eax, %eax
.L61:
        movlps  (%rdx,%rax), %xmm0
        movlps  (%rcx,%rax), %xmm1
        incl    %esi
        movhps  8(%rdx,%rax), %xmm0
        movhps  8(%rcx,%rax), %xmm1
        addps   %xmm1, %xmm0
        movlps  %xmm0, (%rdi,%rax)
        movhps  %xmm0, 8(%rdi,%rax)
        addq    $16, %rax
        cmpl    %esi, %ebx
        ja      .L61
        cmpl    %ebp, %r15d
        movl    %r15d, %eax
        je      .L60
.L57:
        movslq  %eax, %rsi
        leaq    0(,%rsi,4), %rdx
        leaq    (%r8,%rdx), %rcx
        movss   (%rcx), %xmm0
        addss   (%r9,%rsi,4), %xmm0
        movss   %xmm0, (%rcx)
        leal    1(%rax), %ecx
        cmpl    %ecx, %ebp
        jle     .L60
        leaq    4(%r8,%rdx), %rcx
        addl    $2, %eax
        cmpl    %eax, %ebp
        movss   (%rcx), %xmm0
        addss   4(%r9,%rdx), %xmm0
        movss   %xmm0, (%rcx)
        jle     .L60
        leaq    8(%r8,%rdx), %rax
        movss   (%rax), %xmm0
        addss   8(%r9,%rdx), %xmm0
        movss   %xmm0, (%rax)
.L60:
        cmpq    %r14, 64(%rsp)
        leaq    1(%r14), %rax
        je      .L55
        movq    %rax, %r14
        jmp     .L56
.L77:
        movaps  %xmm4, %xmm1
        xorl    %eax, %eax
        jmp     .L45
.L78:
        movaps  %xmm4, %xmm1
        xorl    %esi, %esi
        jmp     .L46
.L119:
        movaps  %xmm4, %xmm5
.L55:
        movl    28(%rsp), %eax
        xorl    %r14d, %r14d
        leal    -1(%rax), %edi
        testl   %eax, %eax
        movq    %rdi, %rsi
        leal    -17(%rbp), %edi
        movl    %edi, 64(%rsp)
        jle     .L64
        movl    %r15d, 104(%rsp)
        movl    %ebx, 108(%rsp)
        movq    40(%rsp), %r15
        movq    32(%rsp), %rbx
        movl    %r12d, 100(%rsp)
        movq    %rsi, %r12
.L65:
        testl   %ebp, %ebp
        jle     .L70
        movl    (%r15,%r14,4), %edx
        movq    (%rbx,%r14,8), %rdi
        testl   %edx, %edx
        jle     .L122
        cmpl    $16, %ebp
        jle     .L82
        movl    64(%rsp), %r10d
        cvtsi2ssl       %edx, %xmm1
        movq    0(%r13,%r14,8), %rdx
        leaq    40(%rdi), %rsi
        movl    $40, %r9d
        xorl    %eax, %eax
        andl    $-16, %r10d
.L69:
        movss   -40(%rsi), %xmm0
        prefetcht0      (%rsi)
        movl    $0x00000000, -40(%rsi)
        divss   %xmm1, %xmm0
        movl    %eax, %ecx
        addq    $64, %rsi
        addl    $16, %eax
        movss   %xmm0, -40(%rdx,%r9)
        movss   -100(%rsi), %xmm0
        movl    $0x00000000, -100(%rsi)
        divss   %xmm1, %xmm0
        movss   %xmm0, -36(%rdx,%r9)
        movss   -96(%rsi), %xmm0
        movl    $0x00000000, -96(%rsi)
        divss   %xmm1, %xmm0
        movss   %xmm0, -32(%rdx,%r9)
        movss   -92(%rsi), %xmm0
        movl    $0x00000000, -92(%rsi)
        divss   %xmm1, %xmm0
        movss   %xmm0, -28(%rdx,%r9)
        movss   -88(%rsi), %xmm0
        movl    $0x00000000, -88(%rsi)
        divss   %xmm1, %xmm0
        movss   %xmm0, -24(%rdx,%r9)
        movss   -84(%rsi), %xmm0
        movl    $0x00000000, -84(%rsi)
        divss   %xmm1, %xmm0
        movss   %xmm0, -20(%rdx,%r9)
        movss   -80(%rsi), %xmm0
        movl    $0x00000000, -80(%rsi)
        divss   %xmm1, %xmm0
        movss   %xmm0, -16(%rdx,%r9)
        movss   -76(%rsi), %xmm0
        movl    $0x00000000, -76(%rsi)
        divss   %xmm1, %xmm0
        movss   %xmm0, -12(%rdx,%r9)
        movss   -72(%rsi), %xmm0
        movl    $0x00000000, -72(%rsi)
        divss   %xmm1, %xmm0
        movss   %xmm0, -8(%rdx,%r9)
        movss   -68(%rsi), %xmm0
        movl    $0x00000000, -68(%rsi)
        divss   %xmm1, %xmm0
        movss   %xmm0, -4(%rdx,%r9)
        movss   -64(%rsi), %xmm0
        divss   %xmm1, %xmm0
        movss   %xmm0, (%rdx,%r9)
        movl    $0x00000000, -64(%rsi)
        movss   -60(%rsi), %xmm0
        movl    $0x00000000, -60(%rsi)
        divss   %xmm1, %xmm0
        movss   %xmm0, 4(%rdx,%r9)
        movss   -56(%rsi), %xmm0
        movl    $0x00000000, -56(%rsi)
        divss   %xmm1, %xmm0
        movss   %xmm0, 8(%rdx,%r9)
        movss   -52(%rsi), %xmm0
        movl    $0x00000000, -52(%rsi)
        divss   %xmm1, %xmm0
        movss   %xmm0, 12(%rdx,%r9)
        movss   -48(%rsi), %xmm0
        movl    $0x00000000, -48(%rsi)
        divss   %xmm1, %xmm0
        movss   %xmm0, 16(%rdx,%r9)
        movss   -44(%rsi), %xmm0
        movl    $0x00000000, -44(%rsi)
        divss   %xmm1, %xmm0
        movss   %xmm0, 20(%rdx,%r9)
        addq    $64, %r9
        cmpl    %ecx, %r10d
        jne     .L69
.L68:
        cltq
.L71:
        movss   (%rdi,%rax,4), %xmm0
        movl    $0x00000000, (%rdi,%rax,4)
        divss   %xmm1, %xmm0
        movss   %xmm0, (%rdx,%rax,4)
        incq    %rax
        cmpl    %eax, %ebp
        jg      .L71
.L70:
        cmpq    %r14, %r12
        leaq    1(%r14), %rax
        movl    $0, (%r15,%r14,4)
        je      .L115
        movq    %rax, %r14
        jmp     .L65
.L122:
        movq    80(%rsp), %rdx
        xorl    %esi, %esi
        movss   %xmm5, 16(%rsp)
        call    memset
        xorps   %xmm4, %xmm4
        movss   16(%rsp), %xmm5
        jmp     .L70
.L115:
        movl    100(%rsp), %r12d
        movl    104(%rsp), %r15d
        movl    108(%rsp), %ebx
.L64:
        comiss  92(%rsp), %xmm5
        ja      .L41
        movq    72(%rsp), %rdi
        call    free
        movq    32(%rsp), %rdi
        call    free
        movq    40(%rsp), %rdi
        call    free
        addq    $120, %rsp
        movq    %r13, %rax
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L80:
        xorl    %eax, %eax
        jmp     .L57
.L81:
        movq    %r8, %rdi
        movq    %r9, %rcx
        movq    %r8, %rdx
        xorl    %esi, %esi
        jmp     .L58
.L82:
        cvtsi2ssl       %edx, %xmm1
        xorl    %eax, %eax
        movq    0(%r13,%r14,8), %rdx
        jmp     .L68
.L73:
        xorl    %esi, %esi
        jmp     .L23
.L118:
        je      .L15
.L117:
        leal    -1(%rbp), %eax
        movl    %eax, 24(%rsp)
        jmp     .L10
.L72:
        movl    $1, %esi
        jmp     .L13
.L74:
        xorl    %ecx, %ecx
        jmp     .L27
.L75:
        movl    $1, %edx
        jmp     .L36
_Z12kmeans_outerPPfiiifPifS0_S1_S0_Pv:
        pushq   %r15
        pushq   %r14
        movq    %r9, %r14
        pushq   %r13
        movl    %esi, %r13d
        andl    $-4, %r13d
        pushq   %r12
        pushq   %rbp
        movl    %esi, %ebp
        pushq   %rbx
        movl    %esi, %ebx
        shrl    $2, %ebx
        leal    -5(%rbx), %eax
        subq    $168, %rsp
        movq    %rdi, 80(%rsp)
        leal    -1(%rsi), %edi
        movss   %xmm0, 136(%rsp)
        andl    $-4, %eax
        movl    %edx, 124(%rsp)
        movl    %ecx, 76(%rsp)
        movl    %eax, 52(%rsp)
        addl    $4, %eax
        movl    %eax, 96(%rsp)
        movslq  %r13d, %rax
        movq    %r8, 64(%rsp)
        salq    $2, %rax
        movl    %edi, 140(%rsp)
        movq    %rax, 88(%rsp)
        leal    1(%r13), %eax
        movl    %eax, 100(%rsp)
        cltq
        salq    $2, %rax
        movq    %rax, 104(%rsp)
        leal    2(%r13), %eax
        movl    %eax, 120(%rsp)
        cltq
        salq    $2, %rax
        movq    %rax, 112(%rsp)
        movl    %edi, %eax
        leaq    4(,%rax,4), %rax
        movq    %rax, 128(%rsp)
        leal    -17(%rsi), %eax
        andl    $-16, %eax
        movl    %eax, 144(%rsp)
        addl    $16, %eax
        movl    %eax, 148(%rsp)
.L153:
        movl    124(%rsp), %edx
        testl   %edx, %edx
        jle     .L123
        xorps   %xmm4, %xmm4
        movq    %r14, %r9
        movl    140(%rsp), %r14d
        xorl    %r15d, %r15d
        movaps  %xmm4, %xmm1
.L124:
        movl    124(%rsp), %edi
        leal    64(%r15), %eax
        cmpl    %edi, %eax
        cmovg   %edi, %eax
        cmpl    %eax, %r15d
        movl    %eax, 72(%rsp)
        jge     .L164
        movslq  %r15d, %rax
        movq    %rax, 56(%rsp)
        movl    76(%rsp), %eax
        leal    -1(%rax), %r15d
.L138:
        movq    80(%rsp), %rax
        movq    56(%rsp), %rdi
        movq    (%rax,%rdi,8), %r10
        movl    76(%rsp), %eax
        testl   %eax, %eax
        jle     .L126
        xorl    %edi, %edi
        testl   %ebp, %ebp
        movss   .LC1(%rip), %xmm5
        movq    (%r9,%rdi,8), %r8
        movl    %edi, %r11d
        jle     .L165
.L193:
        cmpl    $2, %r14d
        jbe     .L166
        cmpl    $4, %ebx
        movq    %r8, %rdx
        movq    %r10, %rcx
        jbe     .L167
        movaps  %xmm4, %xmm2
        xorl    %eax, %eax
.L130:
        movlps  (%rcx), %xmm3
        movlps  (%rdx), %xmm0
        movl    %eax, %esi
        prefetcht0      256(%rcx)
        addl    $4, %eax
        addq    $64, %rcx
        movhps  8(%rdx), %xmm0
        movhps  -56(%rcx), %xmm3
        prefetcht0      256(%rdx)
        addq    $64, %rdx
        subps   %xmm0, %xmm3
        mulps   %xmm3, %xmm3
        movaps  %xmm3, %xmm0
        addss   %xmm2, %xmm0
        movaps  %xmm3, %xmm2
        shufps  $85, %xmm3, %xmm2
        addss   %xmm2, %xmm0
        movaps  %xmm3, %xmm2
        unpckhps        %xmm3, %xmm2
        shufps  $255, %xmm3, %xmm3
        addss   %xmm2, %xmm0
        movlps  -48(%rcx), %xmm2
        movhps  -40(%rcx), %xmm2
        addss   %xmm3, %xmm0
        movlps  -48(%rdx), %xmm3
        movhps  -40(%rdx), %xmm3
        subps   %xmm3, %xmm2
        mulps   %xmm2, %xmm2
        addss   %xmm2, %xmm0
        movaps  %xmm2, %xmm3
        shufps  $85, %xmm2, %xmm3
        addss   %xmm3, %xmm0
        movaps  %xmm2, %xmm3
        unpckhps        %xmm2, %xmm3
        shufps  $255, %xmm2, %xmm2
        addss   %xmm3, %xmm0
        movlps  -32(%rdx), %xmm3
        movhps  -24(%rdx), %xmm3
        addss   %xmm2, %xmm0
        movlps  -32(%rcx), %xmm2
        movhps  -24(%rcx), %xmm2
        subps   %xmm3, %xmm2
        mulps   %xmm2, %xmm2
        addss   %xmm2, %xmm0
        movaps  %xmm2, %xmm3
        shufps  $85, %xmm2, %xmm3
        addss   %xmm3, %xmm0
        movaps  %xmm2, %xmm3
        unpckhps        %xmm2, %xmm3
        shufps  $255, %xmm2, %xmm2
        addss   %xmm3, %xmm0
        movlps  -16(%rcx), %xmm3
        movhps  -8(%rcx), %xmm3
        addss   %xmm2, %xmm0
        movlps  -16(%rdx), %xmm2
        movhps  -8(%rdx), %xmm2
        cmpl    52(%rsp), %esi
        subps   %xmm2, %xmm3
        mulps   %xmm3, %xmm3
        addss   %xmm3, %xmm0
        movaps  %xmm3, %xmm2
        shufps  $85, %xmm3, %xmm2
        addss   %xmm2, %xmm0
        movaps  %xmm3, %xmm2
        unpckhps        %xmm3, %xmm2
        shufps  $255, %xmm3, %xmm3
        addss   %xmm2, %xmm0
        movaps  %xmm3, %xmm2
        addss   %xmm0, %xmm2
        jne     .L130
        movl    96(%rsp), %esi
.L129:
        xorl    %eax, %eax
.L131:
        movlps  (%rcx,%rax), %xmm0
        movlps  (%rdx,%rax), %xmm3
        incl    %esi
        movhps  8(%rdx,%rax), %xmm3
        movhps  8(%rcx,%rax), %xmm0
        addq    $16, %rax
        cmpl    %esi, %ebx
        subps   %xmm3, %xmm0
        mulps   %xmm0, %xmm0
        addss   %xmm0, %xmm2
        movaps  %xmm0, %xmm3
        shufps  $85, %xmm0, %xmm3
        addss   %xmm3, %xmm2
        movaps  %xmm0, %xmm3
        unpckhps        %xmm0, %xmm3
        shufps  $255, %xmm0, %xmm0
        addss   %xmm3, %xmm2
        addss   %xmm0, %xmm2
        ja      .L131
        cmpl    %r13d, %ebp
        movl    %r13d, %eax
        je      .L127
.L128:
        movslq  %eax, %rcx
        movss   (%r10,%rcx,4), %xmm0
        leaq    0(,%rcx,4), %rdx
        subss   (%r8,%rcx,4), %xmm0
        leal    1(%rax), %ecx
        cmpl    %ecx, %ebp
        mulss   %xmm0, %xmm0
        addss   %xmm0, %xmm2
        jle     .L127
        movss   4(%r10,%rdx), %xmm0
        addl    $2, %eax
        subss   4(%r8,%rdx), %xmm0
        cmpl    %eax, %ebp
        mulss   %xmm0, %xmm0
        addss   %xmm0, %xmm2
        jle     .L127
        movss   8(%r10,%rdx), %xmm0
        subss   8(%r8,%rdx), %xmm0
        mulss   %xmm0, %xmm0
        addss   %xmm0, %xmm2
.L127:
        comiss  %xmm2, %xmm5
        minss   %xmm5, %xmm2
        leaq    1(%rdi), %rax
        cmova   %r11d, %r12d
        cmpq    %r15, %rdi
        movaps  %xmm2, %xmm5
        je      .L126
        movq    %rax, %rdi
        testl   %ebp, %ebp
        movq    (%r9,%rdi,8), %r8
        movl    %edi, %r11d
        jg      .L193
.L165:
        movaps  %xmm4, %xmm2
        jmp     .L127
.L126:
        movq    64(%rsp), %rax
        movq    56(%rsp), %rdi
        cmpl    %r12d, (%rax,%rdi,4)
        je      .L136
        addss   .LC2(%rip), %xmm1
.L136:
        movq    64(%rsp), %rax
        movq    56(%rsp), %rdi
        movl    %r12d, (%rax,%rdi,4)
        movq    224(%rsp), %rdi
        movslq  %r12d, %rax
        incl    (%rdi,%rax,4)
        testl   %ebp, %ebp
        jle     .L142
        movq    232(%rsp), %rdi
        movq    (%rdi,%rax,8), %r8
        leaq    15(%r10), %rax
        subq    %r8, %rax
        cmpq    $30, %rax
        jbe     .L139
        cmpl    $3, %r14d
        jbe     .L139
        cmpl    $4, %ebx
        jbe     .L169
        movq    %r10, %rcx
        movq    %r8, %rdx
        xorl    %esi, %esi
.L141:
        movlps  (%rcx), %xmm0
        movlps  (%rdx), %xmm2
        prefetcht0      320(%rcx)
        movl    %esi, %eax
        addq    $64, %rcx
        addl    $4, %esi
        movhps  -56(%rcx), %xmm0
        movhps  8(%rdx), %xmm2
        prefetcht0      320(%rdx)
        addq    $64, %rdx
        addps   %xmm2, %xmm0
        movlps  %xmm0, -64(%rdx)
        movhps  %xmm0, -56(%rdx)
        movlps  -48(%rdx), %xmm0
        movlps  -48(%rcx), %xmm2
        movhps  -40(%rdx), %xmm0
        movhps  -40(%rcx), %xmm2
        addps   %xmm2, %xmm0
        movlps  %xmm0, -48(%rdx)
        movhps  %xmm0, -40(%rdx)
        movlps  -32(%rdx), %xmm0
        movlps  -32(%rcx), %xmm2
        movhps  -24(%rdx), %xmm0
        movhps  -24(%rcx), %xmm2
        addps   %xmm2, %xmm0
        movlps  %xmm0, -32(%rdx)
        movhps  %xmm0, -24(%rdx)
        movlps  -16(%rdx), %xmm0
        movlps  -16(%rcx), %xmm2
        movhps  -8(%rdx), %xmm0
        movhps  -8(%rcx), %xmm2
        addps   %xmm2, %xmm0
        movlps  %xmm0, -16(%rdx)
        movhps  %xmm0, -8(%rdx)
        cmpl    52(%rsp), %eax
        movq    %rdx, %rdi
        jne     .L141
        movl    96(%rsp), %esi
.L140:
        xorl    %eax, %eax
.L143:
        movlps  (%rdx,%rax), %xmm0
        movlps  (%rcx,%rax), %xmm2
        incl    %esi
        movhps  8(%rdx,%rax), %xmm0
        movhps  8(%rcx,%rax), %xmm2
        addps   %xmm2, %xmm0
        movlps  %xmm0, (%rdi,%rax)
        movhps  %xmm0, 8(%rdi,%rax)
        addq    $16, %rax
        cmpl    %esi, %ebx
        ja      .L143
        cmpl    %r13d, %ebp
        je      .L142
        movq    88(%rsp), %rdi
        cmpl    100(%rsp), %ebp
        leaq    (%r8,%rdi), %rax
        movss   (%rax), %xmm0
        addss   (%r10,%rdi), %xmm0
        movss   %xmm0, (%rax)
        jle     .L142
        movq    104(%rsp), %rdi
        cmpl    120(%rsp), %ebp
        leaq    (%r8,%rdi), %rax
        movss   (%rax), %xmm0
        addss   (%r10,%rdi), %xmm0
        movss   %xmm0, (%rax)
        jle     .L142
        movq    112(%rsp), %rax
        addq    %rax, %r8
        movss   (%r8), %xmm0
        addss   (%r10,%rax), %xmm0
        movss   %xmm0, (%r8)
.L142:
        incq    56(%rsp)
        movq    56(%rsp), %rax
        cmpl    %eax, 72(%rsp)
        jg      .L138
        movl    72(%rsp), %edi
        cmpl    %edi, 124(%rsp)
        jle     .L149
.L195:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L194
.L150:
        movl    72(%rsp), %r15d
        jmp     .L124
.L166:
        movaps  %xmm4, %xmm2
        xorl    %eax, %eax
        jmp     .L128
.L167:
        movaps  %xmm4, %xmm2
        xorl    %esi, %esi
        jmp     .L129
.L139:
        cmpl    $16, %ebp
        jle     .L170
        leaq    80(%r8), %rax
        leaq    80(%r10), %rdx
        xorl    %ecx, %ecx
.L146:
        movss   -80(%rax), %xmm0
        prefetcht0      (%rdx)
        prefetcht0      (%rax)
        addss   -80(%rdx), %xmm0
        addl    $16, %ecx
        addq    $64, %rax
        addq    $64, %rdx
        movss   %xmm0, -144(%rax)
        movss   -140(%rax), %xmm0
        addss   -140(%rdx), %xmm0
        movss   %xmm0, -140(%rax)
        movss   -136(%rax), %xmm0
        addss   -136(%rdx), %xmm0
        movss   %xmm0, -136(%rax)
        movss   -132(%rax), %xmm0
        addss   -132(%rdx), %xmm0
        movss   %xmm0, -132(%rax)
        movss   -128(%rax), %xmm0
        addss   -128(%rdx), %xmm0
        movss   %xmm0, -128(%rax)
        movss   -124(%rax), %xmm0
        addss   -124(%rdx), %xmm0
        movss   %xmm0, -124(%rax)
        movss   -120(%rax), %xmm0
        addss   -120(%rdx), %xmm0
        movss   %xmm0, -120(%rax)
        movss   -116(%rax), %xmm0
        addss   -116(%rdx), %xmm0
        movss   %xmm0, -116(%rax)
        movss   -112(%rax), %xmm0
        addss   -112(%rdx), %xmm0
        movss   %xmm0, -112(%rax)
        movss   -108(%rax), %xmm0
        addss   -108(%rdx), %xmm0
        movss   %xmm0, -108(%rax)
        movss   -104(%rax), %xmm0
        addss   -104(%rdx), %xmm0
        movss   %xmm0, -104(%rax)
        movss   -100(%rax), %xmm0
        addss   -100(%rdx), %xmm0
        movss   %xmm0, -100(%rax)
        movss   -96(%rax), %xmm0
        addss   -96(%rdx), %xmm0
        movss   %xmm0, -96(%rax)
        movss   -92(%rax), %xmm0
        addss   -92(%rdx), %xmm0
        movss   %xmm0, -92(%rax)
        movss   -88(%rax), %xmm0
        addss   -88(%rdx), %xmm0
        movss   %xmm0, -88(%rax)
        movss   -84(%rax), %xmm0
        addss   -84(%rdx), %xmm0
        movss   %xmm0, -84(%rax)
        cmpl    148(%rsp), %ecx
        jne     .L146
.L145:
        movslq  %ecx, %rax
.L148:
        movss   (%r8,%rax,4), %xmm0
        addss   (%r10,%rax,4), %xmm0
        movss   %xmm0, (%r8,%rax,4)
        incq    %rax
        cmpl    %eax, %ebp
        jg      .L148
        jmp     .L142
.L169:
        movq    %r8, %rdi
        movq    %r10, %rcx
        movq    %r8, %rdx
        xorl    %esi, %esi
        jmp     .L140
.L170:
        xorl    %ecx, %ecx
        jmp     .L145
.L164:
        movl    %r15d, 72(%rsp)
        movl    72(%rsp), %edi
        cmpl    %edi, 124(%rsp)
        jg      .L195
.L149:
        movl    76(%rsp), %eax
        xorl    %r15d, %r15d
        movq    %r9, %r14
        leal    -1(%rax), %edi
        testl   %eax, %eax
        movq    %rdi, 56(%rsp)
        jle     .L155
.L156:
        testl   %ebp, %ebp
        jle     .L161
        movq    224(%rsp), %rax
        movl    (%rax,%r15,4), %ecx
        movq    232(%rsp), %rax
        testl   %ecx, %ecx
        movq    (%rax,%r15,8), %rdi
        jle     .L196
        cmpl    $16, %ebp
        jle     .L171
        cvtsi2ssl       %ecx, %xmm0
        movq    (%r14,%r15,8), %rcx
        leaq    40(%rdi), %rdx
        movl    $40, %esi
        xorl    %eax, %eax
.L160:
        movss   -40(%rdx), %xmm2
        prefetcht0      (%rdx)
        movl    %eax, %r8d
        divss   %xmm0, %xmm2
        addl    $16, %eax
        addq    $64, %rdx
        movss   %xmm2, -40(%rcx,%rsi)
        movl    $0x00000000, -104(%rdx)
        movss   -100(%rdx), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, -36(%rcx,%rsi)
        movl    $0x00000000, -100(%rdx)
        movss   -96(%rdx), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, -32(%rcx,%rsi)
        movl    $0x00000000, -96(%rdx)
        movss   -92(%rdx), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, -28(%rcx,%rsi)
        movl    $0x00000000, -92(%rdx)
        movss   -88(%rdx), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, -24(%rcx,%rsi)
        movl    $0x00000000, -88(%rdx)
        movss   -84(%rdx), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, -20(%rcx,%rsi)
        movl    $0x00000000, -84(%rdx)
        movss   -80(%rdx), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, -16(%rcx,%rsi)
        movl    $0x00000000, -80(%rdx)
        movss   -76(%rdx), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, -12(%rcx,%rsi)
        movl    $0x00000000, -76(%rdx)
        movss   -72(%rdx), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, -8(%rcx,%rsi)
        movl    $0x00000000, -72(%rdx)
        movss   -68(%rdx), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, -4(%rcx,%rsi)
        movl    $0x00000000, -68(%rdx)
        movss   -64(%rdx), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, (%rcx,%rsi)
        movl    $0x00000000, -64(%rdx)
        movss   -60(%rdx), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, 4(%rcx,%rsi)
        movl    $0x00000000, -60(%rdx)
        movss   -56(%rdx), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, 8(%rcx,%rsi)
        movl    $0x00000000, -56(%rdx)
        movss   -52(%rdx), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, 12(%rcx,%rsi)
        movl    $0x00000000, -52(%rdx)
        movss   -48(%rdx), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, 16(%rcx,%rsi)
        movl    $0x00000000, -48(%rdx)
        movss   -44(%rdx), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, 20(%rcx,%rsi)
        movl    $0x00000000, -44(%rdx)
        addq    $64, %rsi
        cmpl    %r8d, 144(%rsp)
        jne     .L160
.L159:
        cltq
.L162:
        movss   (%rdi,%rax,4), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, (%rcx,%rax,4)
        movl    $0x00000000, (%rdi,%rax,4)
        incq    %rax
        cmpl    %eax, %ebp
        jg      .L162
.L161:
        cmpq    %r15, 56(%rsp)
        movq    224(%rsp), %rax
        movl    $0, (%rax,%r15,4)
        leaq    1(%r15), %rax
        je      .L155
        movq    %rax, %r15
        jmp     .L156
.L194:
        movq    240(%rsp), %rax
        movl    124(%rsp), %edx
        movl    %ebp, %esi
        movl    %edi, 16(%rsp)
        movq    64(%rsp), %r8
        movss   %xmm1, 56(%rsp)
        movl    76(%rsp), %ecx
        movq    80(%rsp), %rdi
        movq    %rax, 32(%rsp)
        movq    232(%rsp), %rax
        movl    %edx, 24(%rsp)
        movss   136(%rsp), %xmm0
        movq    %r9, 152(%rsp)
        movq    %rax, 8(%rsp)
        movq    224(%rsp), %rax
        movq    %rax, (%rsp)
        call    _Z20kmeans_outer_handlerPPfiiifPifS0_S1_S0_iiPv
        testl   %eax, %eax
        movq    152(%rsp), %r9
        xorps   %xmm4, %xmm4
        movss   56(%rsp), %xmm1
        je      .L150
.L123:
        addq    $168, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L196:
        movq    128(%rsp), %rdx
        xorl    %esi, %esi
        movss   %xmm1, 72(%rsp)
        call    memset
        movss   72(%rsp), %xmm1
        jmp     .L161
.L155:
        comiss  136(%rsp), %xmm1
        ja      .L153
        jmp     .L123
.L171:
        cvtsi2ssl       %ecx, %xmm0
        xorl    %eax, %eax
        movq    (%r14,%r15,8), %rcx
        jmp     .L159
_Z12kmeans_innerPPfiiifPiS_S0_S1_S0_iiPv:
        pushq   %r15
        pushq   %r14
        pushq   %r13
        pushq   %r12
        pushq   %rbp
        pushq   %rbx
        subq    $152, %rsp
        movl    %edx, 132(%rsp)
        movl    232(%rsp), %edx
        cmpl    240(%rsp), %edx
        movq    208(%rsp), %r15
        movq    %rdi, 80(%rsp)
        movl    %ecx, 76(%rsp)
        movq    %r8, 64(%rsp)
        movq    %r9, 120(%rsp)
        jge     .L197
        movl    %esi, %ebx
        movl    %esi, %r12d
        leal    -1(%rsi), %r13d
        shrl    $2, %ebx
        andl    $-4, %r12d
        movl    %esi, %r14d
        leal    -5(%rbx), %eax
        movaps  %xmm0, %xmm6
        movss   (%r9), %xmm5
        andl    $-4, %eax
        movl    %eax, 52(%rsp)
        addl    $4, %eax
        movl    %eax, 88(%rsp)
        movslq  %r12d, %rax
        salq    $2, %rax
        movq    %rax, 96(%rsp)
        leal    1(%r12), %eax
        movl    %eax, 92(%rsp)
        cltq
        salq    $2, %rax
        movq    %rax, 104(%rsp)
        leal    2(%r12), %eax
        movl    %eax, 128(%rsp)
        cltq
        salq    $2, %rax
        movq    %rax, 112(%rsp)
        leal    -17(%rsi), %eax
        andl    $-16, %eax
        addl    $16, %eax
        movl    %eax, 136(%rsp)
.L200:
        leal    64(%rdx), %eax
        cmpl    240(%rsp), %eax
        cmovg   240(%rsp), %eax
        cmpl    %eax, %edx
        movl    %eax, 72(%rsp)
        jge     .L227
        movslq  %edx, %rax
        movq    %rax, 56(%rsp)
        movl    76(%rsp), %eax
        leal    -1(%rax), %r11d
.L223:
        movq    80(%rsp), %rax
        movq    56(%rsp), %rdi
        movq    (%rax,%rdi,8), %r9
        movl    76(%rsp), %eax
        testl   %eax, %eax
        jle     .L202
        xorl    %edi, %edi
        testl   %r14d, %r14d
        xorps   %xmm4, %xmm4
        movq    (%r15,%rdi,8), %r8
        movl    %edi, %r10d
        movss   .LC1(%rip), %xmm3
        jle     .L228
.L251:
        cmpl    $2, %r13d
        jbe     .L229
        cmpl    $4, %ebx
        movq    %r8, %rcx
        movq    %r9, %rdx
        jbe     .L230
        movaps  %xmm4, %xmm1
        xorl    %eax, %eax
.L206:
        movlps  (%rdx), %xmm2
        movlps  (%rcx), %xmm0
        movl    %eax, %esi
        prefetcht0      256(%rdx)
        addl    $4, %eax
        addq    $64, %rdx
        movhps  8(%rcx), %xmm0
        movhps  -56(%rdx), %xmm2
        prefetcht0      256(%rcx)
        addq    $64, %rcx
        subps   %xmm0, %xmm2
        mulps   %xmm2, %xmm2
        movaps  %xmm2, %xmm0
        addss   %xmm1, %xmm0
        movaps  %xmm2, %xmm1
        shufps  $85, %xmm2, %xmm1
        addss   %xmm1, %xmm0
        movaps  %xmm2, %xmm1
        unpckhps        %xmm2, %xmm1
        shufps  $255, %xmm2, %xmm2
        addss   %xmm1, %xmm0
        movlps  -48(%rdx), %xmm1
        movhps  -40(%rdx), %xmm1
        addss   %xmm2, %xmm0
        movlps  -48(%rcx), %xmm2
        movhps  -40(%rcx), %xmm2
        subps   %xmm2, %xmm1
        mulps   %xmm1, %xmm1
        addss   %xmm1, %xmm0
        movaps  %xmm1, %xmm2
        shufps  $85, %xmm1, %xmm2
        addss   %xmm2, %xmm0
        movaps  %xmm1, %xmm2
        unpckhps        %xmm1, %xmm2
        shufps  $255, %xmm1, %xmm1
        addss   %xmm2, %xmm0
        movlps  -32(%rcx), %xmm2
        movhps  -24(%rcx), %xmm2
        addss   %xmm1, %xmm0
        movlps  -32(%rdx), %xmm1
        movhps  -24(%rdx), %xmm1
        subps   %xmm2, %xmm1
        mulps   %xmm1, %xmm1
        addss   %xmm1, %xmm0
        movaps  %xmm1, %xmm2
        shufps  $85, %xmm1, %xmm2
        addss   %xmm2, %xmm0
        movaps  %xmm1, %xmm2
        unpckhps        %xmm1, %xmm2
        shufps  $255, %xmm1, %xmm1
        addss   %xmm2, %xmm0
        movlps  -16(%rdx), %xmm2
        movhps  -8(%rdx), %xmm2
        addss   %xmm1, %xmm0
        movlps  -16(%rcx), %xmm1
        movhps  -8(%rcx), %xmm1
        cmpl    52(%rsp), %esi
        subps   %xmm1, %xmm2
        mulps   %xmm2, %xmm2
        addss   %xmm2, %xmm0
        movaps  %xmm2, %xmm1
        shufps  $85, %xmm2, %xmm1
        addss   %xmm1, %xmm0
        movaps  %xmm2, %xmm1
        unpckhps        %xmm2, %xmm1
        shufps  $255, %xmm2, %xmm2
        addss   %xmm1, %xmm0
        movaps  %xmm2, %xmm1
        addss   %xmm0, %xmm1
        jne     .L206
        movl    88(%rsp), %esi
.L205:
        xorl    %eax, %eax
.L207:
        movlps  (%rdx,%rax), %xmm0
        movlps  (%rcx,%rax), %xmm2
        incl    %esi
        movhps  8(%rcx,%rax), %xmm2
        movhps  8(%rdx,%rax), %xmm0
        addq    $16, %rax
        cmpl    %esi, %ebx
        subps   %xmm2, %xmm0
        mulps   %xmm0, %xmm0
        addss   %xmm0, %xmm1
        movaps  %xmm0, %xmm2
        shufps  $85, %xmm0, %xmm2
        addss   %xmm2, %xmm1
        movaps  %xmm0, %xmm2
        unpckhps        %xmm0, %xmm2
        shufps  $255, %xmm0, %xmm0
        addss   %xmm2, %xmm1
        addss   %xmm0, %xmm1
        ja      .L207
        cmpl    %r12d, %r14d
        movl    %r12d, %eax
        je      .L203
.L204:
        movslq  %eax, %rcx
        movss   (%r9,%rcx,4), %xmm0
        leaq    0(,%rcx,4), %rdx
        subss   (%r8,%rcx,4), %xmm0
        leal    1(%rax), %ecx
        cmpl    %ecx, %r14d
        mulss   %xmm0, %xmm0
        addss   %xmm0, %xmm1
        jle     .L203
        movss   4(%r9,%rdx), %xmm0
        addl    $2, %eax
        subss   4(%r8,%rdx), %xmm0
        cmpl    %eax, %r14d
        mulss   %xmm0, %xmm0
        addss   %xmm0, %xmm1
        jle     .L203
        movss   8(%r9,%rdx), %xmm0
        subss   8(%r8,%rdx), %xmm0
        mulss   %xmm0, %xmm0
        addss   %xmm0, %xmm1
.L203:
        comiss  %xmm1, %xmm3
        minss   %xmm3, %xmm1
        leaq    1(%rdi), %rax
        cmova   %r10d, %ebp
        cmpq    %r11, %rdi
        movaps  %xmm1, %xmm3
        je      .L202
        movq    %rax, %rdi
        testl   %r14d, %r14d
        movq    (%r15,%rdi,8), %r8
        movl    %edi, %r10d
        jg      .L251
.L228:
        movaps  %xmm4, %xmm1
        jmp     .L203
.L202:
        movq    64(%rsp), %rax
        movq    56(%rsp), %rdi
        cmpl    %ebp, (%rax,%rdi,4)
        je      .L212
        addss   .LC2(%rip), %xmm5
.L212:
        movq    64(%rsp), %rax
        movq    56(%rsp), %rdi
        movl    %ebp, (%rax,%rdi,4)
        movq    216(%rsp), %rdi
        movslq  %ebp, %rax
        incl    (%rdi,%rax,4)
        testl   %r14d, %r14d
        jle     .L213
        movq    224(%rsp), %rdi
        movq    (%rdi,%rax,8), %r8
        leaq    15(%r9), %rax
        subq    %r8, %rax
        cmpq    $30, %rax
        jbe     .L214
        cmpl    $3, %r13d
        jbe     .L214
        cmpl    $4, %ebx
        jbe     .L232
        movq    %r9, %rcx
        movq    %r8, %rdx
        xorl    %esi, %esi
.L216:
        movlps  (%rcx), %xmm0
        movlps  (%rdx), %xmm1
        prefetcht0      320(%rcx)
        movl    %esi, %eax
        addq    $64, %rcx
        addl    $4, %esi
        movhps  -56(%rcx), %xmm0
        movhps  8(%rdx), %xmm1
        prefetcht0      320(%rdx)
        addq    $64, %rdx
        addps   %xmm1, %xmm0
        movlps  %xmm0, -64(%rdx)
        movhps  %xmm0, -56(%rdx)
        movlps  -48(%rdx), %xmm0
        movlps  -48(%rcx), %xmm1
        movhps  -40(%rdx), %xmm0
        movhps  -40(%rcx), %xmm1
        addps   %xmm1, %xmm0
        movlps  %xmm0, -48(%rdx)
        movhps  %xmm0, -40(%rdx)
        movlps  -32(%rdx), %xmm0
        movlps  -32(%rcx), %xmm1
        movhps  -24(%rdx), %xmm0
        movhps  -24(%rcx), %xmm1
        addps   %xmm1, %xmm0
        movlps  %xmm0, -32(%rdx)
        movhps  %xmm0, -24(%rdx)
        movlps  -16(%rdx), %xmm0
        movlps  -16(%rcx), %xmm1
        movhps  -8(%rdx), %xmm0
        movhps  -8(%rcx), %xmm1
        addps   %xmm1, %xmm0
        movlps  %xmm0, -16(%rdx)
        movhps  %xmm0, -8(%rdx)
        cmpl    52(%rsp), %eax
        movq    %rdx, %rdi
        jne     .L216
        movl    88(%rsp), %esi
.L215:
        xorl    %eax, %eax
.L217:
        movlps  (%rdx,%rax), %xmm0
        movlps  (%rcx,%rax), %xmm1
        incl    %esi
        movhps  8(%rdx,%rax), %xmm0
        movhps  8(%rcx,%rax), %xmm1
        addps   %xmm1, %xmm0
        movlps  %xmm0, (%rdi,%rax)
        movhps  %xmm0, 8(%rdi,%rax)
        addq    $16, %rax
        cmpl    %esi, %ebx
        ja      .L217
        cmpl    %r12d, %r14d
        je      .L213
        movq    96(%rsp), %rdi
        cmpl    92(%rsp), %r14d
        leaq    (%r8,%rdi), %rax
        movss   (%rax), %xmm0
        addss   (%r9,%rdi), %xmm0
        movss   %xmm0, (%rax)
        jle     .L213
        movq    104(%rsp), %rdi
        cmpl    128(%rsp), %r14d
        leaq    (%r8,%rdi), %rax
        movss   (%rax), %xmm0
        addss   (%r9,%rdi), %xmm0
        movss   %xmm0, (%rax)
        jle     .L213
        movq    112(%rsp), %rax
        addq    %rax, %r8
        movss   (%r8), %xmm0
        addss   (%r9,%rax), %xmm0
        movss   %xmm0, (%r8)
.L213:
        incq    56(%rsp)
        movq    56(%rsp), %rax
        cmpl    %eax, 72(%rsp)
        jg      .L223
.L201:
        movl    72(%rsp), %eax
        cmpl    %eax, 240(%rsp)
        jle     .L224
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L252
.L225:
        movl    72(%rsp), %edx
        jmp     .L200
.L229:
        movaps  %xmm4, %xmm1
        xorl    %eax, %eax
        jmp     .L204
.L230:
        movaps  %xmm4, %xmm1
        xorl    %esi, %esi
        jmp     .L205
.L214:
        cmpl    $16, %r14d
        jle     .L233
        leaq    80(%r8), %rax
        leaq    80(%r9), %rdx
        xorl    %ecx, %ecx
.L220:
        movss   -80(%rax), %xmm0
        prefetcht0      (%rdx)
        prefetcht0      (%rax)
        addss   -80(%rdx), %xmm0
        addl    $16, %ecx
        addq    $64, %rax
        addq    $64, %rdx
        movss   %xmm0, -144(%rax)
        movss   -140(%rax), %xmm0
        addss   -140(%rdx), %xmm0
        movss   %xmm0, -140(%rax)
        movss   -136(%rax), %xmm0
        addss   -136(%rdx), %xmm0
        movss   %xmm0, -136(%rax)
        movss   -132(%rax), %xmm0
        addss   -132(%rdx), %xmm0
        movss   %xmm0, -132(%rax)
        movss   -128(%rax), %xmm0
        addss   -128(%rdx), %xmm0
        movss   %xmm0, -128(%rax)
        movss   -124(%rax), %xmm0
        addss   -124(%rdx), %xmm0
        movss   %xmm0, -124(%rax)
        movss   -120(%rax), %xmm0
        addss   -120(%rdx), %xmm0
        movss   %xmm0, -120(%rax)
        movss   -116(%rax), %xmm0
        addss   -116(%rdx), %xmm0
        movss   %xmm0, -116(%rax)
        movss   -112(%rax), %xmm0
        addss   -112(%rdx), %xmm0
        movss   %xmm0, -112(%rax)
        movss   -108(%rax), %xmm0
        addss   -108(%rdx), %xmm0
        movss   %xmm0, -108(%rax)
        movss   -104(%rax), %xmm0
        addss   -104(%rdx), %xmm0
        movss   %xmm0, -104(%rax)
        movss   -100(%rax), %xmm0
        addss   -100(%rdx), %xmm0
        movss   %xmm0, -100(%rax)
        movss   -96(%rax), %xmm0
        addss   -96(%rdx), %xmm0
        movss   %xmm0, -96(%rax)
        movss   -92(%rax), %xmm0
        addss   -92(%rdx), %xmm0
        movss   %xmm0, -92(%rax)
        movss   -88(%rax), %xmm0
        addss   -88(%rdx), %xmm0
        movss   %xmm0, -88(%rax)
        movss   -84(%rax), %xmm0
        addss   -84(%rdx), %xmm0
        movss   %xmm0, -84(%rax)
        cmpl    136(%rsp), %ecx
        jne     .L220
.L219:
        movslq  %ecx, %rax
.L222:
        movss   (%r8,%rax,4), %xmm0
        addss   (%r9,%rax,4), %xmm0
        movss   %xmm0, (%r8,%rax,4)
        incq    %rax
        cmpl    %eax, %r14d
        jg      .L222
        jmp     .L213
.L232:
        movq    %r8, %rdi
        movq    %r9, %rcx
        movq    %r8, %rdx
        xorl    %esi, %esi
        jmp     .L215
.L224:
        movq    120(%rsp), %rax
        movss   %xmm5, (%rax)
.L197:
        addq    $152, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L233:
        xorl    %ecx, %ecx
        jmp     .L219
.L227:
        movl    %edx, 72(%rsp)
        jmp     .L201
.L252:
        movq    248(%rsp), %rax
        movq    120(%rsp), %r9
        movl    %r14d, %esi
        movq    64(%rsp), %r8
        movl    76(%rsp), %ecx
        movss   %xmm5, 140(%rsp)
        movl    132(%rsp), %edx
        movq    80(%rsp), %rdi
        movss   %xmm6, 56(%rsp)
        movss   %xmm5, (%r9)
        movq    %rax, 40(%rsp)
        movl    240(%rsp), %eax
        movaps  %xmm6, %xmm0
        movq    %r15, (%rsp)
        movl    %eax, 32(%rsp)
        movl    72(%rsp), %eax
        movl    %eax, 24(%rsp)
        movq    224(%rsp), %rax
        movq    %rax, 16(%rsp)
        movq    216(%rsp), %rax
        movq    %rax, 8(%rsp)
        call    _Z20kmeans_inner_handlerPPfiiifPiS_S0_S1_S0_iiPv
        testl   %eax, %eax
        movss   56(%rsp), %xmm6
        movss   140(%rsp), %xmm5
        je      .L225
        jmp     .L197
.LC1:
        .long   2139095039
.LC2:
        .long   1065353216
