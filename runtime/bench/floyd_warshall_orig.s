_Z21floyd_warshall_serialPii:
        testl   %esi, %esi
        jle     .L19
        pushq   %r12
        movq    %rdi, %r9
        movl    %esi, %r8d
        xorl    %edi, %edi
        pushq   %rbp
        xorl    %ebp, %ebp
        pushq   %rbx
.L7:
        xorl    %r11d, %r11d
        xorl    %esi, %esi
.L5:
        leal    (%rdi,%r11), %eax
        cmpl    %edi, %esi
        setne   %r10b
        cltq
        leaq    (%r9,%rax,4), %rbx
        xorl    %eax, %eax
        jmp     .L4
.L8:
        movl    %edx, %eax
.L4:
        cmpl    %eax, %esi
        setne   %cl
        cmpl    %eax, %edi
        setne   %dl
        testb   %dl, %cl
        je      .L3
        testb   %r10b, %r10b
        je      .L3
        leal    (%r11,%rax), %edx
        leal    0(%rbp,%rax), %ecx
        movslq  %edx, %rdx
        movslq  %ecx, %rcx
        leaq    (%r9,%rdx,4), %r12
        movl    (%rbx), %edx
        addl    (%r9,%rcx,4), %edx
        movl    (%r12), %ecx
        cmpl    %ecx, %edx
        cmovg   %ecx, %edx
        movl    %edx, (%r12)
.L3:
        leal    1(%rax), %edx
        cmpl    %edx, %r8d
        jne     .L8
        addl    %r8d, %r11d
        cmpl    %eax, %esi
        leal    1(%rsi), %edx
        je      .L23
        movl    %edx, %esi
        jmp     .L5
.L23:
        addl    %r8d, %ebp
        cmpl    %esi, %edi
        leal    1(%rdi), %eax
        je      .L17
        movl    %eax, %edi
        jmp     .L7
.L17:
        popq    %rbx
        popq    %rbp
        popq    %r12
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
        movl    %edx, %r15d
        movq    %rdi, %r14
        setge   %al
        movl    %esi, %r9d
        movl    %edx, %r12d
        imull   %esi, %r15d
        testb   %al, %al
        jne     .L58
.L39:
        xorl    %ebp, %ebp
.L27:
        leal    64(%rbp), %eax
        cmpl    %r9d, %eax
        cmovg   %r9d, %eax
        cmpl    %eax, %ebp
        movl    %eax, 48(%rsp)
        jge     .L40
        movl    %ebp, %r13d
        imull   %r9d, %r13d
.L36:
        leal    (%r12,%r13), %eax
        cltq
        leaq    (%r14,%rax,4), %r10
        xorl    %eax, %eax
.L29:
        leal    128(%rax), %ebx
        cmpl    %r9d, %ebx
        cmovg   %r9d, %ebx
        cmpl    %ebx, %eax
        jge     .L41
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
        leal    0(%r13,%rax), %edx
        leal    (%r15,%rax), %ecx
        movslq  %edx, %rdx
        movslq  %ecx, %rcx
        leaq    (%r14,%rdx,4), %rdi
        movl    (%r10), %edx
        addl    (%r14,%rcx,4), %edx
        movl    (%rdi), %ecx
        cmpl    %ecx, %edx
        cmovg   %ecx, %edx
        movl    %edx, (%rdi)
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
        movq    %r14, %rdi
        movq    %r10, 40(%rsp)
        movq    %rax, 16(%rsp)
        movl    %r9d, 36(%rsp)
        call    _Z15to_loop_handlerPiiiiiiiiPv
        testl   %eax, %eax
        movl    36(%rsp), %r9d
        movq    40(%rsp), %r10
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
.L41:
        movl    %eax, %ebx
        cmpl    %ebx, %r9d
        jg      .L61
.L33:
        incl    %ebp
        addl    %r9d, %r13d
        cmpl    %ebp, 48(%rsp)
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
.L40:
        movl    %ebp, 48(%rsp)
        cmpl    48(%rsp), %r9d
        jg      .L63
.L37:
        incl    %r12d
        addl    %r9d, %r15d
        cmpl    %r12d, 52(%rsp)
        jg      .L39
        jmp     .L58
.L62:
        movq    56(%rsp), %rax
        movl    48(%rsp), %r8d
        movl    %r9d, %esi
        movl    52(%rsp), %ecx
        movl    %r12d, %edx
        movq    %r14, %rdi
        movl    %r9d, 36(%rsp)
        movq    %rax, (%rsp)
        call    _Z17from_loop_handlerPiiiiiiPv
        testl   %eax, %eax
        movl    36(%rsp), %r9d
        je      .L38
        jmp     .L58
_Z29floyd_warshall_interrupt_fromPiiiiiiPv:
        pushq   %r15
        pushq   %r14
        pushq   %r13
        pushq   %r12
        pushq   %rbp
        pushq   %rbx
        subq    $72, %rsp
        cmpl    %r9d, %r8d
        movl    %ecx, 60(%rsp)
        jge     .L93
        movl    %esi, %r15d
        movq    %rdi, %r13
        movl    %edx, %r12d
        imull   %edx, %r15d
        movl    %r8d, %ebp
        movl    %r15d, %r10d
.L66:
        leal    64(%rbp), %eax
        cmpl    %r9d, %eax
        cmovg   %r9d, %eax
        cmpl    %eax, %ebp
        movl    %eax, 56(%rsp)
        jge     .L77
        testl   %esi, %esi
        jle     .L93
        movl    %ebp, %r14d
        imull   %esi, %r14d
.L75:
        leal    (%r12,%r14), %eax
        cltq
        leaq    0(%r13,%rax,4), %r15
        xorl    %eax, %eax
        leal    128(%rax), %ebx
        cmpl    %esi, %ebx
        cmovg   %esi, %ebx
        cmpl    %ebx, %eax
        jge     .L78
.L96:
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
.L97:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L95
.L74:
        movl    %ebx, %eax
        leal    128(%rax), %ebx
        cmpl    %esi, %ebx
        cmovg   %esi, %ebx
        cmpl    %ebx, %eax
        jl      .L96
.L78:
        movl    %eax, %ebx
        cmpl    %esi, %ebx
        jl      .L97
.L73:
        incl    %ebp
        addl    %esi, %r14d
        cmpl    %ebp, 56(%rsp)
        jne     .L75
.L67:
        cmpl    %r9d, 56(%rsp)
        jge     .L93
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L98
.L76:
        movl    56(%rsp), %ebp
        jmp     .L66
.L95:
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
.L93:
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
.L98:
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
        jmp     .L93
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
        movl    %ecx, 32(%rsp)
        cmpl    %r14d, %eax
        jge     .L118
        movl    %r8d, %r15d
        movl    %edx, %ebp
        movl    %esi, %r10d
        imull   %esi, %r15d
        movq    %rdi, %r13
        movl    %r8d, %r12d
        imull   %ebp, %r10d
        leal    (%r15,%rdx), %edx
        movslq  %edx, %rdx
        leaq    (%rdi,%rdx,4), %r11
        movq    %r11, %r14
        movl    120(%rsp), %r11d
.L101:
        leal    128(%rax), %ebx
        cmpl    %r11d, %ebx
        cmovg   %r11d, %ebx
        cmpl    %ebx, %eax
        jge     .L107
        cmpl    %ebp, %r12d
        setne   %dil
.L104:
        cmpl    %r12d, %eax
        setne   %cl
        cmpl    %ebp, %eax
        setne   %dl
        testb   %dl, %cl
        je      .L103
        testb   %dil, %dil
        je      .L103
        leal    (%r15,%rax), %edx
        leal    (%r10,%rax), %r8d
        movslq  %edx, %rdx
        movslq  %r8d, %r8
        leaq    0(%r13,%rdx,4), %rcx
        movl    (%r14), %edx
        addl    0(%r13,%r8,4), %edx
        movl    (%rcx), %r8d
        cmpl    %r8d, %edx
        cmovg   %r8d, %edx
        movl    %edx, (%rcx)
.L103:
        incl    %eax
        cmpl    %eax, %ebx
        jne     .L104
.L102:
        cmpl    %ebx, %r11d
        jle     .L118
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L120
.L106:
        movl    %ebx, %eax
        jmp     .L101
.L120:
        movq    128(%rsp), %rax
        movl    32(%rsp), %ecx
        movl    %r12d, %r8d
        movl    %r11d, 8(%rsp)
        movl    %ebx, (%rsp)
        movl    %ebp, %edx
        movq    %r13, %rdi
        movl    %r10d, 44(%rsp)
        movl    %r11d, 120(%rsp)
        movq    %rax, 16(%rsp)
        movl    %r9d, 40(%rsp)
        movl    %esi, 36(%rsp)
        call    _Z18to_to_loop_handlerPiiiiiiiiPv
        testl   %eax, %eax
        movl    36(%rsp), %esi
        movl    40(%rsp), %r9d
        movl    120(%rsp), %r11d
        movl    44(%rsp), %r10d
        je      .L106
.L118:
        addq    $56, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L107:
        movl    %eax, %ebx
        jmp     .L102
