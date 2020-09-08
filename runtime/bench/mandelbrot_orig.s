_Z29mandelbrot_interrupt_col_loopddddiiiPhddiiPv.part.0:
        pushq   %r15
        vmovsd  %xmm0, %xmm0, %xmm9
        movl    %r8d, %r15d
        pushq   %r14
        movq    %rcx, %r14
        pushq   %r13
        pushq   %r12
        movl    %edi, %r12d
        pushq   %rbp
        movl    %edx, %ebp
        pushq   %rbx
        subq    $104, %rsp
        testl   %edi, %edi
        vmovsd  %xmm2, 40(%rsp)
        setle   75(%rsp)
        vmovsd  %xmm3, 48(%rsp)
        vmovsd  %xmm5, 32(%rsp)
        vmovsd  .LC2(%rip), %xmm8
.L2:
        leal    16(%r15), %r10d
        cmpl    %r9d, %r10d
        cmovg   %r9d, %r10d
        cmpl    %r10d, %r15d
        jge     .L3
        cmpb    $0, 75(%rsp)
        jne     .L3
        movl    %r15d, %r13d
        imull   %r12d, %r13d
.L11:
        xorl    %edx, %edx
        vxorpd  %xmm10, %xmm10, %xmm10
        leal    32(%rdx), %ebx
        cmpl    %r12d, %ebx
        cmovg   %r12d, %ebx
        cmpl    %ebx, %edx
        jge     .L14
.L34:
        vcvtsi2sdl      %r15d, %xmm12, %xmm12
        movslq  %r13d, %rcx
        vcvtsi2sdl      %ebp, %xmm13, %xmm13
        addq    %r14, %rcx
        vmovsd  .LC3(%rip), %xmm15
        vmovsd  .LC1(%rip), %xmm14
        vmulsd  32(%rsp), %xmm12, %xmm12
        vaddsd  %xmm1, %xmm12, %xmm12
.L8:
        vcvtsi2sdl      %edx, %xmm6, %xmm6
        testl   %ebp, %ebp
        vmulsd  %xmm4, %xmm6, %xmm6
        vaddsd  %xmm9, %xmm6, %xmm6
        jle     .L15
        vmovsd  %xmm12, %xmm12, %xmm11
        vmovsd  %xmm6, %xmm6, %xmm0
        vmovsd  %xmm10, %xmm10, %xmm5
        jmp     .L7
.L32:
        vaddsd  %xmm0, %xmm0, %xmm0
        vaddsd  %xmm8, %xmm5, %xmm5
        vsubsd  %xmm3, %xmm2, %xmm2
        vmulsd  %xmm11, %xmm0, %xmm11
        vcomisd %xmm5, %xmm13
        vaddsd  %xmm6, %xmm2, %xmm0
        vaddsd  %xmm11, %xmm12, %xmm11
        jbe     .L6
.L7:
        vmulsd  %xmm0, %xmm0, %xmm2
        vmulsd  %xmm11, %xmm11, %xmm3
        vaddsd  %xmm3, %xmm2, %xmm7
        vcomisd %xmm14, %xmm7
        jbe     .L32
.L6:
        vdivsd  %xmm13, %xmm5, %xmm5
        vmulsd  %xmm15, %xmm5, %xmm5
        vcvttsd2sil     %xmm5, %eax
        movb    %al, (%rcx,%rdx)
        incq    %rdx
        cmpl    %edx, %ebx
        jg      .L8
        cmpl    %ebx, %r12d
        jle     .L9
.L35:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L33
.L10:
        movslq  %ebx, %rdx
        leal    32(%rdx), %ebx
        cmpl    %r12d, %ebx
        cmovg   %r12d, %ebx
        cmpl    %ebx, %edx
        jl      .L34
.L14:
        movl    %edx, %ebx
        cmpl    %ebx, %r12d
        jg      .L35
.L9:
        incl    %r15d
        addl    %r12d, %r13d
        cmpl    %r15d, %r10d
        jg      .L11
.L3:
        cmpl    %r15d, %r9d
        jle     .L29
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        je      .L2
        movq    160(%rsp), %rax
        vmovsd  %xmm9, %xmm9, %xmm0
        vmovsd  32(%rsp), %xmm5
        vmovsd  48(%rsp), %xmm3
        movl    %r15d, %r8d
        movq    %r14, %rcx
        vmovsd  40(%rsp), %xmm2
        movl    %ebp, %edx
        movl    %r12d, %edi
        movq    %rax, (%rsp)
        vmovsd  %xmm4, 80(%rsp)
        movl    %r9d, 88(%rsp)
        vmovsd  %xmm1, 64(%rsp)
        movl    %esi, 76(%rsp)
        vmovsd  %xmm9, 56(%rsp)
        call    _Z16col_loop_handlerddddiiiPhddiiPv
        testl   %eax, %eax
        movl    76(%rsp), %esi
        movl    88(%rsp), %r9d
        vmovsd  56(%rsp), %xmm9
        vmovsd  64(%rsp), %xmm1
        vmovsd  80(%rsp), %xmm4
        vmovsd  .LC2(%rip), %xmm8
        je      .L2
.L29:
        addq    $104, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L15:
        vmovsd  %xmm10, %xmm10, %xmm5
        jmp     .L6
.L33:
        movq    160(%rsp), %rax
        vmovsd  %xmm9, %xmm9, %xmm0
        vmovsd  32(%rsp), %xmm5
        vmovsd  48(%rsp), %xmm3
        movl    %r12d, 8(%rsp)
        movl    %r15d, %r8d
        vmovsd  40(%rsp), %xmm2
        movl    %ebx, (%rsp)
        movq    %r14, %rcx
        movq    %rax, 16(%rsp)
        movl    %ebp, %edx
        movl    %r12d, %edi
        vmovsd  %xmm4, 80(%rsp)
        movl    %r10d, 92(%rsp)
        movl    %r9d, 88(%rsp)
        vmovsd  %xmm1, 64(%rsp)
        movl    %esi, 76(%rsp)
        vmovsd  %xmm9, 56(%rsp)
        call    _Z16row_loop_handlerddddiiiPhddiiiiPv
        testl   %eax, %eax
        movl    76(%rsp), %esi
        vxorpd  %xmm10, %xmm10, %xmm10
        movl    88(%rsp), %r9d
        movl    92(%rsp), %r10d
        vmovsd  56(%rsp), %xmm9
        vmovsd  64(%rsp), %xmm1
        vmovsd  80(%rsp), %xmm4
        vmovsd  .LC2(%rip), %xmm8
        je      .L10
        addq    $104, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
_Z17mandelbrot_serialddddiii:
        pushq   %r12
        vsubsd  %xmm0, %xmm2, %xmm2
        movl    %esi, %r12d
        vcvtsi2sdl      %edi, %xmm11, %xmm11
        vsubsd  %xmm1, %xmm3, %xmm3
        pushq   %rbp
        movl    %edi, %ebp
        pushq   %rbx
        movl    %edx, %ebx
        movl    %edi, %edx
        imull   %esi, %edx
        subq    $48, %rsp
        vmovsd  %xmm0, 24(%rsp)
        leaq    40(%rsp), %rdi
        vcvtsi2sdl      %esi, %xmm0, %xmm0
        movslq  %edx, %rdx
        movl    $64, %esi
        vmovsd  %xmm1, 8(%rsp)
        vdivsd  %xmm11, %xmm2, %xmm11
        vdivsd  %xmm0, %xmm3, %xmm7
        vmovsd  %xmm11, 16(%rsp)
        vmovsd  %xmm7, (%rsp)
        call    posix_memalign
        movl    $0, %r9d
        testl   %eax, %eax
        cmove   40(%rsp), %r9
        testl   %r12d, %r12d
        jle     .L36
        testl   %ebp, %ebp
        jle     .L36
        vcvtsi2sdl      %ebx, %xmm8, %xmm8
        vxorpd  %xmm15, %xmm15, %xmm15
        vmovsd  .LC3(%rip), %xmm14
        leal    -1(%rbp), %esi
        xorl    %r8d, %r8d
        vmovsd  .LC1(%rip), %xmm9
        xorl    %edi, %edi
        vmovsd  .LC2(%rip), %xmm10
        vmovsd  16(%rsp), %xmm11
        vmovsd  24(%rsp), %xmm12
        vmovsd  8(%rsp), %xmm13
.L44:
        vcvtsi2sdl      %edi, %xmm7, %xmm7
        xorl    %edx, %edx
        movslq  %r8d, %rcx
        vcvtsi2sdl      %edx, %xmm4, %xmm4
        addq    %r9, %rcx
        testl   %ebx, %ebx
        vmulsd  (%rsp), %xmm7, %xmm7
        vmulsd  %xmm11, %xmm4, %xmm4
        vaddsd  %xmm12, %xmm4, %xmm4
        vaddsd  %xmm13, %xmm7, %xmm7
        jle     .L46
.L53:
        vmovsd  %xmm7, %xmm7, %xmm6
        vmovsd  %xmm4, %xmm4, %xmm0
        vmovsd  %xmm15, %xmm15, %xmm3
        jmp     .L43
.L51:
        vaddsd  %xmm0, %xmm0, %xmm0
        vaddsd  %xmm10, %xmm3, %xmm3
        vsubsd  %xmm2, %xmm1, %xmm1
        vmulsd  %xmm6, %xmm0, %xmm6
        vcomisd %xmm3, %xmm8
        vaddsd  %xmm4, %xmm1, %xmm0
        vaddsd  %xmm6, %xmm7, %xmm6
        jbe     .L42
.L43:
        vmulsd  %xmm0, %xmm0, %xmm1
        vmulsd  %xmm6, %xmm6, %xmm2
        vaddsd  %xmm2, %xmm1, %xmm5
        vcomisd %xmm9, %xmm5
        jbe     .L51
.L42:
        vdivsd  %xmm8, %xmm3, %xmm3
        cmpq    %rdx, %rsi
        vmulsd  %xmm14, %xmm3, %xmm3
        vcvttsd2sil     %xmm3, %eax
        movb    %al, (%rcx,%rdx)
        leaq    1(%rdx), %rax
        je      .L52
        movq    %rax, %rdx
        testl   %ebx, %ebx
        vcvtsi2sdl      %edx, %xmm4, %xmm4
        vmulsd  %xmm11, %xmm4, %xmm4
        vaddsd  %xmm12, %xmm4, %xmm4
        jg      .L53
.L46:
        vmovsd  %xmm15, %xmm15, %xmm3
        jmp     .L42
.L52:
        incl    %edi
        addl    %ebp, %r8d
        cmpl    %edi, %r12d
        jne     .L44
.L36:
        addq    $48, %rsp
        movq    %r9, %rax
        popq    %rbx
        popq    %rbp
        popq    %r12
        ret
_Z29mandelbrot_interrupt_col_loopddddiiiPhddiiPv:
        cmpl    %r9d, %r8d
        jge     .L56
        jmp     _Z29mandelbrot_interrupt_col_loopddddiiiPhddiiPv.part.0
.L56:
        rep ret
_Z29mandelbrot_interrupt_row_loopddddiiiPhddiiiiPv:
        pushq   %r15
        pushq   %r14
        pushq   %r13
        pushq   %r12
        pushq   %rbp
        pushq   %rbx
        subq    $104, %rsp
        movslq  160(%rsp), %r10
        movl    168(%rsp), %ebp
        vmovsd  %xmm1, 32(%rsp)
        vmovsd  %xmm2, 40(%rsp)
        vmovsd  %xmm3, 48(%rsp)
        cmpl    %ebp, %r10d
        jge     .L74
        leal    32(%r10), %ebx
        movl    %edi, %r12d
        vmovsd  %xmm0, %xmm0, %xmm9
        imull   %r8d, %r12d
        vxorpd  %xmm10, %xmm10, %xmm10
        cmpl    %ebp, %ebx
        vmovsd  .LC2(%rip), %xmm8
        movl    %edi, %r13d
        cmovg   %ebp, %ebx
        movl    %esi, %r14d
        movl    %edx, %r15d
        cmpl    %ebx, %r10d
        jge     .L66
.L78:
        vcvtsi2sdl      %r8d, %xmm12, %xmm12
        movslq  %r12d, %r11
        vcvtsi2sdl      %r15d, %xmm13, %xmm13
        addq    %rcx, %r11
        vmovsd  .LC3(%rip), %xmm15
        vmovsd  .LC1(%rip), %xmm14
        vmulsd  %xmm5, %xmm12, %xmm12
        vaddsd  32(%rsp), %xmm12, %xmm12
.L63:
        vcvtsi2sdl      %r10d, %xmm6, %xmm6
        testl   %r15d, %r15d
        vmulsd  %xmm4, %xmm6, %xmm6
        vaddsd  %xmm9, %xmm6, %xmm6
        jle     .L67
        vmovsd  %xmm12, %xmm12, %xmm11
        vmovsd  %xmm6, %xmm6, %xmm0
        vmovsd  %xmm10, %xmm10, %xmm3
        jmp     .L62
.L76:
        vaddsd  %xmm0, %xmm0, %xmm0
        vaddsd  %xmm8, %xmm3, %xmm3
        vsubsd  %xmm2, %xmm1, %xmm1
        vmulsd  %xmm11, %xmm0, %xmm11
        vcomisd %xmm3, %xmm13
        vaddsd  %xmm6, %xmm1, %xmm0
        vaddsd  %xmm11, %xmm12, %xmm11
        jbe     .L61
.L62:
        vmulsd  %xmm0, %xmm0, %xmm1
        vmulsd  %xmm11, %xmm11, %xmm2
        vaddsd  %xmm2, %xmm1, %xmm7
        vcomisd %xmm14, %xmm7
        jbe     .L76
.L61:
        vdivsd  %xmm13, %xmm3, %xmm3
        vmulsd  %xmm15, %xmm3, %xmm3
        vcvttsd2sil     %xmm3, %eax
        movb    %al, (%r11,%r10)
        incq    %r10
        cmpl    %r10d, %ebx
        jg      .L63
        cmpl    %ebx, %ebp
        jle     .L74
.L79:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L77
.L65:
        movslq  %ebx, %r10
        leal    32(%r10), %ebx
        cmpl    %ebp, %ebx
        cmovg   %ebp, %ebx
        cmpl    %ebx, %r10d
        jl      .L78
.L66:
        movl    %r10d, %ebx
        cmpl    %ebx, %ebp
        jg      .L79
.L74:
        addq    $104, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L67:
        vmovsd  %xmm10, %xmm10, %xmm3
        jmp     .L61
.L77:
        movq    176(%rsp), %rax
        vmovsd  %xmm9, %xmm9, %xmm0
        vmovsd  48(%rsp), %xmm3
        vmovsd  40(%rsp), %xmm2
        movl    %ebp, 8(%rsp)
        movl    %r15d, %edx
        vmovsd  32(%rsp), %xmm1
        movl    %ebx, (%rsp)
        movl    %r14d, %esi
        movq    %rax, 16(%rsp)
        movl    %r13d, %edi
        vmovsd  %xmm5, 80(%rsp)
        vmovsd  %xmm4, 72(%rsp)
        movl    %r9d, 92(%rsp)
        movl    %r8d, 88(%rsp)
        vmovsd  %xmm9, 56(%rsp)
        movq    %rcx, 64(%rsp)
        call    _Z20row_row_loop_handlerddddiiiPhddiiiiPv
        testl   %eax, %eax
        movq    64(%rsp), %rcx
        vxorpd  %xmm10, %xmm10, %xmm10
        movl    88(%rsp), %r8d
        movl    92(%rsp), %r9d
        vmovsd  56(%rsp), %xmm9
        vmovsd  72(%rsp), %xmm4
        vmovsd  80(%rsp), %xmm5
        vmovsd  .LC2(%rip), %xmm8
        je      .L65
        jmp     .L74
_Z20mandelbrot_interruptddddiiiPv:
        movq    %r14, -8(%rsp)
        movl    %edx, %r14d
        movl    %edi, %edx
        imull   %esi, %edx
        movq    %rbx, -40(%rsp)
        movq    %rbp, -32(%rsp)
        movq    %r12, -24(%rsp)
        movq    %r13, -16(%rsp)
        subq    $104, %rsp
        movl    %edi, %r12d
        leaq    56(%rsp), %rdi
        movl    %esi, %ebp
        movslq  %edx, %rdx
        movl    $64, %esi
        vmovsd  %xmm0, 40(%rsp)
        vmovsd  %xmm1, 32(%rsp)
        movq    %rcx, %rbx
        movl    $0, %r13d
        vmovsd  %xmm2, 24(%rsp)
        vmovsd  %xmm3, 16(%rsp)
        call    posix_memalign
        testl   %eax, %eax
        cmove   56(%rsp), %r13
        testl   %ebp, %ebp
        jle     .L80
        vcvtsi2sdl      %ebp, %xmm5, %xmm5
        movq    %rbx, (%rsp)
        movl    %ebp, %r9d
        vcvtsi2sdl      %r12d, %xmm4, %xmm4
        xorl    %r8d, %r8d
        vmovsd  16(%rsp), %xmm3
        movq    %r13, %rcx
        movl    %r14d, %edx
        vmovsd  32(%rsp), %xmm1
        movl    %ebp, %esi
        movl    %r12d, %edi
        vmovsd  24(%rsp), %xmm2
        vmovsd  40(%rsp), %xmm0
        vsubsd  %xmm1, %xmm3, %xmm7
        vsubsd  %xmm0, %xmm2, %xmm6
        vdivsd  %xmm5, %xmm7, %xmm5
        vdivsd  %xmm4, %xmm6, %xmm4
        call    _Z29mandelbrot_interrupt_col_loopddddiiiPhddiiPv.part.0
.L80:
        movq    %r13, %rax
        movq    64(%rsp), %rbx
        movq    72(%rsp), %rbp
        movq    80(%rsp), %r12
        movq    88(%rsp), %r13
        movq    96(%rsp), %r14
        addq    $104, %rsp
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
