plus_reduce_array_serial:
        cmpq    %rdx, %rsi
        je      .L6
        leaq    -7(%rdx), %r9
        leaq    1(%rsi), %rax
        cmpq    %rax, %r9
        jbe     .L7
        cmpq    $6, %rdx
        jbe     .L7
        leaq    232(%rdi,%rsi,8), %rax
        xorl    %r8d, %r8d
.L4:
        addq    -232(%rax), %r8
        movq    %rsi, %rcx
        prefetcht0      (%rax)
        addq    -224(%rax), %r8
        addq    $9, %rcx
        addq    $8, %rsi
        addq    -216(%rax), %r8
        addq    $64, %rax
        addq    -272(%rax), %r8
        addq    -264(%rax), %r8
        addq    -256(%rax), %r8
        addq    -248(%rax), %r8
        addq    -240(%rax), %r8
        cmpq    %rcx, %r9
        ja      .L4
.L3:
        leaq    (%rdi,%rsi,8), %rax
        leaq    (%rdi,%rdx,8), %rdx
.L5:
        addq    (%rax), %r8
        addq    $8, %rax
        cmpq    %rax, %rdx
        jne     .L5
        movq    %r8, %rax
        ret
.L6:
        xorl    %r8d, %r8d
        movq    %r8, %rax
        ret
.L7:
        xorl    %r8d, %r8d
        jmp     .L3
plus_reduce_array_interrupt:
        pushq   %r15
        pushq   %r14
        movq    %r8, %r14
        pushq   %r13
        pushq   %r12
        pushq   %rbp
        pushq   %rbx
        movq    %rcx, %rbx
        subq    $8, %rsp
        cmpq    %rdx, %rsi
        jnb     .L18
        movq    %rdi, %r12
        movq    %rdx, %r13
        movq    %r9, %r15
.L25:
        leaq    2048(%rsi), %rbp
        cmpq    %r13, %rbp
        cmova   %r13, %rbp
        cmpq    %rbp, %rsi
        jnb     .L26
        leaq    -7(%rbp), %rdx
        leaq    1(%rsi), %rax
        cmpq    %rax, %rdx
        jbe     .L22
        cmpq    $6, %rbp
        jbe     .L22
        leaq    232(%r12,%rsi,8), %rcx
.L21:
        movq    -224(%rcx), %rax
        addq    -232(%rcx), %rax
        prefetcht0      (%rcx)
        addq    -216(%rcx), %rax
        addq    $64, %rcx
        addq    -272(%rcx), %rax
        addq    -264(%rcx), %rax
        addq    -256(%rcx), %rax
        addq    -248(%rcx), %rax
        addq    -240(%rcx), %rax
        addq    %rax, %rbx
        movq    %rsi, %rax
        addq    $8, %rsi
        addq    $9, %rax
        cmpq    %rax, %rdx
        ja      .L21
        leaq    1(%rsi), %rax
        addq    (%r12,%rsi,8), %rbx
        cmpq    %rbp, %rax
        movq    %rax, %rsi
        jnb     .L19
.L40:
        incq    %rax
.L22:
        addq    (%r12,%rsi,8), %rbx
        cmpq    %rbp, %rax
        movq    %rax, %rsi
        jb      .L40
.L19:
        cmpq    %rbp, %r13
        jbe     .L18
.L42:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L41
.L23:
        movq    %rbp, %rsi
        jmp     .L25
.L26:
        movq    %rsi, %rbp
        cmpq    %rbp, %r13
        ja      .L42
.L18:
        movq    %rbx, (%r14)
.L38:
        addq    $8, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L41:
        movq    %r15, %r9
        movq    %r14, %r8
        movq    %rbx, %rcx
        movq    %r13, %rdx
        movq    %rbp, %rsi
        movq    %r12, %rdi
        call    loop_handler
        testl   %eax, %eax
        je      .L23
        jmp     .L38
