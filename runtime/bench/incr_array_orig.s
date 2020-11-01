_Z17incr_array_serialPdmm:
        cmpq    %rdx, %rsi
        je      .L1
        leaq    -7(%rdx), %r8
        leaq    1(%rsi), %rax
        cmpq    %r8, %rax
        jnb     .L14
        cmpq    $6, %rdx
        jbe     .L14
        leaq    200(%rdi,%rsi,8), %rax
        movlpd  .LC0(%rip), %xmm1
.L4:
        movlpd  -200(%rax), %xmm0
        movq    %rsi, %rcx
        prefetcht0      (%rax)
        addq    $9, %rcx
        addq    $8, %rsi
        addq    $64, %rax
        addsd   %xmm1, %xmm0
        movsd   %xmm0, -264(%rax)
        movlpd  -256(%rax), %xmm0
        addsd   %xmm1, %xmm0
        movsd   %xmm0, -256(%rax)
        movlpd  -248(%rax), %xmm0
        addsd   %xmm1, %xmm0
        movsd   %xmm0, -248(%rax)
        movlpd  -240(%rax), %xmm0
        addsd   %xmm1, %xmm0
        movsd   %xmm0, -240(%rax)
        movlpd  -232(%rax), %xmm0
        addsd   %xmm1, %xmm0
        movsd   %xmm0, -232(%rax)
        movlpd  -224(%rax), %xmm0
        addsd   %xmm1, %xmm0
        movsd   %xmm0, -224(%rax)
        movlpd  -216(%rax), %xmm0
        addsd   %xmm1, %xmm0
        movsd   %xmm0, -216(%rax)
        movlpd  -208(%rax), %xmm0
        addsd   %xmm1, %xmm0
        movsd   %xmm0, -208(%rax)
        cmpq    %rcx, %r8
        ja      .L4
.L3:
        leaq    (%rdi,%rsi,8), %rax
        leaq    (%rdi,%rdx,8), %rdx
.L5:
        movlpd  (%rax), %xmm0
        addq    $8, %rax
        addsd   %xmm1, %xmm0
        movsd   %xmm0, -8(%rax)
        cmpq    %rax, %rdx
        jne     .L5
.L1:
        rep ret
.L14:
        movlpd  .LC0(%rip), %xmm1
        jmp     .L3
_Z20incr_array_interruptPdmmPv:
        pushq   %r12
        pushq   %rbp
        pushq   %rbx
        subq    $16, %rsp
        cmpq    %rsi, %rdx
        movq    %rdx, 8(%rsp)
        jbe     .L16
        movlpd  .LC0(%rip), %xmm2
        movq    %rcx, %r12
        movq    %rdi, %rbp
        movq    %rdx, %rcx
.L18:
        leaq    64(%rsi), %rbx
        cmpq    %rcx, %rbx
        cmova   %rcx, %rbx
        cmpq    %rbx, %rsi
        je      .L23
        leaq    -7(%rbx), %rdi
        leaq    1(%rsi), %rax
        cmpq    %rax, %rdi
        jbe     .L38
        cmpq    $6, %rbx
        jbe     .L38
        leaq    200(%rbp,%rsi,8), %rax
        movsd   %xmm2, %xmm1
.L22:
        movlpd  -200(%rax), %xmm0
        movq    %rsi, %rdx
        prefetcht0      (%rax)
        addq    $9, %rdx
        addq    $8, %rsi
        addq    $64, %rax
        addsd   %xmm2, %xmm0
        movsd   %xmm0, -264(%rax)
        movlpd  -256(%rax), %xmm0
        addsd   %xmm2, %xmm0
        movsd   %xmm0, -256(%rax)
        movlpd  -248(%rax), %xmm0
        addsd   %xmm2, %xmm0
        movsd   %xmm0, -248(%rax)
        movlpd  -240(%rax), %xmm0
        addsd   %xmm2, %xmm0
        movsd   %xmm0, -240(%rax)
        movlpd  -232(%rax), %xmm0
        addsd   %xmm2, %xmm0
        movsd   %xmm0, -232(%rax)
        movlpd  -224(%rax), %xmm0
        addsd   %xmm2, %xmm0
        movsd   %xmm0, -224(%rax)
        movlpd  -216(%rax), %xmm0
        addsd   %xmm2, %xmm0
        movsd   %xmm0, -216(%rax)
        movlpd  -208(%rax), %xmm0
        addsd   %xmm2, %xmm0
        movsd   %xmm0, -208(%rax)
        cmpq    %rdx, %rdi
        ja      .L22
.L21:
        leaq    0(%rbp,%rsi,8), %rax
        leaq    0(%rbp,%rbx,8), %rdx
.L24:
        movlpd  (%rax), %xmm0
        addq    $8, %rax
        addsd   %xmm1, %xmm0
        movsd   %xmm0, -8(%rax)
        cmpq    %rax, %rdx
        jne     .L24
.L23:
        cmpq    %rcx, %rbx
        jnb     .L16
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L39
.L25:
        movq    %rbx, %rsi
        jmp     .L18
.L16:
        addq    $16, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        ret
.L38:
        movlpd  .LC0(%rip), %xmm1
        jmp     .L21
.L39:
        leaq    8(%rsp), %rdx
        movq    %r12, %rcx
        movq    %rbx, %rsi
        movq    %rbp, %rdi
        call    _Z18incr_array_handlerPdmRmPv
        movq    8(%rsp), %rcx
        movlpd  .LC0(%rip), %xmm2
        jmp     .L25
.LC0:
        .long   0
        .long   1072693248
