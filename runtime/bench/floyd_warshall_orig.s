_Z21floyd_warshall_serialPii:
        testl   %esi, %esi
        jle     .L18
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
        je      .L22
        movl    %edx, %esi
        jmp     .L5
.L22:
        addl    %r8d, %ebp
        cmpl    %esi, %edi
        leal    1(%rdi), %eax
        je      .L1
        movl    %eax, %edi
        jmp     .L7
.L1:
        popq    %rbx
        popq    %rbp
        popq    %r12
        ret
.L18:
        rep ret
_Z24floyd_warshall_interruptPiiiiPv:
        pushq   %r15
        pushq   %r14
        pushq   %r13
        pushq   %r12
        pushq   %rbp
        pushq   %rbx
        subq    $72, %rsp
        cmpl    %ecx, %edx
        movl    %ecx, 52(%rsp)
        movq    %r8, 56(%rsp)
        jge     .L23
        testl   %esi, %esi
        movl    %esi, %r9d
        jle     .L23
        movl    %edx, %r15d
        movq    %rdi, %r14
        movl    %edx, %r12d
        imull   %esi, %r15d
.L36:
        xorl    %r13d, %r13d
        xorl    %ebp, %ebp
.L34:
        leal    (%r12,%r13), %eax
        movq    %r14, %rdi
        cltq
        leaq    (%r14,%rax,4), %r10
        movl    %r13d, %r14d
        xorl    %eax, %eax
        movq    %r10, %r13
.L25:
        leal    128(%rax), %ebx
        cmpl    %r9d, %ebx
        cmovg   %r9d, %ebx
        cmpl    %ebx, %eax
        jge     .L37
        cmpl    %r12d, %ebp
        setne   %cl
.L28:
        cmpl    %eax, %ebp
        setne   %sil
        cmpl    %eax, %r12d
        setne   %dl
        testb   %dl, %sil
        je      .L27
        testb   %cl, %cl
        je      .L27
        leal    (%r14,%rax), %edx
        leal    (%r15,%rax), %esi
        movslq  %edx, %rdx
        movslq  %esi, %rsi
        leaq    (%rdi,%rdx,4), %r8
        movl    0(%r13), %edx
        addl    (%rdi,%rsi,4), %edx
        movl    (%r8), %esi
        cmpl    %esi, %edx
        cmovg   %esi, %edx
        movl    %edx, (%r8)
.L27:
        incl    %eax
        cmpl    %ebx, %eax
        jne     .L28
        cmpl    %ebx, %r9d
        jle     .L29
.L53:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L52
.L30:
        movl    %ebx, %eax
        jmp     .L25
.L52:
        movq    56(%rsp), %rax
        movl    52(%rsp), %ecx
        movl    %r9d, %esi
        movl    %r9d, 8(%rsp)
        movl    %ebx, (%rsp)
        movl    %ebp, %r8d
        movl    %r12d, %edx
        movl    %r9d, 48(%rsp)
        movq    %rdi, 40(%rsp)
        movq    %rax, 16(%rsp)
        call    _Z15to_loop_handlerPiiiiiiiiPv
        testl   %eax, %eax
        movq    40(%rsp), %rdi
        movl    48(%rsp), %r9d
        je      .L30
.L23:
        addq    $72, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L37:
        movl    %eax, %ebx
        cmpl    %ebx, %r9d
        jg      .L53
.L29:
        incl    %ebp
        movl    %r14d, %r13d
        movq    %rdi, %r14
        cmpl    %ebp, %r9d
        jle     .L32
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L33
.L35:
        addl    %r9d, %r13d
        jmp     .L34
.L33:
        movq    56(%rsp), %rax
        movl    52(%rsp), %ecx
        movl    %r9d, %esi
        movl    %ebp, %r8d
        movl    %r12d, %edx
        movl    %r9d, 40(%rsp)
        movq    %rax, (%rsp)
        call    _Z17from_loop_handlerPiiiiiiPv
        testl   %eax, %eax
        movl    40(%rsp), %r9d
        je      .L35
        jmp     .L23
.L32:
        incl    %r12d
        addl    %r9d, %r15d
        cmpl    %r12d, 52(%rsp)
        jg      .L36
        jmp     .L23
_Z29floyd_warshall_interrupt_fromPiiiiiiPv:
        pushq   %r15
        pushq   %r14
        pushq   %r13
        pushq   %r12
        pushq   %rbp
        pushq   %rbx
        subq    $56, %rsp
        cmpl    %r9d, %r8d
        movl    %ecx, 44(%rsp)
        jge     .L54
        testl   %esi, %esi
        jle     .L54
        movl    %esi, %r11d
        movl    %r8d, %r14d
        movq    %rdi, %r13
        imull   %edx, %r11d
        movl    %edx, %r12d
        movl    %r8d, %ebp
        imull   %esi, %r14d
.L64:
        leal    (%r12,%r14), %eax
        movl    %r14d, %r10d
        cltq
        leaq    0(%r13,%rax,4), %r15
        xorl    %eax, %eax
        movq    %r15, %r14
        movl    %esi, %r15d
.L57:
        leal    128(%rax), %ebx
        cmpl    %r15d, %ebx
        cmovg   %r15d, %ebx
        cmpl    %ebx, %eax
        jge     .L66
        cmpl    %ebp, %r12d
        setne   %sil
.L60:
        cmpl    %eax, %ebp
        setne   %cl
        cmpl    %eax, %r12d
        setne   %dl
        testb   %dl, %cl
        je      .L59
        testb   %sil, %sil
        je      .L59
        leal    (%r10,%rax), %edx
        leal    (%r11,%rax), %edi
        movslq  %edx, %rdx
        movslq  %edi, %rdi
        leaq    0(%r13,%rdx,4), %rcx
        movl    (%r14), %edx
        addl    0(%r13,%rdi,4), %edx
        movl    (%rcx), %edi
        cmpl    %edi, %edx
        cmovg   %edi, %edx
        movl    %edx, (%rcx)
.L59:
        incl    %eax
        cmpl    %ebx, %eax
        jne     .L60
        cmpl    %ebx, %r15d
        jle     .L61
.L82:
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L81
.L62:
        movl    %ebx, %eax
        jmp     .L57
.L81:
        movq    112(%rsp), %rax
        movl    44(%rsp), %ecx
        movl    %ebp, %r8d
        movl    %r15d, 8(%rsp)
        movl    %ebx, (%rsp)
        movl    %r12d, %edx
        movl    %r15d, %esi
        movq    %r13, %rdi
        movl    %r10d, 40(%rsp)
        movq    %rax, 16(%rsp)
        movl    %r11d, 36(%rsp)
        movl    %r9d, 32(%rsp)
        call    _Z20from_to_loop_handlerPiiiiiiiiPv
        testl   %eax, %eax
        movl    32(%rsp), %r9d
        movl    36(%rsp), %r11d
        movl    40(%rsp), %r10d
        je      .L62
.L54:
        addq    $56, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L66:
        movl    %eax, %ebx
        cmpl    %ebx, %r15d
        jg      .L82
.L61:
        incl    %ebp
        movl    %r10d, %r14d
        movl    %r15d, %esi
        cmpl    %ebp, %r9d
        je      .L54
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L63
.L65:
        addl    %esi, %r14d
        jmp     .L64
.L63:
        movq    112(%rsp), %rax
        movl    44(%rsp), %ecx
        movl    %ebp, %r8d
        movl    %r12d, %edx
        movq    %r13, %rdi
        movl    %r11d, 40(%rsp)
        movl    %r9d, 36(%rsp)
        movl    %r15d, 32(%rsp)
        movq    %rax, (%rsp)
        call    _Z22from_from_loop_handlerPiiiiiiPv
        testl   %eax, %eax
        movl    32(%rsp), %esi
        movl    36(%rsp), %r9d
        movl    40(%rsp), %r11d
        je      .L65
        jmp     .L54
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
        cmpl    %eax, %r14d
        jle     .L83
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
.L85:
        leal    128(%rax), %ebx
        cmpl    %r11d, %ebx
        cmovg   %r11d, %ebx
        cmpl    %ebx, %eax
        jge     .L91
        cmpl    %ebp, %r12d
        setne   %dil
.L88:
        cmpl    %eax, %r12d
        setne   %cl
        cmpl    %eax, %ebp
        setne   %dl
        testb   %dl, %cl
        je      .L87
        testb   %dil, %dil
        je      .L87
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
.L87:
        incl    %eax
        cmpl    %ebx, %eax
        jne     .L88
.L86:
        cmpl    %ebx, %r11d
        jle     .L83
        movl    heartbeat(%rip), %eax
        testl   %eax, %eax
        jne     .L103
.L90:
        movl    %ebx, %eax
        jmp     .L85
.L103:
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
        je      .L90
.L83:
        addq    $56, %rsp
        popq    %rbx
        popq    %rbp
        popq    %r12
        popq    %r13
        popq    %r14
        popq    %r15
        ret
.L91:
        movl    %eax, %ebx
        jmp     .L86
