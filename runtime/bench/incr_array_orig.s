_Z17incr_array_serialPlmm:
        cmpq    %rdx, %rsi
        je      .L14
        leaq    -7(%rdx), %r8
        leaq    1(%rsi), %rax
        cmpq    %r8, %rax
        jnb     .L3
        cmpq    $6, %rdx
        jbe     .L3
        leaq    200(%rdi,%rsi,8), %rax
.L4:
        movq    %rsi, %rcx
        incq    -200(%rax)
        incq    -192(%rax)
        addq    $9, %rcx
        addq    $8, %rsi
        prefetcht0      (%rax)
        incq    -184(%rax)
        incq    -176(%rax)
        incq    -168(%rax)
        incq    -160(%rax)
        incq    -152(%rax)
        incq    -144(%rax)
        addq    $64, %rax
        cmpq    %rcx, %r8
        ja      .L4
.L3:
        leaq    (%rdi,%rsi,8), %rax
        leaq    (%rdi,%rdx,8), %rdx
.L5:
        incq    (%rax)
        addq    $8, %rax
        cmpq    %rax, %rdx
        jne     .L5
.L14:
        rep ret
_Z20incr_array_interruptPlmmPv:
        pushq   %r12
        pushq   %rbp
        pushq   %rbx
        subq    $16, %rsp
        cmpq    %rsi, %rdx
        movq    %rdx, 8(%rsp)
        jbe     .L35
        movq    %rdi, %rbp
        movq    %rdx, %r8
        movq    %rcx, %r12
.L18:
        leaq    128(%rsi), %rbx
        cmpq    %r8, %rbx
        cmova   %r8, %rbx
        cmpq    %rbx, %rsi
        je      .L19
        leaq    -7(%rbx), %rcx
        leaq    1(%rsi), %rax
        cmpq    %rax, %rcx
        jbe     .L20
        cmpq    $6, %rbx
        jbe     .L20
        leaq    200(%rbp,%rsi,8), %rax
.L21:
        movq    %rsi, %rdx
        incq    -200(%rax)
        incq    -192(%rax)
        addq    $9, %rdx
        addq    $8, %rsi
        prefetcht0      (%rax)
        incq    -184(%rax)
        incq    -176(%rax)
        incq    -168(%rax)
        incq    -160(%rax)
        incq    -152(%rax)
        incq    -144(%rax)
        addq    $64, %rax
        cmpq    %rdx, %rcx
        ja      .L21
.L20:
        leaq    0(%rbp,%rsi,8), %rax
        leaq    0(%rbp,%rbx,8), %rdx
.L22:
        incq    (%rax)
        addq    $8, %rax
        cmpq    %rax, %rdx
        jne     .L22
.L19:
        cmpq    %r8, %rbx
        jnb     .L35
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L37
.L23:
        movq    %rbx, %rsi
        jmp     .L18
.L35:
        addq    $16, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        ret
.L37:
        leaq    8(%rsp), %rdx
        movq    %r12, %rcx
        movq    %rbx, %rsi
        movq    %rbp, %rdi
        call    _Z18incr_array_handlerPlmRmPv
        movq    8(%rsp), %r8
        jmp     .L23
