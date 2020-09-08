_Z21floyd_warshall_serialPii:
        testl   %esi, %esi
        movq    %rdi, %r8
        movl    %esi, %edi
        jle     .L19
        pushq   %r13
        xorl    %esi, %esi
        pushq   %r12
        pushq   %rbp
        pushq   %rbx
.L2:
        movl    %esi, %ebx
        movl    %esi, %ebp
        xorl    %ecx, %ecx
        sall    $13, %ebx
.L5:
        movl    %ecx, %r11d
        movslq  %ebp, %rax
        sall    $13, %r11d
        cmpl    %ecx, %esi
        leaq    (%r8,%rax,4), %r10
        setne   %r9b
        xorl    %eax, %eax
        jmp     .L4
.L8:
        movl    %edx, %eax
.L4:
        cmpl    %ecx, %eax
        setne   %r12b
        cmpl    %esi, %eax
        setne   %dl
        testb   %dl, %r12b
        je      .L3
        testb   %r9b, %r9b
        je      .L3
        leal    (%r11,%rax), %edx
        leal    (%rbx,%rax), %r12d
        movslq  %edx, %rdx
        movslq  %r12d, %r12
        leaq    (%r8,%rdx,4), %r13
        movl    (%r10), %edx
        addl    (%r8,%r12,4), %edx
        movl    0(%r13), %r12d
        cmpl    %r12d, %edx
        cmovg   %r12d, %edx
        movl    %edx, 0(%r13)
.L3:
        leal    1(%rax), %edx
        cmpl    %edx, %edi
        jne     .L8
        addl    $8192, %ebp
        cmpl    %ecx, %eax
        leal    1(%rcx), %edx
        je      .L23
        movl    %edx, %ecx
        jmp     .L5
.L23:
        cmpl    %esi, %eax
        leal    1(%rsi), %edx
        je      .L17
        movl    %edx, %esi
        jmp     .L2
.L17:
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        ret
.L19:
        rep ret
_Z24floyd_warshall_interruptPiiiiPv:
        pushq   %r15
        pushq   %r14
        pushq   %r13
        pushq   %r12
        pushq   %rbp
        pushq   %rbx
        subq    $72, %rsp
        testl   %esi, %esi
        movl    %ecx, 52(%rsp)
        movq    %r8, 56(%rsp)
        jle     .L58
        cmpl    %ecx, %edx
        movq    %rdi, %r15
        movl    %esi, %r9d
        movl    %edx, %r12d
        jge     .L58
.L25:
        movl    %r12d, %r14d
        movq    %r15, %rax
        xorl    %ebp, %ebp
        sall    $13, %r14d
        movl    %r14d, %r15d
        movq    %rax, %r14
.L27:
        leal    512(%rbp), %eax
        cmpl    %r9d, %eax
        cmovg   %r9d, %eax
        cmpl    %eax, %ebp
        movl    %eax, 48(%rsp)
        jge     .L39
.L36:
        movl    %ebp, %r13d
        movq    %r14, %rdi
        sall    $13, %r13d
        leal    (%r12,%r13), %eax
        cltq
        leaq    (%r14,%rax,4), %r10
        movl    %r13d, %r14d
        xorl    %eax, %eax
        movq    %r10, %r13
.L29:
        leal    1024(%rax), %ebx
        cmpl    %r9d, %ebx
        cmovg   %r9d, %ebx
        cmpl    %ebx, %eax
        jge     .L40
        cmpl    %r12d, %ebp
        setne   %sil
.L32:
        cmpl    %eax, %ebp
        setne   %cl
        cmpl    %r12d, %eax
        setne   %dl
        testb   %dl, %cl
        je      .L31
        testb   %sil, %sil
        je      .L31
        leal    (%r14,%rax), %edx
        leal    (%r15,%rax), %ecx
        movslq  %edx, %rdx
        movslq  %ecx, %rcx
        leaq    (%rdi,%rdx,4), %r8
        movl    0(%r13), %edx
        addl    (%rdi,%rcx,4), %edx
        movl    (%r8), %ecx
        cmpl    %ecx, %edx
        cmovg   %ecx, %edx
        movl    %edx, (%r8)
.L31:
        incl    %eax
        cmpl    %eax, %ebx
        jne     .L32
        cmpl    %ebx, %r9d
        jle     .L33
.L61:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L60
.L34:
        movl    %ebx, %eax
        jmp     .L29
.L60:
        movq    56(%rsp), %rax
        movl    52(%rsp), %ecx
        movl    %r9d, %esi
        movl    %r9d, 8(%rsp)
        movl    %ebx, (%rsp)
        movl    %ebp, %r8d
        movl    %r12d, %edx
        movl    %r9d, 44(%rsp)
        movq    %rdi, 32(%rsp)
        movq    %rax, 16(%rsp)
        call    _Z15to_loop_handlerPiiiiiiiiPv
        testl   %eax, %eax
        movq    32(%rsp), %rdi
        movl    44(%rsp), %r9d
        je      .L34
.L58:
        addq    $72, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L40:
        movl    %eax, %ebx
        cmpl    %ebx, %r9d
        jg      .L61
.L33:
        incl    %ebp
        cmpl    %ebp, 48(%rsp)
        movq    %rdi, %r14
        jne     .L36
        cmpl    48(%rsp), %r9d
        jle     .L37
.L63:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L62
.L38:
        movl    48(%rsp), %ebp
        jmp     .L27
.L39:
        movl    %ebp, 48(%rsp)
        cmpl    48(%rsp), %r9d
        jg      .L63
.L37:
        incl    %r12d
        cmpl    %r12d, 52(%rsp)
        movq    %r14, %r15
        jg      .L25
        jmp     .L58
.L62:
        movq    56(%rsp), %rax
        movl    48(%rsp), %r8d
        movl    %r9d, %esi
        movl    52(%rsp), %ecx
        movl    %r12d, %edx
        movq    %r14, %rdi
        movl    %r9d, 32(%rsp)
        movq    %rax, (%rsp)
        call    _Z17from_loop_handlerPiiiiiiPv
        testl   %eax, %eax
        movl    32(%rsp), %r9d
        je      .L38
        jmp     .L58
_Z29floyd_warshall_interrupt_fromPiiiiiiPv:
        pushq   %r15
        movl    %edx, %r15d
        sall    $13, %r15d
        pushq   %r14
        pushq   %r13
        pushq   %r12
        pushq   %rbp
        pushq   %rbx
        subq    $72, %rsp
        cmpl    %r9d, %r8d
        movl    %ecx, 60(%rsp)
        jge     .L95
        movq    %rdi, %r13
        movl    %edx, %r12d
        movl    %r8d, %ebp
        movl    %r15d, %r10d
.L66:
        leal    512(%rbp), %eax
        cmpl    %r9d, %eax
        cmovg   %r9d, %eax
        cmpl    %eax, %ebp
        movl    %eax, 56(%rsp)
        jge     .L77
        testl   %esi, %esi
        jle     .L95
.L75:
        movl    %ebp, %r14d
        sall    $13, %r14d
        leal    (%r12,%r14), %eax
        cltq
        leaq    0(%r13,%rax,4), %r15
        xorl    %eax, %eax
        leal    1024(%rax), %ebx
        cmpl    %esi, %ebx
        cmovg   %esi, %ebx
        cmpl    %ebx, %eax
        jge     .L78
.L98:
        cmpl    %r12d, %ebp
        setne   %cl
.L72:
        cmpl    %eax, %ebp
        setne   %dil
        cmpl    %r12d, %eax
        setne   %dl
        testb   %dl, %dil
        je      .L71
        testb   %cl, %cl
        je      .L71
        leal    (%r14,%rax), %edx
        leal    (%r10,%rax), %r8d
        movslq  %edx, %rdx
        movslq  %r8d, %r8
        leaq    0(%r13,%rdx,4), %rdi
        movl    (%r15), %edx
        addl    0(%r13,%r8,4), %edx
        movl    (%rdi), %r8d
        cmpl    %r8d, %edx
        cmovg   %r8d, %edx
        movl    %edx, (%rdi)
.L71:
        incl    %eax
        cmpl    %eax, %ebx
        jne     .L72
        cmpl    %esi, %ebx
        jge     .L73
.L99:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L97
.L74:
        movl    %ebx, %eax
        leal    1024(%rax), %ebx
        cmpl    %esi, %ebx
        cmovg   %esi, %ebx
        cmpl    %ebx, %eax
        jl      .L98
.L78:
        movl    %eax, %ebx
        cmpl    %esi, %ebx
        jl      .L99
.L73:
        incl    %ebp
        cmpl    %ebp, 56(%rsp)
        jne     .L75
.L67:
        cmpl    %r9d, 56(%rsp)
        jge     .L95
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L100
.L76:
        movl    56(%rsp), %ebp
        jmp     .L66
.L97:
        movq    128(%rsp), %rax
        movl    60(%rsp), %ecx
        movl    %ebp, %r8d
        movl    %esi, 8(%rsp)
        movl    %ebx, (%rsp)
        movl    %r12d, %edx
        movq    %r13, %rdi
        movl    %r10d, 52(%rsp)
        movl    %r9d, 48(%rsp)
        movq    %rax, 16(%rsp)
        movl    %esi, 44(%rsp)
        call    _Z20from_to_loop_handlerPiiiiiiiiPv
        testl   %eax, %eax
        movl    44(%rsp), %esi
        movl    48(%rsp), %r9d
        movl    52(%rsp), %r10d
        je      .L74
.L95:
        addq    $72, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L77:
        movl    %ebp, 56(%rsp)
        jmp     .L67
.L100:
        movq    128(%rsp), %rax
        movl    56(%rsp), %r8d
        movl    %r12d, %edx
        movl    60(%rsp), %ecx
        movq    %r13, %rdi
        movl    %r10d, 52(%rsp)
        movl    %r9d, 48(%rsp)
        movl    %esi, 44(%rsp)
        movq    %rax, (%rsp)
        call    _Z22from_from_loop_handlerPiiiiiiPv
        testl   %eax, %eax
        movl    44(%rsp), %esi
        movl    48(%rsp), %r9d
        movl    52(%rsp), %r10d
        je      .L76
        jmp     .L95
_Z27floyd_warshall_interrupt_toPiiiiiiiiPv:
        pushq   %r15
        pushq   %r14
        pushq   %r13
        pushq   %r12
        pushq   %rbp
        pushq   %rbx
        subq    $56, %rsp
        movl    112(%rsp), %eax
        movl    120(%rsp), %r14d
        movl    %esi, 32(%rsp)
        cmpl    %r14d, %eax
        jge     .L120
        movl    %r8d, %r15d
        movl    %edx, %ebp
        movq    %rdi, %r13
        sall    $13, %r15d
        movl    %ebp, %r10d
        movl    %r8d, %r12d
        leal    (%rdx,%r15), %edx
        sall    $13, %r10d
        movslq  %edx, %rdx
        leaq    (%rdi,%rdx,4), %r11
        movq    %r11, %r14
        movl    120(%rsp), %r11d
.L103:
        leal    1024(%rax), %ebx
        cmpl    %r11d, %ebx
        cmovg   %r11d, %ebx
        cmpl    %ebx, %eax
        jge     .L109
        cmpl    %ebp, %r12d
        setne   %dil
.L106:
        cmpl    %r12d, %eax
        setne   %sil
        cmpl    %ebp, %eax
        setne   %dl
        testb   %dl, %sil
        je      .L105
        testb   %dil, %dil
        je      .L105
        leal    (%r15,%rax), %edx
        leal    (%r10,%rax), %r8d
        movslq  %edx, %rdx
        movslq  %r8d, %r8
        leaq    0(%r13,%rdx,4), %rsi
        movl    (%r14), %edx
        addl    0(%r13,%r8,4), %edx
        movl    (%rsi), %r8d
        cmpl    %r8d, %edx
        cmovg   %r8d, %edx
        movl    %edx, (%rsi)
.L105:
        incl    %eax
        cmpl    %eax, %ebx
        jne     .L106
.L104:
        cmpl    %ebx, %r11d
        jle     .L120
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L122
.L108:
        movl    %ebx, %eax
        jmp     .L103
.L122:
        movq    128(%rsp), %rax
        movl    32(%rsp), %esi
        movl    %r12d, %r8d
        movl    %r11d, 8(%rsp)
        movl    %ebx, (%rsp)
        movl    %ebp, %edx
        movq    %r13, %rdi
        movl    %r10d, 44(%rsp)
        movl    %r11d, 120(%rsp)
        movq    %rax, 16(%rsp)
        movl    %r9d, 40(%rsp)
        movl    %ecx, 36(%rsp)
        call    _Z18to_to_loop_handlerPiiiiiiiiPv
        testl   %eax, %eax
        movl    36(%rsp), %ecx
        movl    40(%rsp), %r9d
        movl    120(%rsp), %r11d
        movl    44(%rsp), %r10d
        je      .L108
.L120:
        addq    $56, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L109:
        movl    %eax, %ebx
        jmp     .L104
