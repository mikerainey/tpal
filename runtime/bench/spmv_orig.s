spmv_serial:
        testq   %r9, %r9
        je      .L24
        pushq   %r14
        vxorpd  %xmm2, %xmm2, %xmm2
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
        vmovsd  %xmm2, %xmm2, %xmm1
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
        vmovsd  (%rcx,%r10,8), %xmm0
        movq    -184(%rax), %r10
        vmulsd  -192(%r11), %xmm0, %xmm0
        vaddsd  %xmm1, %xmm0, %xmm1
        vmovsd  (%rcx,%r10,8), %xmm0
        movq    -176(%rax), %r10
        vmulsd  -184(%r11), %xmm0, %xmm0
        vaddsd  %xmm1, %xmm0, %xmm0
        vmovsd  (%rcx,%r10,8), %xmm1
        movq    -168(%rax), %r10
        vmulsd  -176(%r11), %xmm1, %xmm1
        vaddsd  %xmm0, %xmm1, %xmm0
        vmovsd  (%rcx,%r10,8), %xmm1
        movq    -160(%rax), %r10
        vmulsd  -168(%r11), %xmm1, %xmm1
        vaddsd  %xmm0, %xmm1, %xmm1
        vmovsd  (%rcx,%r10,8), %xmm0
        movq    -152(%rax), %r10
        vmulsd  -160(%r11), %xmm0, %xmm0
        vaddsd  %xmm1, %xmm0, %xmm1
        vmovsd  (%rcx,%r10,8), %xmm0
        movq    -144(%rax), %r10
        vmulsd  -152(%r11), %xmm0, %xmm0
        vaddsd  %xmm1, %xmm0, %xmm0
        vmovsd  (%rcx,%r10,8), %xmm1
        movq    -136(%rax), %r10
        vmulsd  -144(%r11), %xmm1, %xmm1
        vaddsd  %xmm0, %xmm1, %xmm0
        vmovsd  (%rcx,%r10,8), %xmm1
        leaq    8(%rbx), %r10
        vmulsd  -136(%r11), %xmm1, %xmm1
        cmpq    %r13, %r14
        movq    %r10, %rbx
        vaddsd  %xmm0, %xmm1, %xmm1
        ja      .L5
        leaq    1(%r10), %rax
        jmp     .L6
.L28:
        incq    %rax
.L6:
        movq    (%rsi,%r10,8), %r11
        cmpq    %rax, %rdx
        vmovsd  (%rcx,%r11,8), %xmm0
        vmulsd  (%rdi,%r10,8), %xmm0, %xmm0
        movq    %rax, %r10
        vaddsd  %xmm0, %xmm1, %xmm1
        ja      .L28
        vmovsd  %xmm1, (%r8,%r12,8)
        incq    %r12
        cmpq    %r9, %r12
        jne     .L7
.L29:
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        ret
.L8:
        vmovsd  %xmm2, %xmm2, %xmm1
        vmovsd  %xmm1, (%r8,%r12,8)
        incq    %r12
        cmpq    %r9, %r12
        jne     .L7
        jmp     .L29
.L9:
        vmovsd  %xmm2, %xmm2, %xmm1
        jmp     .L6
.L24:
        rep ret
spmv_interrupt:
        pushq   %r15
        vxorpd  %xmm2, %xmm2, %xmm2
        movq    %r9, %r15
        pushq   %r14
        pushq   %r13
        movq    %rdi, %r13
        pushq   %r12
        movq    %rdx, %r12
        pushq   %rbp
        movq    %rcx, %rbp
        pushq   %rbx
        subq    $88, %rsp
        cmpq    144(%rsp), %r9
        jnb     .L65
.L31:
        leaq    2048(%r15), %r10
        cmpq    144(%rsp), %r10
        cmova   144(%rsp), %r10
        cmpq    %r10, %r15
        jb      .L41
        jmp     .L32
.L33:
        cmpq    %r10, %r15
        vmovsd  %xmm1, -8(%r8,%r15,8)
        jnb     .L32
.L41:
        movq    (%rsi,%r15,8), %rax
        movq    %r15, %r9
        incq    %r15
        movq    (%rsi,%r15,8), %r14
        vmovsd  %xmm2, %xmm2, %xmm1
        cmpq    %r14, %rax
        jnb     .L33
.L34:
        leaq    2048(%rax), %rbx
        cmpq    %r14, %rbx
        cmova   %r14, %rbx
        cmpq    %rbx, %rax
        jnb     .L44
        leaq    -7(%rbx), %rdi
        leaq    1(%rax), %rdx
        cmpq    %rdx, %rdi
        jbe     .L38
        cmpq    $6, %rbx
        jbe     .L38
        leaq    128(,%rax,8), %rdx
        leaq    0(%r13,%rdx), %rcx
        addq    %r12, %rdx
.L37:
        movq    -128(%rdx), %r11
        prefetcht0      (%rcx)
        prefetcht0      (%rdx)
        addq    $64, %rcx
        addq    $64, %rdx
        vmovsd  0(%rbp,%r11,8), %xmm0
        movq    -184(%rdx), %r11
        vmulsd  -192(%rcx), %xmm0, %xmm0
        vaddsd  %xmm1, %xmm0, %xmm1
        vmovsd  0(%rbp,%r11,8), %xmm0
        movq    -176(%rdx), %r11
        vmulsd  -184(%rcx), %xmm0, %xmm0
        vaddsd  %xmm1, %xmm0, %xmm3
        vmovsd  0(%rbp,%r11,8), %xmm0
        movq    -168(%rdx), %r11
        vmulsd  -176(%rcx), %xmm0, %xmm1
        vaddsd  %xmm3, %xmm1, %xmm0
        vmovsd  0(%rbp,%r11,8), %xmm1
        movq    -160(%rdx), %r11
        vmulsd  -168(%rcx), %xmm1, %xmm1
        vaddsd  %xmm0, %xmm1, %xmm1
        vmovsd  0(%rbp,%r11,8), %xmm0
        movq    -152(%rdx), %r11
        vmulsd  -160(%rcx), %xmm0, %xmm0
        vaddsd  %xmm1, %xmm0, %xmm1
        vmovsd  0(%rbp,%r11,8), %xmm0
        movq    -144(%rdx), %r11
        vmulsd  -152(%rcx), %xmm0, %xmm0
        vaddsd  %xmm1, %xmm0, %xmm0
        vmovsd  0(%rbp,%r11,8), %xmm1
        movq    -136(%rdx), %r11
        vmulsd  -144(%rcx), %xmm1, %xmm1
        vaddsd  %xmm0, %xmm1, %xmm0
        vmovsd  0(%rbp,%r11,8), %xmm1
        movq    %rax, %r11
        addq    $9, %r11
        addq    $8, %rax
        vmulsd  -136(%rcx), %xmm1, %xmm1
        cmpq    %r11, %rdi
        vaddsd  %xmm0, %xmm1, %xmm1
        ja      .L37
        leaq    1(%rax), %rdx
        jmp     .L38
.L67:
        incq    %rdx
.L38:
        movq    (%r12,%rax,8), %rcx
        cmpq    %rdx, %rbx
        vmovsd  0(%rbp,%rcx,8), %xmm0
        vmulsd  0(%r13,%rax,8), %xmm0, %xmm0
        movq    %rdx, %rax
        vaddsd  %xmm0, %xmm1, %xmm1
        ja      .L67
.L35:
        cmpq    %r14, %rbx
        jnb     .L33
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L68
.L39:
        movq    %rbx, %rax
        jmp     .L34
.L44:
        movq    %rax, %rbx
        jmp     .L35
.L68:
        movq    152(%rsp), %rax
        vmovsd  %xmm1, %xmm1, %xmm0
        movq    %r14, 16(%rsp)
        movq    %rbx, 8(%rsp)
        movq    %rbp, %rcx
        movq    %r12, %rdx
        movq    %r13, %rdi
        vmovsd  %xmm1, 64(%rsp)
        movq    %r10, 72(%rsp)
        movq    %rax, 24(%rsp)
        movq    144(%rsp), %rax
        movq    %r9, 56(%rsp)
        movq    %r8, 48(%rsp)
        movq    %rsi, 40(%rsp)
        movq    %rax, (%rsp)
        call    col_loop_handler
        testl   %eax, %eax
        movq    40(%rsp), %rsi
        movq    48(%rsp), %r8
        movq    56(%rsp), %r9
        vxorpd  %xmm2, %xmm2, %xmm2
        movq    72(%rsp), %r10
        vmovsd  64(%rsp), %xmm1
        je      .L39
.L65:
        addq    $88, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L32:
        cmpq    144(%rsp), %r15
        jnb     .L65
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        je      .L31
        movq    152(%rsp), %rax
        movq    %r15, %r9
        movq    %rbp, %rcx
        movq    %r12, %rdx
        movq    %r13, %rdi
        movq    %r8, 48(%rsp)
        movq    %rsi, 40(%rsp)
        movq    %rax, 8(%rsp)
        movq    144(%rsp), %rax
        movq    %rax, (%rsp)
        call    row_loop_handler
        testl   %eax, %eax
        movq    40(%rsp), %rsi
        movq    48(%rsp), %r8
        vxorpd  %xmm2, %xmm2, %xmm2
        je      .L31
        jmp     .L65
spmv_interrupt_col_loop:
        pushq   %r15
        pushq   %r14
        pushq   %r13
        pushq   %r12
        pushq   %rbp
        pushq   %rbx
        subq    $72, %rsp
        movq    128(%rsp), %r15
        movq    136(%rsp), %r14
        cmpq    %r15, %r9
        jnb     .L70
        movq    %rdi, %r13
        movq    %rdx, %r12
        movq    %rcx, %rbp
.L71:
        leaq    2048(%r9), %rbx
        cmpq    %r15, %rbx
        cmova   %r15, %rbx
        cmpq    %rbx, %r9
        jnb     .L78
        leaq    -7(%rbx), %rcx
        leaq    1(%r9), %rax
        cmpq    %rax, %rcx
        jbe     .L75
        cmpq    $6, %rbx
        jbe     .L75
        leaq    128(,%r9,8), %rax
        leaq    0(%r13,%rax), %rdi
        addq    %r12, %rax
.L74:
        movq    -128(%rax), %rdx
        prefetcht0      (%rdi)
        prefetcht0      (%rax)
        addq    $64, %rdi
        addq    $64, %rax
        vmovsd  0(%rbp,%rdx,8), %xmm1
        movq    -184(%rax), %rdx
        vmulsd  -192(%rdi), %xmm1, %xmm1
        vaddsd  %xmm0, %xmm1, %xmm0
        vmovsd  0(%rbp,%rdx,8), %xmm1
        movq    -176(%rax), %rdx
        vmulsd  -184(%rdi), %xmm1, %xmm1
        vaddsd  %xmm0, %xmm1, %xmm1
        vmovsd  0(%rbp,%rdx,8), %xmm0
        movq    -168(%rax), %rdx
        vmulsd  -176(%rdi), %xmm0, %xmm0
        vaddsd  %xmm1, %xmm0, %xmm1
        vmovsd  0(%rbp,%rdx,8), %xmm0
        movq    -160(%rax), %rdx
        vmulsd  -168(%rdi), %xmm0, %xmm0
        vaddsd  %xmm1, %xmm0, %xmm0
        vmovsd  0(%rbp,%rdx,8), %xmm1
        movq    -152(%rax), %rdx
        vmulsd  -160(%rdi), %xmm1, %xmm1
        vaddsd  %xmm0, %xmm1, %xmm0
        vmovsd  0(%rbp,%rdx,8), %xmm1
        movq    -144(%rax), %rdx
        vmulsd  -152(%rdi), %xmm1, %xmm1
        vaddsd  %xmm0, %xmm1, %xmm1
        vmovsd  0(%rbp,%rdx,8), %xmm0
        movq    -136(%rax), %rdx
        vmulsd  -144(%rdi), %xmm0, %xmm0
        vaddsd  %xmm1, %xmm0, %xmm1
        vmovsd  0(%rbp,%rdx,8), %xmm0
        movq    %r9, %rdx
        addq    $9, %rdx
        addq    $8, %r9
        vmulsd  -136(%rdi), %xmm0, %xmm0
        cmpq    %rdx, %rcx
        vaddsd  %xmm1, %xmm0, %xmm0
        ja      .L74
        leaq    1(%r9), %rax
        jmp     .L75
.L93:
        incq    %rax
.L75:
        movq    (%r12,%r9,8), %rdx
        cmpq    %rax, %rbx
        vmovsd  0(%rbp,%rdx,8), %xmm1
        vmulsd  0(%r13,%r9,8), %xmm1, %xmm1
        movq    %rax, %r9
        vaddsd  %xmm1, %xmm0, %xmm0
        ja      .L93
.L72:
        cmpq    %r15, %rbx
        jnb     .L70
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L94
.L76:
        movq    %rbx, %r9
        jmp     .L71
.L70:
        vmovsd  %xmm0, (%r14)
.L90:
        addq    $72, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L78:
        movq    %r9, %rbx
        jmp     .L72
.L94:
        movq    144(%rsp), %rax
        movq    %r14, 8(%rsp)
        movq    %rbx, %r9
        movq    %r15, (%rsp)
        movq    %rbp, %rcx
        movq    %r12, %rdx
        movq    %r13, %rdi
        vmovsd  %xmm0, 56(%rsp)
        movq    %r8, 48(%rsp)
        movq    %rax, 16(%rsp)
        movq    %rsi, 40(%rsp)
        call    col_loop_handler_col_loop
        testl   %eax, %eax
        movq    40(%rsp), %rsi
        movq    48(%rsp), %r8
        vmovsd  56(%rsp), %xmm0
        je      .L76
        jmp     .L90
