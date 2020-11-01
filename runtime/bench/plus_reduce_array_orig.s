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
_Z27plus_reduce_array_interruptPdmmmS_Pv:
        pushq   %r15
        pushq   %r14
        movq    %r8, %r14
        pushq   %r13
        pushq   %r12
        pushq   %rbp
        pushq   %rbx
        subq    $24, %rsp
        cmpq    %rdx, %rsi
        jnb     .L18
        movq    %rdi, %rbp
        movq    %rdx, %r13
        movq    %r9, %r15
        movabsq $-9223372036854775808, %r12
.L19:
        leaq    128(%rsi), %rbx
        cmpq    %r13, %rbx
        cmova   %r13, %rbx
        cmpq    %rbx, %rsi
        jnb     .L64
        leaq    -7(%rbx), %rdi
        leaq    1(%rsi), %rdx
        cmpq    %rdx, %rdi
        jbe     .L77
        cmpq    $6, %rbx
        jbe     .L77
        leaq    184(%rbp,%rsi,8), %rdx
        movlpd  .LC1(%rip), %xmm1
        jmp     .L54
.L79:
        cvttsd2siq      %xmm0, %rax
        testq   %rax, %rax
        js      .L26
.L80:
        cvtsi2sdq       %rax, %xmm0
        addsd   -176(%rdx), %xmm0
        comisd  %xmm1, %xmm0
        jnb     .L28
.L81:
        cvttsd2siq      %xmm0, %rax
        testq   %rax, %rax
        js      .L30
.L82:
        cvtsi2sdq       %rax, %xmm0
        addsd   -168(%rdx), %xmm0
        comisd  %xmm1, %xmm0
        jnb     .L32
.L83:
        cvttsd2siq      %xmm0, %rax
        testq   %rax, %rax
        js      .L34
.L84:
        cvtsi2sdq       %rax, %xmm0
        addsd   -160(%rdx), %xmm0
        comisd  %xmm1, %xmm0
        jnb     .L36
.L85:
        cvttsd2siq      %xmm0, %rax
        testq   %rax, %rax
        js      .L38
.L86:
        cvtsi2sdq       %rax, %xmm0
        addsd   -152(%rdx), %xmm0
        comisd  %xmm1, %xmm0
        jnb     .L40
.L87:
        cvttsd2siq      %xmm0, %rax
        testq   %rax, %rax
        js      .L42
.L88:
        cvtsi2sdq       %rax, %xmm0
        addsd   -144(%rdx), %xmm0
        comisd  %xmm1, %xmm0
        jnb     .L44
.L89:
        cvttsd2siq      %xmm0, %rax
        testq   %rax, %rax
        js      .L46
.L90:
        cvtsi2sdq       %rax, %xmm0
        addsd   -136(%rdx), %xmm0
        comisd  %xmm1, %xmm0
        jnb     .L48
.L91:
        cvttsd2siq      %xmm0, %rax
        testq   %rax, %rax
        js      .L50
.L92:
        cvtsi2sdq       %rax, %xmm0
        addsd   -128(%rdx), %xmm0
        comisd  %xmm1, %xmm0
        jnb     .L52
.L93:
        cvttsd2siq      %xmm0, %rcx
.L53:
        movq    %rsi, %rax
        addq    $64, %rdx
        addq    $8, %rsi
        addq    $9, %rax
        cmpq    %rax, %rdi
        jbe     .L78
.L54:
        testq   %rcx, %rcx
        prefetcht0      (%rdx)
        js      .L22
        cvtsi2sdq       %rcx, %xmm0
.L23:
        addsd   -184(%rdx), %xmm0
        comisd  %xmm1, %xmm0
        jb      .L79
        subsd   %xmm1, %xmm0
        cvttsd2siq      %xmm0, %rax
        xorq    %r12, %rax
        testq   %rax, %rax
        jns     .L80
.L26:
        movq    %rax, %rcx
        andl    $1, %eax
        shrq    %rcx
        orq     %rax, %rcx
        cvtsi2sdq       %rcx, %xmm0
        addsd   %xmm0, %xmm0
        addsd   -176(%rdx), %xmm0
        comisd  %xmm1, %xmm0
        jb      .L81
.L28:
        subsd   %xmm1, %xmm0
        cvttsd2siq      %xmm0, %rax
        xorq    %r12, %rax
        testq   %rax, %rax
        jns     .L82
.L30:
        movq    %rax, %rcx
        andl    $1, %eax
        shrq    %rcx
        orq     %rax, %rcx
        cvtsi2sdq       %rcx, %xmm0
        addsd   %xmm0, %xmm0
        addsd   -168(%rdx), %xmm0
        comisd  %xmm1, %xmm0
        jb      .L83
.L32:
        subsd   %xmm1, %xmm0
        cvttsd2siq      %xmm0, %rax
        xorq    %r12, %rax
        testq   %rax, %rax
        jns     .L84
.L34:
        movq    %rax, %rcx
        andl    $1, %eax
        shrq    %rcx
        orq     %rax, %rcx
        cvtsi2sdq       %rcx, %xmm0
        addsd   %xmm0, %xmm0
        addsd   -160(%rdx), %xmm0
        comisd  %xmm1, %xmm0
        jb      .L85
.L36:
        subsd   %xmm1, %xmm0
        cvttsd2siq      %xmm0, %rax
        xorq    %r12, %rax
        testq   %rax, %rax
        jns     .L86
.L38:
        movq    %rax, %rcx
        andl    $1, %eax
        shrq    %rcx
        orq     %rax, %rcx
        cvtsi2sdq       %rcx, %xmm0
        addsd   %xmm0, %xmm0
        addsd   -152(%rdx), %xmm0
        comisd  %xmm1, %xmm0
        jb      .L87
.L40:
        subsd   %xmm1, %xmm0
        cvttsd2siq      %xmm0, %rax
        xorq    %r12, %rax
        testq   %rax, %rax
        jns     .L88
.L42:
        movq    %rax, %rcx
        andl    $1, %eax
        shrq    %rcx
        orq     %rax, %rcx
        cvtsi2sdq       %rcx, %xmm0
        addsd   %xmm0, %xmm0
        addsd   -144(%rdx), %xmm0
        comisd  %xmm1, %xmm0
        jb      .L89
.L44:
        subsd   %xmm1, %xmm0
        cvttsd2siq      %xmm0, %rax
        xorq    %r12, %rax
        testq   %rax, %rax
        jns     .L90
.L46:
        movq    %rax, %rcx
        andl    $1, %eax
        shrq    %rcx
        orq     %rax, %rcx
        cvtsi2sdq       %rcx, %xmm0
        addsd   %xmm0, %xmm0
        addsd   -136(%rdx), %xmm0
        comisd  %xmm1, %xmm0
        jb      .L91
.L48:
        subsd   %xmm1, %xmm0
        cvttsd2siq      %xmm0, %rax
        xorq    %r12, %rax
        testq   %rax, %rax
        jns     .L92
.L50:
        movq    %rax, %rcx
        andl    $1, %eax
        shrq    %rcx
        orq     %rax, %rcx
        cvtsi2sdq       %rcx, %xmm0
        addsd   %xmm0, %xmm0
        addsd   -128(%rdx), %xmm0
        comisd  %xmm1, %xmm0
        jb      .L93
.L52:
        subsd   %xmm1, %xmm0
        cvttsd2siq      %xmm0, %rcx
        xorq    %r12, %rcx
        jmp     .L53
.L22:
        movq    %rcx, %rax
        andl    $1, %ecx
        shrq    %rax
        orq     %rcx, %rax
        cvtsi2sdq       %rax, %xmm0
        addsd   %xmm0, %xmm0
        jmp     .L23
.L78:
        leaq    1(%rsi), %rdx
        jmp     .L59
.L94:
        cmpq    %rbx, %rdx
        cvttsd2siq      %xmm0, %rcx
        movq    %rdx, %rsi
        jnb     .L20
.L95:
        incq    %rdx
.L59:
        testq   %rcx, %rcx
        js      .L55
        cvtsi2sdq       %rcx, %xmm0
.L56:
        addsd   0(%rbp,%rsi,8), %xmm0
        comisd  %xmm1, %xmm0
        jb      .L94
        subsd   %xmm1, %xmm0
        movq    %rdx, %rsi
        cvttsd2siq      %xmm0, %rcx
        xorq    %r12, %rcx
        cmpq    %rbx, %rdx
        jb      .L95
.L20:
        cmpq    %rbx, %r13
        jbe     .L18
.L97:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L96
.L60:
        movq    %rbx, %rsi
        jmp     .L19
.L55:
        movq    %rcx, %rax
        andl    $1, %ecx
        shrq    %rax
        orq     %rcx, %rax
        cvtsi2sdq       %rax, %xmm0
        addsd   %xmm0, %xmm0
        jmp     .L56
.L64:
        movq    %rsi, %rbx
        cmpq    %rbx, %r13
        ja      .L97
.L18:
        testq   %rcx, %rcx
        js      .L62
        cvtsi2sdq       %rcx, %xmm0
.L63:
        movsd   %xmm0, (%r14)
.L17:
        addq    $24, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L96:
        movq    %r15, %r9
        movq    %r14, %r8
        movq    %r13, %rdx
        movq    %rbx, %rsi
        movq    %rbp, %rdi
        movq    %rcx, 8(%rsp)
        call    _Z12loop_handlerPdmmmS_Pv
        testl   %eax, %eax
        movq    8(%rsp), %rcx
        je      .L60
        jmp     .L17
.L77:
        movlpd  .LC1(%rip), %xmm1
        jmp     .L59
.L62:
        movq    %rcx, %rax
        andl    $1, %ecx
        shrq    %rax
        orq     %rcx, %rax
        cvtsi2sdq       %rax, %xmm0
        addsd   %xmm0, %xmm0
        jmp     .L63
.LC1:
        .long   0
        .long   1138753536
