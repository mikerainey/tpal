_Z19mergesort_interruptPmS_mmPvN7tpalrts12stack_structES0_P17merge_args_structPSt4pairImmE:
        pushq   %rbp
        movq    %rsp, %rbp
        pushq   %r15
        pushq   %r14
        pushq   %r13
        pushq   %r12
        pushq   %rbx
        andq    $-32, %rsp
        subq    $336, %rsp
        cmpq    $0, 16(%rbp)
        movq    56(%rbp), %rbx
        movq    %rsi, 248(%rsp)
        movq    %rdi, 256(%rsp)
        movq    48(%rbp), %rsi
        movq    %r8, 240(%rsp)
        movq    %r9, 296(%rsp)
        je      .L3
        movq    24(%rbp), %rax
.L4:
        movq    %rax, 304(%rsp)
        movq    32(%rbp), %rax
        testq   %rsi, %rsi
        movq    %rax, 312(%rsp)
        movq    40(%rbp), %rax
        movq    %rax, 320(%rsp)
        je      .L5
        movq    (%rsi), %rax
        movq    8(%rsi), %r10
        movq    24(%rsi), %r14
        movq    32(%rsi), %r12
        movq    40(%rsi), %r15
        movq    48(%rsi), %r13
        movq    %rax, 288(%rsp)
        movq    16(%rsi), %rax
        movq    %rax, 280(%rsp)
        movq    56(%rsi), %rax
        movq    %rax, 272(%rsp)
.L5:
        testq   %rbx, %rbx
        movq    $0, 328(%rsp)
        movq    $0, 264(%rsp)
        je      .L6
        movq    (%rbx), %rax
        movq    %rax, 264(%rsp)
        movq    8(%rbx), %rax
        movq    %rax, 328(%rsp)
.L6:
        movq    296(%rsp), %rax
        movl    $.L2, %esi
        testq   %rax, %rax
        cmove   %rsi, %rax
        movq    304(%rsp), %rsi
        movq    %rax, 296(%rsp)
        jmp     *%rax
.L63:
        cmpq    %rbx, %rdi
        je      .L16
        leaq    -8(%rbx), %rax
        leaq    31(%rdi), %r8
        subq    %rdi, %rax
        subq    %rsi, %r8
        movq    %rax, %r9
        shrq    $3, %r9
        cmpq    $62, %r8
        jbe     .L79
        cmpq    $296, %rax
        jbe     .L79
        incq    %r9
        xorl    %eax, %eax
        movq    %r9, %r8
        shrq    $2, %r8
        salq    $5, %r8
.L81:
        vmovdqu (%rdi,%rax), %ymm0
        vmovdqu %ymm0, (%rsi,%rax)
        addq    $32, %rax
        cmpq    %rax, %r8
        jne     .L81
        movq    %r9, %rax
        andq    $-4, %rax
        leaq    0(,%rax,8), %r8
        addq    %r8, %rdi
        addq    %r8, %rsi
        cmpq    %rax, %r9
        je      .L16
        movq    (%rdi), %rax
        movq    %rax, (%rsi)
        leaq    8(%rdi), %rax
        cmpq    %rax, %rbx
        je      .L16
        movq    8(%rdi), %rax
        movq    %rax, 8(%rsi)
        leaq    16(%rdi), %rax
        cmpq    %rax, %rbx
        je      .L16
        movq    16(%rdi), %rax
        movq    %rax, 16(%rsi)
.L16:
        movq    304(%rsp), %rsi
        movq    (%rsi), %rax
        movq    304(%rsp), %rsi
        jmp     *%rax
.L206:
        leaq    2000(%rbx), %rax
        cmpq    %r11, %rax
        cmovbe  %rax, %r11
        leaq    0(,%rbx,8), %rax
        movq    256(%rsp), %rbx
        leaq    (%rbx,%rax), %r8
        movq    248(%rsp), %rbx
        leaq    (%rbx,%r11,8), %r9
        leaq    (%rbx,%rax), %rsi
        cmpq    %rsi, %r9
        je      .L98
        movq    %r9, %rdi
        addq    $32, %rax
        subq    %rsi, %rdi
        leaq    -8(%rdi), %rbx
        movq    %rbx, %rdi
        shrq    $3, %rdi
        movq    %rdi, 264(%rsp)
        movq    256(%rsp), %rdi
        addq    %rax, %rdi
        cmpq    %rdi, %rsi
        setnb   %dil
        addq    248(%rsp), %rax
        cmpq    %rax, %r8
        setnb   %al
        orb     %al, %dil
        je      .L41
        cmpq    $296, %rbx
        jbe     .L41
        movq    264(%rsp), %rbx
        xorl    %eax, %eax
        incq    %rbx
        movq    %rbx, %rdi
        shrq    $2, %rdi
        salq    $5, %rdi
.L42:
        vmovdqu (%rsi,%rax), %ymm0
        vmovdqu %ymm0, (%r8,%rax)
        addq    $32, %rax
        cmpq    %rax, %rdi
        jne     .L42
        movq    %rbx, %rax
        andq    $-4, %rax
        leaq    0(,%rax,8), %rdi
        addq    %rdi, %rsi
        addq    %r8, %rdi
        cmpq    %rax, %rbx
        je      .L98
        movq    (%rsi), %rax
        movq    %rax, (%rdi)
        leaq    8(%rsi), %rax
        cmpq    %rax, %r9
        je      .L98
        movq    8(%rsi), %rax
        movq    %rax, 8(%rdi)
        leaq    16(%rsi), %rax
        cmpq    %rax, %r9
        je      .L98
        movq    16(%rsi), %rax
        movq    %rax, 16(%rdi)
.L98:
        movq    %r11, 264(%rsp)
.L37:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L205
        movq    328(%rsp), %r11
        movq    264(%rsp), %rbx
        cmpq    %rbx, %r11
        jne     .L206
.L12:
        addq    $64, 304(%rsp)
        jmp     .L16
.L22:
        movq    248(%rsp), %rax
        movq    $.L21, (%rsi)
        movq    304(%rsp), %rsi
        movq    256(%rsp), %r10
        movq    %rax, 280(%rsp)
        movq    40(%rsi), %r12
        movq    56(%rsi), %rax
        movq    48(%rsi), %r13
        movq    %r10, 288(%rsp)
        movq    %rax, 272(%rsp)
        movq    %r12, %r15
        movq    %rax, %r14
.L20:
        leaq    -8(%rsi), %rax
        movq    %rax, 304(%rsp)
        movq    $.L56, -8(%rsi)
.L58:
        movq    %r12, %rbx
        movq    %r13, %r11
        subq    %r14, %rbx
        subq    %r15, %r11
        cmpq    %r11, %rbx
        jb      .L100
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L207
.L59:
        testq   %rbx, %rbx
        je      .L16
        cmpq    $1, %rbx
        je      .L208
        leaq    0(,%r15,8), %rsi
        cmpq    $1999, %rbx
        leaq    0(,%r13,8), %rax
        leaq    (%r10,%rsi), %rdi
        jbe     .L209
        movq    288(%rsp), %rbx
        leaq    (%r14,%r12), %r8
        subq    %rsi, %rax
        sarq    $3, %rax
        shrq    %r8
        leaq    (%rbx,%r8,8), %r9
.L88:
        testq   %rax, %rax
        jle     .L87
.L210:
        movq    %rax, %rsi
        movq    (%r9), %rbx
        sarq    %rsi
        leaq    (%rdi,%rsi,8), %r11
        cmpq    %rbx, (%r11)
        jnb     .L101
        incq    %rsi
        leaq    8(%r11), %rdi
        subq    %rsi, %rax
        testq   %rax, %rax
        jg      .L210
.L87:
        movq    272(%rsp), %rsi
        leaq    (%r14,%r15), %rax
        subq    %r10, %rdi
        sarq    $3, %rdi
        subq    %rax, %rsi
        movq    304(%rsp), %rax
        addq    %r8, %rsi
        leaq    -88(%rax), %r9
        movq    %r9, 304(%rsp)
        movq    $.L18, -88(%rax)
        movq    320(%rsp), %r9
        movq    304(%rsp), %rax
        testq   %r9, %r9
        leaq    8(%rax), %r11
        movq    %r9, 8(%rax)
        movq    $0, 16(%rax)
        je      .L90
        movq    %r11, 8(%r9)
.L90:
        cmpq    $0, 312(%rsp)
        movq    %r11, 320(%rsp)
        je      .L211
.L91:
        movq    288(%rsp), %rbx
        addq    %rdi, %rsi
        movq    %r12, 56(%rax)
        movq    %r13, 72(%rax)
        movq    %r10, 32(%rax)
        movq    %rdi, %r13
        movq    %r8, 48(%rax)
        movq    %rdi, 64(%rax)
        movq    %r8, %r12
        movq    %rbx, 24(%rax)
        movq    280(%rsp), %rbx
        movq    %rsi, 80(%rax)
        movq    %rbx, 40(%rax)
        jmp     .L58
.L101:
        movq    %rsi, %rax
        jmp     .L88
.L100:
        movq    %r12, %rax
        movq    %r13, %r12
        movq    %rax, %r13
        movq    %r14, %rax
        movq    %r15, %r14
        movq    %rax, %r15
        movq    288(%rsp), %rax
        movq    %r10, 288(%rsp)
        movq    %rax, %r10
        jmp     .L58
.L211:
        movq    %r11, 312(%rsp)
        jmp     .L91
.L207:
        leaq    296(%rsp), %rax
        movq    %r11, 208(%rsp)
        movq    %r10, 216(%rsp)
        movq    $.L12, 184(%rsp)
        movq    $.L13, 176(%rsp)
        leaq    328(%rsp), %r9
        movq    %rax, 192(%rsp)
        leaq    320(%rsp), %rax
        movq    $.L14, 168(%rsp)
        movq    $.L15, 160(%rsp)
        movq    $.L16, 152(%rsp)
        movq    %rax, 56(%rsp)
        leaq    312(%rsp), %rax
        movq    $.L17, 144(%rsp)
        movq    $.L18, 136(%rsp)
        movq    $.L19, 128(%rsp)
        movq    %rax, 48(%rsp)
        leaq    304(%rsp), %rax
        movq    $.L20, 120(%rsp)
        movq    $.L21, 112(%rsp)
        movq    $.L22, 104(%rsp)
        movq    %rax, 40(%rsp)
        movq    16(%rbp), %rax
        movq    $.L23, 96(%rsp)
        movq    $.L24, 88(%rsp)
        movq    $.L25, 80(%rsp)
        movq    $.L26, 72(%rsp)
        movq    %rax, 8(%rsp)
        movq    24(%rbp), %rax
        movq    $.L2, 64(%rsp)
        movq    %rax, 16(%rsp)
        movq    32(%rbp), %rax
        movq    %rax, 24(%rsp)
        movq    40(%rbp), %rax
        movq    %rax, 32(%rsp)
        movq    240(%rsp), %rax
        movq    %rax, (%rsp)
        movq    264(%rsp), %r8
        movq    248(%rsp), %rsi
        movq    256(%rsp), %rdi
        movq    %rcx, 224(%rsp)
        movq    %rdx, 232(%rsp)
        vzeroupper
        call    _Z17mergesort_handlerPmS_mmmRmPvN7tpalrts12stack_structERPcS5_S5_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_RS1_
        movq    208(%rsp), %r11
        movq    216(%rsp), %r10
        movq    224(%rsp), %rcx
        movq    232(%rsp), %rdx
        jmp     .L59
.L208:
        movq    272(%rsp), %rbx
        movq    288(%rsp), %rax
        testq   %r11, %r11
        leaq    0(,%rbx,8), %rsi
        movq    280(%rsp), %rbx
        leaq    (%rax,%r14,8), %rdi
        movq    (%rdi), %rax
        leaq    (%rbx,%rsi), %r9
        jne     .L61
        movq    %rax, (%r9)
        jmp     .L16
.L209:
        movq    280(%rsp), %rbx
        movq    272(%rsp), %rsi
        leaq    (%rbx,%rsi,8), %rsi
        leaq    (%r10,%rax), %rbx
        movq    288(%rsp), %rax
        leaq    (%rax,%r12,8), %r11
        leaq    (%rax,%r14,8), %rax
        cmpq    %rax, %r11
        jne     .L180
        jmp     .L63
.L213:
        addq    $8, %rdi
.L77:
        movq    %r8, (%rsi)
        addq    $8, %rsi
        cmpq    %rax, %r11
        je      .L63
.L180:
        cmpq    %rdi, %rbx
        je      .L212
        movq    (%rdi), %r8
        movq    (%rax), %r9
        cmpq    %r9, %r8
        jb      .L213
        addq    $8, %rax
        movq    %r9, %r8
        jmp     .L77
.L215:
        movq    %rbx, %rax
        andq    $-4, %rax
        leaq    0(,%rax,8), %rdi
        addq    %rdi, %rsi
        addq    %r8, %rdi
        cmpq    %rax, %rbx
        je      .L99
        movq    (%rsi), %rax
        movq    %rax, (%rdi)
        leaq    8(%rsi), %rax
        cmpq    %rax, %r9
        je      .L99
        movq    8(%rsi), %rax
        movq    %rax, 8(%rdi)
        leaq    16(%rsi), %rax
        cmpq    %rax, %r9
        je      .L99
        movq    16(%rsi), %rax
        movq    %rax, 16(%rdi)
.L99:
        movq    %r11, 264(%rsp)
.L13:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L214
        movq    328(%rsp), %r11
        movq    264(%rsp), %rbx
        cmpq    %rbx, %r11
        je      .L196
        leaq    2000(%rbx), %rax
        cmpq    %r11, %rax
        cmovbe  %rax, %r11
        leaq    0(,%rbx,8), %rax
        movq    256(%rsp), %rbx
        leaq    (%rbx,%rax), %r8
        movq    248(%rsp), %rbx
        leaq    (%rbx,%r11,8), %r9
        leaq    (%rbx,%rax), %rsi
        cmpq    %rsi, %r9
        je      .L99
        movq    %r9, %rdi
        addq    $32, %rax
        subq    %rsi, %rdi
        leaq    -8(%rdi), %rbx
        movq    %rbx, %rdi
        shrq    $3, %rdi
        movq    %rdi, 264(%rsp)
        movq    256(%rsp), %rdi
        addq    %rax, %rdi
        cmpq    %rdi, %rsi
        setnb   %dil
        addq    248(%rsp), %rax
        cmpq    %rax, %r8
        setnb   %al
        orb     %al, %dil
        je      .L49
        cmpq    $296, %rbx
        jbe     .L49
        movq    264(%rsp), %rbx
        xorl    %eax, %eax
        incq    %rbx
        movq    %rbx, %rdi
        shrq    $2, %rdi
        salq    $5, %rdi
.L50:
        vmovdqu (%rsi,%rax), %ymm0
        vmovdqu %ymm0, (%r8,%rax)
        addq    $32, %rax
        cmpq    %rdi, %rax
        jne     .L50
        jmp     .L215
.L61:
        leaq    (%r10,%r15,8), %r8
        cmpq    %rax, (%r8)
        cmovbe  (%r8), %rax
        movq    %rax, (%r9)
        movq    (%rdi), %rax
        cmpq    %rax, (%r8)
        cmovnb  (%r8), %rax
        movq    %rax, 8(%rbx,%rsi)
        jmp     .L16
.L26:
        jmp     .L16
.L18:
        movq    $.L17, (%rsi)
        movq    320(%rsp), %rsi
        movq    (%rsi), %rax
        testq   %rax, %rax
        je      .L216
        movq    $0, 8(%rax)
        movq    $0, (%rsi)
.L94:
        movq    %rax, 320(%rsp)
        movq    304(%rsp), %rax
        movq    24(%rax), %rbx
        movq    32(%rax), %r10
        movq    48(%rax), %r14
        movq    56(%rax), %r12
        movq    64(%rax), %r15
        movq    72(%rax), %r13
        movq    %rbx, 288(%rsp)
        movq    40(%rax), %rbx
        movq    80(%rax), %rax
        movq    %rbx, 280(%rsp)
        movq    %rax, 272(%rsp)
        jmp     .L58
.L17:
        addq    $88, 304(%rsp)
        jmp     .L16
.L23:
        movq    $.L22, (%rsi)
        movq    320(%rsp), %rdx
        movq    (%rdx), %rax
        testq   %rax, %rax
        je      .L217
        movq    $0, 8(%rax)
        movq    $0, (%rdx)
.L36:
        movq    %rax, 320(%rsp)
        movq    304(%rsp), %rax
        movq    %r13, 224(%rsp)
        movq    %r10, 232(%rsp)
        movq    %r12, %r13
        movq    24(%rax), %rbx
        movq    32(%rax), %rsi
        movq    48(%rax), %rcx
        movq    40(%rax), %rdx
        movq    %rbx, 256(%rsp)
        movq    %rbx, %r12
        movq    %rsi, 248(%rsp)
        movq    %rcx, %rbx
        jmp     .L34
.L33:
        movq    %rbx, 48(%rax)
        movq    %r12, 24(%rax)
        movq    %rcx, %rbx
        movq    %rsi, 32(%rax)
        movq    %rcx, 40(%rax)
        movq    %rdx, 56(%rax)
.L34:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L218
.L11:
        movq    %rbx, %rax
        subq    %rdx, %rax
        cmpq    $23, %rax
        jbe     .L219
.L27:
        movq    304(%rsp), %rax
        leaq    (%rbx,%rdx), %rcx
        shrq    %rcx
        leaq    -64(%rax), %rdi
        movq    %rdi, 304(%rsp)
        movq    $.L23, -64(%rax)
        movq    320(%rsp), %rdi
        movq    304(%rsp), %rax
        testq   %rdi, %rdi
        leaq    8(%rax), %r8
        movq    %rdi, 8(%rax)
        movq    $0, 16(%rax)
        je      .L32
        movq    %r8, 8(%rdi)
.L32:
        cmpq    $0, 312(%rsp)
        movq    %r8, 320(%rsp)
        jne     .L33
        movq    %r8, 312(%rsp)
        jmp     .L33
.L21:
        movq    24(%rsi), %rdx
        movq    48(%rsi), %rcx
        movq    %rdx, 256(%rsp)
        movq    32(%rsi), %rdx
        movq    %rcx, 328(%rsp)
        movq    %rdx, 248(%rsp)
        movq    56(%rsi), %rdx
        movq    %rdx, 264(%rsp)
        jmp     .L37
.L25:
        movq    $.L24, (%rsi)
        vzeroupper
        leaq    -40(%rbp), %rsp
        popq    %rbx
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        popq    %rbp
        ret
.L24:
        movq    %rsi, %rax
        leaq    -8(%rsi), %rsi
        movq    %rsi, 304(%rsp)
        movq    $.L25, -8(%rax)
.L200:
        movl    heartbeat(%rip), %eax
        movq    %r13, 224(%rsp)
        movq    %rcx, %rbx
        movq    %r12, %r13
        movq    248(%rsp), %rsi
        movq    256(%rsp), %r12
        movq    %r10, 232(%rsp)
        testl   %eax, %eax
        je      .L11
.L218:
        leaq    296(%rsp), %rax
        movq    264(%rsp), %r8
        leaq    328(%rsp), %r9
        movq    %rbx, %rcx
        movq    %r12, %rdi
        movq    $.L12, 184(%rsp)
        movq    %rax, 192(%rsp)
        leaq    320(%rsp), %rax
        movq    $.L13, 176(%rsp)
        movq    $.L14, 168(%rsp)
        movq    $.L15, 160(%rsp)
        movq    %rax, 56(%rsp)
        leaq    312(%rsp), %rax
        movq    $.L16, 152(%rsp)
        movq    $.L17, 144(%rsp)
        movq    $.L18, 136(%rsp)
        movq    %rax, 48(%rsp)
        leaq    304(%rsp), %rax
        movq    $.L19, 128(%rsp)
        movq    $.L20, 120(%rsp)
        movq    $.L21, 112(%rsp)
        movq    %rax, 40(%rsp)
        movq    16(%rbp), %rax
        movq    $.L22, 104(%rsp)
        movq    $.L23, 96(%rsp)
        movq    $.L24, 88(%rsp)
        movq    $.L25, 80(%rsp)
        movq    %rax, 8(%rsp)
        movq    24(%rbp), %rax
        movq    $.L26, 72(%rsp)
        movq    $.L2, 64(%rsp)
        movq    %rdx, 208(%rsp)
        movq    %rax, 16(%rsp)
        movq    32(%rbp), %rax
        movq    %rax, 24(%rsp)
        movq    40(%rbp), %rax
        movq    %rax, 32(%rsp)
        movq    240(%rsp), %rax
        movq    %rax, (%rsp)
        movq    %rsi, 216(%rsp)
        vzeroupper
        call    _Z17mergesort_handlerPmS_mmmRmPvN7tpalrts12stack_structERPcS5_S5_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_RS1_
        movq    208(%rsp), %rdx
        movq    %rbx, %rax
        movq    216(%rsp), %rsi
        subq    %rdx, %rax
        cmpq    $23, %rax
        ja      .L27
.L219:
        movq    %rbx, %rcx
        movq    256(%rsp), %rbx
        testq   %rax, %rax
        movq    %r13, %r12
        movq    232(%rsp), %r10
        movq    224(%rsp), %r13
        leaq    (%rbx,%rdx,8), %r8
        je      .L16
        leaq    -8(%r8), %r9
        leaq    (%r9,%rax,8), %r11
.L31:
        cmpq    %r9, %r8
        movq    8(%r9), %rdi
        movq    %r9, %rax
        jbe     .L29
        jmp     .L28
.L220:
        movq    %rsi, 8(%rax)
        subq    $8, %rax
        cmpq    %rax, %r8
        ja      .L28
.L29:
        movq    (%rax), %rsi
        cmpq    %rsi, %rdi
        jb      .L220
.L28:
        addq    $8, %r9
        movq    %rdi, 8(%rax)
        cmpq    %r9, %r11
        jne     .L31
        jmp     .L16
.L9:
        addq    $8, 304(%rsp)
        leaq    16(%rbp), %rdi
        vzeroupper
        call    _ZN7tpalrts7sdeleteERNS_12stack_structE
        leaq    -40(%rbp), %rsp
        popq    %rbx
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        popq    %rbp
        ret
.L56:
        addq    $8, 304(%rsp)
        jmp     .L16
.L19:
        movq    %rsi, %rax
        leaq    -8(%rsi), %rsi
        movq    %rsi, 304(%rsp)
        movq    $.L95, -8(%rax)
        jmp     .L58
.L95:
.L196:
        vzeroupper
        leaq    -40(%rbp), %rsp
        popq    %rbx
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        popq    %rbp
        ret
.L2:
        movq    %rsi, %rax
        leaq    -8(%rsi), %rsi
        movq    %rsi, 304(%rsp)
        movq    $.L9, -8(%rax)
        jmp     .L200
.L15:
        movq    $.L14, (%rsi)
        vzeroupper
        leaq    -40(%rbp), %rsp
        popq    %rbx
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        popq    %rbp
        ret
.L14:
        movq    %rsi, %rax
        leaq    -8(%rsi), %rsi
        movq    %rsi, 304(%rsp)
        movq    $.L15, -8(%rax)
        jmp     .L58
.L3:
        movq    %rsi, 48(%rbp)
        movq    %rcx, 224(%rsp)
        movq    %rdx, 232(%rsp)
        movq    %r10, 264(%rsp)
        call    _ZN7tpalrts11alloc_stackEv
        movq    %rax, 16(%rbp)
        addq    $8191, %rax
        movq    48(%rbp), %rsi
        movq    224(%rsp), %rcx
        movq    232(%rsp), %rdx
        movq    264(%rsp), %r10
        movq    %rax, 24(%rbp)
        jmp     .L4
.L212:
        leaq    -8(%r11), %rdi
        leaq    31(%rax), %r8
        subq    %rax, %rdi
        subq    %rsi, %r8
        movq    %rdi, %r9
        shrq    $3, %r9
        cmpq    $62, %r8
        jbe     .L67
        cmpq    $296, %rdi
        jbe     .L67
        incq    %r9
        xorl    %edi, %edi
        movq    %r9, %r8
        shrq    $2, %r8
        salq    $5, %r8
.L69:
        vmovdqu (%rax,%rdi), %ymm0
        vmovdqu %ymm0, (%rsi,%rdi)
        addq    $32, %rdi
        cmpq    %rdi, %r8
        jne     .L69
        movq    %r9, %rdi
        andq    $-4, %rdi
        leaq    0(,%rdi,8), %r8
        addq    %r8, %rax
        addq    %rsi, %r8
        cmpq    %rdi, %r9
        je      .L16
        movq    (%rax), %rsi
        movq    %rsi, (%r8)
        leaq    8(%rax), %rsi
        cmpq    %rsi, %r11
        je      .L16
        movq    8(%rax), %rsi
        movq    %rsi, 8(%r8)
        leaq    16(%rax), %rsi
        cmpq    %rsi, %r11
        je      .L16
        movq    16(%rax), %rax
        movq    %rax, 16(%r8)
        jmp     .L16
.L217:
        movq    $0, 312(%rsp)
        jmp     .L36
.L216:
        movq    $0, 312(%rsp)
        jmp     .L94
.L205:
        movq    %r10, 216(%rsp)
        movq    $.L37, 296(%rsp)
.L199:
        leaq    296(%rsp), %rax
        movq    264(%rsp), %r8
        movq    $.L12, 184(%rsp)
        movq    $.L13, 176(%rsp)
        movq    $.L14, 168(%rsp)
        leaq    328(%rsp), %r9
        movq    %rax, 192(%rsp)
        leaq    320(%rsp), %rax
        movq    $.L15, 160(%rsp)
        movq    $.L16, 152(%rsp)
        movq    $.L17, 144(%rsp)
        movq    %rax, 56(%rsp)
        leaq    312(%rsp), %rax
        movq    $.L18, 136(%rsp)
        movq    $.L19, 128(%rsp)
        movq    $.L20, 120(%rsp)
        movq    %rax, 48(%rsp)
        leaq    304(%rsp), %rax
        movq    $.L21, 112(%rsp)
        movq    $.L22, 104(%rsp)
        movq    $.L23, 96(%rsp)
        movq    %rax, 40(%rsp)
        movq    16(%rbp), %rax
        movq    $.L24, 88(%rsp)
        movq    $.L25, 80(%rsp)
        movq    $.L26, 72(%rsp)
        movq    $.L2, 64(%rsp)
        movq    %rax, 8(%rsp)
        movq    24(%rbp), %rax
        movq    %rcx, 224(%rsp)
        movq    %rax, 16(%rsp)
        movq    32(%rbp), %rax
        movq    %rax, 24(%rsp)
        movq    40(%rbp), %rax
        movq    %rax, 32(%rsp)
        movq    240(%rsp), %rax
        movq    %rax, (%rsp)
        movq    %rdx, 232(%rsp)
        movq    248(%rsp), %rsi
        movq    256(%rsp), %rdi
        vzeroupper
        call    _Z17mergesort_handlerPmS_mmmRmPvN7tpalrts12stack_structERPcS5_S5_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_RS1_
        movq    296(%rsp), %rax
        movq    232(%rsp), %rdx
        movq    224(%rsp), %rcx
        movq    216(%rsp), %r10
        movq    304(%rsp), %rsi
        jmp     *%rax
.L67:
        leaq    -56(%r11), %r8
        leaq    8(%rax), %rdi
        cmpq    %r8, %rdi
        jnb     .L75
        cmpq    $55, %r11
        jbe     .L75
.L73:
        movq    (%rax), %r9
        prefetcht0      272(%rax)
        movq    %rax, %rdi
        addq    $64, %rax
        addq    $72, %rdi
        prefetcht0      272(%rsi)
        addq    $64, %rsi
        movq    %r9, -64(%rsi)
        movq    -56(%rax), %r9
        movq    %r9, -56(%rsi)
        movq    -48(%rax), %r9
        movq    %r9, -48(%rsi)
        movq    -40(%rax), %r9
        movq    %r9, -40(%rsi)
        movq    -32(%rax), %r9
        movq    %r9, -32(%rsi)
        movq    -24(%rax), %r9
        movq    %r9, -24(%rsi)
        movq    -16(%rax), %r9
        movq    %r9, -16(%rsi)
        movq    -8(%rax), %r9
        cmpq    %rdi, %r8
        movq    %r9, -8(%rsi)
        ja      .L73
        leaq    8(%rax), %rdi
        jmp     .L75
.L221:
        addq    $8, %rdi
.L75:
        movq    -8(%rdi), %rax
        addq    $8, %rsi
        cmpq    %rdi, %r11
        movq    %rax, -8(%rsi)
        jne     .L221
        jmp     .L16
.L49:
        leaq    -56(%r9), %rdi
        leaq    8(%rsi), %rax
        cmpq    %rdi, %rax
        jnb     .L55
        cmpq    $55, %r9
        jbe     .L55
.L53:
        movq    (%rsi), %rbx
        prefetcht0      272(%rsi)
        movq    %rsi, %rax
        addq    $64, %rsi
        addq    $72, %rax
        prefetcht0      272(%r8)
        addq    $64, %r8
        movq    %rbx, -64(%r8)
        movq    -56(%rsi), %rbx
        movq    %rbx, -56(%r8)
        movq    -48(%rsi), %rbx
        movq    %rbx, -48(%r8)
        movq    -40(%rsi), %rbx
        movq    %rbx, -40(%r8)
        movq    -32(%rsi), %rbx
        movq    %rbx, -32(%r8)
        movq    -24(%rsi), %rbx
        movq    %rbx, -24(%r8)
        movq    -16(%rsi), %rbx
        movq    %rbx, -16(%r8)
        movq    -8(%rsi), %rbx
        cmpq    %rdi, %rax
        movq    %rbx, -8(%r8)
        jb      .L53
        leaq    8(%rsi), %rax
        jmp     .L55
.L222:
        addq    $8, %rax
.L55:
        movq    -8(%rax), %rsi
        addq    $8, %r8
        cmpq    %rax, %r9
        movq    %rsi, -8(%r8)
        jne     .L222
        jmp     .L99
.L79:
        leaq    -56(%rbx), %r8
        leaq    8(%rdi), %rax
        cmpq    %rax, %r8
        jbe     .L86
        cmpq    $55, %rbx
        jbe     .L86
.L84:
        movq    (%rdi), %r9
        prefetcht0      272(%rdi)
        movq    %rdi, %rax
        addq    $64, %rdi
        addq    $72, %rax
        prefetcht0      272(%rsi)
        addq    $64, %rsi
        movq    %r9, -64(%rsi)
        movq    -56(%rdi), %r9
        movq    %r9, -56(%rsi)
        movq    -48(%rdi), %r9
        movq    %r9, -48(%rsi)
        movq    -40(%rdi), %r9
        movq    %r9, -40(%rsi)
        movq    -32(%rdi), %r9
        movq    %r9, -32(%rsi)
        movq    -24(%rdi), %r9
        movq    %r9, -24(%rsi)
        movq    -16(%rdi), %r9
        movq    %r9, -16(%rsi)
        movq    -8(%rdi), %r9
        cmpq    %rax, %r8
        movq    %r9, -8(%rsi)
        ja      .L84
        leaq    8(%rdi), %rax
        jmp     .L86
.L223:
        addq    $8, %rax
.L86:
        movq    -8(%rax), %rdi
        addq    $8, %rsi
        cmpq    %rax, %rbx
        movq    %rdi, -8(%rsi)
        jne     .L223
        jmp     .L16
.L41:
        leaq    -56(%r9), %rdi
        leaq    8(%rsi), %rax
        cmpq    %rdi, %rax
        jnb     .L47
        cmpq    $55, %r9
        jbe     .L47
.L45:
        movq    (%rsi), %rbx
        prefetcht0      272(%rsi)
        movq    %rsi, %rax
        addq    $64, %rsi
        addq    $72, %rax
        prefetcht0      272(%r8)
        addq    $64, %r8
        movq    %rbx, -64(%r8)
        movq    -56(%rsi), %rbx
        movq    %rbx, -56(%r8)
        movq    -48(%rsi), %rbx
        movq    %rbx, -48(%r8)
        movq    -40(%rsi), %rbx
        movq    %rbx, -40(%r8)
        movq    -32(%rsi), %rbx
        movq    %rbx, -32(%r8)
        movq    -24(%rsi), %rbx
        movq    %rbx, -24(%r8)
        movq    -16(%rsi), %rbx
        movq    %rbx, -16(%r8)
        movq    -8(%rsi), %rbx
        cmpq    %rdi, %rax
        movq    %rbx, -8(%r8)
        jb      .L45
        leaq    8(%rsi), %rax
        jmp     .L47
.L224:
        addq    $8, %rax
.L47:
        movq    -8(%rax), %rsi
        addq    $8, %r8
        cmpq    %rax, %r9
        movq    %rsi, -8(%r8)
        jne     .L224
        jmp     .L98
.L214:
        movq    %r10, 216(%rsp)
        movq    $.L13, 296(%rsp)
        jmp     .L199
compare:
        .zero   1
