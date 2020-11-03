_Z24plus_reduce_array_serialPdmm:
        cmpq    %rdx, %rsi
        je      .L6
        leaq    -7(%rdx), %r8
        leaq    1(%rsi), %rax
        cmpq    %rax, %r8
        jbe     .L7
        cmpq    $6, %rdx
        jbe     .L7
        xorpd   %xmm0, %xmm0
        leaq    232(%rdi,%rsi,8), %rax
.L4:
        addsd   -232(%rax), %xmm0
        movq    %rsi, %rcx
        prefetcht0      (%rax)
        addq    $9, %rcx
        addq    $8, %rsi
        addq    $64, %rax
        addsd   -288(%rax), %xmm0
        addsd   -280(%rax), %xmm0
        addsd   -272(%rax), %xmm0
        addsd   -264(%rax), %xmm0
        addsd   -256(%rax), %xmm0
        addsd   -248(%rax), %xmm0
        addsd   -240(%rax), %xmm0
        cmpq    %rcx, %r8
        ja      .L4
.L3:
        leaq    (%rdi,%rsi,8), %rax
        leaq    (%rdi,%rdx,8), %rdx
.L5:
        addsd   (%rax), %xmm0
        addq    $8, %rax
        cmpq    %rax, %rdx
        jne     .L5
        rep ret
.L6:
        xorpd   %xmm0, %xmm0
        ret
.L7:
        xorpd   %xmm0, %xmm0
        jmp     .L3
_Z27plus_reduce_array_interruptPdmmdS_Pv:
        pushq   %r14
        pushq   %r13
        movq    %rcx, %r13
        pushq   %r12
        pushq   %rbp
        pushq   %rbx
        subq    $16, %rsp
        cmpq    %rdx, %rsi
        jnb     .L18
        leaq    64(%rsi), %rbx
        movq    %rdx, %r12
        movq    %rdi, %rbp
        movq    %r8, %r14
        cmpq    %r12, %rbx
        cmova   %r12, %rbx
        cmpq    %rbx, %rsi
        jnb     .L26
.L42:
        leaq    -7(%rbx), %rcx
        leaq    1(%rsi), %rax
        cmpq    %rax, %rcx
        jbe     .L23
        cmpq    $6, %rbx
        jbe     .L23
        leaq    232(%rbp,%rsi,8), %rax
.L22:
        addsd   -232(%rax), %xmm0
        movq    %rsi, %rdx
        prefetcht0      (%rax)
        addq    $9, %rdx
        addq    $8, %rsi
        addq    $64, %rax
        addsd   -288(%rax), %xmm0
        addsd   -280(%rax), %xmm0
        addsd   -272(%rax), %xmm0
        addsd   -264(%rax), %xmm0
        addsd   -256(%rax), %xmm0
        addsd   -248(%rax), %xmm0
        addsd   -240(%rax), %xmm0
        cmpq    %rdx, %rcx
        ja      .L22
        leaq    1(%rsi), %rax
        addsd   0(%rbp,%rsi,8), %xmm0
        cmpq    %rbx, %rax
        movq    %rax, %rsi
        jnb     .L20
.L40:
        incq    %rax
.L23:
        cmpq    %rbx, %rax
        addsd   0(%rbp,%rsi,8), %xmm0
        movq    %rax, %rsi
        jb      .L40
.L20:
        cmpq    %rbx, %r12
        jbe     .L18
.L43:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L41
.L24:
        movq    %rbx, %rsi
        leaq    64(%rsi), %rbx
        cmpq    %r12, %rbx
        cmova   %r12, %rbx
        cmpq    %rbx, %rsi
        jb      .L42
.L26:
        movq    %rsi, %rbx
        cmpq    %rbx, %r12
        ja      .L43
.L18:
        movsd   %xmm0, 0(%r13)
.L17:
        addq    $16, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        ret
.L41:
        movq    %r14, %r8
        movq    %r13, %rcx
        movq    %r12, %rdx
        movq    %rbx, %rsi
        movq    %rbp, %rdi
        movsd   %xmm0, 8(%rsp)
        call    _Z12loop_handlerPdmmdS_Pv
        testl   %eax, %eax
        movlpd  8(%rsp), %xmm0
        je      .L24
        jmp     .L17
