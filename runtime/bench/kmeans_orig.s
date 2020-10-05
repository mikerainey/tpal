_Z13kmeans_serialPPfiiifPi:
        pushq   %r15
        movslq  %ecx, %rax
        pushq   %r14
        leaq    0(,%rax,8), %r14
        pushq   %r13
        pushq   %r12
        pushq   %rbp
        movl    %esi, %ebp
        pushq   %rbx
        movq    %rax, %rbx
        movl    %ebx, %r15d
        imull   %ebp, %r15d
        subq    $152, %rsp
        movq    %rdi, 56(%rsp)
        movq    %r14, %rdi
        movss   %xmm0, 128(%rsp)
        movl    %edx, 120(%rsp)
        movq    %r8, 8(%rsp)
        movslq  %r15d, %r15
        movl    %eax, 28(%rsp)
        salq    $2, %r15
        movq    %rax, (%rsp)
        call    malloc
        movq    %r15, %rdi
        movq    %rax, %r13
        call    malloc
        decl    %ebx
        movq    %rax, 0(%r13)
        jle     .L111
        movl    28(%rsp), %r11d
        movslq  %ebp, %rsi
        movq    %rax, %rdx
        leaq    0(,%rsi,4), %rdi
        cmpl    $9, %r11d
        jle     .L66
        leal    -10(%r11), %r8d
        movq    %rsi, %r9
        movq    %rsi, %rbx
        leaq    0(,%rsi,8), %r10
        salq    $4, %r9
        leaq    (%rsi,%rsi,2), %rsi
        andl    $-8, %r8d
        leaq    192(%r13), %rcx
        leaq    (%rax,%r9), %rax
        leal    9(%r8), %r11d
        salq    $5, %rbx
        movl    %r11d, 24(%rsp)
        leaq    0(,%rsi,4), %r11
        movl    $1, %esi
.L7:
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
        addq    %rbx, %rdx
        movq    %rax, -192(%rcx)
        movq    %r8, -232(%rcx)
        addq    %r9, %rax
        cmpl    24(%rsp), %esi
        jne     .L7
.L6:
        movslq  %esi, %rsi
        addq    %rdi, %rdx
.L9:
        movq    %rdx, 0(%r13,%rsi,8)
        incq    %rsi
        addq    %rdi, %rdx
        cmpl    %esi, 28(%rsp)
        jg      .L9
.L8:
        testl   %ebp, %ebp
        jle     .L112
        movl    %ebp, %r9d
        movl    %ebp, %r11d
        xorl    %r10d, %r10d
        shrl    $2, %r9d
        andl    $-4, %r11d
        leal    -5(%r9), %eax
        movl    %r11d, %ebx
        salq    $2, %rbx
        andl    $-4, %eax
        movl    %eax, 64(%rsp)
        addl    $4, %eax
        movl    %eax, 72(%rsp)
        leal    1(%r11), %eax
        movl    %eax, 16(%rsp)
        salq    $2, %rax
        movq    %rax, 48(%rsp)
        leal    2(%r11), %eax
        movl    %eax, 32(%rsp)
        salq    $2, %rax
        movq    %rax, 40(%rsp)
        leal    -1(%rbp), %eax
        movl    %eax, 24(%rsp)
        leal    -17(%rbp), %eax
        andl    $-16, %eax
        addl    $16, %eax
        movl    %eax, 96(%rsp)
.L5:
        movq    56(%rsp), %rax
        movq    0(%r13,%r10,8), %r8
        movq    (%rax,%r10,8), %rdi
        leaq    15(%rdi), %rax
        subq    %r8, %rax
        cmpq    $30, %rax
        jbe     .L12
        cmpl    $8, 24(%rsp)
        jbe     .L12
        cmpl    $4, %r9d
        movq    %r8, %rcx
        movq    %rdi, %rdx
        jbe     .L67
        xorl    %eax, %eax
.L17:
        movlps  (%rdx), %xmm0
        prefetcht0      464(%rdx)
        movl    %eax, %esi
        addq    $64, %rdx
        addl    $4, %eax
        prefetcht0      464(%rcx)
        movhps  -56(%rdx), %xmm0
        addq    $64, %rcx
        movlps  %xmm0, -64(%rcx)
        movhps  %xmm0, -56(%rcx)
        movlps  -48(%rdx), %xmm0
        movhps  -40(%rdx), %xmm0
        movlps  %xmm0, -48(%rcx)
        movhps  %xmm0, -40(%rcx)
        movlps  -32(%rdx), %xmm0
        movhps  -24(%rdx), %xmm0
        movlps  %xmm0, -32(%rcx)
        movhps  %xmm0, -24(%rcx)
        movlps  -16(%rdx), %xmm0
        movhps  -8(%rdx), %xmm0
        movlps  %xmm0, -16(%rcx)
        movhps  %xmm0, -8(%rcx)
        cmpl    64(%rsp), %esi
        jne     .L17
        movl    72(%rsp), %esi
.L16:
        xorl    %eax, %eax
.L18:
        movlps  (%rdx,%rax), %xmm0
        incl    %esi
        movhps  8(%rdx,%rax), %xmm0
        movlps  %xmm0, (%rcx,%rax)
        movhps  %xmm0, 8(%rcx,%rax)
        addq    $16, %rax
        cmpl    %esi, %r9d
        ja      .L18
        cmpl    %ebp, %r11d
        je      .L22
        cmpl    16(%rsp), %ebp
        movss   (%rdi,%rbx), %xmm0
        movss   %xmm0, (%r8,%rbx)
        jle     .L22
        movq    48(%rsp), %rax
        cmpl    32(%rsp), %ebp
        movss   (%rdi,%rax), %xmm0
        movss   %xmm0, (%r8,%rax)
        jle     .L22
        movq    40(%rsp), %rax
        movss   (%rdi,%rax), %xmm0
        movss   %xmm0, (%r8,%rax)
.L22:
        incq    %r10
        cmpl    %r10d, 28(%rsp)
        jg      .L5
.L4:
        movl    120(%rsp), %esi
        testl   %esi, %esi
        jle     .L24
.L13:
        movl    120(%rsp), %eax
        movq    8(%rsp), %rdi
        movl    $255, %esi
        decl    %eax
        leaq    4(,%rax,4), %rdx
        call    memset
.L24:
        movq    (%rsp), %rdi
        salq    $2, %rdi
        call    _Z8mycallocm
        movq    %r14, %rdi
        movq    %rax, 40(%rsp)
        call    malloc
        movq    %r15, %rdi
        movq    %rax, %rbx
        movq    %rax, 32(%rsp)
        call    _Z8mycallocm
        cmpl    $1, 28(%rsp)
        movq    %rax, 80(%rsp)
        movq    %rax, (%rbx)
        jle     .L14
        movl    28(%rsp), %ebx
        movslq  %ebp, %rdx
        leaq    0(,%rdx,4), %rcx
        cmpl    $9, %ebx
        jle     .L69
        movq    %rax, %r15
        leal    -10(%rbx), %esi
        movq    %rdx, %r8
        movq    32(%rsp), %rax
        movq    %rdx, %r11
        leaq    0(,%rdx,8), %r9
        salq    $4, %r8
        leaq    (%rdx,%rdx,2), %rdx
        andl    $-8, %esi
        leaq    (%r15,%r8), %rdi
        leal    9(%rsi), %ebx
        salq    $5, %r11
        leaq    0(,%rdx,4), %r10
        addq    $192, %rax
        movl    $1, %edx
        movq    %r15, %rsi
.L26:
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
        jne     .L26
        movq    %rsi, 80(%rsp)
        movq    %rsi, %rax
.L25:
        movslq  %edx, %rdx
        addq    %rcx, %rax
.L27:
        movq    32(%rsp), %rbx
        movq    %rax, (%rbx,%rdx,8)
        incq    %rdx
        addq    %rcx, %rax
        cmpl    %edx, 28(%rsp)
        jg      .L27
        movq    (%rbx), %rax
        movq    %rax, 80(%rsp)
.L14:
        xorps   %xmm4, %xmm4
        movl    %ebp, %ebx
        movl    %ebp, %r14d
        shrl    $2, %ebx
        andl    $-4, %r14d
        leal    -5(%rbx), %eax
        andl    $-4, %eax
        movl    %eax, (%rsp)
        addl    $4, %eax
        movl    %eax, 48(%rsp)
        movslq  %r14d, %rax
        salq    $2, %rax
        movq    %rax, 72(%rsp)
        leal    1(%r14), %eax
        movl    %eax, 96(%rsp)
        cltq
        salq    $2, %rax
        movq    %rax, 88(%rsp)
        leal    2(%r14), %eax
        movl    %eax, 100(%rsp)
        cltq
        salq    $2, %rax
        movq    %rax, 104(%rsp)
        movl    24(%rsp), %eax
        leaq    4(,%rax,4), %rax
        movq    %rax, 112(%rsp)
        leal    -17(%rbp), %eax
        andl    $-16, %eax
        movl    %eax, 124(%rsp)
        addl    $16, %eax
        movl    %eax, 132(%rsp)
.L30:
        movl    120(%rsp), %ecx
        testl   %ecx, %ecx
        jle     .L113
        movaps  %xmm4, %xmm5
        movl    120(%rsp), %eax
        xorl    %r15d, %r15d
        decl    %eax
        movq    %rax, 64(%rsp)
        movl    28(%rsp), %eax
        leal    -1(%rax), %r11d
.L45:
        movl    28(%rsp), %edx
        movq    56(%rsp), %rax
        testl   %edx, %edx
        movq    (%rax,%r15,8), %r9
        jle     .L32
        movss   .LC1(%rip), %xmm3
        xorl    %edi, %edi
        testl   %ebp, %ebp
        movq    %r15, 16(%rsp)
        movq    0(%r13,%rdi,8), %r8
        movl    %edi, %r10d
        movl    24(%rsp), %r15d
        jle     .L70
.L115:
        cmpl    $2, %r15d
        jbe     .L71
        cmpl    $4, %ebx
        movq    %r8, %rcx
        movq    %r9, %rdx
        jbe     .L72
        movaps  %xmm4, %xmm1
        xorl    %eax, %eax
.L36:
        movlps  (%rdx), %xmm6
        movlps  (%rcx), %xmm0
        movl    %eax, %esi
        prefetcht0      256(%rdx)
        addl    $4, %eax
        addq    $64, %rdx
        movhps  8(%rcx), %xmm0
        movhps  -56(%rdx), %xmm6
        prefetcht0      256(%rcx)
        addq    $64, %rcx
        subps   %xmm0, %xmm6
        mulps   %xmm6, %xmm6
        movaps  %xmm6, %xmm2
        movaps  %xmm6, %xmm0
        shufps  $85, %xmm6, %xmm2
        addss   %xmm1, %xmm0
        movaps  %xmm2, %xmm1
        movlps  -48(%rcx), %xmm2
        addss   %xmm0, %xmm1
        movaps  %xmm6, %xmm0
        movhps  -40(%rcx), %xmm2
        unpckhps        %xmm6, %xmm0
        shufps  $255, %xmm6, %xmm6
        addss   %xmm0, %xmm1
        movlps  -48(%rdx), %xmm0
        movhps  -40(%rdx), %xmm0
        subps   %xmm2, %xmm0
        addss   %xmm6, %xmm1
        movlps  -16(%rdx), %xmm6
        movhps  -8(%rdx), %xmm6
        mulps   %xmm0, %xmm0
        addss   %xmm0, %xmm1
        movaps  %xmm0, %xmm2
        shufps  $85, %xmm0, %xmm2
        addss   %xmm2, %xmm1
        movaps  %xmm0, %xmm2
        unpckhps        %xmm0, %xmm2
        shufps  $255, %xmm0, %xmm0
        addss   %xmm2, %xmm1
        movlps  -32(%rcx), %xmm2
        movhps  -24(%rcx), %xmm2
        addss   %xmm0, %xmm1
        movlps  -32(%rdx), %xmm0
        movhps  -24(%rdx), %xmm0
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
        movlps  -16(%rcx), %xmm0
        movhps  -8(%rcx), %xmm0
        cmpl    (%rsp), %esi
        subps   %xmm0, %xmm6
        mulps   %xmm6, %xmm6
        addss   %xmm6, %xmm1
        movaps  %xmm6, %xmm2
        shufps  $85, %xmm6, %xmm2
        addss   %xmm2, %xmm1
        movaps  %xmm6, %xmm2
        unpckhps        %xmm6, %xmm2
        shufps  $255, %xmm6, %xmm6
        addss   %xmm1, %xmm2
        movaps  %xmm2, %xmm1
        addss   %xmm6, %xmm1
        jne     .L36
        movl    48(%rsp), %esi
.L35:
        xorl    %eax, %eax
.L37:
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
        ja      .L37
        cmpl    %ebp, %r14d
        movl    %r14d, %eax
        je      .L33
.L34:
        movslq  %eax, %rcx
        movss   (%r9,%rcx,4), %xmm0
        leaq    0(,%rcx,4), %rdx
        subss   (%r8,%rcx,4), %xmm0
        leal    1(%rax), %ecx
        cmpl    %ecx, %ebp
        mulss   %xmm0, %xmm0
        addss   %xmm0, %xmm1
        jle     .L33
        movss   4(%r9,%rdx), %xmm0
        addl    $2, %eax
        subss   4(%r8,%rdx), %xmm0
        cmpl    %eax, %ebp
        mulss   %xmm0, %xmm0
        addss   %xmm0, %xmm1
        jle     .L33
        movss   8(%r9,%rdx), %xmm0
        subss   8(%r8,%rdx), %xmm0
        mulss   %xmm0, %xmm0
        addss   %xmm0, %xmm1
.L33:
        comiss  %xmm1, %xmm3
        minss   %xmm3, %xmm1
        leaq    1(%rdi), %rax
        cmova   %r10d, %r12d
        cmpq    %rdi, %r11
        movaps  %xmm1, %xmm3
        je      .L114
        movq    %rax, %rdi
        testl   %ebp, %ebp
        movq    0(%r13,%rdi,8), %r8
        movl    %edi, %r10d
        jg      .L115
.L70:
        movaps  %xmm4, %xmm1
        jmp     .L33
.L12:
        cmpl    $16, %ebp
        jle     .L68
        leaq    100(%rdi), %rdx
        leaq    100(%r8), %rax
        xorl    %ecx, %ecx
.L21:
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
        cmpl    96(%rsp), %ecx
        jne     .L21
.L20:
        movslq  %ecx, %rcx
.L23:
        movss   (%rdi,%rcx,4), %xmm0
        movss   %xmm0, (%r8,%rcx,4)
        incq    %rcx
        cmpl    %ecx, %ebp
        jg      .L23
        jmp     .L22
.L114:
        movq    16(%rsp), %r15
.L32:
        movq    8(%rsp), %rax
        cmpl    %r12d, (%rax,%r15,4)
        je      .L42
        addss   .LC2(%rip), %xmm5
.L42:
        movq    8(%rsp), %rax
        movq    40(%rsp), %rdi
        movl    %r12d, (%rax,%r15,4)
        movslq  %r12d, %rax
        incl    (%rdi,%rax,4)
        testl   %ebp, %ebp
        jle     .L49
        movq    32(%rsp), %rdi
        movq    (%rdi,%rax,8), %r8
        leaq    15(%r9), %rax
        subq    %r8, %rax
        cmpq    $30, %rax
        jbe     .L46
        cmpl    $3, 24(%rsp)
        jbe     .L46
        cmpl    $4, %ebx
        jbe     .L74
        movq    %r9, %rcx
        movq    %r8, %rdx
        xorl    %esi, %esi
.L48:
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
        cmpl    (%rsp), %eax
        movq    %rdx, %rdi
        jne     .L48
        movl    48(%rsp), %esi
.L47:
        xorl    %eax, %eax
.L50:
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
        ja      .L50
        cmpl    %ebp, %r14d
        je      .L49
        movq    72(%rsp), %rdi
        cmpl    96(%rsp), %ebp
        leaq    (%r8,%rdi), %rax
        movss   (%rax), %xmm0
        addss   (%r9,%rdi), %xmm0
        movss   %xmm0, (%rax)
        jle     .L49
        movq    88(%rsp), %rdi
        cmpl    100(%rsp), %ebp
        leaq    (%r8,%rdi), %rax
        movss   (%rax), %xmm0
        addss   (%r9,%rdi), %xmm0
        movss   %xmm0, (%rax)
        jle     .L49
        movq    104(%rsp), %rax
        addq    %rax, %r8
        movss   (%r8), %xmm0
        addss   (%r9,%rax), %xmm0
        movss   %xmm0, (%r8)
.L49:
        cmpq    64(%rsp), %r15
        leaq    1(%r15), %rax
        je      .L44
.L116:
        movq    %rax, %r15
        jmp     .L45
.L71:
        movaps  %xmm4, %xmm1
        xorl    %eax, %eax
        jmp     .L34
.L72:
        movaps  %xmm4, %xmm1
        xorl    %esi, %esi
        jmp     .L35
.L46:
        cmpl    $16, %ebp
        jle     .L75
        leaq    80(%r8), %rax
        leaq    80(%r9), %rdx
        xorl    %ecx, %ecx
.L53:
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
        cmpl    132(%rsp), %ecx
        jne     .L53
.L52:
        movslq  %ecx, %rax
.L55:
        movss   (%r8,%rax,4), %xmm0
        addss   (%r9,%rax,4), %xmm0
        movss   %xmm0, (%r8,%rax,4)
        incq    %rax
        cmpl    %eax, %ebp
        jg      .L55
        cmpq    64(%rsp), %r15
        leaq    1(%r15), %rax
        jne     .L116
.L44:
        movl    28(%rsp), %eax
        xorl    %r15d, %r15d
        testl   %eax, %eax
        leal    -1(%rax), %edi
        jle     .L57
        movl    %r14d, 64(%rsp)
        movl    %r12d, 140(%rsp)
        movq    %r15, %r14
        movq    32(%rsp), %r12
        movl    %ebp, %r15d
        movq    40(%rsp), %rbp
        movl    %ebx, 136(%rsp)
        movq    %rdi, %rbx
.L58:
        testl   %r15d, %r15d
        jle     .L63
        movl    0(%rbp,%r14,4), %edx
        movq    (%r12,%r14,8), %rdi
        testl   %edx, %edx
        jle     .L117
        cmpl    $16, %r15d
        jle     .L76
        cvtsi2ssl       %edx, %xmm1
        movq    0(%r13,%r14,8), %rdx
        leaq    40(%rdi), %rsi
        movl    $40, %r10d
        xorl    %eax, %eax
.L62:
        movss   -40(%rsi), %xmm0
        prefetcht0      (%rsi)
        movl    %eax, %ecx
        divss   %xmm1, %xmm0
        addl    $16, %eax
        addq    $64, %rsi
        movss   %xmm0, -40(%rdx,%r10)
        movl    $0x00000000, -104(%rsi)
        movss   -100(%rsi), %xmm0
        divss   %xmm1, %xmm0
        movss   %xmm0, -36(%rdx,%r10)
        movl    $0x00000000, -100(%rsi)
        movss   -96(%rsi), %xmm0
        divss   %xmm1, %xmm0
        movss   %xmm0, -32(%rdx,%r10)
        movl    $0x00000000, -96(%rsi)
        movss   -92(%rsi), %xmm0
        divss   %xmm1, %xmm0
        movss   %xmm0, -28(%rdx,%r10)
        movl    $0x00000000, -92(%rsi)
        movss   -88(%rsi), %xmm0
        divss   %xmm1, %xmm0
        movss   %xmm0, -24(%rdx,%r10)
        movl    $0x00000000, -88(%rsi)
        movss   -84(%rsi), %xmm0
        divss   %xmm1, %xmm0
        movss   %xmm0, -20(%rdx,%r10)
        movl    $0x00000000, -84(%rsi)
        movss   -80(%rsi), %xmm0
        divss   %xmm1, %xmm0
        movss   %xmm0, -16(%rdx,%r10)
        movl    $0x00000000, -80(%rsi)
        movss   -76(%rsi), %xmm0
        divss   %xmm1, %xmm0
        movss   %xmm0, -12(%rdx,%r10)
        movl    $0x00000000, -76(%rsi)
        movss   -72(%rsi), %xmm0
        divss   %xmm1, %xmm0
        movss   %xmm0, -8(%rdx,%r10)
        movl    $0x00000000, -72(%rsi)
        movss   -68(%rsi), %xmm0
        divss   %xmm1, %xmm0
        movss   %xmm0, -4(%rdx,%r10)
        movl    $0x00000000, -68(%rsi)
        movss   -64(%rsi), %xmm0
        divss   %xmm1, %xmm0
        movss   %xmm0, (%rdx,%r10)
        movl    $0x00000000, -64(%rsi)
        movss   -60(%rsi), %xmm0
        divss   %xmm1, %xmm0
        movss   %xmm0, 4(%rdx,%r10)
        movl    $0x00000000, -60(%rsi)
        movss   -56(%rsi), %xmm0
        divss   %xmm1, %xmm0
        movss   %xmm0, 8(%rdx,%r10)
        movl    $0x00000000, -56(%rsi)
        movss   -52(%rsi), %xmm0
        divss   %xmm1, %xmm0
        movss   %xmm0, 12(%rdx,%r10)
        movl    $0x00000000, -52(%rsi)
        movss   -48(%rsi), %xmm0
        divss   %xmm1, %xmm0
        movss   %xmm0, 16(%rdx,%r10)
        movl    $0x00000000, -48(%rsi)
        movss   -44(%rsi), %xmm0
        divss   %xmm1, %xmm0
        movss   %xmm0, 20(%rdx,%r10)
        movl    $0x00000000, -44(%rsi)
        addq    $64, %r10
        cmpl    %ecx, 124(%rsp)
        jne     .L62
.L61:
        cltq
.L64:
        movss   (%rdi,%rax,4), %xmm0
        divss   %xmm1, %xmm0
        movss   %xmm0, (%rdx,%rax,4)
        movl    $0x00000000, (%rdi,%rax,4)
        incq    %rax
        cmpl    %eax, %r15d
        jg      .L64
.L63:
        cmpq    %r14, %rbx
        leaq    1(%r14), %rax
        movl    $0, 0(%rbp,%r14,4)
        je      .L108
        movq    %rax, %r14
        jmp     .L58
.L117:
        movq    112(%rsp), %rdx
        xorl    %esi, %esi
        movss   %xmm5, 16(%rsp)
        call    memset
        xorps   %xmm4, %xmm4
        movss   16(%rsp), %xmm5
        jmp     .L63
.L108:
        movl    64(%rsp), %r14d
        movl    136(%rsp), %ebx
        movl    %r15d, %ebp
        movl    140(%rsp), %r12d
.L57:
        comiss  128(%rsp), %xmm5
        ja      .L30
        movq    80(%rsp), %rdi
        call    free
        movq    32(%rsp), %rdi
        call    free
        movq    40(%rsp), %rdi
        call    free
        addq    $152, %rsp
        movq    %r13, %rax
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L74:
        movq    %r8, %rdi
        movq    %r9, %rcx
        movq    %r8, %rdx
        xorl    %esi, %esi
        jmp     .L47
.L76:
        cvtsi2ssl       %edx, %xmm1
        xorl    %eax, %eax
        movq    0(%r13,%r14,8), %rdx
        jmp     .L61
.L75:
        xorl    %ecx, %ecx
        jmp     .L52
.L113:
        movaps  %xmm4, %xmm5
        jmp     .L44
.L67:
        xorl    %esi, %esi
        jmp     .L16
.L111:
        je      .L8
        movl    120(%rsp), %eax
        testl   %eax, %eax
        jle     .L65
        leal    -1(%rbp), %eax
        movl    %eax, 24(%rsp)
        jmp     .L13
.L66:
        movl    $1, %esi
        jmp     .L6
.L68:
        xorl    %ecx, %ecx
        jmp     .L20
.L69:
        movl    $1, %edx
        jmp     .L25
.L112:
        leal    -1(%rbp), %eax
        movl    %eax, 24(%rsp)
        jmp     .L4
.L65:
        movq    (%rsp), %rdi
        salq    $2, %rdi
        call    _Z8mycallocm
        movq    %r14, %rdi
        movq    %rax, 40(%rsp)
        call    malloc
        movq    %r15, %rdi
        movq    %rax, %rbx
        movq    %rax, 32(%rsp)
        call    _Z8mycallocm
        movq    %rax, 80(%rsp)
        movq    %rax, (%rbx)
        leal    -1(%rbp), %eax
        movl    %eax, 24(%rsp)
        jmp     .L14
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
.L148:
        movl    124(%rsp), %edx
        testl   %edx, %edx
        jle     .L118
        xorps   %xmm4, %xmm4
        movq    %r14, %r9
        movl    140(%rsp), %r14d
        xorl    %r15d, %r15d
        movaps  %xmm4, %xmm1
.L120:
        movl    124(%rsp), %edi
        leal    64(%r15), %eax
        cmpl    %edi, %eax
        cmovg   %edi, %eax
        cmpl    %eax, %r15d
        movl    %eax, 72(%rsp)
        jge     .L159
        movslq  %r15d, %rax
        movq    %rax, 56(%rsp)
        movl    76(%rsp), %eax
        leal    -1(%rax), %r15d
.L134:
        movq    80(%rsp), %rax
        movq    56(%rsp), %rdi
        movq    (%rax,%rdi,8), %r10
        movl    76(%rsp), %eax
        testl   %eax, %eax
        jle     .L122
        xorl    %edi, %edi
        testl   %ebp, %ebp
        movss   .LC1(%rip), %xmm5
        movq    (%r9,%rdi,8), %r8
        movl    %edi, %r11d
        jle     .L160
.L188:
        cmpl    $2, %r14d
        jbe     .L161
        cmpl    $4, %ebx
        movq    %r8, %rdx
        movq    %r10, %rcx
        jbe     .L162
        movaps  %xmm4, %xmm2
        xorl    %eax, %eax
.L126:
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
        jne     .L126
        movl    96(%rsp), %esi
.L125:
        xorl    %eax, %eax
.L127:
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
        ja      .L127
        cmpl    %r13d, %ebp
        movl    %r13d, %eax
        je      .L123
.L124:
        movslq  %eax, %rcx
        movss   (%r10,%rcx,4), %xmm0
        leaq    0(,%rcx,4), %rdx
        subss   (%r8,%rcx,4), %xmm0
        leal    1(%rax), %ecx
        cmpl    %ecx, %ebp
        mulss   %xmm0, %xmm0
        addss   %xmm0, %xmm2
        jle     .L123
        movss   4(%r10,%rdx), %xmm0
        addl    $2, %eax
        subss   4(%r8,%rdx), %xmm0
        cmpl    %eax, %ebp
        mulss   %xmm0, %xmm0
        addss   %xmm0, %xmm2
        jle     .L123
        movss   8(%r10,%rdx), %xmm0
        subss   8(%r8,%rdx), %xmm0
        mulss   %xmm0, %xmm0
        addss   %xmm0, %xmm2
.L123:
        comiss  %xmm2, %xmm5
        minss   %xmm5, %xmm2
        leaq    1(%rdi), %rax
        cmova   %r11d, %r12d
        cmpq    %r15, %rdi
        movaps  %xmm2, %xmm5
        je      .L122
        movq    %rax, %rdi
        testl   %ebp, %ebp
        movq    (%r9,%rdi,8), %r8
        movl    %edi, %r11d
        jg      .L188
.L160:
        movaps  %xmm4, %xmm2
        jmp     .L123
.L122:
        movq    64(%rsp), %rax
        movq    56(%rsp), %rdi
        cmpl    %r12d, (%rax,%rdi,4)
        je      .L132
        addss   .LC2(%rip), %xmm1
.L132:
        movq    64(%rsp), %rax
        movq    56(%rsp), %rdi
        movl    %r12d, (%rax,%rdi,4)
        movq    224(%rsp), %rdi
        movslq  %r12d, %rax
        incl    (%rdi,%rax,4)
        testl   %ebp, %ebp
        jle     .L138
        movq    232(%rsp), %rdi
        movq    (%rdi,%rax,8), %r8
        leaq    15(%r10), %rax
        subq    %r8, %rax
        cmpq    $30, %rax
        jbe     .L135
        cmpl    $3, %r14d
        jbe     .L135
        cmpl    $4, %ebx
        jbe     .L164
        movq    %r10, %rcx
        movq    %r8, %rdx
        xorl    %esi, %esi
.L137:
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
        jne     .L137
        movl    96(%rsp), %esi
.L136:
        xorl    %eax, %eax
.L139:
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
        ja      .L139
        cmpl    %r13d, %ebp
        je      .L138
        movq    88(%rsp), %rdi
        cmpl    100(%rsp), %ebp
        leaq    (%r8,%rdi), %rax
        movss   (%rax), %xmm0
        addss   (%r10,%rdi), %xmm0
        movss   %xmm0, (%rax)
        jle     .L138
        movq    104(%rsp), %rdi
        cmpl    120(%rsp), %ebp
        leaq    (%r8,%rdi), %rax
        movss   (%rax), %xmm0
        addss   (%r10,%rdi), %xmm0
        movss   %xmm0, (%rax)
        jle     .L138
        movq    112(%rsp), %rax
        addq    %rax, %r8
        movss   (%r8), %xmm0
        addss   (%r10,%rax), %xmm0
        movss   %xmm0, (%r8)
.L138:
        incq    56(%rsp)
        movq    56(%rsp), %rax
        cmpl    %eax, 72(%rsp)
        jg      .L134
        movl    72(%rsp), %edi
        cmpl    %edi, 124(%rsp)
        jle     .L145
.L190:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L189
.L146:
        movl    72(%rsp), %r15d
        jmp     .L120
.L161:
        movaps  %xmm4, %xmm2
        xorl    %eax, %eax
        jmp     .L124
.L162:
        movaps  %xmm4, %xmm2
        xorl    %esi, %esi
        jmp     .L125
.L135:
        cmpl    $16, %ebp
        jle     .L165
        leaq    80(%r8), %rax
        leaq    80(%r10), %rdx
        xorl    %ecx, %ecx
.L142:
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
        jne     .L142
.L141:
        movslq  %ecx, %rax
.L144:
        movss   (%r8,%rax,4), %xmm0
        addss   (%r10,%rax,4), %xmm0
        movss   %xmm0, (%r8,%rax,4)
        incq    %rax
        cmpl    %eax, %ebp
        jg      .L144
        jmp     .L138
.L164:
        movq    %r8, %rdi
        movq    %r10, %rcx
        movq    %r8, %rdx
        xorl    %esi, %esi
        jmp     .L136
.L165:
        xorl    %ecx, %ecx
        jmp     .L141
.L159:
        movl    %r15d, 72(%rsp)
        movl    72(%rsp), %edi
        cmpl    %edi, 124(%rsp)
        jg      .L190
.L145:
        movl    76(%rsp), %eax
        xorl    %r15d, %r15d
        movq    %r9, %r14
        leal    -1(%rax), %edi
        testl   %eax, %eax
        movq    %rdi, 56(%rsp)
        jle     .L151
.L152:
        testl   %ebp, %ebp
        jle     .L157
        movq    224(%rsp), %rax
        movl    (%rax,%r15,4), %ecx
        movq    232(%rsp), %rax
        testl   %ecx, %ecx
        movq    (%rax,%r15,8), %rdi
        jle     .L191
        cmpl    $16, %ebp
        jle     .L166
        cvtsi2ssl       %ecx, %xmm0
        movq    (%r14,%r15,8), %rcx
        leaq    40(%rdi), %rax
        movl    $40, %esi
        xorl    %edx, %edx
.L156:
        movss   -40(%rax), %xmm2
        prefetcht0      (%rax)
        movl    %edx, %r8d
        divss   %xmm0, %xmm2
        addl    $16, %edx
        addq    $64, %rax
        movss   %xmm2, -40(%rcx,%rsi)
        movl    $0x00000000, -104(%rax)
        movss   -100(%rax), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, -36(%rcx,%rsi)
        movl    $0x00000000, -100(%rax)
        movss   -96(%rax), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, -32(%rcx,%rsi)
        movl    $0x00000000, -96(%rax)
        movss   -92(%rax), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, -28(%rcx,%rsi)
        movl    $0x00000000, -92(%rax)
        movss   -88(%rax), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, -24(%rcx,%rsi)
        movl    $0x00000000, -88(%rax)
        movss   -84(%rax), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, -20(%rcx,%rsi)
        movl    $0x00000000, -84(%rax)
        movss   -80(%rax), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, -16(%rcx,%rsi)
        movl    $0x00000000, -80(%rax)
        movss   -76(%rax), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, -12(%rcx,%rsi)
        movl    $0x00000000, -76(%rax)
        movss   -72(%rax), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, -8(%rcx,%rsi)
        movl    $0x00000000, -72(%rax)
        movss   -68(%rax), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, -4(%rcx,%rsi)
        movl    $0x00000000, -68(%rax)
        movss   -64(%rax), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, (%rcx,%rsi)
        movl    $0x00000000, -64(%rax)
        movss   -60(%rax), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, 4(%rcx,%rsi)
        movl    $0x00000000, -60(%rax)
        movss   -56(%rax), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, 8(%rcx,%rsi)
        movl    $0x00000000, -56(%rax)
        movss   -52(%rax), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, 12(%rcx,%rsi)
        movl    $0x00000000, -52(%rax)
        movss   -48(%rax), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, 16(%rcx,%rsi)
        movl    $0x00000000, -48(%rax)
        movss   -44(%rax), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, 20(%rcx,%rsi)
        movl    $0x00000000, -44(%rax)
        addq    $64, %rsi
        cmpl    %r8d, 144(%rsp)
        jne     .L156
.L155:
        movslq  %edx, %rax
.L158:
        movss   (%rdi,%rax,4), %xmm2
        divss   %xmm0, %xmm2
        movss   %xmm2, (%rcx,%rax,4)
        movl    $0x00000000, (%rdi,%rax,4)
        incq    %rax
        cmpl    %eax, %ebp
        jg      .L158
.L157:
        cmpq    %r15, 56(%rsp)
        movq    224(%rsp), %rax
        movl    $0, (%rax,%r15,4)
        leaq    1(%r15), %rax
        je      .L151
        movq    %rax, %r15
        jmp     .L152
.L189:
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
        je      .L146
.L118:
        addq    $168, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L191:
        movq    128(%rsp), %rdx
        xorl    %esi, %esi
        movss   %xmm1, 72(%rsp)
        call    memset
        movss   72(%rsp), %xmm1
        jmp     .L157
.L151:
        comiss  136(%rsp), %xmm1
        ja      .L148
        jmp     .L118
.L166:
        cvtsi2ssl       %ecx, %xmm0
        xorl    %edx, %edx
        movq    (%r14,%r15,8), %rcx
        jmp     .L155
_Z12kmeans_innerPPfiiifPiS_S0_S1_S0_iiPbPv:
        pushq   %r15
        pushq   %r14
        pushq   %r13
        pushq   %r12
        pushq   %rbp
        pushq   %rbx
        subq    $168, %rsp
        movl    %edx, 148(%rsp)
        movl    248(%rsp), %edx
        cmpl    256(%rsp), %edx
        movq    224(%rsp), %r15
        movq    %rdi, 96(%rsp)
        movl    %ecx, 92(%rsp)
        movq    %r8, 80(%rsp)
        movq    %r9, 136(%rsp)
        jge     .L192
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
        movl    %eax, 68(%rsp)
        addl    $4, %eax
        movl    %eax, 112(%rsp)
        movslq  %r12d, %rax
        salq    $2, %rax
        movq    %rax, 104(%rsp)
        leal    1(%r12), %eax
        movl    %eax, 116(%rsp)
        cltq
        salq    $2, %rax
        movq    %rax, 120(%rsp)
        leal    2(%r12), %eax
        movl    %eax, 144(%rsp)
        cltq
        salq    $2, %rax
        movq    %rax, 128(%rsp)
        leal    -17(%rsi), %eax
        andl    $-16, %eax
        addl    $16, %eax
        movl    %eax, 152(%rsp)
.L195:
        leal    64(%rdx), %eax
        cmpl    256(%rsp), %eax
        cmovg   256(%rsp), %eax
        cmpl    %eax, %edx
        movl    %eax, 88(%rsp)
        jge     .L222
        movslq  %edx, %rax
        movq    %rax, 72(%rsp)
        movl    92(%rsp), %eax
        leal    -1(%rax), %r11d
.L218:
        movq    96(%rsp), %rax
        movq    72(%rsp), %rdi
        movq    (%rax,%rdi,8), %r9
        movl    92(%rsp), %eax
        testl   %eax, %eax
        jle     .L197
        xorl    %edi, %edi
        testl   %r14d, %r14d
        xorps   %xmm4, %xmm4
        movq    (%r15,%rdi,8), %r8
        movl    %edi, %r10d
        movss   .LC1(%rip), %xmm3
        jle     .L223
.L246:
        cmpl    $2, %r13d
        jbe     .L224
        cmpl    $4, %ebx
        movq    %r8, %rcx
        movq    %r9, %rdx
        jbe     .L225
        movaps  %xmm4, %xmm1
        xorl    %eax, %eax
.L201:
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
        cmpl    68(%rsp), %esi
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
        jne     .L201
        movl    112(%rsp), %esi
.L200:
        xorl    %eax, %eax
.L202:
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
        ja      .L202
        cmpl    %r12d, %r14d
        movl    %r12d, %eax
        je      .L198
.L199:
        movslq  %eax, %rcx
        movss   (%r9,%rcx,4), %xmm0
        leaq    0(,%rcx,4), %rdx
        subss   (%r8,%rcx,4), %xmm0
        leal    1(%rax), %ecx
        cmpl    %ecx, %r14d
        mulss   %xmm0, %xmm0
        addss   %xmm0, %xmm1
        jle     .L198
        movss   4(%r9,%rdx), %xmm0
        addl    $2, %eax
        subss   4(%r8,%rdx), %xmm0
        cmpl    %eax, %r14d
        mulss   %xmm0, %xmm0
        addss   %xmm0, %xmm1
        jle     .L198
        movss   8(%r9,%rdx), %xmm0
        subss   8(%r8,%rdx), %xmm0
        mulss   %xmm0, %xmm0
        addss   %xmm0, %xmm1
.L198:
        comiss  %xmm1, %xmm3
        minss   %xmm3, %xmm1
        leaq    1(%rdi), %rax
        cmova   %r10d, %ebp
        cmpq    %r11, %rdi
        movaps  %xmm1, %xmm3
        je      .L197
        movq    %rax, %rdi
        testl   %r14d, %r14d
        movq    (%r15,%rdi,8), %r8
        movl    %edi, %r10d
        jg      .L246
.L223:
        movaps  %xmm4, %xmm1
        jmp     .L198
.L197:
        movq    80(%rsp), %rax
        movq    72(%rsp), %rdi
        cmpl    %ebp, (%rax,%rdi,4)
        je      .L207
        addss   .LC2(%rip), %xmm5
.L207:
        movq    80(%rsp), %rax
        movq    72(%rsp), %rdi
        movl    %ebp, (%rax,%rdi,4)
        movq    232(%rsp), %rdi
        movslq  %ebp, %rax
        incl    (%rdi,%rax,4)
        testl   %r14d, %r14d
        jle     .L208
        movq    240(%rsp), %rdi
        movq    (%rdi,%rax,8), %r8
        leaq    15(%r9), %rax
        subq    %r8, %rax
        cmpq    $30, %rax
        jbe     .L209
        cmpl    $3, %r13d
        jbe     .L209
        cmpl    $4, %ebx
        jbe     .L227
        movq    %r9, %rcx
        movq    %r8, %rdx
        xorl    %esi, %esi
.L211:
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
        cmpl    68(%rsp), %eax
        movq    %rdx, %rdi
        jne     .L211
        movl    112(%rsp), %esi
.L210:
        xorl    %eax, %eax
.L212:
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
        ja      .L212
        cmpl    %r12d, %r14d
        je      .L208
        movq    104(%rsp), %rdi
        cmpl    116(%rsp), %r14d
        leaq    (%r8,%rdi), %rax
        movss   (%rax), %xmm0
        addss   (%r9,%rdi), %xmm0
        movss   %xmm0, (%rax)
        jle     .L208
        movq    120(%rsp), %rdi
        cmpl    144(%rsp), %r14d
        leaq    (%r8,%rdi), %rax
        movss   (%rax), %xmm0
        addss   (%r9,%rdi), %xmm0
        movss   %xmm0, (%rax)
        jle     .L208
        movq    128(%rsp), %rax
        addq    %rax, %r8
        movss   (%r8), %xmm0
        addss   (%r9,%rax), %xmm0
        movss   %xmm0, (%r8)
.L208:
        incq    72(%rsp)
        movq    72(%rsp), %rax
        cmpl    %eax, 88(%rsp)
        jg      .L218
        movl    88(%rsp), %eax
        cmpl    %eax, 256(%rsp)
        jle     .L219
.L248:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L247
.L220:
        movl    88(%rsp), %edx
        jmp     .L195
.L224:
        movaps  %xmm4, %xmm1
        xorl    %eax, %eax
        jmp     .L199
.L225:
        movaps  %xmm4, %xmm1
        xorl    %esi, %esi
        jmp     .L200
.L209:
        cmpl    $16, %r14d
        jle     .L228
        leaq    80(%r8), %rax
        leaq    80(%r9), %rdx
        xorl    %ecx, %ecx
.L215:
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
        cmpl    152(%rsp), %ecx
        jne     .L215
.L214:
        movslq  %ecx, %rax
.L217:
        movss   (%r8,%rax,4), %xmm0
        addss   (%r9,%rax,4), %xmm0
        movss   %xmm0, (%r8,%rax,4)
        incq    %rax
        cmpl    %eax, %r14d
        jg      .L217
        jmp     .L208
.L227:
        movq    %r8, %rdi
        movq    %r9, %rcx
        movq    %r8, %rdx
        xorl    %esi, %esi
        jmp     .L210
.L228:
        xorl    %ecx, %ecx
        jmp     .L214
.L222:
        movl    %edx, 88(%rsp)
        movl    88(%rsp), %eax
        cmpl    %eax, 256(%rsp)
        jg      .L248
.L219:
        movq    136(%rsp), %rax
        movss   %xmm5, (%rax)
        movq    264(%rsp), %rax
        movb    $1, (%rax)
.L192:
        addq    $168, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L247:
        movq    272(%rsp), %rax
        movq    136(%rsp), %r9
        movl    %r14d, %esi
        movq    80(%rsp), %r8
        movl    92(%rsp), %ecx
        movss   %xmm5, 156(%rsp)
        movl    148(%rsp), %edx
        movq    96(%rsp), %rdi
        movss   %xmm6, 72(%rsp)
        movss   %xmm5, (%r9)
        movq    %rax, 48(%rsp)
        movq    264(%rsp), %rax
        movaps  %xmm6, %xmm0
        movq    %r15, (%rsp)
        movq    %rax, 40(%rsp)
        movl    256(%rsp), %eax
        movl    %eax, 32(%rsp)
        movl    88(%rsp), %eax
        movl    %eax, 24(%rsp)
        movq    240(%rsp), %rax
        movq    %rax, 16(%rsp)
        movq    232(%rsp), %rax
        movq    %rax, 8(%rsp)
        call    _Z20kmeans_inner_handlerPPfiiifPiS_S0_S1_S0_iiPbPv
        testl   %eax, %eax
        movss   72(%rsp), %xmm6
        movss   156(%rsp), %xmm5
        je      .L220
        jmp     .L192
.LC1:
        .long   2139095039
.LC2:
        .long   1065353216
