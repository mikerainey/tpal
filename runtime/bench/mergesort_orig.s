_Z19mergesort_interruptPmS_mmPvN7tpalrts12stack_structES0_P17merge_args_structPSt4pairImmE:
        pushq   %r15
        pushq   %r14
        pushq   %r13
        pushq   %r12
        pushq   %rbp
        pushq   %rbx
        subq    $216, %rsp
        cmpq    $0, 272(%rsp)
        movq    %rsi, 120(%rsp)
        movq    304(%rsp), %rbx
        movq    312(%rsp), %rsi
        movq    %rdi, 112(%rsp)
        movq    %r8, 128(%rsp)
        movq    %r9, 168(%rsp)
        je      .L2
        movq    280(%rsp), %rax
.L3:
        movq    %rax, 176(%rsp)
        movq    288(%rsp), %rax
        testq   %rbx, %rbx
        movq    %rax, 184(%rsp)
        movq    296(%rsp), %rax
        movq    %rax, 192(%rsp)
        je      .L4
        movq    16(%rbx), %rax
        movq    (%rbx), %r11
        movq    8(%rbx), %r15
        movq    24(%rbx), %r13
        movq    32(%rbx), %rbp
        movq    40(%rbx), %r14
        movq    %rax, 88(%rsp)
        movq    56(%rbx), %rax
        movq    48(%rbx), %r12
        movq    %rax, 96(%rsp)
.L4:
        testq   %rsi, %rsi
        movq    $0, 200(%rsp)
        movq    $0, 104(%rsp)
        je      .L5
        movq    (%rsi), %rax
        movq    %rax, 104(%rsp)
        movq    8(%rsi), %rax
        movq    %rax, 200(%rsp)
.L5:
        cmpq    $0, __ms_entry(%rip)
        je      .L159
.L6:
        movq    168(%rsp), %rax
        movq    176(%rsp), %rsi
        testq   %rax, %rax
        cmove   __ms_entry(%rip), %rax
        movq    %rax, 168(%rsp)
        jmp     *%rax
.L164:
        movq    96(%rsp), %rbx
        leaq    (%r11,%r13,8), %rdi
        testq   %r10, %r10
        movq    (%rdi), %rax
        leaq    0(,%rbx,8), %rsi
        movq    88(%rsp), %rbx
        leaq    (%rbx,%rsi), %r9
        jne     .L56
        movq    %rax, (%r9)
.L19:
        movq    176(%rsp), %rsi
        movq    (%rsi), %rax
        movq    176(%rsp), %rsi
        jmp     *%rax
.L160:
        addq    $8, %rax
.L47:
        movq    -8(%rax), %rdi
        addq    $8, %rsi
        cmpq    %rax, %r8
        movq    %rdi, -8(%rsi)
        jne     .L160
.L81:
        movq    %r9, 104(%rsp)
.L24:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L161
        movq    200(%rsp), %r9
        movq    104(%rsp), %rbx
        cmpq    %rbx, %r9
        jne     .L162
.L26:
        addq    $64, 176(%rsp)
        jmp     .L19
.L12:
        movq    %rsi, %rax
        movq    __ms_branch3(%rip), %rsi
        movq    112(%rsp), %r15
        movq    %rsi, (%rax)
        movq    120(%rsp), %rax
        movq    %r15, %r11
        movq    176(%rsp), %rsi
        movq    %rax, 88(%rsp)
        movq    40(%rsi), %rbp
        movq    56(%rsi), %rax
        movq    48(%rsi), %r12
        movq    %rax, 96(%rsp)
        movq    %rbp, %r14
        movq    %rax, %r13
.L15:
        leaq    -8(%rsi), %rax
        movq    %rax, 176(%rsp)
        movq    __mg_exitk(%rip), %rax
        movq    %rax, -8(%rsi)
.L53:
        movq    %rbp, %rbx
        movq    %r12, %r10
        subq    %r13, %rbx
        subq    %r14, %r10
        cmpq    %r10, %rbx
        jb      .L84
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L163
.L54:
        testq   %rbx, %rbx
        je      .L19
        cmpq    $1, %rbx
        je      .L164
        leaq    0(,%r14,8), %rdi
        cmpq    $1999, %rbx
        leaq    0(,%r12,8), %rax
        leaq    (%r15,%rdi), %rsi
        jbe     .L165
        leaq    0(%r13,%rbp), %r8
        subq    %rdi, %rax
        sarq    $3, %rax
        shrq    %r8
        leaq    (%r11,%r8,8), %r9
.L73:
        testq   %rax, %rax
        jle     .L72
.L166:
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
        jg      .L166
.L72:
        movq    96(%rsp), %rdi
        leaq    0(%r13,%r14), %rax
        subq    %r15, %rsi
        sarq    $3, %rsi
        subq    %rax, %rdi
        movq    176(%rsp), %rax
        addq    %r8, %rdi
        leaq    -88(%rax), %r9
        movq    %r9, 176(%rsp)
        movq    __mg_branch1(%rip), %r9
        movq    %r9, -88(%rax)
        movq    192(%rsp), %r9
        movq    176(%rsp), %rax
        testq   %r9, %r9
        leaq    8(%rax), %r10
        movq    %r9, 8(%rax)
        movq    $0, 16(%rax)
        je      .L75
        movq    %r10, 8(%r9)
.L75:
        cmpq    $0, 184(%rsp)
        movq    %r10, 192(%rsp)
        je      .L167
.L76:
        movq    88(%rsp), %rbx
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
        jmp     .L53
.L85:
        movq    %rdi, %rax
        jmp     .L73
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
        jmp     .L53
.L167:
        movq    %r10, 184(%rsp)
        jmp     .L76
.L163:
        leaq    168(%rsp), %rax
        movq    104(%rsp), %r8
        movq    120(%rsp), %rsi
        movq    112(%rsp), %rdi
        leaq    200(%rsp), %r9
        movq    %r10, 160(%rsp)
        movq    %rax, 64(%rsp)
        leaq    192(%rsp), %rax
        movq    %r11, 152(%rsp)
        movq    %rcx, 144(%rsp)
        movq    %rdx, 136(%rsp)
        movq    %rax, 56(%rsp)
        leaq    184(%rsp), %rax
        movq    %rax, 48(%rsp)
        leaq    176(%rsp), %rax
        movq    %rax, 40(%rsp)
        movq    272(%rsp), %rax
        movq    %rax, 8(%rsp)
        movq    280(%rsp), %rax
        movq    %rax, 16(%rsp)
        movq    288(%rsp), %rax
        movq    %rax, 24(%rsp)
        movq    296(%rsp), %rax
        movq    %rax, 32(%rsp)
        movq    128(%rsp), %rax
        movq    %rax, (%rsp)
        call    _Z17mergesort_handlerPmS_mmmRmPvN7tpalrts12stack_structERPcS5_S5_RS1_
        movq    160(%rsp), %r10
        movq    152(%rsp), %r11
        movq    144(%rsp), %rcx
        movq    136(%rsp), %rdx
        jmp     .L54
.L165:
        movq    88(%rsp), %rbx
        movq    96(%rsp), %rdi
        leaq    (%r11,%r13,8), %r8
        addq    %r15, %rax
        leaq    (%rbx,%rdi,8), %rdi
        leaq    (%r11,%rbp,8), %rbx
        cmpq    %r8, %rbx
        jne     .L138
        jmp     .L58
.L169:
        movq    %r9, (%rdi)
        addq    $8, %rsi
        addq    $8, %rdi
        cmpq    %r8, %rbx
        je      .L58
.L138:
        cmpq    %rsi, %rax
        je      .L168
        movq    (%rsi), %r9
        movq    (%r8), %r10
        cmpq    %r10, %r9
        jb      .L169
        addq    $8, %r8
        movq    %r10, %r9
        addq    $8, %rdi
        movq    %r9, -8(%rdi)
        cmpq    %r8, %rbx
        jne     .L138
.L58:
        cmpq    %rax, %rsi
        je      .L19
        leaq    -56(%rax), %r9
        leaq    8(%rsi), %r8
        cmpq    %r9, %r8
        jnb     .L71
        cmpq    $55, %rax
        jbe     .L71
.L70:
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
        ja      .L70
        leaq    8(%rsi), %r8
        jmp     .L71
.L170:
        addq    $8, %rsi
.L51:
        movq    -8(%rsi), %rdi
        addq    $8, %rax
        cmpq    %rsi, %r8
        movq    %rdi, -8(%rax)
        jne     .L170
.L83:
        movq    %r9, 104(%rsp)
.L25:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L171
        movq    200(%rsp), %r9
        movq    104(%rsp), %rbx
        cmpq    %rbx, %r9
        je      .L1
        leaq    2000(%rbx), %rax
        leaq    0(,%rbx,8), %rdi
        movq    120(%rsp), %rbx
        cmpq    %r9, %rax
        cmovbe  %rax, %r9
        movq    112(%rsp), %rax
        leaq    (%rbx,%r9,8), %r8
        addq    %rdi, %rax
        addq    %rbx, %rdi
        cmpq    %rdi, %r8
        je      .L83
        leaq    -56(%r8), %r10
        leaq    8(%rdi), %rsi
        cmpq    %r10, %rsi
        jnb     .L51
        cmpq    $55, %r8
        jbe     .L51
.L50:
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
        jb      .L50
        leaq    8(%rdi), %rsi
        jmp     .L51
.L56:
        leaq    (%r15,%r14,8), %r8
        cmpq    %rax, (%r8)
        cmovbe  (%r8), %rax
        movq    %rax, (%r9)
        movq    (%rdi), %rax
        cmpq    %rax, (%r8)
        cmovnb  (%r8), %rax
        movq    %rax, 8(%rbx,%rsi)
        jmp     .L19
.L162:
        leaq    2000(%rbx), %rax
        leaq    0(,%rbx,8), %rdi
        cmpq    %r9, %rax
        cmovbe  %rax, %r9
        movq    112(%rsp), %rax
        leaq    (%rax,%rdi), %rsi
        movq    120(%rsp), %rax
        leaq    (%rax,%r9,8), %r8
        addq    %rax, %rdi
        cmpq    %rdi, %r8
        je      .L81
        leaq    -56(%r8), %r10
        leaq    8(%rdi), %rax
        cmpq    %r10, %rax
        jnb     .L47
        cmpq    $55, %r8
        jbe     .L47
.L45:
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
        ja      .L45
        leaq    8(%rdi), %rax
        jmp     .L47
.L23:
.L1:
        addq    $216, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L8:
        jmp     .L19
.L14:
        leaq    272(%rsp), %rdi
        addq    $8, 176(%rsp)
        call    _ZN7tpalrts7sdeleteERNS_12stack_structE
        jmp     .L1
.L16:
        movq    %rsi, %rax
        leaq    -8(%rsi), %rsi
        movq    %rsi, 176(%rsp)
        movq    __mg_exitk2(%rip), %rsi
        movq    %rsi, -8(%rax)
        jmp     .L53
.L17:
        movq    %rsi, %rax
        movq    __mg_branch2(%rip), %rsi
        movq    %rsi, (%rax)
        movq    192(%rsp), %rsi
        movq    (%rsi), %rax
        testq   %rax, %rax
        je      .L172
        movq    $0, 8(%rax)
        movq    $0, (%rsi)
.L79:
        movq    %rax, 192(%rsp)
        movq    176(%rsp), %rax
        movq    40(%rax), %rbx
        movq    24(%rax), %r11
        movq    32(%rax), %r15
        movq    48(%rax), %r13
        movq    56(%rax), %rbp
        movq    64(%rax), %r14
        movq    72(%rax), %r12
        movq    80(%rax), %rax
        movq    %rbx, 88(%rsp)
        movq    %rax, 96(%rsp)
        jmp     .L53
.L18:
        addq    $88, 176(%rsp)
        jmp     .L19
.L7:
        movq    %rsi, %rax
        leaq    -8(%rsi), %rsi
        movq    %rsi, 176(%rsp)
        movq    __ms_exitk(%rip), %rsi
.L154:
        movq    %rsi, -8(%rax)
        movq    %rcx, %rbx
        movq    %r12, 136(%rsp)
        movq    120(%rsp), %rsi
        movq    %rbp, %r12
        movq    112(%rsp), %rbp
        jmp     .L38
.L37:
        movq    %rbx, 48(%rax)
        movq    %rbp, 24(%rax)
        movq    %rcx, %rbx
        movq    %rsi, 32(%rax)
        movq    %rcx, 40(%rax)
        movq    %rdx, 56(%rax)
.L38:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L173
.L30:
        movq    %rbx, %rax
        subq    %rdx, %rax
        cmpq    $23, %rax
        jbe     .L174
.L31:
        movq    176(%rsp), %rax
        leaq    (%rbx,%rdx), %rcx
        shrq    %rcx
        leaq    -64(%rax), %rdi
        movq    %rdi, 176(%rsp)
        movq    __ms_branch1(%rip), %rdi
        movq    %rdi, -64(%rax)
        movq    192(%rsp), %rdi
        movq    176(%rsp), %rax
        testq   %rdi, %rdi
        leaq    8(%rax), %r8
        movq    %rdi, 8(%rax)
        movq    $0, 16(%rax)
        je      .L36
        movq    %r8, 8(%rdi)
.L36:
        cmpq    $0, 184(%rsp)
        movq    %r8, 192(%rsp)
        jne     .L37
        movq    %r8, 184(%rsp)
        jmp     .L37
.L11:
        movq    __ms_branch2(%rip), %rdx
        movq    %rdx, (%rsi)
        movq    192(%rsp), %rdx
        movq    (%rdx), %rax
        testq   %rax, %rax
        je      .L175
        movq    $0, 8(%rax)
        movq    $0, (%rdx)
.L40:
        movq    %rax, 192(%rsp)
        movq    176(%rsp), %rax
        movq    %r12, 136(%rsp)
        movq    %rbp, %r12
        movq    24(%rax), %rbx
        movq    32(%rax), %rsi
        movq    48(%rax), %rcx
        movq    40(%rax), %rdx
        movl    heartbeat(%rip), %eax
        movq    %rbx, 112(%rsp)
        movq    %rbx, %rbp
        movq    %rsi, 120(%rsp)
        movq    %rcx, %rbx
        testl   %eax, %eax
        je      .L30
.L173:
        leaq    168(%rsp), %rax
        movq    104(%rsp), %r8
        leaq    200(%rsp), %r9
        movq    %r11, 160(%rsp)
        movq    %rdx, 152(%rsp)
        movq    %rbx, %rcx
        movq    %rax, 64(%rsp)
        leaq    192(%rsp), %rax
        movq    %rsi, 144(%rsp)
        movq    %rbp, %rdi
        movq    %rax, 56(%rsp)
        leaq    184(%rsp), %rax
        movq    %rax, 48(%rsp)
        leaq    176(%rsp), %rax
        movq    %rax, 40(%rsp)
        movq    272(%rsp), %rax
        movq    %rax, 8(%rsp)
        movq    280(%rsp), %rax
        movq    %rax, 16(%rsp)
        movq    288(%rsp), %rax
        movq    %rax, 24(%rsp)
        movq    296(%rsp), %rax
        movq    %rax, 32(%rsp)
        movq    128(%rsp), %rax
        movq    %rax, (%rsp)
        call    _Z17mergesort_handlerPmS_mmmRmPvN7tpalrts12stack_structERPcS5_S5_RS1_
        movq    152(%rsp), %rdx
        movq    %rbx, %rax
        movq    160(%rsp), %r11
        movq    144(%rsp), %rsi
        subq    %rdx, %rax
        cmpq    $23, %rax
        ja      .L31
.L174:
        movq    %rbx, %rcx
        movq    112(%rsp), %rbx
        testq   %rax, %rax
        movq    %r12, %rbp
        movq    136(%rsp), %r12
        leaq    (%rbx,%rdx,8), %r8
        je      .L19
        leaq    -8(%r8), %r9
        leaq    (%r9,%rax,8), %r10
.L35:
        cmpq    %r9, %r8
        movq    8(%r9), %rdi
        movq    %r9, %rax
        jbe     .L33
        jmp     .L32
.L176:
        movq    %rsi, 8(%rax)
        subq    $8, %rax
        cmpq    %rax, %r8
        ja      .L32
.L33:
        movq    (%rax), %rsi
        cmpq    %rsi, %rdi
        jb      .L176
.L32:
        addq    $8, %r9
        movq    %rdi, 8(%rax)
        cmpq    %r9, %r10
        jne     .L35
        jmp     .L19
.L10:
        movq    %rsi, %rax
        leaq    -8(%rsi), %rsi
        movq    %rsi, 176(%rsp)
        movq    __ms_joink(%rip), %rsi
        jmp     .L154
.L9:
        movq    __ms_clonek(%rip), %rdx
        movq    %rdx, (%rsi)
        jmp     .L1
.L20:
        movq    __mg_clonek(%rip), %rdx
        movq    %rdx, (%rsi)
        jmp     .L1
.L21:
        movq    %rsi, %rax
        leaq    -8(%rsi), %rsi
        movq    %rsi, 176(%rsp)
        movq    __mg_joink(%rip), %rsi
        movq    %rsi, -8(%rax)
        jmp     .L53
.L22:
        addq    $8, 176(%rsp)
        jmp     .L19
.L13:
        movq    24(%rsi), %rdx
        movq    48(%rsi), %rcx
        movq    %rdx, 112(%rsp)
        movq    32(%rsi), %rdx
        movq    %rcx, 200(%rsp)
        movq    %rdx, 120(%rsp)
        movq    56(%rsi), %rdx
        movq    %rdx, 104(%rsp)
        jmp     .L24
.L2:
        movq    %rsi, 312(%rsp)
        movq    %rcx, 144(%rsp)
        movq    %rdx, 136(%rsp)
        movq    %r11, 104(%rsp)
        call    _ZN7tpalrts11alloc_stackEv
        movq    %rax, 272(%rsp)
        addq    $8191, %rax
        movq    312(%rsp), %rsi
        movq    144(%rsp), %rcx
        movq    136(%rsp), %rdx
        movq    104(%rsp), %r11
        movq    %rax, 280(%rsp)
        jmp     .L3
.L159:
        movl    $.L7, %edi
        movq    %rcx, 152(%rsp)
        movq    %rdx, 144(%rsp)
        movq    %r11, 136(%rsp)
        call    _Z14sanitize_labelPv
        movl    $.L8, %edi
        movq    %rax, __ms_entry(%rip)
        call    _Z14sanitize_labelPv
        movl    $.L9, %edi
        movq    %rax, __ms_retk(%rip)
        call    _Z14sanitize_labelPv
        movl    $.L10, %edi
        movq    %rax, __ms_joink(%rip)
        call    _Z14sanitize_labelPv
        movl    $.L11, %edi
        movq    %rax, __ms_clonek(%rip)
        call    _Z14sanitize_labelPv
        movl    $.L12, %edi
        movq    %rax, __ms_branch1(%rip)
        call    _Z14sanitize_labelPv
        movl    $.L13, %edi
        movq    %rax, __ms_branch2(%rip)
        call    _Z14sanitize_labelPv
        movl    $.L14, %edi
        movq    %rax, __ms_branch3(%rip)
        call    _Z14sanitize_labelPv
        movl    $.L15, %edi
        movq    %rax, __ms_exitk(%rip)
        call    _Z14sanitize_labelPv
        movl    $.L16, %edi
        movq    %rax, __mg_entry(%rip)
        call    _Z14sanitize_labelPv
        movl    $.L17, %edi
        movq    %rax, __mg_entry2(%rip)
        call    _Z14sanitize_labelPv
        movl    $.L18, %edi
        movq    %rax, __mg_branch1(%rip)
        call    _Z14sanitize_labelPv
        movl    $.L19, %edi
        movq    %rax, __mg_branch2(%rip)
        call    _Z14sanitize_labelPv
        movl    $.L20, %edi
        movq    %rax, __mg_retk(%rip)
        call    _Z14sanitize_labelPv
        movl    $.L21, %edi
        movq    %rax, __mg_joink(%rip)
        call    _Z14sanitize_labelPv
        movl    $.L22, %edi
        movq    %rax, __mg_clonek(%rip)
        call    _Z14sanitize_labelPv
        movl    $.L23, %edi
        movq    %rax, __mg_exitk(%rip)
        call    _Z14sanitize_labelPv
        movl    $.L24, %edi
        movq    %rax, __mg_exitk2(%rip)
        call    _Z14sanitize_labelPv
        movl    $.L25, %edi
        movq    %rax, __cp_entry(%rip)
        call    _Z14sanitize_labelPv
        movl    $.L26, %edi
        movq    %rax, __cp_par(%rip)
        call    _Z14sanitize_labelPv
        movq    152(%rsp), %rcx
        movq    144(%rsp), %rdx
        movq    136(%rsp), %r11
        movq    %rax, __cp_joink(%rip)
        jmp     .L6
.L177:
        addq    $8, %r8
.L71:
        movq    -8(%r8), %rsi
        addq    $8, %rdi
        cmpq    %rax, %r8
        movq    %rsi, -8(%rdi)
        jne     .L177
        jmp     .L19
.L168:
        leaq    -56(%rbx), %rsi
        leaq    8(%r8), %rax
        cmpq    %rax, %rsi
        jbe     .L65
        cmpq    $55, %rbx
        jbe     .L65
.L63:
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
        ja      .L63
        leaq    8(%r8), %rax
        jmp     .L65
.L178:
        addq    $8, %rax
.L65:
        movq    -8(%rax), %rsi
        addq    $8, %rdi
        cmpq    %rax, %rbx
        movq    %rsi, -8(%rdi)
        jne     .L178
        jmp     .L19
.L172:
        movq    $0, 184(%rsp)
        jmp     .L79
.L175:
        movq    $0, 184(%rsp)
        jmp     .L40
.L161:
        movq    __cp_entry(%rip), %rax
        movq    %r11, 152(%rsp)
.L153:
        movq    %rax, 168(%rsp)
        leaq    168(%rsp), %rax
        movq    120(%rsp), %rsi
        movq    104(%rsp), %r8
        movq    112(%rsp), %rdi
        leaq    200(%rsp), %r9
        movq    %rax, 64(%rsp)
        leaq    192(%rsp), %rax
        movq    %rcx, 144(%rsp)
        movq    %rdx, 136(%rsp)
        movq    %rax, 56(%rsp)
        leaq    184(%rsp), %rax
        movq    %rax, 48(%rsp)
        leaq    176(%rsp), %rax
        movq    %rax, 40(%rsp)
        movq    272(%rsp), %rax
        movq    %rax, 8(%rsp)
        movq    280(%rsp), %rax
        movq    %rax, 16(%rsp)
        movq    288(%rsp), %rax
        movq    %rax, 24(%rsp)
        movq    296(%rsp), %rax
        movq    %rax, 32(%rsp)
        movq    128(%rsp), %rax
        movq    %rax, (%rsp)
        call    _Z17mergesort_handlerPmS_mmmRmPvN7tpalrts12stack_structERPcS5_S5_RS1_
        movq    168(%rsp), %rax
        movq    136(%rsp), %rdx
        movq    144(%rsp), %rcx
        movq    152(%rsp), %r11
        movq    176(%rsp), %rsi
        jmp     *%rax
.L171:
        movq    __cp_par(%rip), %rax
        movq    %r11, 152(%rsp)
        jmp     .L153
compare:
        .zero   1
