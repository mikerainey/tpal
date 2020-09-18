_Z13kmeans_serialPPfiiifPi:
        pushq   %rbp
        movslq  %ecx, %rax
        movq    %rsp, %rbp
        pushq   %r15
        pushq   %r14
        movq    %rax, %r14
        pushq   %r13
        leaq    0(,%rax,8), %r13
        pushq   %r12
        pushq   %rbx
        movl    %esi, %ebx
        andq    $-32, %rsp
        subq    $160, %rsp
        movq    %rdi, 88(%rsp)
        movq    %r13, %rdi
        vmovss  %xmm0, 28(%rsp)
        movl    %edx, 96(%rsp)
        movq    %r8, 120(%rsp)
        movq    %rax, 144(%rsp)
        call    malloc
        movl    %r14d, 136(%rsp)
        movq    %rax, %r15
        imull   %ebx, %r14d
        movslq  %r14d, %r14
        leaq    0(,%r14,4), %rdi
        call    malloc
        cmpl    $1, 136(%rsp)
        movq    %rax, (%r15)
        jle     .L98
        movl    136(%rsp), %esi
        movslq  %ebx, %rcx
        leaq    0(,%rcx,4), %rdi
        cmpl    $9, %esi
        jle     .L60
        movq    %rcx, %r11
        movq    %rcx, %r9
        leaq    0(,%rcx,8), %r10
        subl    $10, %esi
        leaq    (%rcx,%rcx,2), %rcx
        salq    $5, %r11
        salq    $4, %r9
        andl    $-8, %esi
        movq    %r11, 152(%rsp)
        addl    $9, %esi
        leaq    192(%r15), %rdx
        leaq    (%rax,%r9), %r8
        leaq    0(,%rcx,4), %r11
        movl    %esi, 140(%rsp)
        movl    $1, %esi
.L7:
        leaq    (%rdi,%rax), %rcx
        movq    %r8, -160(%rdx)
        addq    %rdi, %r8
        movq    %r8, -152(%rdx)
        addq    %rdi, %r8
        addl    $8, %esi
        movq    %rcx, -184(%rdx)
        leaq    (%rax,%r10), %rcx
        movq    %r8, -144(%rdx)
        addq    %rdi, %r8
        prefetcht0      (%rdx)
        addq    $64, %rdx
        movq    %rcx, -240(%rdx)
        leaq    (%rax,%r11), %rcx
        movq    %r8, -200(%rdx)
        addq    %rdi, %r8
        addq    152(%rsp), %rax
        movq    %r8, -192(%rdx)
        movq    %rcx, -232(%rdx)
        addq    %r9, %r8
        cmpl    140(%rsp), %esi
        jne     .L7
.L6:
        movslq  %esi, %rsi
        addq    %rdi, %rax
.L9:
        movq    %rax, (%r15,%rsi,8)
        incq    %rsi
        addq    %rdi, %rax
        cmpl    %esi, 136(%rsp)
        jg      .L9
.L8:
        testl   %ebx, %ebx
        jle     .L99
        movl    %ebx, %r8d
        movl    %ebx, %r10d
        xorl    %r9d, %r9d
        andl    $-8, %r8d
        shrl    $3, %r10d
        leal    1(%r8), %eax
        movl    %r8d, %r11d
        salq    $5, %r10
        salq    $2, %r11
        movl    %eax, 140(%rsp)
        salq    $2, %rax
        movq    %rax, 64(%rsp)
        leal    2(%r8), %eax
        movl    %eax, 128(%rsp)
        salq    $2, %rax
        movq    %rax, 56(%rsp)
        leal    3(%r8), %eax
        movl    %eax, 112(%rsp)
        salq    $2, %rax
        movq    %rax, 48(%rsp)
        leal    4(%r8), %eax
        movl    %eax, 104(%rsp)
        salq    $2, %rax
        movq    %rax, 40(%rsp)
        leal    5(%r8), %eax
        movl    %eax, 100(%rsp)
        salq    $2, %rax
        movq    %rax, 32(%rsp)
        leal    6(%r8), %eax
        movl    %eax, 72(%rsp)
        salq    $2, %rax
        movq    %rax, 80(%rsp)
        leal    -1(%rbx), %eax
        movl    %eax, 152(%rsp)
        leal    -17(%rbx), %eax
        andl    $-16, %eax
        addl    $16, %eax
        movl    %eax, 24(%rsp)
.L5:
        movq    88(%rsp), %rax
        movq    (%r15,%r9,8), %rsi
        movq    (%rax,%r9,8), %rcx
        leaq    31(%rcx), %rax
        subq    %rsi, %rax
        cmpq    $62, %rax
        jbe     .L12
        xorl    %eax, %eax
        cmpl    $6, 152(%rsp)
        jbe     .L12
.L10:
        vmovups (%rcx,%rax), %ymm0
        vmovups %ymm0, (%rsi,%rax)
        addq    $32, %rax
        cmpq    %r10, %rax
        jne     .L10
        cmpl    %r8d, %ebx
        je      .L20
        cmpl    140(%rsp), %ebx
        vmovss  (%rcx,%r11), %xmm0
        vmovss  %xmm0, (%rsi,%r11)
        jle     .L20
        movq    64(%rsp), %rax
        cmpl    128(%rsp), %ebx
        vmovss  (%rcx,%rax), %xmm0
        vmovss  %xmm0, (%rsi,%rax)
        jle     .L20
        movq    56(%rsp), %rax
        cmpl    112(%rsp), %ebx
        vmovss  (%rcx,%rax), %xmm0
        vmovss  %xmm0, (%rsi,%rax)
        jle     .L20
        movq    48(%rsp), %rax
        cmpl    104(%rsp), %ebx
        vmovss  (%rcx,%rax), %xmm0
        vmovss  %xmm0, (%rsi,%rax)
        jle     .L20
        movq    40(%rsp), %rax
        cmpl    100(%rsp), %ebx
        vmovss  (%rcx,%rax), %xmm0
        vmovss  %xmm0, (%rsi,%rax)
        jle     .L20
        movq    32(%rsp), %rax
        cmpl    72(%rsp), %ebx
        vmovss  (%rcx,%rax), %xmm0
        vmovss  %xmm0, (%rsi,%rax)
        jle     .L20
        movq    80(%rsp), %rax
        vmovss  (%rcx,%rax), %xmm0
        vmovss  %xmm0, (%rsi,%rax)
.L20:
        incq    %r9
        cmpl    %r9d, 136(%rsp)
        jg      .L5
        vzeroupper
.L4:
        movl    96(%rsp), %esi
        testl   %esi, %esi
        jle     .L22
.L13:
        movl    96(%rsp), %eax
        movq    120(%rsp), %rdi
        movl    $255, %esi
        decl    %eax
        leaq    4(,%rax,4), %rdx
        call    memset
.L22:
        movq    144(%rsp), %rdi
        movl    $4, %esi
        call    calloc
        movq    %r13, %rdi
        movq    %rax, 104(%rsp)
        call    malloc
        movl    $4, %esi
        movq    %r14, %rdi
        movq    %rax, %r13
        movq    %rax, 112(%rsp)
        call    calloc
        cmpl    $1, 136(%rsp)
        movq    %rax, 72(%rsp)
        movq    %rax, 0(%r13)
        jle     .L14
        movl    136(%rsp), %r10d
        movslq  %ebx, %rdx
        leaq    0(,%rdx,4), %rcx
        cmpl    $9, %r10d
        jle     .L63
        movq    %rax, %r14
        leal    -10(%r10), %esi
        movq    %rdx, %r8
        movq    112(%rsp), %rax
        movq    %rdx, %r11
        leaq    0(,%rdx,8), %r9
        salq    $4, %r8
        leaq    (%rdx,%rdx,2), %rdx
        andl    $-8, %esi
        leaq    (%r14,%r8), %rdi
        leal    9(%rsi), %r13d
        salq    $5, %r11
        leaq    0(,%rdx,4), %r10
        addq    $192, %rax
        movl    $1, %edx
        movq    %r14, %rsi
.L24:
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
        cmpl    %r13d, %edx
        jne     .L24
        movq    %rsi, 72(%rsp)
        movq    %rsi, %rax
.L23:
        movslq  %edx, %rdx
        addq    %rcx, %rax
.L25:
        movq    112(%rsp), %rsi
        movq    %rax, (%rsi,%rdx,8)
        incq    %rdx
        addq    %rcx, %rax
        cmpl    %edx, 136(%rsp)
        jg      .L25
        movq    (%rsi), %rax
        movq    %rax, 72(%rsp)
.L14:
        vxorps  %xmm4, %xmm4, %xmm4
        movl    %ebx, %r13d
        movl    %ebx, %r14d
        shrl    $3, %r13d
        andl    $-8, %r14d
        leal    -1(%r13), %eax
        movl    %eax, 144(%rsp)
        leal    -3(%r13), %eax
        andl    $-2, %eax
        movl    %eax, 140(%rsp)
        addl    $2, %eax
        movl    %eax, 100(%rsp)
        movl    152(%rsp), %eax
        leaq    4(,%rax,4), %rax
        movq    %rax, 56(%rsp)
        movl    96(%rsp), %eax
        decl    %eax
        movl    %eax, 48(%rsp)
.L28:
        movl    96(%rsp), %ecx
        testl   %ecx, %ecx
        jle     .L100
        vmovaps %xmm4, %xmm5
        movl    48(%rsp), %eax
        movq    $0, 128(%rsp)
        movq    128(%rsp), %rdi
        vmovss  .LC1(%rip), %xmm6
        vmovss  .LC2(%rip), %xmm7
        movq    %rax, 80(%rsp)
        movl    136(%rsp), %eax
        leal    -1(%rax), %r11d
.L43:
        movl    136(%rsp), %edx
        movq    88(%rsp), %rax
        testl   %edx, %edx
        movq    (%rax,%rdi,8), %r8
        jle     .L30
        xorl    %r9d, %r9d
        testl   %ebx, %ebx
        vmovaps %xmm6, %xmm3
        movq    (%r15,%r9,8), %rdi
        movl    %r9d, %r10d
        jle     .L64
.L101:
        cmpl    $6, 152(%rsp)
        jbe     .L65
        cmpl    $1, 144(%rsp)
        movq    %rdi, %rcx
        movq    %r8, %rsi
        jbe     .L66
        vmovaps %xmm4, %xmm0
        xorl    %eax, %eax
.L34:
        vmovups (%rsi), %ymm1
        movl    %eax, %edx
        prefetcht0      384(%rsi)
        addl    $2, %eax
        addq    $64, %rsi
        prefetcht0      384(%rcx)
        vsubps  (%rcx), %ymm1, %ymm1
        addq    $64, %rcx
        vmulps  %ymm1, %ymm1, %ymm1
        vaddss  %xmm0, %xmm1, %xmm0
        vshufps $85, %xmm1, %xmm1, %xmm8
        vshufps $255, %xmm1, %xmm1, %xmm2
        vaddss  %xmm0, %xmm8, %xmm8
        vunpckhps       %xmm1, %xmm1, %xmm0
        vextractf128    $0x1, %ymm1, %xmm1
        vaddss  %xmm8, %xmm0, %xmm0
        vaddss  %xmm0, %xmm2, %xmm2
        vshufps $85, %xmm1, %xmm1, %xmm0
        vaddss  %xmm2, %xmm1, %xmm2
        vaddss  %xmm2, %xmm0, %xmm2
        vunpckhps       %xmm1, %xmm1, %xmm0
        vshufps $255, %xmm1, %xmm1, %xmm1
        vaddss  %xmm2, %xmm0, %xmm0
        vaddss  %xmm1, %xmm0, %xmm0
        vmovups -32(%rsi), %ymm1
        vsubps  -32(%rcx), %ymm1, %ymm1
        cmpl    140(%rsp), %edx
        vmulps  %ymm1, %ymm1, %ymm1
        vaddss  %xmm1, %xmm0, %xmm0
        vshufps $85, %xmm1, %xmm1, %xmm8
        vshufps $255, %xmm1, %xmm1, %xmm2
        vaddss  %xmm8, %xmm0, %xmm0
        vunpckhps       %xmm1, %xmm1, %xmm8
        vextractf128    $0x1, %ymm1, %xmm1
        vaddss  %xmm8, %xmm0, %xmm0
        vaddss  %xmm2, %xmm0, %xmm0
        vshufps $85, %xmm1, %xmm1, %xmm2
        vaddss  %xmm1, %xmm0, %xmm0
        vaddss  %xmm2, %xmm0, %xmm0
        vunpckhps       %xmm1, %xmm1, %xmm2
        vshufps $255, %xmm1, %xmm1, %xmm1
        vaddss  %xmm2, %xmm0, %xmm0
        vaddss  %xmm1, %xmm0, %xmm0
        jne     .L34
        movl    100(%rsp), %edx
.L33:
        xorl    %eax, %eax
.L35:
        vmovups (%rsi,%rax), %ymm1
        incl    %edx
        vsubps  (%rcx,%rax), %ymm1, %ymm1
        addq    $32, %rax
        cmpl    %edx, %r13d
        vmulps  %ymm1, %ymm1, %ymm2
        vaddss  %xmm2, %xmm0, %xmm0
        vshufps $85, %xmm2, %xmm2, %xmm1
        vshufps $255, %xmm2, %xmm2, %xmm8
        vaddss  %xmm1, %xmm0, %xmm0
        vunpckhps       %xmm2, %xmm2, %xmm1
        vaddss  %xmm1, %xmm0, %xmm0
        vextractf128    $0x1, %ymm2, %xmm1
        vshufps $85, %xmm1, %xmm1, %xmm2
        vaddss  %xmm8, %xmm0, %xmm0
        vaddss  %xmm1, %xmm0, %xmm0
        vaddss  %xmm2, %xmm0, %xmm0
        vunpckhps       %xmm1, %xmm1, %xmm2
        vshufps $255, %xmm1, %xmm1, %xmm1
        vaddss  %xmm2, %xmm0, %xmm0
        vaddss  %xmm1, %xmm0, %xmm0
        ja      .L35
        cmpl    %ebx, %r14d
        je      .L31
        movl    %r14d, %edx
.L32:
        movslq  %edx, %rcx
        vmovss  (%r8,%rcx,4), %xmm1
        leaq    0(,%rcx,4), %rax
        vsubss  (%rdi,%rcx,4), %xmm1, %xmm1
        leal    1(%rdx), %ecx
        cmpl    %ecx, %ebx
        vmulss  %xmm1, %xmm1, %xmm1
        vaddss  %xmm1, %xmm0, %xmm0
        jle     .L31
        vmovss  4(%r8,%rax), %xmm1
        leal    2(%rdx), %ecx
        vsubss  4(%rdi,%rax), %xmm1, %xmm1
        cmpl    %ecx, %ebx
        vmulss  %xmm1, %xmm1, %xmm1
        vaddss  %xmm1, %xmm0, %xmm0
        jle     .L31
        vmovss  8(%r8,%rax), %xmm1
        leal    3(%rdx), %ecx
        vsubss  8(%rdi,%rax), %xmm1, %xmm1
        cmpl    %ecx, %ebx
        vmulss  %xmm1, %xmm1, %xmm1
        vaddss  %xmm1, %xmm0, %xmm0
        jle     .L31
        vmovss  12(%r8,%rax), %xmm1
        leal    4(%rdx), %ecx
        vsubss  12(%rdi,%rax), %xmm1, %xmm1
        cmpl    %ecx, %ebx
        vmulss  %xmm1, %xmm1, %xmm1
        vaddss  %xmm1, %xmm0, %xmm0
        jle     .L31
        vmovss  16(%r8,%rax), %xmm1
        leal    5(%rdx), %ecx
        vsubss  16(%rdi,%rax), %xmm1, %xmm1
        cmpl    %ecx, %ebx
        vmulss  %xmm1, %xmm1, %xmm1
        vaddss  %xmm1, %xmm0, %xmm0
        jle     .L31
        vmovss  20(%r8,%rax), %xmm1
        addl    $6, %edx
        vsubss  20(%rdi,%rax), %xmm1, %xmm1
        cmpl    %edx, %ebx
        vmulss  %xmm1, %xmm1, %xmm1
        vaddss  %xmm1, %xmm0, %xmm0
        jle     .L31
        vmovss  24(%r8,%rax), %xmm1
        vsubss  24(%rdi,%rax), %xmm1, %xmm1
        vmulss  %xmm1, %xmm1, %xmm1
        vaddss  %xmm1, %xmm0, %xmm0
.L31:
        vcomiss %xmm0, %xmm3
        leaq    1(%r9), %rax
        vminss  %xmm3, %xmm0, %xmm3
        cmova   %r10d, %r12d
        cmpq    %r9, %r11
        je      .L30
        movq    %rax, %r9
        testl   %ebx, %ebx
        movq    (%r15,%r9,8), %rdi
        movl    %r9d, %r10d
        jg      .L101
.L64:
        vmovaps %xmm4, %xmm0
        jmp     .L31
.L12:
        cmpl    $16, %ebx
        jle     .L62
        leaq    100(%rcx), %rdx
        leaq    100(%rsi), %rax
        xorl    %edi, %edi
.L19:
        vmovss  -100(%rdx), %xmm0
        prefetcht0      (%rdx)
        prefetcht0      (%rax)
        vmovss  %xmm0, -100(%rax)
        addl    $16, %edi
        addq    $64, %rdx
        addq    $64, %rax
        vmovss  -160(%rdx), %xmm0
        vmovss  %xmm0, -160(%rax)
        vmovss  -156(%rdx), %xmm0
        vmovss  %xmm0, -156(%rax)
        vmovss  -152(%rdx), %xmm0
        vmovss  %xmm0, -152(%rax)
        vmovss  -148(%rdx), %xmm0
        vmovss  %xmm0, -148(%rax)
        vmovss  -144(%rdx), %xmm0
        vmovss  %xmm0, -144(%rax)
        vmovss  -140(%rdx), %xmm0
        vmovss  %xmm0, -140(%rax)
        vmovss  -136(%rdx), %xmm0
        vmovss  %xmm0, -136(%rax)
        vmovss  -132(%rdx), %xmm0
        vmovss  %xmm0, -132(%rax)
        vmovss  -128(%rdx), %xmm0
        vmovss  %xmm0, -128(%rax)
        vmovss  -124(%rdx), %xmm0
        vmovss  %xmm0, -124(%rax)
        vmovss  -120(%rdx), %xmm0
        vmovss  %xmm0, -120(%rax)
        vmovss  -116(%rdx), %xmm0
        vmovss  %xmm0, -116(%rax)
        vmovss  -112(%rdx), %xmm0
        vmovss  %xmm0, -112(%rax)
        vmovss  -108(%rdx), %xmm0
        vmovss  %xmm0, -108(%rax)
        vmovss  -104(%rdx), %xmm0
        vmovss  %xmm0, -104(%rax)
        cmpl    24(%rsp), %edi
        jne     .L19
.L18:
        movslq  %edi, %rdi
.L21:
        vmovss  (%rcx,%rdi,4), %xmm0
        vmovss  %xmm0, (%rsi,%rdi,4)
        incq    %rdi
        cmpl    %edi, %ebx
        jg      .L21
        jmp     .L20
.L30:
        movq    120(%rsp), %rax
        movq    128(%rsp), %rdi
        cmpl    %r12d, (%rax,%rdi,4)
        je      .L40
        vaddss  %xmm7, %xmm5, %xmm5
.L40:
        movq    120(%rsp), %rax
        movq    128(%rsp), %rdi
        movq    104(%rsp), %rsi
        movl    %r12d, (%rax,%rdi,4)
        movslq  %r12d, %rax
        incl    (%rsi,%rax,4)
        testl   %ebx, %ebx
        jle     .L47
        cmpl    $6, 152(%rsp)
        movq    112(%rsp), %rdi
        movq    (%rdi,%rax,8), %r9
        jbe     .L68
        cmpl    $1, 144(%rsp)
        jbe     .L69
        movq    %r8, %rsi
        movq    %r9, %rcx
        xorl    %eax, %eax
.L46:
        vmovups (%rcx), %ymm0
        prefetcht0      640(%rsi)
        movl    %eax, %edx
        addq    $64, %rsi
        addl    $2, %eax
        prefetcht0      640(%rcx)
        vaddps  -64(%rsi), %ymm0, %ymm0
        addq    $64, %rcx
        vmovups %ymm0, -64(%rcx)
        vmovups -32(%rsi), %ymm0
        vaddps  -32(%rcx), %ymm0, %ymm0
        vmovups %ymm0, -32(%rcx)
        cmpl    140(%rsp), %edx
        movq    %rcx, %rdi
        jne     .L46
        movl    100(%rsp), %edx
.L45:
        xorl    %eax, %eax
.L48:
        vmovups (%rsi,%rax), %ymm0
        incl    %edx
        vaddps  (%rcx,%rax), %ymm0, %ymm0
        vmovups %ymm0, (%rdi,%rax)
        addq    $32, %rax
        cmpl    %edx, %r13d
        ja      .L48
        cmpl    %ebx, %r14d
        je      .L47
        movl    %r14d, %edx
.L44:
        movslq  %edx, %rsi
        leaq    0(,%rsi,4), %rax
        leaq    (%r9,%rax), %rcx
        vmovss  (%rcx), %xmm0
        vaddss  (%r8,%rsi,4), %xmm0, %xmm0
        vmovss  %xmm0, (%rcx)
        leal    1(%rdx), %ecx
        cmpl    %ecx, %ebx
        jle     .L47
        leaq    4(%r9,%rax), %rcx
        vmovss  (%rcx), %xmm0
        vaddss  4(%r8,%rax), %xmm0, %xmm0
        vmovss  %xmm0, (%rcx)
        leal    2(%rdx), %ecx
        cmpl    %ecx, %ebx
        jle     .L47
        leaq    8(%r9,%rax), %rcx
        vmovss  (%rcx), %xmm0
        vaddss  8(%r8,%rax), %xmm0, %xmm0
        vmovss  %xmm0, (%rcx)
        leal    3(%rdx), %ecx
        cmpl    %ecx, %ebx
        jle     .L47
        leaq    12(%r9,%rax), %rcx
        vmovss  (%rcx), %xmm0
        vaddss  12(%r8,%rax), %xmm0, %xmm0
        vmovss  %xmm0, (%rcx)
        leal    4(%rdx), %ecx
        cmpl    %ebx, %ecx
        jge     .L47
        leaq    16(%r9,%rax), %rcx
        vmovss  (%rcx), %xmm0
        vaddss  16(%r8,%rax), %xmm0, %xmm0
        vmovss  %xmm0, (%rcx)
        leal    5(%rdx), %ecx
        cmpl    %ebx, %ecx
        jge     .L47
        leaq    20(%r9,%rax), %rcx
        addl    $6, %edx
        cmpl    %edx, %ebx
        vmovss  (%rcx), %xmm0
        vaddss  20(%r8,%rax), %xmm0, %xmm0
        vmovss  %xmm0, (%rcx)
        jle     .L47
        leaq    24(%r9,%rax), %rdx
        vmovss  (%rdx), %xmm0
        vaddss  24(%r8,%rax), %xmm0, %xmm0
        vmovss  %xmm0, (%rdx)
.L47:
        movq    128(%rsp), %rdi
        cmpq    %rdi, 80(%rsp)
        leaq    1(%rdi), %rax
        je      .L42
        movq    %rax, 128(%rsp)
        movq    %rax, %rdi
        jmp     .L43
.L65:
        vmovaps %xmm4, %xmm0
        xorl    %edx, %edx
        jmp     .L32
.L66:
        vmovaps %xmm4, %xmm0
        xorl    %edx, %edx
        jmp     .L33
.L100:
        vmovaps %xmm4, %xmm5
.L42:
        movl    136(%rsp), %eax
        leal    -17(%rbx), %edi
        xorl    %ecx, %ecx
        movl    %edi, 64(%rsp)
        leal    -1(%rax), %esi
        testl   %eax, %eax
        movq    %rsi, 128(%rsp)
        jle     .L51
        movl    %r12d, 40(%rsp)
        movl    %r13d, 24(%rsp)
        movq    112(%rsp), %r12
        movq    104(%rsp), %r13
        movl    %r14d, 32(%rsp)
        movq    %rcx, %r14
.L52:
        testl   %ebx, %ebx
        jle     .L57
        movl    0(%r13,%r14,4), %edx
        movq    (%r12,%r14,8), %rdi
        testl   %edx, %edx
        jle     .L102
        cmpl    $16, %ebx
        jle     .L70
        movl    64(%rsp), %r10d
        vcvtsi2ssl      %edx, %xmm1, %xmm1
        movq    (%r15,%r14,8), %rdx
        leaq    40(%rdi), %rsi
        movl    $40, %r9d
        xorl    %eax, %eax
        andl    $-16, %r10d
.L56:
        vmovss  -40(%rsi), %xmm0
        prefetcht0      (%rsi)
        movl    $0x00000000, -40(%rsi)
        vdivss  %xmm1, %xmm0, %xmm0
        movl    %eax, %ecx
        addq    $64, %rsi
        addl    $16, %eax
        vmovss  %xmm0, -40(%rdx,%r9)
        vmovss  -100(%rsi), %xmm0
        movl    $0x00000000, -100(%rsi)
        vdivss  %xmm1, %xmm0, %xmm0
        vmovss  %xmm0, -36(%rdx,%r9)
        vmovss  -96(%rsi), %xmm0
        movl    $0x00000000, -96(%rsi)
        vdivss  %xmm1, %xmm0, %xmm0
        vmovss  %xmm0, -32(%rdx,%r9)
        vmovss  -92(%rsi), %xmm0
        movl    $0x00000000, -92(%rsi)
        vdivss  %xmm1, %xmm0, %xmm0
        vmovss  %xmm0, -28(%rdx,%r9)
        vmovss  -88(%rsi), %xmm0
        movl    $0x00000000, -88(%rsi)
        vdivss  %xmm1, %xmm0, %xmm0
        vmovss  %xmm0, -24(%rdx,%r9)
        vmovss  -84(%rsi), %xmm0
        movl    $0x00000000, -84(%rsi)
        vdivss  %xmm1, %xmm0, %xmm0
        vmovss  %xmm0, -20(%rdx,%r9)
        vmovss  -80(%rsi), %xmm0
        movl    $0x00000000, -80(%rsi)
        vdivss  %xmm1, %xmm0, %xmm0
        vmovss  %xmm0, -16(%rdx,%r9)
        vmovss  -76(%rsi), %xmm0
        movl    $0x00000000, -76(%rsi)
        vdivss  %xmm1, %xmm0, %xmm0
        vmovss  %xmm0, -12(%rdx,%r9)
        vmovss  -72(%rsi), %xmm0
        movl    $0x00000000, -72(%rsi)
        vdivss  %xmm1, %xmm0, %xmm0
        vmovss  %xmm0, -8(%rdx,%r9)
        vmovss  -68(%rsi), %xmm0
        movl    $0x00000000, -68(%rsi)
        vdivss  %xmm1, %xmm0, %xmm0
        vmovss  %xmm0, -4(%rdx,%r9)
        vmovss  -64(%rsi), %xmm0
        vdivss  %xmm1, %xmm0, %xmm0
        vmovss  %xmm0, (%rdx,%r9)
        movl    $0x00000000, -64(%rsi)
        vmovss  -60(%rsi), %xmm0
        movl    $0x00000000, -60(%rsi)
        vdivss  %xmm1, %xmm0, %xmm0
        vmovss  %xmm0, 4(%rdx,%r9)
        vmovss  -56(%rsi), %xmm0
        movl    $0x00000000, -56(%rsi)
        vdivss  %xmm1, %xmm0, %xmm0
        vmovss  %xmm0, 8(%rdx,%r9)
        vmovss  -52(%rsi), %xmm0
        movl    $0x00000000, -52(%rsi)
        vdivss  %xmm1, %xmm0, %xmm0
        vmovss  %xmm0, 12(%rdx,%r9)
        vmovss  -48(%rsi), %xmm0
        movl    $0x00000000, -48(%rsi)
        vdivss  %xmm1, %xmm0, %xmm0
        vmovss  %xmm0, 16(%rdx,%r9)
        vmovss  -44(%rsi), %xmm0
        movl    $0x00000000, -44(%rsi)
        vdivss  %xmm1, %xmm0, %xmm0
        vmovss  %xmm0, 20(%rdx,%r9)
        addq    $64, %r9
        cmpl    %ecx, %r10d
        jne     .L56
.L55:
        cltq
.L58:
        vmovss  (%rdi,%rax,4), %xmm0
        movl    $0x00000000, (%rdi,%rax,4)
        vdivss  %xmm1, %xmm0, %xmm0
        vmovss  %xmm0, (%rdx,%rax,4)
        incq    %rax
        cmpl    %eax, %ebx
        jg      .L58
.L57:
        cmpq    %r14, 128(%rsp)
        leaq    1(%r14), %rax
        movl    $0, 0(%r13,%r14,4)
        je      .L95
        movq    %rax, %r14
        jmp     .L52
.L102:
        movq    56(%rsp), %rdx
        xorl    %esi, %esi
        vmovss  %xmm5, 80(%rsp)
        vzeroupper
        call    memset
        vxorps  %xmm4, %xmm4, %xmm4
        vmovss  80(%rsp), %xmm5
        jmp     .L57
.L95:
        movl    40(%rsp), %r12d
        movl    32(%rsp), %r14d
        movl    24(%rsp), %r13d
.L51:
        vcomiss 28(%rsp), %xmm5
        ja      .L28
        movq    72(%rsp), %rdi
        vzeroupper
        call    free
        movq    112(%rsp), %rdi
        call    free
        movq    104(%rsp), %rdi
        call    free
        leaq    -40(%rbp), %rsp
        movq    %r15, %rax
        popq    %rbx
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        popq    %rbp
        ret
.L68:
        xorl    %edx, %edx
        jmp     .L44
.L69:
        movq    %r9, %rdi
        movq    %r8, %rsi
        movq    %r9, %rcx
        xorl    %edx, %edx
        jmp     .L45
.L70:
        vcvtsi2ssl      %edx, %xmm1, %xmm1
        xorl    %eax, %eax
        movq    (%r15,%r14,8), %rdx
        jmp     .L55
.L98:
        je      .L8
        movl    96(%rsp), %eax
        testl   %eax, %eax
        jle     .L59
        leal    -1(%rbx), %eax
        movl    %eax, 152(%rsp)
        jmp     .L13
.L60:
        movl    $1, %esi
        jmp     .L6
.L62:
        xorl    %edi, %edi
        jmp     .L18
.L63:
        movl    $1, %edx
        jmp     .L23
.L99:
        leal    -1(%rbx), %eax
        movl    %eax, 152(%rsp)
        jmp     .L4
.L59:
        movq    144(%rsp), %rdi
        movl    $4, %esi
        call    calloc
        movq    %r13, %rdi
        movq    %rax, 104(%rsp)
        call    malloc
        movl    $4, %esi
        movq    %rax, %r13
        movq    %r14, %rdi
        movq    %rax, 112(%rsp)
        call    calloc
        movq    %rax, 72(%rsp)
        movq    %rax, 0(%r13)
        leal    -1(%rbx), %eax
        movl    %eax, 152(%rsp)
        jmp     .L14
_Z12kmeans_outerPPfiiifPifS0_S1_S0_Pv:
        pushq   %rbp
        movq    %rsp, %rbp
        pushq   %r15
        movq    %r9, %r15
        pushq   %r14
        movl    %esi, %r14d
        andl    $-8, %r14d
        pushq   %r13
        pushq   %r12
        movl    %esi, %r12d
        shrl    $3, %r12d
        pushq   %rbx
        leal    -1(%r12), %eax
        movl    %esi, %ebx
        andq    $-32, %rsp
        subq    $208, %rsp
        movl    %eax, 200(%rsp)
        leal    -3(%r12), %eax
        movq    %rdi, 160(%rsp)
        leal    -1(%rsi), %edi
        vmovss  %xmm0, 72(%rsp)
        movl    %edx, 76(%rsp)
        andl    $-2, %eax
        movl    %ecx, 172(%rsp)
        movq    %r8, 176(%rsp)
        movl    %eax, 196(%rsp)
        addl    $2, %eax
        movl    %eax, 168(%rsp)
        movslq  %r14d, %rax
        movl    %edi, 204(%rsp)
        salq    $2, %rax
        movq    %rax, 152(%rsp)
        leal    1(%r14), %eax
        movl    %eax, 148(%rsp)
        cltq
        salq    $2, %rax
        movq    %rax, 136(%rsp)
        leal    2(%r14), %eax
        movl    %eax, 144(%rsp)
        cltq
        salq    $2, %rax
        movq    %rax, 128(%rsp)
        leal    3(%r14), %eax
        movl    %eax, 124(%rsp)
        cltq
        salq    $2, %rax
        movq    %rax, 112(%rsp)
        leal    4(%r14), %eax
        movl    %eax, 120(%rsp)
        cltq
        salq    $2, %rax
        movq    %rax, 104(%rsp)
        leal    5(%r14), %eax
        movl    %eax, 100(%rsp)
        cltq
        salq    $2, %rax
        movq    %rax, 80(%rsp)
        leal    6(%r14), %eax
        movl    %eax, 96(%rsp)
        cltq
        salq    $2, %rax
        movq    %rax, 88(%rsp)
        movl    %edi, %eax
        leaq    4(,%rax,4), %rax
        movq    %rax, 64(%rsp)
        leal    -17(%rsi), %eax
        andl    $-16, %eax
        movl    %eax, 60(%rsp)
        addl    $16, %eax
        movl    %eax, 56(%rsp)
.L133:
        movl    76(%rsp), %edx
        testl   %edx, %edx
        jle     .L174
        vxorps  %xmm4, %xmm4, %xmm4
        xorl    %eax, %eax
        vmovaps %xmm4, %xmm1
.L104:
        movl    76(%rsp), %esi
        leal    64(%rax), %edx
        cmpl    %esi, %edx
        cmovg   %esi, %edx
        cmpl    %edx, %eax
        movl    %edx, 192(%rsp)
        jge     .L144
        movq    %rax, 184(%rsp)
        movl    172(%rsp), %eax
        leal    -1(%rax), %r11d
.L118:
        movq    160(%rsp), %rax
        movq    184(%rsp), %rdi
        movq    (%rax,%rdi,8), %r8
        movl    172(%rsp), %eax
        testl   %eax, %eax
        jle     .L106
        xorl    %r9d, %r9d
        testl   %ebx, %ebx
        vmovss  .LC1(%rip), %xmm5
        movq    (%r15,%r9,8), %rdi
        movl    %r9d, %r10d
        jle     .L145
.L175:
        cmpl    $6, 204(%rsp)
        jbe     .L146
        cmpl    $1, 200(%rsp)
        movq    %rdi, %rcx
        movq    %r8, %rsi
        jbe     .L147
        vmovaps %xmm4, %xmm0
        xorl    %eax, %eax
.L110:
        vmovups (%rsi), %ymm3
        movl    %eax, %edx
        prefetcht0      384(%rsi)
        addl    $2, %eax
        addq    $64, %rsi
        prefetcht0      384(%rcx)
        vsubps  (%rcx), %ymm3, %ymm3
        addq    $64, %rcx
        vmulps  %ymm3, %ymm3, %ymm3
        vaddss  %xmm0, %xmm3, %xmm0
        vshufps $85, %xmm3, %xmm3, %xmm2
        vshufps $255, %xmm3, %xmm3, %xmm6
        vaddss  %xmm2, %xmm0, %xmm0
        vunpckhps       %xmm3, %xmm3, %xmm2
        vaddss  %xmm0, %xmm2, %xmm2
        vextractf128    $0x1, %ymm3, %xmm0
        vshufps $85, %xmm0, %xmm0, %xmm3
        vaddss  %xmm6, %xmm2, %xmm2
        vaddss  %xmm0, %xmm2, %xmm2
        vaddss  %xmm3, %xmm2, %xmm2
        vunpckhps       %xmm0, %xmm0, %xmm3
        vshufps $255, %xmm0, %xmm0, %xmm0
        vaddss  %xmm3, %xmm2, %xmm2
        vmovups -32(%rsi), %ymm3
        vsubps  -32(%rcx), %ymm3, %ymm3
        cmpl    196(%rsp), %edx
        vaddss  %xmm0, %xmm2, %xmm2
        vmulps  %ymm3, %ymm3, %ymm3
        vaddss  %xmm3, %xmm2, %xmm2
        vshufps $85, %xmm3, %xmm3, %xmm6
        vshufps $255, %xmm3, %xmm3, %xmm0
        vaddss  %xmm6, %xmm2, %xmm2
        vunpckhps       %xmm3, %xmm3, %xmm6
        vextractf128    $0x1, %ymm3, %xmm3
        vaddss  %xmm6, %xmm2, %xmm2
        vaddss  %xmm0, %xmm2, %xmm2
        vshufps $85, %xmm3, %xmm3, %xmm0
        vaddss  %xmm3, %xmm2, %xmm2
        vaddss  %xmm0, %xmm2, %xmm2
        vunpckhps       %xmm3, %xmm3, %xmm0
        vaddss  %xmm0, %xmm2, %xmm2
        vshufps $255, %xmm3, %xmm3, %xmm0
        vaddss  %xmm0, %xmm2, %xmm0
        jne     .L110
        movl    168(%rsp), %edx
.L109:
        xorl    %eax, %eax
.L111:
        vmovups (%rsi,%rax), %ymm2
        incl    %edx
        vsubps  (%rcx,%rax), %ymm2, %ymm2
        addq    $32, %rax
        cmpl    %edx, %r12d
        vmulps  %ymm2, %ymm2, %ymm3
        vaddss  %xmm3, %xmm0, %xmm0
        vshufps $85, %xmm3, %xmm3, %xmm2
        vshufps $255, %xmm3, %xmm3, %xmm6
        vaddss  %xmm2, %xmm0, %xmm0
        vunpckhps       %xmm3, %xmm3, %xmm2
        vaddss  %xmm2, %xmm0, %xmm0
        vextractf128    $0x1, %ymm3, %xmm2
        vshufps $85, %xmm2, %xmm2, %xmm3
        vaddss  %xmm6, %xmm0, %xmm0
        vaddss  %xmm2, %xmm0, %xmm0
        vaddss  %xmm3, %xmm0, %xmm0
        vunpckhps       %xmm2, %xmm2, %xmm3
        vshufps $255, %xmm2, %xmm2, %xmm2
        vaddss  %xmm3, %xmm0, %xmm0
        vaddss  %xmm2, %xmm0, %xmm0
        ja      .L111
        cmpl    %r14d, %ebx
        je      .L107
        movl    %r14d, %edx
.L108:
        movslq  %edx, %rcx
        vmovss  (%r8,%rcx,4), %xmm2
        leaq    0(,%rcx,4), %rax
        vsubss  (%rdi,%rcx,4), %xmm2, %xmm2
        leal    1(%rdx), %ecx
        cmpl    %ecx, %ebx
        vmulss  %xmm2, %xmm2, %xmm2
        vaddss  %xmm2, %xmm0, %xmm0
        jle     .L107
        vmovss  4(%r8,%rax), %xmm2
        leal    2(%rdx), %ecx
        vsubss  4(%rdi,%rax), %xmm2, %xmm2
        cmpl    %ecx, %ebx
        vmulss  %xmm2, %xmm2, %xmm2
        vaddss  %xmm2, %xmm0, %xmm0
        jle     .L107
        vmovss  8(%r8,%rax), %xmm2
        leal    3(%rdx), %ecx
        vsubss  8(%rdi,%rax), %xmm2, %xmm2
        cmpl    %ecx, %ebx
        vmulss  %xmm2, %xmm2, %xmm2
        vaddss  %xmm2, %xmm0, %xmm0
        jle     .L107
        vmovss  12(%r8,%rax), %xmm2
        leal    4(%rdx), %ecx
        vsubss  12(%rdi,%rax), %xmm2, %xmm2
        cmpl    %ecx, %ebx
        vmulss  %xmm2, %xmm2, %xmm2
        vaddss  %xmm2, %xmm0, %xmm0
        jle     .L107
        vmovss  16(%r8,%rax), %xmm2
        leal    5(%rdx), %ecx
        vsubss  16(%rdi,%rax), %xmm2, %xmm2
        cmpl    %ecx, %ebx
        vmulss  %xmm2, %xmm2, %xmm2
        vaddss  %xmm2, %xmm0, %xmm0
        jle     .L107
        vmovss  20(%r8,%rax), %xmm2
        addl    $6, %edx
        vsubss  20(%rdi,%rax), %xmm2, %xmm2
        cmpl    %edx, %ebx
        vmulss  %xmm2, %xmm2, %xmm2
        vaddss  %xmm2, %xmm0, %xmm0
        jle     .L107
        vmovss  24(%r8,%rax), %xmm2
        vsubss  24(%rdi,%rax), %xmm2, %xmm2
        vmulss  %xmm2, %xmm2, %xmm2
        vaddss  %xmm2, %xmm0, %xmm0
.L107:
        vcomiss %xmm0, %xmm5
        leaq    1(%r9), %rax
        vminss  %xmm5, %xmm0, %xmm5
        cmova   %r10d, %r13d
        cmpq    %r11, %r9
        je      .L106
        movq    %rax, %r9
        testl   %ebx, %ebx
        movq    (%r15,%r9,8), %rdi
        movl    %r9d, %r10d
        jg      .L175
.L145:
        vmovaps %xmm4, %xmm0
        jmp     .L107
.L106:
        movq    176(%rsp), %rax
        movq    184(%rsp), %rdi
        cmpl    %r13d, (%rax,%rdi,4)
        je      .L116
        vaddss  .LC2(%rip), %xmm1, %xmm1
.L116:
        movq    176(%rsp), %rax
        movq    184(%rsp), %rdi
        movl    %r13d, (%rax,%rdi,4)
        movq    16(%rbp), %rdi
        movslq  %r13d, %rax
        incl    (%rdi,%rax,4)
        testl   %ebx, %ebx
        jle     .L122
        movq    24(%rbp), %rdi
        movq    (%rdi,%rax,8), %rcx
        leaq    31(%r8), %rax
        subq    %rcx, %rax
        cmpq    $62, %rax
        jbe     .L119
        cmpl    $6, 204(%rsp)
        jbe     .L119
        cmpl    $1, 200(%rsp)
        jbe     .L149
        movq    %r8, %rdi
        movq    %rcx, %rsi
        xorl    %eax, %eax
.L121:
        vmovups (%rsi), %ymm0
        prefetcht0      640(%rdi)
        movl    %eax, %edx
        addq    $64, %rdi
        addl    $2, %eax
        prefetcht0      640(%rsi)
        vaddps  -64(%rdi), %ymm0, %ymm0
        addq    $64, %rsi
        vmovups %ymm0, -64(%rsi)
        vmovups -32(%rdi), %ymm0
        vaddps  -32(%rsi), %ymm0, %ymm0
        vmovups %ymm0, -32(%rsi)
        cmpl    196(%rsp), %edx
        movq    %rsi, %r9
        jne     .L121
        movl    168(%rsp), %edx
.L120:
        xorl    %eax, %eax
.L123:
        vmovups (%rdi,%rax), %ymm0
        incl    %edx
        vaddps  (%rsi,%rax), %ymm0, %ymm0
        vmovups %ymm0, (%r9,%rax)
        addq    $32, %rax
        cmpl    %edx, %r12d
        ja      .L123
        cmpl    %r14d, %ebx
        je      .L122
        movq    152(%rsp), %rdi
        cmpl    148(%rsp), %ebx
        leaq    (%rcx,%rdi), %rax
        vmovss  (%rax), %xmm0
        vaddss  (%r8,%rdi), %xmm0, %xmm0
        vmovss  %xmm0, (%rax)
        jle     .L122
        movq    136(%rsp), %rsi
        cmpl    144(%rsp), %ebx
        leaq    (%rcx,%rsi), %rax
        vmovss  (%rax), %xmm0
        vaddss  (%r8,%rsi), %xmm0, %xmm0
        vmovss  %xmm0, (%rax)
        jle     .L122
        movq    128(%rsp), %rsi
        cmpl    124(%rsp), %ebx
        leaq    (%rcx,%rsi), %rax
        vmovss  (%rax), %xmm0
        vaddss  (%r8,%rsi), %xmm0, %xmm0
        vmovss  %xmm0, (%rax)
        jle     .L122
        movq    112(%rsp), %rdi
        cmpl    120(%rsp), %ebx
        leaq    (%rcx,%rdi), %rax
        vmovss  (%rax), %xmm0
        vaddss  (%r8,%rdi), %xmm0, %xmm0
        vmovss  %xmm0, (%rax)
        jle     .L122
        movq    104(%rsp), %rsi
        cmpl    100(%rsp), %ebx
        leaq    (%rcx,%rsi), %rax
        vmovss  (%rax), %xmm0
        vaddss  (%r8,%rsi), %xmm0, %xmm0
        vmovss  %xmm0, (%rax)
        jle     .L122
        movq    80(%rsp), %rdi
        cmpl    96(%rsp), %ebx
        leaq    (%rcx,%rdi), %rax
        vmovss  (%rax), %xmm0
        vaddss  (%r8,%rdi), %xmm0, %xmm0
        vmovss  %xmm0, (%rax)
        jle     .L122
        movq    88(%rsp), %rax
        addq    %rax, %rcx
        vmovss  (%rcx), %xmm0
        vaddss  (%r8,%rax), %xmm0, %xmm0
        vmovss  %xmm0, (%rcx)
.L122:
        incq    184(%rsp)
        movq    184(%rsp), %rax
        cmpl    %eax, 192(%rsp)
        jg      .L118
        movl    192(%rsp), %esi
        cmpl    %esi, 76(%rsp)
        jle     .L129
.L177:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L176
.L130:
        movslq  192(%rsp), %rax
        jmp     .L104
.L146:
        vmovaps %xmm4, %xmm0
        xorl    %edx, %edx
        jmp     .L108
.L147:
        vmovaps %xmm4, %xmm0
        xorl    %edx, %edx
        jmp     .L109
.L119:
        cmpl    $16, %ebx
        jle     .L150
        leaq    80(%rcx), %rax
        leaq    80(%r8), %rdx
        xorl    %esi, %esi
.L126:
        vmovss  -80(%rax), %xmm0
        prefetcht0      (%rdx)
        prefetcht0      (%rax)
        vaddss  -80(%rdx), %xmm0, %xmm0
        addl    $16, %esi
        addq    $64, %rax
        addq    $64, %rdx
        vmovss  %xmm0, -144(%rax)
        vmovss  -140(%rax), %xmm0
        vaddss  -140(%rdx), %xmm0, %xmm0
        vmovss  %xmm0, -140(%rax)
        vmovss  -136(%rax), %xmm0
        vaddss  -136(%rdx), %xmm0, %xmm0
        vmovss  %xmm0, -136(%rax)
        vmovss  -132(%rax), %xmm0
        vaddss  -132(%rdx), %xmm0, %xmm0
        vmovss  %xmm0, -132(%rax)
        vmovss  -128(%rax), %xmm0
        vaddss  -128(%rdx), %xmm0, %xmm0
        vmovss  %xmm0, -128(%rax)
        vmovss  -124(%rax), %xmm0
        vaddss  -124(%rdx), %xmm0, %xmm0
        vmovss  %xmm0, -124(%rax)
        vmovss  -120(%rax), %xmm0
        vaddss  -120(%rdx), %xmm0, %xmm0
        vmovss  %xmm0, -120(%rax)
        vmovss  -116(%rax), %xmm0
        vaddss  -116(%rdx), %xmm0, %xmm0
        vmovss  %xmm0, -116(%rax)
        vmovss  -112(%rax), %xmm0
        vaddss  -112(%rdx), %xmm0, %xmm0
        vmovss  %xmm0, -112(%rax)
        vmovss  -108(%rax), %xmm0
        vaddss  -108(%rdx), %xmm0, %xmm0
        vmovss  %xmm0, -108(%rax)
        vmovss  -104(%rax), %xmm0
        vaddss  -104(%rdx), %xmm0, %xmm0
        vmovss  %xmm0, -104(%rax)
        vmovss  -100(%rax), %xmm0
        vaddss  -100(%rdx), %xmm0, %xmm0
        vmovss  %xmm0, -100(%rax)
        vmovss  -96(%rax), %xmm0
        vaddss  -96(%rdx), %xmm0, %xmm0
        vmovss  %xmm0, -96(%rax)
        vmovss  -92(%rax), %xmm0
        vaddss  -92(%rdx), %xmm0, %xmm0
        vmovss  %xmm0, -92(%rax)
        vmovss  -88(%rax), %xmm0
        vaddss  -88(%rdx), %xmm0, %xmm0
        vmovss  %xmm0, -88(%rax)
        vmovss  -84(%rax), %xmm0
        vaddss  -84(%rdx), %xmm0, %xmm0
        vmovss  %xmm0, -84(%rax)
        cmpl    56(%rsp), %esi
        jne     .L126
.L125:
        movslq  %esi, %rax
.L128:
        vmovss  (%rcx,%rax,4), %xmm0
        vaddss  (%r8,%rax,4), %xmm0, %xmm0
        vmovss  %xmm0, (%rcx,%rax,4)
        incq    %rax
        cmpl    %eax, %ebx
        jg      .L128
        jmp     .L122
.L149:
        movq    %rcx, %r9
        movq    %r8, %rdi
        movq    %rcx, %rsi
        xorl    %edx, %edx
        jmp     .L120
.L150:
        xorl    %esi, %esi
        jmp     .L125
.L144:
        movl    %eax, 192(%rsp)
        movl    192(%rsp), %esi
        cmpl    %esi, 76(%rsp)
        jg      .L177
.L129:
        movl    172(%rsp), %eax
        xorl    %r9d, %r9d
        leal    -1(%rax), %edi
        testl   %eax, %eax
        movq    %rdi, 184(%rsp)
        jle     .L135
.L136:
        testl   %ebx, %ebx
        jle     .L141
        movq    16(%rbp), %rax
        movl    (%rax,%r9,4), %ecx
        movq    24(%rbp), %rax
        testl   %ecx, %ecx
        movq    (%rax,%r9,8), %rdi
        jle     .L178
        cmpl    $16, %ebx
        jle     .L151
        vcvtsi2ssl      %ecx, %xmm0, %xmm0
        movq    (%r15,%r9,8), %rcx
        leaq    40(%rdi), %rdx
        movl    $40, %esi
        xorl    %eax, %eax
.L140:
        vmovss  -40(%rdx), %xmm2
        prefetcht0      (%rdx)
        movl    %eax, %r8d
        vdivss  %xmm0, %xmm2, %xmm2
        addl    $16, %eax
        addq    $64, %rdx
        vmovss  %xmm2, -40(%rcx,%rsi)
        movl    $0x00000000, -104(%rdx)
        vmovss  -100(%rdx), %xmm2
        vdivss  %xmm0, %xmm2, %xmm2
        vmovss  %xmm2, -36(%rcx,%rsi)
        movl    $0x00000000, -100(%rdx)
        vmovss  -96(%rdx), %xmm2
        vdivss  %xmm0, %xmm2, %xmm2
        vmovss  %xmm2, -32(%rcx,%rsi)
        movl    $0x00000000, -96(%rdx)
        vmovss  -92(%rdx), %xmm2
        vdivss  %xmm0, %xmm2, %xmm2
        vmovss  %xmm2, -28(%rcx,%rsi)
        movl    $0x00000000, -92(%rdx)
        vmovss  -88(%rdx), %xmm2
        vdivss  %xmm0, %xmm2, %xmm2
        vmovss  %xmm2, -24(%rcx,%rsi)
        movl    $0x00000000, -88(%rdx)
        vmovss  -84(%rdx), %xmm2
        vdivss  %xmm0, %xmm2, %xmm2
        vmovss  %xmm2, -20(%rcx,%rsi)
        movl    $0x00000000, -84(%rdx)
        vmovss  -80(%rdx), %xmm2
        vdivss  %xmm0, %xmm2, %xmm2
        vmovss  %xmm2, -16(%rcx,%rsi)
        movl    $0x00000000, -80(%rdx)
        vmovss  -76(%rdx), %xmm2
        vdivss  %xmm0, %xmm2, %xmm2
        vmovss  %xmm2, -12(%rcx,%rsi)
        movl    $0x00000000, -76(%rdx)
        vmovss  -72(%rdx), %xmm2
        vdivss  %xmm0, %xmm2, %xmm2
        vmovss  %xmm2, -8(%rcx,%rsi)
        movl    $0x00000000, -72(%rdx)
        vmovss  -68(%rdx), %xmm2
        vdivss  %xmm0, %xmm2, %xmm2
        vmovss  %xmm2, -4(%rcx,%rsi)
        movl    $0x00000000, -68(%rdx)
        vmovss  -64(%rdx), %xmm2
        vdivss  %xmm0, %xmm2, %xmm2
        vmovss  %xmm2, (%rcx,%rsi)
        movl    $0x00000000, -64(%rdx)
        vmovss  -60(%rdx), %xmm2
        vdivss  %xmm0, %xmm2, %xmm2
        vmovss  %xmm2, 4(%rcx,%rsi)
        movl    $0x00000000, -60(%rdx)
        vmovss  -56(%rdx), %xmm2
        vdivss  %xmm0, %xmm2, %xmm2
        vmovss  %xmm2, 8(%rcx,%rsi)
        movl    $0x00000000, -56(%rdx)
        vmovss  -52(%rdx), %xmm2
        vdivss  %xmm0, %xmm2, %xmm2
        vmovss  %xmm2, 12(%rcx,%rsi)
        movl    $0x00000000, -52(%rdx)
        vmovss  -48(%rdx), %xmm2
        vdivss  %xmm0, %xmm2, %xmm2
        vmovss  %xmm2, 16(%rcx,%rsi)
        movl    $0x00000000, -48(%rdx)
        vmovss  -44(%rdx), %xmm2
        vdivss  %xmm0, %xmm2, %xmm2
        vmovss  %xmm2, 20(%rcx,%rsi)
        movl    $0x00000000, -44(%rdx)
        addq    $64, %rsi
        cmpl    %r8d, 60(%rsp)
        jne     .L140
.L139:
        cltq
.L142:
        vmovss  (%rdi,%rax,4), %xmm2
        vdivss  %xmm0, %xmm2, %xmm2
        vmovss  %xmm2, (%rcx,%rax,4)
        movl    $0x00000000, (%rdi,%rax,4)
        incq    %rax
        cmpl    %eax, %ebx
        jg      .L142
.L141:
        cmpq    %r9, 184(%rsp)
        movq    16(%rbp), %rax
        movl    $0, (%rax,%r9,4)
        leaq    1(%r9), %rax
        je      .L135
        movq    %rax, %r9
        jmp     .L136
.L176:
        movq    32(%rbp), %rax
        movl    76(%rsp), %edx
        movq    %r15, %r9
        movq    176(%rsp), %r8
        movl    172(%rsp), %ecx
        vmovss  %xmm1, 184(%rsp)
        movq    160(%rsp), %rdi
        movl    %esi, 16(%rsp)
        movl    %ebx, %esi
        movq    %rax, 32(%rsp)
        movq    24(%rbp), %rax
        vmovss  72(%rsp), %xmm0
        movl    %edx, 24(%rsp)
        movq    %rax, 8(%rsp)
        movq    16(%rbp), %rax
        movq    %rax, (%rsp)
        vzeroupper
        call    _Z20kmeans_outer_handlerPPfiiifPifS0_S1_S0_iiPv
        testl   %eax, %eax
        vxorps  %xmm4, %xmm4, %xmm4
        vmovss  184(%rsp), %xmm1
        je      .L130
        leaq    -40(%rbp), %rsp
        popq    %rbx
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        popq    %rbp
        ret
.L178:
        movq    64(%rsp), %rdx
        xorl    %esi, %esi
        vmovss  %xmm1, 192(%rsp)
        movq    %r9, 48(%rsp)
        vzeroupper
        call    memset
        movq    48(%rsp), %r9
        vmovss  192(%rsp), %xmm1
        jmp     .L141
.L135:
        vcomiss 72(%rsp), %xmm1
        ja      .L133
.L174:
        vzeroupper
        leaq    -40(%rbp), %rsp
        popq    %rbx
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        popq    %rbp
        ret
.L151:
        vcvtsi2ssl      %ecx, %xmm0, %xmm0
        xorl    %eax, %eax
        movq    (%r15,%r9,8), %rcx
        jmp     .L139
_Z12kmeans_innerPPfiiifPiS_S0_S1_S0_iiPv:
        pushq   %rbp
        movq    %rsp, %rbp
        pushq   %r15
        pushq   %r14
        pushq   %r13
        pushq   %r12
        pushq   %rbx
        andq    $-32, %rsp
        subq    $208, %rsp
        movq    16(%rbp), %r15
        movl    %edx, 68(%rsp)
        movl    40(%rbp), %edx
        cmpl    48(%rbp), %edx
        movq    %rdi, 160(%rsp)
        movl    %ecx, 172(%rsp)
        movq    %r8, 176(%rsp)
        movq    %r9, 72(%rsp)
        jge     .L232
        leal    -1(%rsi), %eax
        movl    %esi, %ebx
        movl    %esi, %r13d
        shrl    $3, %ebx
        andl    $-8, %r13d
        movl    %esi, %r14d
        movl    %eax, 204(%rsp)
        leal    -1(%rbx), %eax
        vmovaps %xmm0, %xmm6
        vmovss  (%r9), %xmm5
        movl    %eax, 200(%rsp)
        leal    -3(%rbx), %eax
        andl    $-2, %eax
        movl    %eax, 196(%rsp)
        addl    $2, %eax
        movl    %eax, 168(%rsp)
        movslq  %r13d, %rax
        salq    $2, %rax
        movq    %rax, 144(%rsp)
        leal    1(%r13), %eax
        movl    %eax, 156(%rsp)
        cltq
        salq    $2, %rax
        movq    %rax, 136(%rsp)
        leal    2(%r13), %eax
        movl    %eax, 152(%rsp)
        cltq
        salq    $2, %rax
        movq    %rax, 128(%rsp)
        leal    3(%r13), %eax
        movl    %eax, 124(%rsp)
        cltq
        salq    $2, %rax
        movq    %rax, 112(%rsp)
        leal    4(%r13), %eax
        movl    %eax, 120(%rsp)
        cltq
        salq    $2, %rax
        movq    %rax, 104(%rsp)
        leal    5(%r13), %eax
        movl    %eax, 100(%rsp)
        cltq
        salq    $2, %rax
        movq    %rax, 80(%rsp)
        leal    6(%r13), %eax
        movl    %eax, 96(%rsp)
        cltq
        salq    $2, %rax
        movq    %rax, 88(%rsp)
        leal    -17(%rsi), %eax
        andl    $-16, %eax
        addl    $16, %eax
        movl    %eax, 64(%rsp)
.L182:
        leal    64(%rdx), %eax
        cmpl    48(%rbp), %eax
        cmovg   48(%rbp), %eax
        cmpl    %eax, %edx
        movl    %eax, 192(%rsp)
        jge     .L209
        movslq  %edx, %rax
        movq    %rax, 184(%rsp)
        movl    172(%rsp), %eax
        leal    -1(%rax), %r11d
.L205:
        movq    160(%rsp), %rax
        movq    184(%rsp), %rdi
        movq    (%rax,%rdi,8), %r8
        movl    172(%rsp), %eax
        testl   %eax, %eax
        jle     .L184
        xorl    %r9d, %r9d
        testl   %r14d, %r14d
        vxorps  %xmm4, %xmm4, %xmm4
        movq    (%r15,%r9,8), %rdi
        movl    %r9d, %r10d
        vmovss  .LC1(%rip), %xmm3
        jle     .L210
.L234:
        cmpl    $6, 204(%rsp)
        jbe     .L211
        cmpl    $1, 200(%rsp)
        movq    %rdi, %rsi
        movq    %r8, %rcx
        jbe     .L212
        vmovaps %xmm4, %xmm0
        xorl    %eax, %eax
.L188:
        vmovups (%rcx), %ymm1
        movl    %eax, %edx
        prefetcht0      384(%rcx)
        addl    $2, %eax
        addq    $64, %rcx
        prefetcht0      384(%rsi)
        vsubps  (%rsi), %ymm1, %ymm1
        addq    $64, %rsi
        vmulps  %ymm1, %ymm1, %ymm2
        vaddss  %xmm2, %xmm0, %xmm0
        vshufps $85, %xmm2, %xmm2, %xmm1
        vshufps $255, %xmm2, %xmm2, %xmm7
        vaddss  %xmm1, %xmm0, %xmm0
        vunpckhps       %xmm2, %xmm2, %xmm1
        vaddss  %xmm1, %xmm0, %xmm0
        vextractf128    $0x1, %ymm2, %xmm1
        vshufps $85, %xmm1, %xmm1, %xmm2
        vaddss  %xmm7, %xmm0, %xmm0
        vaddss  %xmm1, %xmm0, %xmm0
        vaddss  %xmm2, %xmm0, %xmm0
        vunpckhps       %xmm1, %xmm1, %xmm2
        vshufps $255, %xmm1, %xmm1, %xmm1
        vaddss  %xmm2, %xmm0, %xmm0
        vaddss  %xmm1, %xmm0, %xmm0
        vmovups -32(%rcx), %ymm1
        vsubps  -32(%rsi), %ymm1, %ymm1
        cmpl    196(%rsp), %edx
        vmulps  %ymm1, %ymm1, %ymm1
        vaddss  %xmm1, %xmm0, %xmm0
        vshufps $85, %xmm1, %xmm1, %xmm7
        vshufps $255, %xmm1, %xmm1, %xmm2
        vaddss  %xmm7, %xmm0, %xmm0
        vunpckhps       %xmm1, %xmm1, %xmm7
        vextractf128    $0x1, %ymm1, %xmm1
        vaddss  %xmm7, %xmm0, %xmm0
        vaddss  %xmm2, %xmm0, %xmm0
        vshufps $85, %xmm1, %xmm1, %xmm2
        vaddss  %xmm1, %xmm0, %xmm0
        vaddss  %xmm2, %xmm0, %xmm0
        vunpckhps       %xmm1, %xmm1, %xmm2
        vshufps $255, %xmm1, %xmm1, %xmm1
        vaddss  %xmm2, %xmm0, %xmm0
        vaddss  %xmm1, %xmm0, %xmm0
        jne     .L188
        movl    168(%rsp), %edx
.L187:
        xorl    %eax, %eax
.L189:
        vmovups (%rcx,%rax), %ymm1
        incl    %edx
        vsubps  (%rsi,%rax), %ymm1, %ymm1
        addq    $32, %rax
        cmpl    %edx, %ebx
        vmulps  %ymm1, %ymm1, %ymm2
        vaddss  %xmm2, %xmm0, %xmm0
        vshufps $85, %xmm2, %xmm2, %xmm1
        vshufps $255, %xmm2, %xmm2, %xmm7
        vaddss  %xmm1, %xmm0, %xmm0
        vunpckhps       %xmm2, %xmm2, %xmm1
        vaddss  %xmm1, %xmm0, %xmm0
        vextractf128    $0x1, %ymm2, %xmm1
        vshufps $85, %xmm1, %xmm1, %xmm2
        vaddss  %xmm7, %xmm0, %xmm0
        vaddss  %xmm1, %xmm0, %xmm0
        vaddss  %xmm2, %xmm0, %xmm0
        vunpckhps       %xmm1, %xmm1, %xmm2
        vshufps $255, %xmm1, %xmm1, %xmm1
        vaddss  %xmm2, %xmm0, %xmm0
        vaddss  %xmm1, %xmm0, %xmm0
        ja      .L189
        cmpl    %r13d, %r14d
        je      .L185
        movl    %r13d, %edx
.L186:
        movslq  %edx, %rcx
        vmovss  (%r8,%rcx,4), %xmm1
        leaq    0(,%rcx,4), %rax
        vsubss  (%rdi,%rcx,4), %xmm1, %xmm1
        leal    1(%rdx), %ecx
        cmpl    %ecx, %r14d
        vmulss  %xmm1, %xmm1, %xmm1
        vaddss  %xmm1, %xmm0, %xmm0
        jle     .L185
        vmovss  4(%r8,%rax), %xmm1
        leal    2(%rdx), %ecx
        vsubss  4(%rdi,%rax), %xmm1, %xmm1
        cmpl    %ecx, %r14d
        vmulss  %xmm1, %xmm1, %xmm1
        vaddss  %xmm1, %xmm0, %xmm0
        jle     .L185
        vmovss  8(%r8,%rax), %xmm1
        leal    3(%rdx), %ecx
        vsubss  8(%rdi,%rax), %xmm1, %xmm1
        cmpl    %ecx, %r14d
        vmulss  %xmm1, %xmm1, %xmm1
        vaddss  %xmm1, %xmm0, %xmm0
        jle     .L185
        vmovss  12(%r8,%rax), %xmm1
        leal    4(%rdx), %ecx
        vsubss  12(%rdi,%rax), %xmm1, %xmm1
        cmpl    %ecx, %r14d
        vmulss  %xmm1, %xmm1, %xmm1
        vaddss  %xmm1, %xmm0, %xmm0
        jle     .L185
        vmovss  16(%r8,%rax), %xmm1
        leal    5(%rdx), %ecx
        vsubss  16(%rdi,%rax), %xmm1, %xmm1
        cmpl    %ecx, %r14d
        vmulss  %xmm1, %xmm1, %xmm1
        vaddss  %xmm1, %xmm0, %xmm0
        jle     .L185
        vmovss  20(%r8,%rax), %xmm1
        addl    $6, %edx
        vsubss  20(%rdi,%rax), %xmm1, %xmm1
        cmpl    %edx, %r14d
        vmulss  %xmm1, %xmm1, %xmm1
        vaddss  %xmm1, %xmm0, %xmm0
        jle     .L185
        vmovss  24(%r8,%rax), %xmm1
        vsubss  24(%rdi,%rax), %xmm1, %xmm1
        vmulss  %xmm1, %xmm1, %xmm1
        vaddss  %xmm1, %xmm0, %xmm0
.L185:
        vcomiss %xmm0, %xmm3
        leaq    1(%r9), %rax
        vminss  %xmm3, %xmm0, %xmm3
        cmova   %r10d, %r12d
        cmpq    %r11, %r9
        je      .L184
        movq    %rax, %r9
        testl   %r14d, %r14d
        movq    (%r15,%r9,8), %rdi
        movl    %r9d, %r10d
        jg      .L234
.L210:
        vmovaps %xmm4, %xmm0
        jmp     .L185
.L184:
        movq    176(%rsp), %rax
        movq    184(%rsp), %rdi
        cmpl    %r12d, (%rax,%rdi,4)
        je      .L194
        vaddss  .LC2(%rip), %xmm5, %xmm5
.L194:
        movq    176(%rsp), %rax
        movq    184(%rsp), %rdi
        movl    %r12d, (%rax,%rdi,4)
        movq    24(%rbp), %rdi
        movslq  %r12d, %rax
        incl    (%rdi,%rax,4)
        testl   %r14d, %r14d
        jle     .L195
        movq    32(%rbp), %rdi
        movq    (%rdi,%rax,8), %rcx
        leaq    31(%r8), %rax
        subq    %rcx, %rax
        cmpq    $62, %rax
        jbe     .L196
        cmpl    $6, 204(%rsp)
        jbe     .L196
        cmpl    $1, 200(%rsp)
        jbe     .L214
        movq    %r8, %rdi
        movq    %rcx, %rsi
        xorl    %eax, %eax
.L198:
        vmovups (%rsi), %ymm0
        prefetcht0      640(%rdi)
        movl    %eax, %edx
        addq    $64, %rdi
        addl    $2, %eax
        prefetcht0      640(%rsi)
        vaddps  -64(%rdi), %ymm0, %ymm0
        addq    $64, %rsi
        vmovups %ymm0, -64(%rsi)
        vmovups -32(%rdi), %ymm0
        vaddps  -32(%rsi), %ymm0, %ymm0
        vmovups %ymm0, -32(%rsi)
        cmpl    196(%rsp), %edx
        movq    %rsi, %r9
        jne     .L198
        movl    168(%rsp), %edx
.L197:
        xorl    %eax, %eax
.L199:
        vmovups (%rdi,%rax), %ymm0
        incl    %edx
        vaddps  (%rsi,%rax), %ymm0, %ymm0
        vmovups %ymm0, (%r9,%rax)
        addq    $32, %rax
        cmpl    %edx, %ebx
        ja      .L199
        cmpl    %r13d, %r14d
        je      .L195
        movq    144(%rsp), %rdi
        cmpl    156(%rsp), %r14d
        leaq    (%rcx,%rdi), %rax
        vmovss  (%rax), %xmm0
        vaddss  (%r8,%rdi), %xmm0, %xmm0
        vmovss  %xmm0, (%rax)
        jle     .L195
        movq    136(%rsp), %rsi
        cmpl    152(%rsp), %r14d
        leaq    (%rcx,%rsi), %rax
        vmovss  (%rax), %xmm0
        vaddss  (%r8,%rsi), %xmm0, %xmm0
        vmovss  %xmm0, (%rax)
        jle     .L195
        movq    128(%rsp), %rsi
        cmpl    124(%rsp), %r14d
        leaq    (%rcx,%rsi), %rax
        vmovss  (%rax), %xmm0
        vaddss  (%r8,%rsi), %xmm0, %xmm0
        vmovss  %xmm0, (%rax)
        jle     .L195
        movq    112(%rsp), %rdi
        cmpl    120(%rsp), %r14d
        leaq    (%rcx,%rdi), %rax
        vmovss  (%rax), %xmm0
        vaddss  (%r8,%rdi), %xmm0, %xmm0
        vmovss  %xmm0, (%rax)
        jle     .L195
        movq    104(%rsp), %rsi
        cmpl    100(%rsp), %r14d
        leaq    (%rcx,%rsi), %rax
        vmovss  (%rax), %xmm0
        vaddss  (%r8,%rsi), %xmm0, %xmm0
        vmovss  %xmm0, (%rax)
        jle     .L195
        movq    80(%rsp), %rdi
        cmpl    96(%rsp), %r14d
        leaq    (%rcx,%rdi), %rax
        vmovss  (%rax), %xmm0
        vaddss  (%r8,%rdi), %xmm0, %xmm0
        vmovss  %xmm0, (%rax)
        jle     .L195
        movq    88(%rsp), %rax
        addq    %rax, %rcx
        vmovss  (%rcx), %xmm0
        vaddss  (%r8,%rax), %xmm0, %xmm0
        vmovss  %xmm0, (%rcx)
.L195:
        incq    184(%rsp)
        movq    184(%rsp), %rax
        cmpl    %eax, 192(%rsp)
        jg      .L205
.L183:
        movl    192(%rsp), %eax
        cmpl    %eax, 48(%rbp)
        jle     .L206
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L235
.L207:
        movl    192(%rsp), %edx
        jmp     .L182
.L211:
        vmovaps %xmm4, %xmm0
        xorl    %edx, %edx
        jmp     .L186
.L212:
        vmovaps %xmm4, %xmm0
        xorl    %edx, %edx
        jmp     .L187
.L196:
        cmpl    $16, %r14d
        jle     .L215
        leaq    80(%rcx), %rax
        leaq    80(%r8), %rdx
        xorl    %esi, %esi
.L202:
        vmovss  -80(%rax), %xmm0
        prefetcht0      (%rdx)
        prefetcht0      (%rax)
        vaddss  -80(%rdx), %xmm0, %xmm0
        addl    $16, %esi
        addq    $64, %rax
        addq    $64, %rdx
        vmovss  %xmm0, -144(%rax)
        vmovss  -140(%rax), %xmm0
        vaddss  -140(%rdx), %xmm0, %xmm0
        vmovss  %xmm0, -140(%rax)
        vmovss  -136(%rax), %xmm0
        vaddss  -136(%rdx), %xmm0, %xmm0
        vmovss  %xmm0, -136(%rax)
        vmovss  -132(%rax), %xmm0
        vaddss  -132(%rdx), %xmm0, %xmm0
        vmovss  %xmm0, -132(%rax)
        vmovss  -128(%rax), %xmm0
        vaddss  -128(%rdx), %xmm0, %xmm0
        vmovss  %xmm0, -128(%rax)
        vmovss  -124(%rax), %xmm0
        vaddss  -124(%rdx), %xmm0, %xmm0
        vmovss  %xmm0, -124(%rax)
        vmovss  -120(%rax), %xmm0
        vaddss  -120(%rdx), %xmm0, %xmm0
        vmovss  %xmm0, -120(%rax)
        vmovss  -116(%rax), %xmm0
        vaddss  -116(%rdx), %xmm0, %xmm0
        vmovss  %xmm0, -116(%rax)
        vmovss  -112(%rax), %xmm0
        vaddss  -112(%rdx), %xmm0, %xmm0
        vmovss  %xmm0, -112(%rax)
        vmovss  -108(%rax), %xmm0
        vaddss  -108(%rdx), %xmm0, %xmm0
        vmovss  %xmm0, -108(%rax)
        vmovss  -104(%rax), %xmm0
        vaddss  -104(%rdx), %xmm0, %xmm0
        vmovss  %xmm0, -104(%rax)
        vmovss  -100(%rax), %xmm0
        vaddss  -100(%rdx), %xmm0, %xmm0
        vmovss  %xmm0, -100(%rax)
        vmovss  -96(%rax), %xmm0
        vaddss  -96(%rdx), %xmm0, %xmm0
        vmovss  %xmm0, -96(%rax)
        vmovss  -92(%rax), %xmm0
        vaddss  -92(%rdx), %xmm0, %xmm0
        vmovss  %xmm0, -92(%rax)
        vmovss  -88(%rax), %xmm0
        vaddss  -88(%rdx), %xmm0, %xmm0
        vmovss  %xmm0, -88(%rax)
        vmovss  -84(%rax), %xmm0
        vaddss  -84(%rdx), %xmm0, %xmm0
        vmovss  %xmm0, -84(%rax)
        cmpl    64(%rsp), %esi
        jne     .L202
.L201:
        movslq  %esi, %rax
.L204:
        vmovss  (%rcx,%rax,4), %xmm0
        vaddss  (%r8,%rax,4), %xmm0, %xmm0
        vmovss  %xmm0, (%rcx,%rax,4)
        incq    %rax
        cmpl    %eax, %r14d
        jg      .L204
        jmp     .L195
.L214:
        movq    %rcx, %r9
        movq    %r8, %rdi
        movq    %rcx, %rsi
        xorl    %edx, %edx
        jmp     .L197
.L206:
        movq    72(%rsp), %rax
        vmovss  %xmm5, (%rax)
        vzeroupper
.L232:
        leaq    -40(%rbp), %rsp
        popq    %rbx
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        popq    %rbp
        ret
.L215:
        xorl    %esi, %esi
        jmp     .L201
.L209:
        movl    %edx, 192(%rsp)
        jmp     .L183
.L235:
        movq    56(%rbp), %rax
        movq    72(%rsp), %r9
        movl    %r14d, %esi
        movq    176(%rsp), %r8
        movl    172(%rsp), %ecx
        vmovss  %xmm5, 60(%rsp)
        movl    68(%rsp), %edx
        movq    160(%rsp), %rdi
        vmovss  %xmm6, 184(%rsp)
        vmovss  %xmm5, (%r9)
        movq    %rax, 40(%rsp)
        movl    48(%rbp), %eax
        vmovaps %xmm6, %xmm0
        movq    %r15, (%rsp)
        movl    %eax, 32(%rsp)
        movl    192(%rsp), %eax
        movl    %eax, 24(%rsp)
        movq    32(%rbp), %rax
        movq    %rax, 16(%rsp)
        movq    24(%rbp), %rax
        movq    %rax, 8(%rsp)
        vzeroupper
        call    _Z20kmeans_inner_handlerPPfiiifPiS_S0_S1_S0_iiPv
        testl   %eax, %eax
        vmovss  184(%rsp), %xmm6
        vmovss  60(%rsp), %xmm5
        je      .L207
        jmp     .L232
.LC1:
        .long   2139095039
.LC2:
        .long   1065353216
