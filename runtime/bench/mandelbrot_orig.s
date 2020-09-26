_Z17mandelbrot_serialddddiii:
        pushq   %r12
        subsd   %xmm0, %xmm2
        movl    %esi, %r12d
        subsd   %xmm1, %xmm3
        pushq   %rbp
        movl    %edi, %ebp
        pushq   %rbx
        movl    %edx, %ebx
        subq    $32, %rsp
        movsd   %xmm0, 24(%rsp)
        cvtsi2sdl       %edi, %xmm0
        imull   %esi, %edi
        movsd   %xmm1, 8(%rsp)
        movslq  %edi, %rdi
        divsd   %xmm0, %xmm2
        cvtsi2sdl       %esi, %xmm0
        divsd   %xmm0, %xmm3
        movsd   %xmm2, 16(%rsp)
        movsd   %xmm3, (%rsp)
        call    malloc
        testl   %r12d, %r12d
        movq    %rax, %r9
        jle     .L1
        testl   %ebp, %ebp
        jle     .L1
        cvtsi2sdl       %ebx, %xmm8
        xorpd   %xmm15, %xmm15
        movlpd  .LC3(%rip), %xmm14
        leal    -1(%rbp), %esi
        xorl    %r8d, %r8d
        movlpd  .LC1(%rip), %xmm9
        xorl    %edi, %edi
        movlpd  .LC2(%rip), %xmm10
        movlpd  16(%rsp), %xmm11
        movlpd  24(%rsp), %xmm12
        movlpd  8(%rsp), %xmm13
.L8:
        cvtsi2sdl       %edi, %xmm7
        movslq  %r8d, %rcx
        xorl    %edx, %edx
        addq    %r9, %rcx
        mulsd   (%rsp), %xmm7
        addsd   %xmm13, %xmm7
.L4:
        cvtsi2sdl       %edx, %xmm4
        testl   %ebx, %ebx
        mulsd   %xmm11, %xmm4
        addsd   %xmm12, %xmm4
        jle     .L9
        movsd   %xmm7, %xmm6
        movsd   %xmm4, %xmm0
        movsd   %xmm15, %xmm3
        jmp     .L7
.L15:
        addsd   %xmm0, %xmm0
        addsd   %xmm10, %xmm3
        subsd   %xmm2, %xmm1
        mulsd   %xmm0, %xmm6
        comisd  %xmm3, %xmm8
        movsd   %xmm1, %xmm0
        addsd   %xmm7, %xmm6
        addsd   %xmm4, %xmm0
        jbe     .L6
.L7:
        movsd   %xmm0, %xmm1
        movsd   %xmm6, %xmm2
        mulsd   %xmm0, %xmm1
        mulsd   %xmm6, %xmm2
        movsd   %xmm1, %xmm5
        addsd   %xmm2, %xmm5
        comisd  %xmm9, %xmm5
        jbe     .L15
.L6:
        divsd   %xmm8, %xmm3
        cmpq    %rdx, %rsi
        mulsd   %xmm14, %xmm3
        cvttsd2sil      %xmm3, %eax
        movb    %al, (%rcx,%rdx)
        leaq    1(%rdx), %rax
        je      .L16
        movq    %rax, %rdx
        jmp     .L4
.L16:
        incl    %edi
        addl    %ebp, %r8d
        cmpl    %edi, %r12d
        jne     .L8
.L1:
        addq    $32, %rsp
        movq    %r9, %rax
        popq    %rbx
        popq    %rbp
        popq    %r12
        ret
.L9:
        movsd   %xmm15, %xmm3
        jmp     .L6
_Z29mandelbrot_interrupt_col_loopddddiiiPhddiiPv:
        pushq   %r15
        pushq   %r14
        pushq   %r13
        pushq   %r12
        pushq   %rbp
        pushq   %rbx
        subq    $104, %rsp
        cmpl    %r9d, %r8d
        movsd   %xmm2, 40(%rsp)
        movsd   %xmm3, 48(%rsp)
        movsd   %xmm5, 32(%rsp)
        movlpd  .LC2(%rip), %xmm8
        jge     .L17
        movsd   %xmm0, %xmm9
        movl    %edi, %r12d
        movl    %edx, %ebp
        movl    %r8d, %r13d
        movq    %rcx, %r14
.L18:
        leal    1024(%r13), %r10d
        cmpl    %r9d, %r10d
        cmovg   %r9d, %r10d
        cmpl    %r10d, %r13d
        jge     .L19
        testl   %r12d, %r12d
        jle     .L19
        movl    %r13d, %r15d
        imull   %r12d, %r15d
.L28:
        xorpd   %xmm10, %xmm10
        xorl    %edx, %edx
.L20:
        leal    512(%rdx), %ebx
        cmpl    %r12d, %ebx
        cmovg   %r12d, %ebx
        cmpl    %ebx, %edx
        jge     .L30
        cvtsi2sdl       %r13d, %xmm12
        movslq  %r15d, %rcx
        cvtsi2sdl       %ebp, %xmm13
        addq    %r14, %rcx
        movlpd  .LC3(%rip), %xmm15
        movlpd  .LC1(%rip), %xmm14
        mulsd   32(%rsp), %xmm12
        addsd   %xmm1, %xmm12
.L24:
        cvtsi2sdl       %edx, %xmm6
        testl   %ebp, %ebp
        mulsd   %xmm4, %xmm6
        addsd   %xmm9, %xmm6
        jle     .L31
        movsd   %xmm12, %xmm11
        movsd   %xmm6, %xmm0
        movsd   %xmm10, %xmm5
        jmp     .L23
.L44:
        addsd   %xmm0, %xmm0
        addsd   %xmm8, %xmm5
        subsd   %xmm3, %xmm2
        mulsd   %xmm0, %xmm11
        comisd  %xmm5, %xmm13
        movsd   %xmm2, %xmm0
        addsd   %xmm12, %xmm11
        addsd   %xmm6, %xmm0
        jbe     .L22
.L23:
        movsd   %xmm0, %xmm2
        movsd   %xmm11, %xmm3
        mulsd   %xmm0, %xmm2
        mulsd   %xmm11, %xmm3
        movsd   %xmm2, %xmm7
        addsd   %xmm3, %xmm7
        comisd  %xmm14, %xmm7
        jbe     .L44
.L22:
        divsd   %xmm13, %xmm5
        mulsd   %xmm15, %xmm5
        cvttsd2sil      %xmm5, %eax
        movb    %al, (%rcx,%rdx)
        incq    %rdx
        cmpl    %edx, %ebx
        jg      .L24
        cmpl    %ebx, %r12d
        jle     .L25
.L46:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L45
.L26:
        movslq  %ebx, %rdx
        jmp     .L20
.L31:
        movsd   %xmm10, %xmm5
        jmp     .L22
.L30:
        movl    %edx, %ebx
        cmpl    %ebx, %r12d
        jg      .L46
.L25:
        incl    %r13d
        addl    %r12d, %r15d
        cmpl    %r10d, %r13d
        jne     .L28
.L19:
        cmpl    %r13d, %r9d
        jle     .L17
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        je      .L18
        movq    160(%rsp), %rax
        movsd   %xmm9, %xmm0
        movlpd  32(%rsp), %xmm5
        movlpd  48(%rsp), %xmm3
        movl    %r13d, %r8d
        movq    %r14, %rcx
        movlpd  40(%rsp), %xmm2
        movl    %ebp, %edx
        movl    %r12d, %edi
        movq    %rax, (%rsp)
        movsd   %xmm4, 80(%rsp)
        movl    %r9d, 88(%rsp)
        movsd   %xmm1, 64(%rsp)
        movl    %esi, 76(%rsp)
        movsd   %xmm9, 56(%rsp)
        call    _Z16col_loop_handlerddddiiiPhddiiPv
        testl   %eax, %eax
        movl    76(%rsp), %esi
        movl    88(%rsp), %r9d
        movlpd  56(%rsp), %xmm9
        movlpd  64(%rsp), %xmm1
        movlpd  80(%rsp), %xmm4
        movlpd  .LC2(%rip), %xmm8
        je      .L18
.L17:
        addq    $104, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L45:
        movq    160(%rsp), %rax
        movsd   %xmm9, %xmm0
        movlpd  32(%rsp), %xmm5
        movlpd  48(%rsp), %xmm3
        movl    %r12d, 8(%rsp)
        movl    %r13d, %r8d
        movlpd  40(%rsp), %xmm2
        movl    %ebx, (%rsp)
        movq    %r14, %rcx
        movq    %rax, 16(%rsp)
        movl    %ebp, %edx
        movl    %r12d, %edi
        movsd   %xmm4, 80(%rsp)
        movl    %r10d, 92(%rsp)
        movl    %r9d, 88(%rsp)
        movsd   %xmm1, 64(%rsp)
        movl    %esi, 76(%rsp)
        movsd   %xmm9, 56(%rsp)
        call    _Z16row_loop_handlerddddiiiPhddiiiiPv
        testl   %eax, %eax
        movl    76(%rsp), %esi
        xorpd   %xmm10, %xmm10
        movl    88(%rsp), %r9d
        movl    92(%rsp), %r10d
        movlpd  56(%rsp), %xmm9
        movlpd  64(%rsp), %xmm1
        movlpd  80(%rsp), %xmm4
        movlpd  .LC2(%rip), %xmm8
        je      .L26
        addq    $104, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
_Z29mandelbrot_interrupt_row_loopddddiiiPhddiiiiPv:
        pushq   %r15
        pushq   %r14
        pushq   %r13
        pushq   %r12
        pushq   %rbp
        movl    %edx, %ebp
        pushq   %rbx
        subq    $104, %rsp
        movslq  160(%rsp), %rdx
        movl    168(%rsp), %r12d
        movsd   %xmm1, 32(%rsp)
        movsd   %xmm2, 40(%rsp)
        movsd   %xmm3, 48(%rsp)
        cmpl    %edx, %r12d
        jle     .L47
        movl    %r8d, %r14d
        xorpd   %xmm10, %xmm10
        imull   %edi, %r14d
        movsd   %xmm0, %xmm9
        movlpd  .LC2(%rip), %xmm8
        movl    %edi, %r15d
        movq    %rcx, %r13
.L49:
        leal    512(%rdx), %ebx
        cmpl    %r12d, %ebx
        cmovg   %r12d, %ebx
        cmpl    %ebx, %edx
        jge     .L56
        cvtsi2sdl       %r8d, %xmm12
        movslq  %r14d, %rcx
        cvtsi2sdl       %ebp, %xmm13
        addq    %r13, %rcx
        movlpd  .LC3(%rip), %xmm15
        movlpd  .LC1(%rip), %xmm14
        mulsd   %xmm5, %xmm12
        addsd   32(%rsp), %xmm12
.L53:
        cvtsi2sdl       %edx, %xmm6
        testl   %ebp, %ebp
        mulsd   %xmm4, %xmm6
        addsd   %xmm9, %xmm6
        jle     .L57
        movsd   %xmm12, %xmm11
        movsd   %xmm6, %xmm0
        movsd   %xmm10, %xmm3
        jmp     .L52
.L65:
        addsd   %xmm0, %xmm0
        addsd   %xmm8, %xmm3
        subsd   %xmm2, %xmm1
        mulsd   %xmm0, %xmm11
        comisd  %xmm3, %xmm13
        movsd   %xmm1, %xmm0
        addsd   %xmm12, %xmm11
        addsd   %xmm6, %xmm0
        jbe     .L51
.L52:
        movsd   %xmm0, %xmm1
        movsd   %xmm11, %xmm2
        mulsd   %xmm0, %xmm1
        mulsd   %xmm11, %xmm2
        movsd   %xmm1, %xmm7
        addsd   %xmm2, %xmm7
        comisd  %xmm14, %xmm7
        jbe     .L65
.L51:
        divsd   %xmm13, %xmm3
        mulsd   %xmm15, %xmm3
        cvttsd2sil      %xmm3, %eax
        movb    %al, (%rcx,%rdx)
        incq    %rdx
        cmpl    %edx, %ebx
        jg      .L53
        cmpl    %ebx, %r12d
        jle     .L47
.L67:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L66
.L55:
        movslq  %ebx, %rdx
        jmp     .L49
.L57:
        movsd   %xmm10, %xmm3
        jmp     .L51
.L56:
        movl    %edx, %ebx
        cmpl    %ebx, %r12d
        jg      .L67
.L47:
        addq    $104, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L66:
        movq    176(%rsp), %rax
        movsd   %xmm9, %xmm0
        movlpd  48(%rsp), %xmm3
        movlpd  40(%rsp), %xmm2
        movl    %r12d, 8(%rsp)
        movq    %r13, %rcx
        movlpd  32(%rsp), %xmm1
        movl    %ebx, (%rsp)
        movl    %ebp, %edx
        movq    %rax, 16(%rsp)
        movl    %r15d, %edi
        movsd   %xmm5, 80(%rsp)
        movsd   %xmm4, 72(%rsp)
        movl    %r9d, 92(%rsp)
        movl    %r8d, 88(%rsp)
        movsd   %xmm9, 56(%rsp)
        movl    %esi, 68(%rsp)
        call    _Z20row_row_loop_handlerddddiiiPhddiiiiPv
        testl   %eax, %eax
        movl    68(%rsp), %esi
        xorpd   %xmm10, %xmm10
        movl    88(%rsp), %r8d
        movl    92(%rsp), %r9d
        movlpd  56(%rsp), %xmm9
        movlpd  72(%rsp), %xmm4
        movlpd  80(%rsp), %xmm5
        movlpd  .LC2(%rip), %xmm8
        je      .L55
        jmp     .L47
_Z20mandelbrot_interruptddddiiiPv:
        movq    %r12, -24(%rsp)
        movl    %edi, %r12d
        movq    %rbx, -40(%rsp)
        imull   %esi, %edi
        movq    %rbp, -32(%rsp)
        movq    %r13, -16(%rsp)
        movq    %r14, -8(%rsp)
        movl    %esi, %ebp
        subq    $88, %rsp
        movq    %rcx, %rbx
        movsd   %xmm0, 40(%rsp)
        movl    %edx, %r14d
        movslq  %edi, %rdi
        movsd   %xmm1, 32(%rsp)
        movsd   %xmm2, 24(%rsp)
        movsd   %xmm3, 16(%rsp)
        call    malloc
        cvtsi2sdl       %ebp, %xmm7
        movq    %rax, %r13
        cvtsi2sdl       %r12d, %xmm6
        movq    %rbx, (%rsp)
        movlpd  16(%rsp), %xmm3
        movl    %ebp, %r9d
        movq    %rax, %rcx
        movlpd  24(%rsp), %xmm2
        movl    %r14d, %edx
        movl    %ebp, %esi
        movlpd  32(%rsp), %xmm1
        movsd   %xmm3, %xmm5
        movl    %r12d, %edi
        movlpd  40(%rsp), %xmm0
        movsd   %xmm2, %xmm4
        xorl    %r8d, %r8d
        subsd   %xmm1, %xmm5
        subsd   %xmm0, %xmm4
        divsd   %xmm7, %xmm5
        divsd   %xmm6, %xmm4
        call    _Z29mandelbrot_interrupt_col_loopddddiiiPhddiiPv
        movq    %r13, %rax
        movq    48(%rsp), %rbx
        movq    56(%rsp), %rbp
        movq    64(%rsp), %r12
        movq    72(%rsp), %r13
        movq    80(%rsp), %r14
        addq    $88, %rsp
        ret
.LC1:
        .long   0
        .long   1074790400
.LC2:
        .long   0
        .long   1072693248
.LC3:
        .long   0
        .long   1081073664
