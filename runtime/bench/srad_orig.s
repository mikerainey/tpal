_Z11srad_serialiiiiPfS_fS_S_S_S_S_PiS0_S0_S0_f:
        pushq   %r15
        testl   %edi, %edi
        movl    %esi, %eax
        pushq   %r14
        pushq   %r13
        pushq   %r12
        pushq   %rbp
        pushq   %rbx
        movq    64(%rsp), %r8
        movq    72(%rsp), %r10
        movq    80(%rsp), %r11
        movl    %esi, -68(%rsp)
        movq    88(%rsp), %rcx
        movq    56(%rsp), %rsi
        jle     .L1
        testl   %eax, %eax
        jle     .L1
        movslq  %eax, %r15
        decl    %eax
        movq    96(%rsp), %rbp
        leaq    1(%rax), %rdx
        movl    %eax, -4(%rsp)
        movq    %r15, %rax
        movaps  %xmm0, %xmm4
        negq    %rax
        salq    $2, %rax
        movss   .LC0(%rip), %xmm9
        addss   %xmm9, %xmm4
        movq    %rax, -32(%rsp)
        leal    -1(%rdi), %eax
        movq    104(%rsp), %rbx
        movq    120(%rsp), %r14
        xorl    %edi, %edi
        movl    %eax, -8(%rsp)
        leaq    4(%rbp,%rax,4), %rax
        movq    112(%rsp), %r13
        xorps   %xmm6, %xmm6
        movlpd  .LC1(%rip), %xmm5
        movq    %rbx, -64(%rsp)
        movq    %rax, -48(%rsp)
        leaq    0(,%r15,4), %rbx
        movq    %rdx, %rax
        mulss   %xmm0, %xmm4
        movlpd  .LC2(%rip), %xmm3
        negq    %rax
        movq    %rbx, -40(%rsp)
        movlpd  .LC3(%rip), %xmm8
        salq    $2, %rax
        leaq    0(,%rdx,4), %rbx
        movlpd  .LC4(%rip), %xmm7
        movq    %r15, -16(%rsp)
        movq    %rbp, -80(%rsp)
        xorl    %r15d, %r15d
        movq    %rax, -24(%rsp)
.L9:
        movq    -80(%rsp), %r12
        movl    -68(%rsp), %ebp
        movq    -24(%rsp), %rax
        movl    (%r12), %edx
        addq    %rbx, %rax
        movq    %rax, -56(%rsp)
        movq    -64(%rsp), %rax
        imull   %ebp, %edx
        movslq  %edx, %rdx
        leaq    (%r15,%rdx,4), %r12
        movl    (%rax), %edx
        movq    -56(%rsp), %rax
        addq    %r9, %r12
        imull   %ebp, %edx
        movslq  %edx, %rdx
        leaq    (%r15,%rdx,4), %rbp
        addq    %r9, %rbp
        jmp     .L7
.L16:
        movaps  %xmm9, %xmm12
        minss   %xmm2, %xmm12
        movss   %xmm12, (%rcx,%rax)
        addq    $4, %rax
        cmpq    %rax, %rbx
        je      .L19
.L7:
        movss   (%r9,%rax), %xmm13
        movl    (%r14,%rax), %edx
        movss   (%r12,%rax), %xmm2
        subss   %xmm13, %xmm2
        addl    %edi, %edx
        movslq  %edx, %rdx
        movss   %xmm2, (%rsi,%rax)
        movss   0(%rbp,%rax), %xmm2
        subss   %xmm13, %xmm2
        movss   %xmm2, (%r8,%rax)
        movss   (%r9,%rdx,4), %xmm2
        subss   %xmm13, %xmm2
        movl    0(%r13,%rax), %edx
        addl    %edi, %edx
        movss   %xmm2, (%r10,%rax)
        movslq  %edx, %rdx
        movss   (%r9,%rdx,4), %xmm14
        subss   %xmm13, %xmm14
        movss   %xmm14, (%r11,%rax)
        movss   (%rsi,%rax), %xmm12
        movaps  %xmm12, %xmm11
        movss   (%r8,%rax), %xmm2
        mulss   %xmm12, %xmm12
        movss   (%r10,%rax), %xmm15
        addss   %xmm2, %xmm11
        mulss   %xmm2, %xmm2
        addss   %xmm2, %xmm12
        movaps  %xmm15, %xmm2
        addss   %xmm15, %xmm11
        mulss   %xmm15, %xmm2
        movsd   %xmm3, %xmm15
        addss   %xmm14, %xmm11
        mulss   %xmm14, %xmm14
        addss   %xmm12, %xmm2
        divss   %xmm13, %xmm11
        addss   %xmm14, %xmm2
        mulss   %xmm13, %xmm13
        cvtss2sd        %xmm11, %xmm10
        mulss   %xmm11, %xmm11
        divss   %xmm13, %xmm2
        cvtss2sd        %xmm11, %xmm11
        mulsd   %xmm5, %xmm10
        mulsd   %xmm7, %xmm11
        cvtss2sd        %xmm2, %xmm2
        addsd   %xmm3, %xmm10
        mulsd   %xmm8, %xmm2
        cvtsd2ss        %xmm10, %xmm10
        mulss   %xmm10, %xmm10
        subsd   %xmm11, %xmm2
        cvtsd2ss        %xmm2, %xmm2
        divss   %xmm10, %xmm2
        subss   %xmm0, %xmm2
        divss   %xmm4, %xmm2
        cvtss2sd        %xmm2, %xmm2
        addsd   %xmm3, %xmm2
        divsd   %xmm2, %xmm15
        cvtsd2ss        %xmm15, %xmm2
        comiss  %xmm2, %xmm6
        jbe     .L16
        movl    $0x00000000, (%rcx,%rax)
        addq    $4, %rax
        cmpq    %rax, %rbx
        jne     .L7
.L19:
        movq    -32(%rsp), %rdx
        addq    $4, -80(%rsp)
        addq    $4, -64(%rsp)
        addq    -40(%rsp), %rbx
        addl    -68(%rsp), %edi
        movq    -80(%rsp), %rax
        addq    %rdx, %r15
        addq    %rdx, %r14
        addq    %rdx, %r13
        cmpq    %rax, -48(%rsp)
        jne     .L9
        movq    -16(%rsp), %rax
        movl    -8(%rsp), %edx
        cvtss2sd        %xmm1, %xmm1
        movq    104(%rsp), %r13
        movq    112(%rsp), %r12
        xorl    %r14d, %r14d
        mulsd   %xmm1, %xmm5
        xorl    %ebp, %ebp
        movq    %rax, %r15
        salq    $2, %rax
        movq    %rax, -64(%rsp)
        movl    -4(%rsp), %eax
        negq    %r15
        salq    $2, %r15
        leaq    4(%r13,%rdx,4), %rbx
        movq    %r15, -48(%rsp)
        movl    -68(%rsp), %r15d
        movq    %rbx, -80(%rsp)
        incq    %rax
        leaq    0(,%rax,4), %rdi
        negq    %rax
        salq    $2, %rax
        movq    %rax, -56(%rsp)
.L11:
        movl    0(%r13), %edx
        movq    -56(%rsp), %rax
        imull   %r15d, %edx
        addq    %rdi, %rax
        movslq  %edx, %rdx
        leaq    (%r14,%rdx,4), %rbx
        addq    %rcx, %rbx
.L10:
        movss   (%r8,%rax), %xmm0
        movl    (%r12,%rax), %edx
        mulss   (%rbx,%rax), %xmm0
        movss   (%rcx,%rax), %xmm2
        movss   (%rsi,%rax), %xmm3
        mulss   %xmm2, %xmm3
        addl    %ebp, %edx
        mulss   (%r10,%rax), %xmm2
        movslq  %edx, %rdx
        addss   %xmm3, %xmm0
        addss   %xmm2, %xmm0
        movss   (%rcx,%rdx,4), %xmm2
        mulss   (%r11,%rax), %xmm2
        addss   %xmm2, %xmm0
        cvtss2sd        (%r9,%rax), %xmm2
        cvtss2sd        %xmm0, %xmm0
        mulsd   %xmm5, %xmm0
        addsd   %xmm2, %xmm0
        cvtsd2ss        %xmm0, %xmm0
        movss   %xmm0, (%r9,%rax)
        addq    $4, %rax
        cmpq    %rax, %rdi
        jne     .L10
        movq    -48(%rsp), %rax
        addq    -64(%rsp), %rdi
        addq    $4, %r13
        addl    %r15d, %ebp
        addq    %rax, %r14
        addq    %rax, %r12
        cmpq    %r13, -80(%rsp)
        jne     .L11
.L1:
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
_Z14srad_interruptiiiiPfS_fS_S_S_S_S_PiS0_S0_S0_fPv:
        pushq   %r15
        pushq   %r14
        pushq   %r13
        pushq   %r12
        pushq   %rbp
        pushq   %rbx
        subq    $232, %rsp
        testl   %edi, %edi
        movq    288(%rsp), %rbp
        movq    296(%rsp), %r12
        movq    304(%rsp), %r13
        movq    312(%rsp), %r10
        movq    320(%rsp), %r11
        movl    %edi, 204(%rsp)
        movl    %esi, 200(%rsp)
        movl    %edx, 208(%rsp)
        movl    %ecx, 212(%rsp)
        movq    %r8, 216(%rsp)
        jle     .L20
        leal    -1(%rdi), %eax
        movaps  %xmm0, %xmm4
        movlpd  .LC1(%rip), %xmm7
        movq    %r9, %rbx
        movq    %r10, %r15
        movq    %rax, 192(%rsp)
        xorl    %r14d, %r14d
        movq    $0, 144(%rsp)
        movss   .LC0(%rip), %xmm8
        movl    %esi, %r9d
        movq    %r11, %r10
.L31:
        movl    144(%rsp), %eax
        testl   %r9d, %r9d
        movl    %eax, 172(%rsp)
        jle     .L22
        movslq  %r14d, %rax
        movq    352(%rsp), %r11
        xorl    %edx, %edx
        movq    %rax, 160(%rsp)
        negq    %rax
        leal    64(%rdx), %r8d
        salq    $2, %rax
        addq    %rax, %r11
        movq    %rax, 120(%rsp)
        addq    344(%rsp), %rax
        cmpl    %r9d, %r8d
        cmovg   %r9d, %r8d
        cmpl    %r8d, %edx
        movq    %rax, 152(%rsp)
        jge     .L34
.L48:
        movq    160(%rsp), %rsi
        movslq  %edx, %rcx
        movq    328(%rsp), %rdi
        notl    %edx
        movaps  %xmm4, %xmm3
        addl    %r8d, %edx
        movl    %r8d, 136(%rsp)
        movlpd  .LC2(%rip), %xmm2
        leaq    (%rsi,%rcx), %rax
        leaq    1(%rsi,%rcx), %rcx
        movq    144(%rsp), %rsi
        addss   %xmm8, %xmm3
        xorps   %xmm5, %xmm5
        addq    %rdx, %rcx
        salq    $2, %rax
        movq    152(%rsp), %r8
        movl    (%rdi,%rsi,4), %edx
        movq    %rax, 128(%rsp)
        salq    $2, %rcx
        movq    336(%rsp), %rax
        movq    120(%rsp), %rdi
        mulss   %xmm4, %xmm3
        movlpd  .LC3(%rip), %xmm9
        imull   %r9d, %edx
        movlpd  .LC4(%rip), %xmm6
        movslq  %edx, %rdx
        leaq    (%rdi,%rdx,4), %rdi
        movl    (%rax,%rsi,4), %edx
        movq    120(%rsp), %rsi
        movq    128(%rsp), %rax
        addq    %rbx, %rdi
        imull   %r9d, %edx
        movslq  %edx, %rdx
        leaq    (%rsi,%rdx,4), %rsi
        addq    %rbx, %rsi
        jmp     .L29
.L43:
        movaps  %xmm8, %xmm12
        minss   %xmm0, %xmm12
        movss   %xmm12, (%r10,%rax)
        addq    $4, %rax
        cmpq    %rax, %rcx
        je      .L46
.L29:
        movss   (%rbx,%rax), %xmm13
        movl    (%r11,%rax), %edx
        movss   (%rdi,%rax), %xmm0
        subss   %xmm13, %xmm0
        addl    %r14d, %edx
        movslq  %edx, %rdx
        movss   %xmm0, 0(%rbp,%rax)
        movss   (%rsi,%rax), %xmm0
        subss   %xmm13, %xmm0
        movss   %xmm0, (%r12,%rax)
        movss   (%rbx,%rdx,4), %xmm0
        subss   %xmm13, %xmm0
        movl    (%r8,%rax), %edx
        addl    %r14d, %edx
        movss   %xmm0, 0(%r13,%rax)
        movslq  %edx, %rdx
        movss   (%rbx,%rdx,4), %xmm14
        subss   %xmm13, %xmm14
        movss   %xmm14, (%r15,%rax)
        movss   0(%rbp,%rax), %xmm12
        movaps  %xmm12, %xmm11
        movss   (%r12,%rax), %xmm0
        mulss   %xmm12, %xmm12
        movss   0(%r13,%rax), %xmm15
        addss   %xmm0, %xmm11
        mulss   %xmm0, %xmm0
        addss   %xmm0, %xmm12
        movaps  %xmm15, %xmm0
        addss   %xmm15, %xmm11
        mulss   %xmm15, %xmm0
        movsd   %xmm2, %xmm15
        addss   %xmm14, %xmm11
        mulss   %xmm14, %xmm14
        addss   %xmm12, %xmm0
        divss   %xmm13, %xmm11
        addss   %xmm14, %xmm0
        mulss   %xmm13, %xmm13
        cvtss2sd        %xmm11, %xmm10
        mulss   %xmm11, %xmm11
        divss   %xmm13, %xmm0
        cvtss2sd        %xmm11, %xmm11
        mulsd   %xmm7, %xmm10
        mulsd   %xmm6, %xmm11
        cvtss2sd        %xmm0, %xmm0
        addsd   %xmm2, %xmm10
        mulsd   %xmm9, %xmm0
        cvtsd2ss        %xmm10, %xmm10
        mulss   %xmm10, %xmm10
        subsd   %xmm11, %xmm0
        cvtsd2ss        %xmm0, %xmm0
        divss   %xmm10, %xmm0
        subss   %xmm4, %xmm0
        divss   %xmm3, %xmm0
        cvtss2sd        %xmm0, %xmm0
        addsd   %xmm2, %xmm0
        divsd   %xmm0, %xmm15
        cvtsd2ss        %xmm15, %xmm0
        comiss  %xmm0, %xmm5
        jbe     .L43
        movl    $0x00000000, (%r10,%rax)
        addq    $4, %rax
        cmpq    %rax, %rcx
        jne     .L29
.L46:
        movl    136(%rsp), %r8d
        cmpl    %r8d, %r9d
        jle     .L22
.L49:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L47
.L30:
        movl    %r8d, %edx
        leal    64(%rdx), %r8d
        cmpl    %r9d, %r8d
        cmovg   %r9d, %r8d
        cmpl    %r8d, %edx
        jl      .L48
.L34:
        movl    %edx, %r8d
        cmpl    %r8d, %r9d
        jg      .L49
.L22:
        movq    144(%rsp), %rdi
        addl    %r9d, %r14d
        cmpq    %rdi, 192(%rsp)
        leaq    1(%rdi), %rax
        je      .L50
        movq    %rax, 144(%rsp)
        jmp     .L31
.L47:
        movq    360(%rsp), %rax
        movl    204(%rsp), %edi
        movl    %r9d, %esi
        movl    172(%rsp), %edx
        movaps  %xmm4, %xmm0
        movss   %xmm1, 180(%rsp)
        movq    %r11, 184(%rsp)
        movq    %r10, 64(%rsp)
        movq    %rax, 104(%rsp)
        movq    352(%rsp), %rax
        movl    %edi, %ecx
        movss   %xmm4, 176(%rsp)
        movq    %r10, 320(%rsp)
        movl    %r8d, 136(%rsp)
        movl    %r9d, 128(%rsp)
        movq    %rax, 96(%rsp)
        movq    344(%rsp), %rax
        movq    %r15, 56(%rsp)
        movq    %r13, 48(%rsp)
        movq    %r12, 40(%rsp)
        movq    %rbp, 32(%rsp)
        movq    %rbx, 24(%rsp)
        movq    %rax, 88(%rsp)
        movq    336(%rsp), %rax
        movq    %rax, 80(%rsp)
        movq    328(%rsp), %rax
        movq    %rax, 72(%rsp)
        movq    216(%rsp), %rax
        movq    %rax, 16(%rsp)
        movl    212(%rsp), %eax
        movl    %eax, 8(%rsp)
        movl    208(%rsp), %eax
        movl    %eax, (%rsp)
        call    _Z12srad_handleriiiiiiiiPfS_fS_S_S_S_S_PiS0_S0_S0_fPv
        testl   %eax, %eax
        movl    128(%rsp), %r9d
        movl    136(%rsp), %r8d
        movq    320(%rsp), %r10
        movq    184(%rsp), %r11
        movlpd  .LC1(%rip), %xmm7
        movss   176(%rsp), %xmm4
        movss   180(%rsp), %xmm1
        movss   .LC0(%rip), %xmm8
        je      .L30
.L20:
        addq    $232, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L50:
        movl    200(%rsp), %edi
        movq    %r10, %r11
        movq    %r15, %r10
        testl   %edi, %edi
        jle     .L20
        cvtss2sd        %xmm1, %xmm1
        movslq  %edi, %rax
        movq    336(%rsp), %r8
        movq    %rax, %rdx
        salq    $2, %rax
        movq    344(%rsp), %r9
        mulsd   .LC1(%rip), %xmm1
        movq    %rax, 128(%rsp)
        leal    -1(%rdi), %eax
        movq    192(%rsp), %rdi
        negq    %rdx
        xorl    %esi, %esi
        incq    %rax
        leaq    0(,%rdx,4), %r15
        leaq    0(,%rax,4), %rcx
        negq    %rax
        leaq    4(%r8,%rdi,4), %rdi
        leaq    0(,%rax,4), %r14
        movsd   %xmm1, %xmm3
        movq    %rdi, 120(%rsp)
        movq    %r14, 136(%rsp)
        xorl    %edi, %edi
        movq    %rsi, %r14
.L33:
        movl    200(%rsp), %edx
        movq    136(%rsp), %rax
        imull   (%r8), %edx
        addq    %rcx, %rax
        movslq  %edx, %rdx
        leaq    (%r14,%rdx,4), %rsi
        addq    %r11, %rsi
.L32:
        movss   (%r12,%rax), %xmm0
        movl    (%r9,%rax), %edx
        mulss   (%rsi,%rax), %xmm0
        movss   (%r11,%rax), %xmm1
        movss   0(%rbp,%rax), %xmm2
        mulss   %xmm1, %xmm2
        addl    %edi, %edx
        mulss   0(%r13,%rax), %xmm1
        movslq  %edx, %rdx
        addss   %xmm2, %xmm0
        addss   %xmm1, %xmm0
        movss   (%r11,%rdx,4), %xmm1
        mulss   (%r10,%rax), %xmm1
        addss   %xmm1, %xmm0
        cvtss2sd        (%rbx,%rax), %xmm1
        cvtss2sd        %xmm0, %xmm0
        mulsd   %xmm3, %xmm0
        addsd   %xmm1, %xmm0
        cvtsd2ss        %xmm0, %xmm0
        movss   %xmm0, (%rbx,%rax)
        addq    $4, %rax
        cmpq    %rax, %rcx
        jne     .L32
        addl    200(%rsp), %edi
        addq    128(%rsp), %rcx
        addq    $4, %r8
        addq    %r15, %r14
        addq    %r15, %r9
        cmpq    %r8, 120(%rsp)
        jne     .L33
        jmp     .L20
_Z16srad_interrupt_1iiiiiiPfS_fS_S_S_S_S_PiS0_S0_S0_fPv:
        pushq   %r15
        pushq   %r14
        pushq   %r13
        pushq   %r12
        pushq   %rbp
        pushq   %rbx
        subq    $216, %rsp
        cmpl    %ecx, %edx
        movq    280(%rsp), %rbx
        movq    288(%rsp), %rbp
        movq    296(%rsp), %r12
        movq    304(%rsp), %r13
        movq    312(%rsp), %r11
        movq    320(%rsp), %r14
        movl    %edi, 192(%rsp)
        movl    %ecx, 196(%rsp)
        movl    %r8d, 200(%rsp)
        movl    %r9d, 204(%rsp)
        jge     .L51
        movl    %ecx, %edi
        movl    %esi, %r10d
        movl    %edx, %eax
        imull   %edx, %r10d
        movslq  %edx, %rcx
        leal    -1(%rdi), %edx
        movaps  %xmm0, %xmm4
        movlpd  .LC1(%rip), %xmm7
        movl    %edx, %edi
        movq    %rcx, 136(%rsp)
        movl    %esi, %r9d
        subl    %eax, %edi
        movl    %r10d, %r15d
        movq    %r11, %r10
        leaq    1(%rcx,%rdi), %rax
        movss   .LC0(%rip), %xmm8
        movq    %rax, 184(%rsp)
.L62:
        movl    136(%rsp), %eax
        testl   %r9d, %r9d
        movl    %eax, 164(%rsp)
        jle     .L53
        movslq  %r15d, %rax
        movq    352(%rsp), %r11
        xorl    %edx, %edx
        movq    %rax, 144(%rsp)
        negq    %rax
        leal    64(%rdx), %r8d
        salq    $2, %rax
        movq    %r14, 320(%rsp)
        movq    %r10, %r14
        addq    %rax, %r11
        movq    %rax, 120(%rsp)
        addq    344(%rsp), %rax
        cmpl    %r9d, %r8d
        movq    320(%rsp), %r10
        cmovg   %r9d, %r8d
        cmpl    %r8d, %edx
        movq    %rax, 152(%rsp)
        jge     .L63
.L75:
        movq    144(%rsp), %rsi
        movslq  %edx, %rcx
        movq    328(%rsp), %rdi
        notl    %edx
        movaps  %xmm4, %xmm3
        addl    %r8d, %edx
        movl    %r8d, 160(%rsp)
        movlpd  .LC2(%rip), %xmm2
        leaq    (%rsi,%rcx), %rax
        leaq    1(%rsi,%rcx), %rcx
        movq    136(%rsp), %rsi
        addss   %xmm8, %xmm3
        xorps   %xmm5, %xmm5
        addq    %rdx, %rcx
        salq    $2, %rax
        movq    152(%rsp), %r8
        movl    (%rdi,%rsi,4), %edx
        movq    %rax, 128(%rsp)
        salq    $2, %rcx
        movq    336(%rsp), %rax
        movq    120(%rsp), %rdi
        mulss   %xmm4, %xmm3
        movlpd  .LC3(%rip), %xmm9
        imull   %r9d, %edx
        movlpd  .LC4(%rip), %xmm6
        movslq  %edx, %rdx
        leaq    (%rdi,%rdx,4), %rdi
        movl    (%rax,%rsi,4), %edx
        movq    120(%rsp), %rsi
        movq    128(%rsp), %rax
        addq    %rbx, %rdi
        imull   %r9d, %edx
        movslq  %edx, %rdx
        leaq    (%rsi,%rdx,4), %rsi
        addq    %rbx, %rsi
        jmp     .L60
.L70:
        movaps  %xmm8, %xmm12
        minss   %xmm0, %xmm12
        movss   %xmm12, (%r10,%rax)
        addq    $4, %rax
        cmpq    %rax, %rcx
        je      .L73
.L60:
        movss   (%rbx,%rax), %xmm13
        movl    (%r11,%rax), %edx
        movss   (%rdi,%rax), %xmm0
        subss   %xmm13, %xmm0
        addl    %r15d, %edx
        movslq  %edx, %rdx
        movss   %xmm0, 0(%rbp,%rax)
        movss   (%rsi,%rax), %xmm0
        subss   %xmm13, %xmm0
        movss   %xmm0, (%r12,%rax)
        movss   (%rbx,%rdx,4), %xmm0
        subss   %xmm13, %xmm0
        movl    (%r8,%rax), %edx
        addl    %r15d, %edx
        movss   %xmm0, 0(%r13,%rax)
        movslq  %edx, %rdx
        movss   (%rbx,%rdx,4), %xmm14
        subss   %xmm13, %xmm14
        movss   %xmm14, (%r14,%rax)
        movss   0(%rbp,%rax), %xmm12
        movaps  %xmm12, %xmm11
        movss   (%r12,%rax), %xmm0
        mulss   %xmm12, %xmm12
        movss   0(%r13,%rax), %xmm15
        addss   %xmm0, %xmm11
        mulss   %xmm0, %xmm0
        addss   %xmm0, %xmm12
        movaps  %xmm15, %xmm0
        addss   %xmm15, %xmm11
        mulss   %xmm15, %xmm0
        movsd   %xmm2, %xmm15
        addss   %xmm14, %xmm11
        mulss   %xmm14, %xmm14
        addss   %xmm12, %xmm0
        divss   %xmm13, %xmm11
        addss   %xmm14, %xmm0
        mulss   %xmm13, %xmm13
        cvtss2sd        %xmm11, %xmm10
        mulss   %xmm11, %xmm11
        divss   %xmm13, %xmm0
        cvtss2sd        %xmm11, %xmm11
        mulsd   %xmm7, %xmm10
        mulsd   %xmm6, %xmm11
        cvtss2sd        %xmm0, %xmm0
        addsd   %xmm2, %xmm10
        mulsd   %xmm9, %xmm0
        cvtsd2ss        %xmm10, %xmm10
        mulss   %xmm10, %xmm10
        subsd   %xmm11, %xmm0
        cvtsd2ss        %xmm0, %xmm0
        divss   %xmm10, %xmm0
        subss   %xmm4, %xmm0
        divss   %xmm3, %xmm0
        cvtss2sd        %xmm0, %xmm0
        addsd   %xmm2, %xmm0
        divsd   %xmm0, %xmm15
        cvtsd2ss        %xmm15, %xmm0
        comiss  %xmm0, %xmm5
        jbe     .L70
        movl    $0x00000000, (%r10,%rax)
        addq    $4, %rax
        cmpq    %rax, %rcx
        jne     .L60
.L73:
        movl    160(%rsp), %r8d
        cmpl    %r8d, %r9d
        jle     .L71
.L76:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L74
.L61:
        movl    %r8d, %edx
        leal    64(%rdx), %r8d
        cmpl    %r9d, %r8d
        cmovg   %r9d, %r8d
        cmpl    %r8d, %edx
        jl      .L75
.L63:
        movl    %edx, %r8d
        cmpl    %r8d, %r9d
        jg      .L76
.L71:
        movq    %r10, 320(%rsp)
        movq    %r14, %r10
        movq    320(%rsp), %r14
.L53:
        incq    136(%rsp)
        addl    %r9d, %r15d
        movq    136(%rsp), %rax
        cmpq    %rax, 184(%rsp)
        jne     .L62
.L51:
        addq    $216, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L74:
        movq    360(%rsp), %rax
        movl    196(%rsp), %ecx
        movl    %r9d, %esi
        movl    164(%rsp), %edx
        movl    192(%rsp), %edi
        movss   %xmm1, 172(%rsp)
        movaps  %xmm4, %xmm0
        movss   %xmm4, 168(%rsp)
        movq    %rax, 104(%rsp)
        movq    352(%rsp), %rax
        movq    %r11, 176(%rsp)
        movq    %r10, 64(%rsp)
        movq    %r10, 320(%rsp)
        movl    %r8d, 160(%rsp)
        movq    %rax, 96(%rsp)
        movq    344(%rsp), %rax
        movl    %r9d, 128(%rsp)
        movq    %r14, 56(%rsp)
        movq    %r13, 48(%rsp)
        movq    %r12, 40(%rsp)
        movq    %rax, 88(%rsp)
        movq    336(%rsp), %rax
        movq    %rbp, 32(%rsp)
        movq    %rbx, 24(%rsp)
        movq    %rax, 80(%rsp)
        movq    328(%rsp), %rax
        movq    %rax, 72(%rsp)
        movq    272(%rsp), %rax
        movq    %rax, 16(%rsp)
        movl    204(%rsp), %eax
        movl    %eax, 8(%rsp)
        movl    200(%rsp), %eax
        movl    %eax, (%rsp)
        call    _Z14srad_handler_1iiiiiiiiPfS_fS_S_S_S_S_PiS0_S0_S0_fPv
        testl   %eax, %eax
        movl    128(%rsp), %r9d
        movl    160(%rsp), %r8d
        movq    320(%rsp), %r10
        movq    176(%rsp), %r11
        movlpd  .LC1(%rip), %xmm7
        movss   168(%rsp), %xmm4
        movss   172(%rsp), %xmm1
        movss   .LC0(%rip), %xmm8
        je      .L61
        jmp     .L51
_Z22srad_interrupt_inner_1iiiiiiiiPfS_fS_S_S_S_S_PiS0_S0_S0_fPv:
        pushq   %r15
        movslq  %edx, %rax
        pushq   %r14
        pushq   %r13
        pushq   %r12
        pushq   %rbp
        pushq   %rbx
        subq    $200, %rsp
        cmpl    %r9d, %r8d
        movq    280(%rsp), %rbx
        movq    288(%rsp), %rbp
        movq    296(%rsp), %r12
        movq    304(%rsp), %r13
        movq    312(%rsp), %r15
        movl    %edi, 152(%rsp)
        movl    %esi, 124(%rsp)
        movl    %eax, 156(%rsp)
        movl    %ecx, 160(%rsp)
        jge     .L77
        movq    328(%rsp), %rcx
        movq    352(%rsp), %r11
        movl    %r8d, %edx
        imull   %eax, %esi
        salq    $2, %rax
        leal    64(%rdx), %r8d
        movss   .LC0(%rip), %xmm8
        addq    %rax, %rcx
        addq    336(%rsp), %rax
        movl    %esi, %r14d
        movq    %rcx, 128(%rsp)
        movq    %rax, 136(%rsp)
        movslq  %esi, %rax
        movq    %rax, 144(%rsp)
        negq    %rax
        salq    $2, %rax
        addq    %rax, %r11
        movq    %rax, 112(%rsp)
        addq    344(%rsp), %rax
        cmpl    %r9d, %r8d
        cmovg   %r9d, %r8d
        cmpl    %r8d, %edx
        movq    %rax, %r10
        jge     .L89
.L99:
        movq    144(%rsp), %rdi
        movslq  %edx, %rcx
        notl    %edx
        addl    %r8d, %edx
        movl    124(%rsp), %esi
        movl    %r8d, 120(%rsp)
        movaps  %xmm0, %xmm4
        movq    320(%rsp), %r8
        leaq    (%rdi,%rcx), %rax
        leaq    1(%rdi,%rcx), %rcx
        movq    128(%rsp), %rdi
        addss   %xmm8, %xmm4
        xorps   %xmm5, %xmm5
        addq    %rdx, %rcx
        movlpd  .LC1(%rip), %xmm9
        salq    $2, %rax
        movl    (%rdi), %edx
        movq    112(%rsp), %rdi
        salq    $2, %rcx
        movlpd  .LC2(%rip), %xmm3
        mulss   %xmm0, %xmm4
        movlpd  .LC3(%rip), %xmm7
        imull   %esi, %edx
        movlpd  .LC4(%rip), %xmm6
        movslq  %edx, %rdx
        leaq    (%rdi,%rdx,4), %rdi
        movq    136(%rsp), %rdx
        addq    %rbx, %rdi
        imull   (%rdx), %esi
        movslq  %esi, %rdx
        movq    112(%rsp), %rsi
        leaq    (%rsi,%rdx,4), %rsi
        addq    %rbx, %rsi
        jmp     .L86
.L95:
        movaps  %xmm8, %xmm12
        minss   %xmm2, %xmm12
        movss   %xmm12, (%r8,%rax)
        addq    $4, %rax
        cmpq    %rax, %rcx
        je      .L97
.L86:
        movss   (%rbx,%rax), %xmm13
        movl    (%r11,%rax), %edx
        movss   (%rdi,%rax), %xmm2
        subss   %xmm13, %xmm2
        addl    %r14d, %edx
        movslq  %edx, %rdx
        movss   %xmm2, 0(%rbp,%rax)
        movss   (%rsi,%rax), %xmm2
        subss   %xmm13, %xmm2
        movss   %xmm2, (%r12,%rax)
        movss   (%rbx,%rdx,4), %xmm2
        subss   %xmm13, %xmm2
        movl    (%r10,%rax), %edx
        addl    %r14d, %edx
        movss   %xmm2, 0(%r13,%rax)
        movslq  %edx, %rdx
        movss   (%rbx,%rdx,4), %xmm14
        subss   %xmm13, %xmm14
        movss   %xmm14, (%r15,%rax)
        movss   0(%rbp,%rax), %xmm12
        movaps  %xmm12, %xmm11
        movss   (%r12,%rax), %xmm2
        mulss   %xmm12, %xmm12
        movss   0(%r13,%rax), %xmm15
        addss   %xmm2, %xmm11
        mulss   %xmm2, %xmm2
        addss   %xmm2, %xmm12
        movaps  %xmm15, %xmm2
        addss   %xmm15, %xmm11
        mulss   %xmm15, %xmm2
        movsd   %xmm3, %xmm15
        addss   %xmm14, %xmm11
        mulss   %xmm14, %xmm14
        addss   %xmm12, %xmm2
        divss   %xmm13, %xmm11
        addss   %xmm14, %xmm2
        mulss   %xmm13, %xmm13
        cvtss2sd        %xmm11, %xmm10
        mulss   %xmm11, %xmm11
        divss   %xmm13, %xmm2
        cvtss2sd        %xmm11, %xmm11
        mulsd   %xmm9, %xmm10
        mulsd   %xmm6, %xmm11
        cvtss2sd        %xmm2, %xmm2
        addsd   %xmm3, %xmm10
        mulsd   %xmm7, %xmm2
        cvtsd2ss        %xmm10, %xmm10
        mulss   %xmm10, %xmm10
        subsd   %xmm11, %xmm2
        cvtsd2ss        %xmm2, %xmm2
        divss   %xmm10, %xmm2
        subss   %xmm0, %xmm2
        divss   %xmm4, %xmm2
        cvtss2sd        %xmm2, %xmm2
        addsd   %xmm3, %xmm2
        divsd   %xmm2, %xmm15
        cvtsd2ss        %xmm15, %xmm2
        comiss  %xmm2, %xmm5
        jbe     .L95
        movl    $0x00000000, (%r8,%rax)
        addq    $4, %rax
        cmpq    %rax, %rcx
        jne     .L86
.L97:
        movl    120(%rsp), %r8d
        cmpl    %r9d, %r8d
        jge     .L77
.L100:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L98
.L87:
        movl    %r8d, %edx
        leal    64(%rdx), %r8d
        cmpl    %r9d, %r8d
        cmovg   %r9d, %r8d
        cmpl    %r8d, %edx
        jl      .L99
.L89:
        movl    %edx, %r8d
        cmpl    %r9d, %r8d
        jl      .L100
.L77:
        addq    $200, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L98:
        movq    360(%rsp), %rax
        movss   %xmm1, 172(%rsp)
        movq    %r11, 184(%rsp)
        movss   %xmm0, 168(%rsp)
        movq    %r10, 176(%rsp)
        movl    %r9d, 164(%rsp)
        movl    %r8d, 120(%rsp)
        movq    %rax, 104(%rsp)
        movq    352(%rsp), %rax
        movl    160(%rsp), %ecx
        movl    156(%rsp), %edx
        movl    124(%rsp), %esi
        movq    %r15, 56(%rsp)
        movq    %r13, 48(%rsp)
        movq    %rax, 96(%rsp)
        movq    344(%rsp), %rax
        movq    %r12, 40(%rsp)
        movq    %rbp, 32(%rsp)
        movq    %rbx, 24(%rsp)
        movq    %rax, 88(%rsp)
        movq    336(%rsp), %rax
        movq    %rax, 80(%rsp)
        movq    328(%rsp), %rax
        movq    %rax, 72(%rsp)
        movq    320(%rsp), %rax
        movq    %rax, 64(%rsp)
        movq    272(%rsp), %rax
        movq    %rax, 16(%rsp)
        movl    264(%rsp), %eax
        movl    %eax, 8(%rsp)
        movl    256(%rsp), %eax
        movl    %eax, (%rsp)
        movl    152(%rsp), %edi
        call    _Z20srad_handler_inner_1iiiiiiiiPfS_fS_S_S_S_S_PiS0_S0_S0_fPv
        testl   %eax, %eax
        movl    120(%rsp), %r8d
        movl    164(%rsp), %r9d
        movq    176(%rsp), %r10
        movq    184(%rsp), %r11
        movss   168(%rsp), %xmm0
        movss   172(%rsp), %xmm1
        movss   .LC0(%rip), %xmm8
        je      .L87
        jmp     .L77
_Z16srad_interrupt_2iiiiiiiiPfS_fS_S_S_S_S_PiS0_S0_S0_fPv:
        pushq   %r15
        pushq   %r14
        pushq   %r13
        pushq   %r12
        pushq   %rbp
        pushq   %rbx
        subq    $184, %rsp
        cmpl    %ecx, %edx
        movq    264(%rsp), %rbp
        movq    272(%rsp), %r11
        movss   %xmm0, 172(%rsp)
        movq    280(%rsp), %r13
        movq    288(%rsp), %r10
        movq    304(%rsp), %rbx
        movl    %edi, 168(%rsp)
        movl    %ecx, 136(%rsp)
        jge     .L101
        movl    %edx, %r12d
        movl    %esi, %r9d
        movslq  %edx, %rax
        imull   %esi, %r12d
        movq    320(%rsp), %rsi
        movq    %r10, %r14
        movq    296(%rsp), %r10
        movlpd  .LC1(%rip), %xmm3
        movq    %r11, %r15
        leaq    (%rsi,%rax,4), %rax
        movq    %rax, 112(%rsp)
.L108:
        testl   %r9d, %r9d
        jle     .L103
        movslq  %r12d, %rax
        xorl    %ecx, %ecx
        movq    328(%rsp), %r11
        leal    64(%rcx), %r8d
        movq    %rax, 120(%rsp)
        negq    %rax
        salq    $2, %rax
        movq    %r10, 296(%rsp)
        movl    %r12d, %r10d
        addq    %rax, %r11
        cmpl    %r9d, %r8d
        movq    296(%rsp), %r12
        cmovg   %r9d, %r8d
        movq    %rax, 128(%rsp)
        cmpl    %r8d, %ecx
        jge     .L109
.L118:
        movq    120(%rsp), %rdi
        movslq  %ecx, %rsi
        notl    %ecx
        addl    %r8d, %ecx
        cvtss2sd        %xmm1, %xmm4
        leaq    (%rdi,%rsi), %rax
        leaq    1(%rdi,%rsi), %rsi
        movq    112(%rsp), %rdi
        mulsd   %xmm3, %xmm4
        addq    %rcx, %rsi
        salq    $2, %rax
        movl    (%rdi), %ecx
        movq    128(%rsp), %rdi
        salq    $2, %rsi
        imull   %r9d, %ecx
        movslq  %ecx, %rcx
        leaq    (%rdi,%rcx,4), %rdi
        addq    %rbx, %rdi
.L106:
        movss   0(%r13,%rax), %xmm0
        movl    (%r11,%rax), %ecx
        mulss   (%rdi,%rax), %xmm0
        movss   (%rbx,%rax), %xmm2
        movss   (%r15,%rax), %xmm5
        mulss   %xmm2, %xmm5
        addl    %r10d, %ecx
        mulss   (%r14,%rax), %xmm2
        movslq  %ecx, %rcx
        addss   %xmm5, %xmm0
        addss   %xmm2, %xmm0
        movss   (%rbx,%rcx,4), %xmm2
        mulss   (%r12,%rax), %xmm2
        addss   %xmm2, %xmm0
        cvtss2sd        0(%rbp,%rax), %xmm2
        cvtss2sd        %xmm0, %xmm0
        mulsd   %xmm4, %xmm0
        addsd   %xmm2, %xmm0
        cvtsd2ss        %xmm0, %xmm0
        movss   %xmm0, 0(%rbp,%rax)
        addq    $4, %rax
        cmpq    %rax, %rsi
        jne     .L106
        cmpl    %r8d, %r9d
        jle     .L115
.L119:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L117
.L107:
        movl    %r8d, %ecx
        leal    64(%rcx), %r8d
        cmpl    %r9d, %r8d
        cmovg   %r9d, %r8d
        cmpl    %r8d, %ecx
        jl      .L118
.L109:
        movl    %ecx, %r8d
        cmpl    %r8d, %r9d
        jg      .L119
.L115:
        movq    %r12, 296(%rsp)
        movl    %r10d, %r12d
        movq    296(%rsp), %r10
.L103:
        addq    $4, 112(%rsp)
        incl    %edx
        addl    %r9d, %r12d
        cmpl    %edx, 136(%rsp)
        jne     .L108
.L101:
        addq    $184, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L117:
        movq    344(%rsp), %rax
        movl    136(%rsp), %ecx
        movl    %r9d, %esi
        movl    168(%rsp), %edi
        movss   172(%rsp), %xmm0
        movss   %xmm1, 152(%rsp)
        movq    %r11, 160(%rsp)
        movl    %r10d, 156(%rsp)
        movq    %rax, 104(%rsp)
        movq    336(%rsp), %rax
        movl    %r8d, 148(%rsp)
        movl    %edx, 144(%rsp)
        movl    %r9d, 140(%rsp)
        movq    %rax, 96(%rsp)
        movq    328(%rsp), %rax
        movq    %rbx, 64(%rsp)
        movq    %r12, 56(%rsp)
        movq    %r14, 48(%rsp)
        movq    %r13, 40(%rsp)
        movq    %rax, 88(%rsp)
        movq    320(%rsp), %rax
        movq    %r15, 32(%rsp)
        movq    %rbp, 24(%rsp)
        movq    %rax, 80(%rsp)
        movq    312(%rsp), %rax
        movq    %rax, 72(%rsp)
        movq    256(%rsp), %rax
        movq    %rax, 16(%rsp)
        movl    248(%rsp), %eax
        movl    %eax, 8(%rsp)
        movl    240(%rsp), %eax
        movl    %eax, (%rsp)
        call    _Z14srad_handler_2iiiiiiiiPfS_fS_S_S_S_S_PiS0_S0_S0_fPv
        testl   %eax, %eax
        movl    140(%rsp), %r9d
        movl    144(%rsp), %edx
        movl    148(%rsp), %r8d
        movl    156(%rsp), %r10d
        movq    160(%rsp), %r11
        movlpd  .LC1(%rip), %xmm3
        movss   152(%rsp), %xmm1
        je      .L107
        jmp     .L101
_Z22srad_interrupt_inner_2iiiiiiiiPfS_fS_S_S_S_S_PiS0_S0_S0_fPv:
        pushq   %r15
        movslq  %edx, %rax
        pushq   %r14
        pushq   %r13
        pushq   %r12
        pushq   %rbp
        pushq   %rbx
        subq    $200, %rsp
        cmpl    %r9d, %r8d
        movq    280(%rsp), %rbp
        movq    288(%rsp), %r12
        movq    296(%rsp), %r13
        movq    304(%rsp), %r14
        movq    312(%rsp), %r15
        movq    320(%rsp), %rbx
        movl    %edi, 148(%rsp)
        movl    %eax, 152(%rsp)
        movl    %ecx, 156(%rsp)
        jge     .L120
        movq    336(%rsp), %rcx
        movl    %eax, %r10d
        movl    %r8d, %edx
        imull   %esi, %r10d
        movq    344(%rsp), %r11
        leal    64(%rdx), %r8d
        movlpd  .LC1(%rip), %xmm4
        leaq    (%rcx,%rax,4), %rax
        movq    %rax, 120(%rsp)
        movslq  %r10d, %rax
        movq    %rax, 128(%rsp)
        negq    %rax
        salq    $2, %rax
        addq    %rax, %r11
        cmpl    %r9d, %r8d
        movq    %rax, 136(%rsp)
        cmovg   %r9d, %r8d
        cmpl    %r8d, %edx
        jge     .L128
.L135:
        movq    128(%rsp), %rdi
        movslq  %edx, %rcx
        notl    %edx
        addl    %r8d, %edx
        cvtss2sd        %xmm1, %xmm5
        leaq    (%rdi,%rcx), %rax
        leaq    1(%rdi,%rcx), %rcx
        movq    120(%rsp), %rdi
        mulsd   %xmm4, %xmm5
        addq    %rdx, %rcx
        salq    $2, %rax
        movl    (%rdi), %edx
        movq    136(%rsp), %rdi
        salq    $2, %rcx
        imull   %esi, %edx
        movslq  %edx, %rdx
        leaq    (%rdi,%rdx,4), %rdi
        addq    %rbx, %rdi
.L125:
        movss   0(%r13,%rax), %xmm2
        movl    (%r11,%rax), %edx
        mulss   (%rdi,%rax), %xmm2
        movss   (%rbx,%rax), %xmm3
        movss   (%r12,%rax), %xmm6
        mulss   %xmm3, %xmm6
        addl    %r10d, %edx
        mulss   (%r14,%rax), %xmm3
        movslq  %edx, %rdx
        addss   %xmm6, %xmm2
        addss   %xmm3, %xmm2
        movss   (%rbx,%rdx,4), %xmm3
        mulss   (%r15,%rax), %xmm3
        addss   %xmm3, %xmm2
        cvtss2sd        0(%rbp,%rax), %xmm3
        cvtss2sd        %xmm2, %xmm2
        mulsd   %xmm5, %xmm2
        addsd   %xmm3, %xmm2
        cvtsd2ss        %xmm2, %xmm2
        movss   %xmm2, 0(%rbp,%rax)
        addq    $4, %rax
        cmpq    %rax, %rcx
        jne     .L125
        cmpl    %r9d, %r8d
        jge     .L120
.L136:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L134
.L126:
        movl    %r8d, %edx
        leal    64(%rdx), %r8d
        cmpl    %r9d, %r8d
        cmovg   %r9d, %r8d
        cmpl    %r8d, %edx
        jl      .L135
.L128:
        movl    %edx, %r8d
        cmpl    %r9d, %r8d
        jl      .L136
.L120:
        addq    $200, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L134:
        movq    360(%rsp), %rax
        movl    156(%rsp), %ecx
        movss   %xmm1, 176(%rsp)
        movl    152(%rsp), %edx
        movl    148(%rsp), %edi
        movss   %xmm0, 172(%rsp)
        movq    %r11, 184(%rsp)
        movq    %rax, 104(%rsp)
        movq    352(%rsp), %rax
        movl    %r10d, 180(%rsp)
        movl    %r9d, 168(%rsp)
        movl    %r8d, 164(%rsp)
        movl    %esi, 160(%rsp)
        movq    %rbx, 64(%rsp)
        movq    %rax, 96(%rsp)
        movq    344(%rsp), %rax
        movq    %r15, 56(%rsp)
        movq    %r14, 48(%rsp)
        movq    %r13, 40(%rsp)
        movq    %r12, 32(%rsp)
        movq    %rax, 88(%rsp)
        movq    336(%rsp), %rax
        movq    %rbp, 24(%rsp)
        movq    %rax, 80(%rsp)
        movq    328(%rsp), %rax
        movq    %rax, 72(%rsp)
        movq    272(%rsp), %rax
        movq    %rax, 16(%rsp)
        movl    264(%rsp), %eax
        movl    %eax, 8(%rsp)
        movl    256(%rsp), %eax
        movl    %eax, (%rsp)
        call    _Z20srad_handler_inner_2iiiiiiiiPfS_fS_S_S_S_S_PiS0_S0_S0_fPv
        testl   %eax, %eax
        movl    160(%rsp), %esi
        movl    164(%rsp), %r8d
        movl    168(%rsp), %r9d
        movl    180(%rsp), %r10d
        movq    184(%rsp), %r11
        movlpd  .LC1(%rip), %xmm4
        movss   172(%rsp), %xmm0
        movss   176(%rsp), %xmm1
        je      .L126
        jmp     .L120
.LC0:
        .long   1065353216
.LC1:
        .long   0
        .long   1070596096
.LC2:
        .long   0
        .long   1072693248
.LC3:
        .long   0
        .long   1071644672
.LC4:
        .long   0
        .long   1068498944
