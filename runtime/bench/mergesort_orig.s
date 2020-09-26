_Z19mergesort_interruptPmS_mmPvN7tpalrts12stack_structES0_P17merge_args_structPSt4pairImmE:
        pushq   %r15
        pushq   %r14
        pushq   %r13
        pushq   %r12
        pushq   %rbp
        pushq   %rbx
        subq    $344, %rsp
        cmpq    $0, 400(%rsp)
        movq    %rsi, 248(%rsp)
        movq    440(%rsp), %rbx
        movq    432(%rsp), %rsi
        movq    %rdi, 240(%rsp)
        movq    %r8, 256(%rsp)
        movq    %r9, 296(%rsp)
        je      .L3
        movq    408(%rsp), %rax
.L4:
        movq    %rax, 304(%rsp)
        movq    416(%rsp), %rax
        testq   %rsi, %rsi
        movq    %rax, 312(%rsp)
        movq    424(%rsp), %rax
        movq    %rax, 320(%rsp)
        je      .L5
        movq    16(%rsi), %rax
        movq    (%rsi), %r11
        movq    8(%rsi), %r15
        movq    24(%rsi), %r13
        movq    32(%rsi), %rbp
        movq    40(%rsi), %r14
        movq    %rax, 216(%rsp)
        movq    56(%rsi), %rax
        movq    48(%rsi), %r12
        movq    %rax, 224(%rsp)
.L5:
        testq   %rbx, %rbx
        movq    $0, 328(%rsp)
        movq    $0, 232(%rsp)
        je      .L6
        movq    (%rbx), %rax
        movq    %rax, 232(%rsp)
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
.L163:
        movq    224(%rsp), %rbx
        leaq    (%r11,%r13,8), %rdi
        testq   %r10, %r10
        movq    (%rdi), %rax
        leaq    0(,%rbx,8), %rsi
        movq    216(%rsp), %rbx
        leaq    (%rbx,%rsi), %r8
        jne     .L54
        movq    %rax, (%r8)
.L16:
        movq    304(%rsp), %rsi
        movq    (%rsi), %rax
        movq    304(%rsp), %rsi
        jmp     *%rax
.L159:
        addq    $8, %rax
.L44:
        movq    -8(%rax), %rdi
        addq    $8, %rsi
        cmpq    %rax, %r8
        movq    %rdi, -8(%rsi)
        jne     .L159
.L81:
        movq    %r9, 232(%rsp)
.L37:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L160
        movq    328(%rsp), %r9
        movq    232(%rsp), %rbx
        cmpq    %rbx, %r9
        jne     .L161
.L12:
        addq    $64, 304(%rsp)
        jmp     .L16
.L22:
        movq    248(%rsp), %rax
        movq    $.L21, (%rsi)
        movq    304(%rsp), %rsi
        movq    240(%rsp), %r15
        movq    %rax, 216(%rsp)
        movq    40(%rsi), %rbp
        movq    56(%rsi), %rax
        movq    %r15, %r11
        movq    48(%rsi), %r12
        movq    %rax, 224(%rsp)
        movq    %rbp, %r14
        movq    %rax, %r13
.L20:
        leaq    -8(%rsi), %rax
        movq    %rax, 304(%rsp)
        movq    $.L49, -8(%rsi)
.L51:
        movq    %rbp, %rbx
        movq    %r12, %r10
        subq    %r13, %rbx
        subq    %r14, %r10
        cmpq    %r10, %rbx
        jb      .L84
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L162
.L52:
        testq   %rbx, %rbx
        je      .L16
        cmpq    $1, %rbx
        je      .L163
        leaq    0(,%r14,8), %rdi
        cmpq    $1999, %rbx
        leaq    0(,%r12,8), %rax
        leaq    (%r15,%rdi), %rsi
        jbe     .L164
        leaq    0(%r13,%rbp), %r8
        subq    %rdi, %rax
        sarq    $3, %rax
        shrq    %r8
        leaq    (%r11,%r8,8), %r9
.L71:
        testq   %rax, %rax
        jle     .L70
.L165:
        movq    %rax, %rdi
        movq    (%r9), %rbx
        sarq    %rdi
        leaq    (%rsi,%rdi,8), %r10
        cmpq    %rbx, (%r10)
        jnb     .L85
        incq    %rdi
        leaq    8(%r10), %rsi
        subq    %rdi, %rax
        testq   %rax, %rax
        jg      .L165
.L70:
        movq    224(%rsp), %rdi
        leaq    0(%r13,%r14), %rax
        subq    %r15, %rsi
        sarq    $3, %rsi
        subq    %rax, %rdi
        movq    304(%rsp), %rax
        addq    %r8, %rdi
        leaq    -88(%rax), %r9
        movq    %r9, 304(%rsp)
        movq    $.L18, -88(%rax)
        movq    320(%rsp), %r9
        movq    304(%rsp), %rax
        testq   %r9, %r9
        leaq    8(%rax), %r10
        movq    %r9, 8(%rax)
        movq    $0, 16(%rax)
        je      .L73
        movq    %r10, 8(%r9)
.L73:
        cmpq    $0, 312(%rsp)
        movq    %r10, 320(%rsp)
        je      .L166
.L74:
        movq    216(%rsp), %rbx
        addq    %rsi, %rdi
        movq    %rbp, 56(%rax)
        movq    %r12, 72(%rax)
        movq    %r11, 24(%rax)
        movq    %rsi, %r12
        movq    %r15, 32(%rax)
        movq    %r8, 48(%rax)
        movq    %r8, %rbp
        movq    %rbx, 40(%rax)
        movq    %rsi, 64(%rax)
        movq    %rdi, 80(%rax)
        jmp     .L51
.L85:
        movq    %rdi, %rax
        jmp     .L71
.L84:
        movq    %rbp, %rax
        movq    %r12, %rbp
        movq    %rax, %r12
        movq    %r13, %rax
        movq    %r14, %r13
        movq    %rax, %r14
        movq    %r11, %rax
        movq    %r15, %r11
        movq    %rax, %r15
        jmp     .L51
.L166:
        movq    %r10, 312(%rsp)
        jmp     .L74
.L162:
        leaq    296(%rsp), %rax
        movq    %r10, 288(%rsp)
        movq    %r11, 280(%rsp)
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
        movq    400(%rsp), %rax
        movq    $.L23, 96(%rsp)
        movq    $.L24, 88(%rsp)
        movq    $.L25, 80(%rsp)
        movq    $.L26, 72(%rsp)
        movq    %rax, 8(%rsp)
        movq    408(%rsp), %rax
        movq    $.L2, 64(%rsp)
        movq    %rax, 16(%rsp)
        movq    416(%rsp), %rax
        movq    %rax, 24(%rsp)
        movq    424(%rsp), %rax
        movq    %rax, 32(%rsp)
        movq    256(%rsp), %rax
        movq    %rax, (%rsp)
        movq    232(%rsp), %r8
        movq    248(%rsp), %rsi
        movq    240(%rsp), %rdi
        movq    %rcx, 272(%rsp)
        movq    %rdx, 264(%rsp)
        call    _Z17mergesort_handlerPmS_mmmRmPvN7tpalrts12stack_structERPcS5_S5_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_RS1_
        movq    288(%rsp), %r10
        movq    280(%rsp), %r11
        movq    272(%rsp), %rcx
        movq    264(%rsp), %rdx
        jmp     .L52
.L164:
        movq    216(%rsp), %rbx
        movq    224(%rsp), %rdi
        leaq    (%r11,%r13,8), %r8
        addq    %r15, %rax
        leaq    (%rbx,%rdi,8), %rdi
        leaq    (%r11,%rbp,8), %rbx
        cmpq    %r8, %rbx
        jne     .L138
        jmp     .L56
.L168:
        movq    %r9, (%rdi)
        addq    $8, %rsi
        addq    $8, %rdi
        cmpq    %r8, %rbx
        je      .L56
.L138:
        cmpq    %rsi, %rax
        je      .L167
        movq    (%rsi), %r9
        movq    (%r8), %r10
        cmpq    %r10, %r9
        jb      .L168
        addq    $8, %r8
        movq    %r10, %r9
        addq    $8, %rdi
        movq    %r9, -8(%rdi)
        cmpq    %r8, %rbx
        jne     .L138
.L56:
        cmpq    %rax, %rsi
        je      .L16
        leaq    -56(%rax), %r9
        leaq    8(%rsi), %r8
        cmpq    %r9, %r8
        jnb     .L69
        cmpq    $55, %rax
        jbe     .L69
.L68:
        movq    (%rsi), %r10
        prefetcht0      272(%rsi)
        movq    %rsi, %r8
        addq    $64, %rsi
        addq    $72, %r8
        prefetcht0      272(%rdi)
        addq    $64, %rdi
        movq    %r10, -64(%rdi)
        movq    -56(%rsi), %r10
        movq    %r10, -56(%rdi)
        movq    -48(%rsi), %r10
        movq    %r10, -48(%rdi)
        movq    -40(%rsi), %r10
        movq    %r10, -40(%rdi)
        movq    -32(%rsi), %r10
        movq    %r10, -32(%rdi)
        movq    -24(%rsi), %r10
        movq    %r10, -24(%rdi)
        movq    -16(%rsi), %r10
        movq    %r10, -16(%rdi)
        movq    -8(%rsi), %r10
        cmpq    %r8, %r9
        movq    %r10, -8(%rdi)
        ja      .L68
        leaq    8(%rsi), %r8
        jmp     .L69
.L169:
        addq    $8, %rsi
.L48:
        movq    -8(%rsi), %rdi
        addq    $8, %rax
        cmpq    %rsi, %r8
        movq    %rdi, -8(%rax)
        jne     .L169
.L83:
        movq    %r9, 232(%rsp)
.L13:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L170
        movq    328(%rsp), %r9
        movq    232(%rsp), %rbx
        cmpq    %rbx, %r9
        je      .L1
        leaq    2000(%rbx), %rax
        leaq    0(,%rbx,8), %rdi
        movq    248(%rsp), %rbx
        cmpq    %r9, %rax
        cmovbe  %rax, %r9
        movq    240(%rsp), %rax
        leaq    (%rbx,%r9,8), %r8
        addq    %rdi, %rax
        addq    %rbx, %rdi
        cmpq    %rdi, %r8
        je      .L83
        leaq    -56(%r8), %r10
        leaq    8(%rdi), %rsi
        cmpq    %r10, %rsi
        jnb     .L48
        cmpq    $55, %r8
        jbe     .L48
.L47:
        movq    (%rdi), %rbx
        prefetcht0      272(%rdi)
        movq    %rdi, %rsi
        addq    $64, %rdi
        addq    $72, %rsi
        prefetcht0      272(%rax)
        addq    $64, %rax
        movq    %rbx, -64(%rax)
        movq    -56(%rdi), %rbx
        movq    %rbx, -56(%rax)
        movq    -48(%rdi), %rbx
        movq    %rbx, -48(%rax)
        movq    -40(%rdi), %rbx
        movq    %rbx, -40(%rax)
        movq    -32(%rdi), %rbx
        movq    %rbx, -32(%rax)
        movq    -24(%rdi), %rbx
        movq    %rbx, -24(%rax)
        movq    -16(%rdi), %rbx
        movq    %rbx, -16(%rax)
        movq    -8(%rdi), %rbx
        cmpq    %r10, %rsi
        movq    %rbx, -8(%rax)
        jb      .L47
        leaq    8(%rdi), %rsi
        jmp     .L48
.L54:
        leaq    (%r15,%r14,8), %r9
        cmpq    %rax, (%r9)
        cmovbe  (%r9), %rax
        movq    %rax, (%r8)
        movq    (%rdi), %rax
        cmpq    %rax, (%r9)
        cmovnb  (%r9), %rax
        movq    %rax, 8(%rbx,%rsi)
        jmp     .L16
.L161:
        leaq    2000(%rbx), %rax
        leaq    0(,%rbx,8), %rdi
        cmpq    %r9, %rax
        cmovbe  %rax, %r9
        movq    240(%rsp), %rax
        leaq    (%rax,%rdi), %rsi
        movq    248(%rsp), %rax
        leaq    (%rax,%r9,8), %r8
        addq    %rax, %rdi
        cmpq    %rdi, %r8
        je      .L81
        leaq    -56(%r8), %r10
        leaq    8(%rdi), %rax
        cmpq    %r10, %rax
        jnb     .L44
        cmpq    $55, %r8
        jbe     .L44
.L42:
        movq    (%rdi), %rbx
        prefetcht0      272(%rdi)
        movq    %rdi, %rax
        addq    $64, %rdi
        addq    $72, %rax
        prefetcht0      272(%rsi)
        addq    $64, %rsi
        movq    %rbx, -64(%rsi)
        movq    -56(%rdi), %rbx
        movq    %rbx, -56(%rsi)
        movq    -48(%rdi), %rbx
        movq    %rbx, -48(%rsi)
        movq    -40(%rdi), %rbx
        movq    %rbx, -40(%rsi)
        movq    -32(%rdi), %rbx
        movq    %rbx, -32(%rsi)
        movq    -24(%rdi), %rbx
        movq    %rbx, -24(%rsi)
        movq    -16(%rdi), %rbx
        movq    %rbx, -16(%rsi)
        movq    -8(%rdi), %rbx
        cmpq    %rax, %r10
        movq    %rbx, -8(%rsi)
        ja      .L42
        leaq    8(%rdi), %rax
        jmp     .L44
.L24:
        movq    %rsi, %rax
        leaq    -8(%rsi), %rsi
        movq    %rsi, 304(%rsp)
        movq    $.L25, -8(%rax)
.L154:
        movq    %r12, 264(%rsp)
        movq    248(%rsp), %rsi
        movq    %rbp, %r12
        movq    %rcx, %rbx
        movq    240(%rsp), %rbp
        jmp     .L34
.L33:
        movq    %rbx, 48(%rax)
        movq    %rbp, 24(%rax)
        movq    %rcx, %rbx
        movq    %rsi, 32(%rax)
        movq    %rcx, 40(%rax)
        movq    %rdx, 56(%rax)
.L34:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L171
.L11:
        movq    %rbx, %rax
        subq    %rdx, %rax
        cmpq    $23, %rax
        jbe     .L172
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
.L9:
        leaq    400(%rsp), %rdi
        addq    $8, 304(%rsp)
        call    _ZN7tpalrts7sdeleteERNS_12stack_structE
.L1:
        addq    $344, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L26:
        jmp     .L16
.L23:
        movq    $.L22, (%rsi)
        movq    320(%rsp), %rdx
        movq    (%rdx), %rax
        testq   %rax, %rax
        je      .L173
        movq    $0, 8(%rax)
        movq    $0, (%rdx)
.L36:
        movq    %rax, 320(%rsp)
        movq    304(%rsp), %rax
        movq    %r12, 264(%rsp)
        movq    %rbp, %r12
        movq    24(%rax), %rbx
        movq    32(%rax), %rsi
        movq    48(%rax), %rcx
        movq    40(%rax), %rdx
        movl    heartbeat(%rip), %eax
        movq    %rbx, 240(%rsp)
        movq    %rbx, %rbp
        movq    %rsi, 248(%rsp)
        movq    %rcx, %rbx
        testl   %eax, %eax
        je      .L11
.L171:
        leaq    296(%rsp), %rax
        movq    232(%rsp), %r8
        leaq    328(%rsp), %r9
        movq    %r11, 288(%rsp)
        movq    $.L12, 184(%rsp)
        movq    %rbx, %rcx
        movq    %rax, 192(%rsp)
        leaq    320(%rsp), %rax
        movq    $.L13, 176(%rsp)
        movq    $.L14, 168(%rsp)
        movq    $.L15, 160(%rsp)
        movq    %rbp, %rdi
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
        movq    400(%rsp), %rax
        movq    $.L22, 104(%rsp)
        movq    $.L23, 96(%rsp)
        movq    $.L24, 88(%rsp)
        movq    $.L25, 80(%rsp)
        movq    %rax, 8(%rsp)
        movq    408(%rsp), %rax
        movq    $.L26, 72(%rsp)
        movq    $.L2, 64(%rsp)
        movq    %rax, 16(%rsp)
        movq    416(%rsp), %rax
        movq    %rax, 24(%rsp)
        movq    424(%rsp), %rax
        movq    %rax, 32(%rsp)
        movq    256(%rsp), %rax
        movq    %rax, (%rsp)
        movq    %rdx, 280(%rsp)
        movq    %rsi, 272(%rsp)
        call    _Z17mergesort_handlerPmS_mmmRmPvN7tpalrts12stack_structERPcS5_S5_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_RS1_
        movq    280(%rsp), %rdx
        movq    %rbx, %rax
        movq    288(%rsp), %r11
        movq    272(%rsp), %rsi
        subq    %rdx, %rax
        cmpq    $23, %rax
        ja      .L27
.L172:
        movq    %rbx, %rcx
        movq    240(%rsp), %rbx
        testq   %rax, %rax
        movq    %r12, %rbp
        movq    264(%rsp), %r12
        leaq    (%rbx,%rdx,8), %r8
        je      .L16
        leaq    -8(%r8), %r9
        leaq    (%r9,%rax,8), %r10
.L31:
        cmpq    %r9, %r8
        movq    8(%r9), %rdi
        movq    %r9, %rax
        jbe     .L29
        jmp     .L28
.L174:
        movq    %rsi, 8(%rax)
        subq    $8, %rax
        cmpq    %rax, %r8
        ja      .L28
.L29:
        movq    (%rax), %rsi
        cmpq    %rsi, %rdi
        jb      .L174
.L28:
        addq    $8, %r9
        movq    %rdi, 8(%rax)
        cmpq    %r9, %r10
        jne     .L31
        jmp     .L16
.L18:
        movq    $.L17, (%rsi)
        movq    320(%rsp), %rsi
        movq    (%rsi), %rax
        testq   %rax, %rax
        je      .L175
        movq    $0, 8(%rax)
        movq    $0, (%rsi)
.L77:
        movq    %rax, 320(%rsp)
        movq    304(%rsp), %rax
        movq    40(%rax), %rbx
        movq    24(%rax), %r11
        movq    32(%rax), %r15
        movq    48(%rax), %r13
        movq    56(%rax), %rbp
        movq    64(%rax), %r14
        movq    72(%rax), %r12
        movq    80(%rax), %rax
        movq    %rbx, 216(%rsp)
        movq    %rax, 224(%rsp)
        jmp     .L51
.L17:
        addq    $88, 304(%rsp)
        jmp     .L16
.L15:
        movq    $.L14, (%rsi)
        jmp     .L1
.L14:
        movq    %rsi, %rax
        leaq    -8(%rsi), %rsi
        movq    %rsi, 304(%rsp)
        movq    $.L15, -8(%rax)
        jmp     .L51
.L49:
        addq    $8, 304(%rsp)
        jmp     .L16
.L19:
        movq    %rsi, %rax
        leaq    -8(%rsi), %rsi
        movq    %rsi, 304(%rsp)
        movq    $.L78, -8(%rax)
        jmp     .L51
.L78:
        jmp     .L1
.L2:
        movq    %rsi, %rax
        leaq    -8(%rsi), %rsi
        movq    %rsi, 304(%rsp)
        movq    $.L9, -8(%rax)
        jmp     .L154
.L21:
        movq    24(%rsi), %rdx
        movq    48(%rsi), %rcx
        movq    %rdx, 240(%rsp)
        movq    32(%rsi), %rdx
        movq    %rcx, 328(%rsp)
        movq    %rdx, 248(%rsp)
        movq    56(%rsi), %rdx
        movq    %rdx, 232(%rsp)
        jmp     .L37
.L25:
        movq    $.L24, (%rsi)
        jmp     .L1
.L3:
        movq    %rsi, 432(%rsp)
        movq    %rcx, 272(%rsp)
        movq    %rdx, 264(%rsp)
        movq    %r11, 232(%rsp)
        call    _ZN7tpalrts11alloc_stackEv
        movq    %rax, 400(%rsp)
        addq    $8191, %rax
        movq    432(%rsp), %rsi
        movq    272(%rsp), %rcx
        movq    264(%rsp), %rdx
        movq    232(%rsp), %r11
        movq    %rax, 408(%rsp)
        jmp     .L4
.L176:
        addq    $8, %r8
.L69:
        movq    -8(%r8), %rsi
        addq    $8, %rdi
        cmpq    %rax, %r8
        movq    %rsi, -8(%rdi)
        jne     .L176
        jmp     .L16
.L167:
        leaq    -56(%rbx), %rsi
        leaq    8(%r8), %rax
        cmpq    %rax, %rsi
        jbe     .L63
        cmpq    $55, %rbx
        jbe     .L63
.L61:
        movq    (%r8), %r9
        prefetcht0      272(%r8)
        movq    %r8, %rax
        addq    $64, %r8
        addq    $72, %rax
        prefetcht0      272(%rdi)
        addq    $64, %rdi
        movq    %r9, -64(%rdi)
        movq    -56(%r8), %r9
        movq    %r9, -56(%rdi)
        movq    -48(%r8), %r9
        movq    %r9, -48(%rdi)
        movq    -40(%r8), %r9
        movq    %r9, -40(%rdi)
        movq    -32(%r8), %r9
        movq    %r9, -32(%rdi)
        movq    -24(%r8), %r9
        movq    %r9, -24(%rdi)
        movq    -16(%r8), %r9
        movq    %r9, -16(%rdi)
        movq    -8(%r8), %r9
        cmpq    %rax, %rsi
        movq    %r9, -8(%rdi)
        ja      .L61
        leaq    8(%r8), %rax
        jmp     .L63
.L177:
        addq    $8, %rax
.L63:
        movq    -8(%rax), %rsi
        addq    $8, %rdi
        cmpq    %rax, %rbx
        movq    %rsi, -8(%rdi)
        jne     .L177
        jmp     .L16
.L173:
        movq    $0, 312(%rsp)
        jmp     .L36
.L175:
        movq    $0, 312(%rsp)
        jmp     .L77
.L160:
        movq    %r11, 280(%rsp)
        movq    $.L37, 296(%rsp)
.L153:
        leaq    296(%rsp), %rax
        movq    %rcx, 272(%rsp)
        movq    232(%rsp), %r8
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
        movq    400(%rsp), %rax
        movq    $.L23, 96(%rsp)
        movq    $.L24, 88(%rsp)
        movq    $.L25, 80(%rsp)
        movq    $.L26, 72(%rsp)
        movq    %rax, 8(%rsp)
        movq    408(%rsp), %rax
        movq    $.L2, 64(%rsp)
        movq    %rax, 16(%rsp)
        movq    416(%rsp), %rax
        movq    %rax, 24(%rsp)
        movq    424(%rsp), %rax
        movq    %rax, 32(%rsp)
        movq    256(%rsp), %rax
        movq    %rax, (%rsp)
        movq    %rdx, 264(%rsp)
        movq    248(%rsp), %rsi
        movq    240(%rsp), %rdi
        call    _Z17mergesort_handlerPmS_mmmRmPvN7tpalrts12stack_structERPcS5_S5_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_S1_RS1_
        movq    296(%rsp), %rax
        movq    264(%rsp), %rdx
        movq    272(%rsp), %rcx
        movq    280(%rsp), %r11
        movq    304(%rsp), %rsi
        jmp     *%rax
.L170:
        movq    %r11, 280(%rsp)
        movq    $.L13, 296(%rsp)
        jmp     .L153
compare:
        .zero   1
