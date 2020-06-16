# 1 "spmv_manual_orig.s"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/nix/store/fwpn2f7a4iqszyydw7ag61zlnp6xk5d3-glibc-2.30-dev/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "spmv_manual_orig.s"
# 1 "spmv_offsets.h" 1
       
# 2 "spmv_manual_orig.s" 2

 .text
 .p2align 4,,15
 .globl spmv_interrupt
 .type spmv_interrupt, @function
 .globl spmv_interrupt_row_loop
 .type spmv_interrupt_row_loop, @function
 .globl spmv_interrupt_col_loop
 .type spmv_interrupt_col_loop, @function

        .globl spmv_l0
 .type spmv_l0, @function
        .globl spmv_l1
 .type spmv_l1, @function
        .globl spmv_l2
 .type spmv_l2, @function
        .globl spmv_l3
 .type spmv_l3, @function
        .globl spmv_l4
 .type spmv_l4, @function
        .globl spmv_l5
 .type spmv_l5, @function
        .globl spmv_l6
 .type spmv_l6, @function
        .globl spmv_l7
 .type spmv_l7, @function
        .globl spmv_l8
 .type spmv_l8, @function
        .globl spmv_l9
 .type spmv_l9, @function
        .globl spmv_l10
 .type spmv_l10, @function
        .globl spmv_l11
 .type spmv_l11, @function
        .globl spmv_l12
 .type spmv_l12, @function
        .globl spmv_l13
 .type spmv_l13, @function
        .globl spmv_l14
 .type spmv_l14, @function
        .globl spmv_l15
 .type spmv_l15, @function

        .globl spmv_rf_l0
 .type spmv_rf_l0, @function
        .globl spmv_rf_l1
 .type spmv_rf_l1, @function
        .globl spmv_rf_l2
 .type spmv_rf_l2, @function
        .globl spmv_rf_l3
 .type spmv_rf_l3, @function
        .globl spmv_rf_l4
 .type spmv_rf_l4, @function
        .globl spmv_rf_l5
 .type spmv_rf_l5, @function
        .globl spmv_rf_l6
 .type spmv_rf_l6, @function
        .globl spmv_rf_l7
 .type spmv_rf_l7, @function
        .globl spmv_rf_l8
 .type spmv_rf_l8, @function
        .globl spmv_rf_l9
 .type spmv_rf_l9, @function
        .globl spmv_rf_l10
 .type spmv_rf_l10, @function
        .globl spmv_rf_l11
 .type spmv_rf_l11, @function
        .globl spmv_rf_l12
 .type spmv_rf_l12, @function
        .globl spmv_rf_l13
 .type spmv_rf_l13, @function
        .globl spmv_rf_l14
 .type spmv_rf_l14, @function
        .globl spmv_rf_l15
 .type spmv_rf_l15, @function

        .globl spmv_col_l0
 .type spmv_col_l0, @function
        .globl spmv_col_l1
 .type spmv_col_l1, @function
        .globl spmv_col_l2
 .type spmv_col_l2, @function
        .globl spmv_col_l3
 .type spmv_col_l3, @function
        .globl spmv_col_l4
 .type spmv_col_l4, @function
        .globl spmv_col_l5
 .type spmv_col_l5, @function
        .globl spmv_col_l6
 .type spmv_col_l6, @function

        .globl spmv_col_rf_l0
 .type spmv_col_rf_l0, @function
        .globl spmv_col_rf_l1
 .type spmv_col_rf_l1, @function
        .globl spmv_col_rf_l2
 .type spmv_col_rf_l2, @function
        .globl spmv_col_rf_l3
 .type spmv_col_rf_l3, @function
        .globl spmv_col_rf_l4
 .type spmv_col_rf_l4, @function
        .globl spmv_col_rf_l5
 .type spmv_col_rf_l5, @function
        .globl spmv_col_rf_l6
 .type spmv_col_rf_l6, @function




.row_loop_entry:
spmv_l0: movq (%rsi,%rbx,8), %rax
spmv_l1: movq 8(%rsi,%rbx,8), %r11
spmv_l2: pxor %xmm1, %xmm1
spmv_l3: cmpq %r11, %rax
spmv_l4: jge .row_loop_back


.col_loop:
spmv_l5: movq (%rdx,%rax,8), %r10
spmv_l6: movsd (%rcx,%r10,8), %xmm0
spmv_l7: mulsd (%rdi,%rax,8), %xmm0
spmv_l8: addq $1, %rax
spmv_l9: cmpq %r11, %rax
spmv_l10: addsd %xmm0, %xmm1
spmv_l11: jne .col_loop
.row_loop_back:
spmv_l12: movsd %xmm1, (%r8,%rbx,8)
spmv_l13: addq $1, %rbx
spmv_l14: cmpq %rbx, %r9
spmv_l15: jne .row_loop_entry
                jmp .spmv_interrupt_exit


.row_loop_entry_rf:
spmv_rf_l0: jmp .row_loop_comp_to

spmv_rf_l1: movq 8(%rsi,%rbx,8), %r11
spmv_rf_l2: pxor %xmm1, %xmm1
spmv_rf_l3: cmpq %r11, %rax
spmv_rf_l4: jge .row_loop_back_rf
.col_loop_rf:
spmv_rf_l5: jmp .col_loop_comp_to

spmv_rf_l6: movsd (%rcx,%r10,8), %xmm0
spmv_rf_l7: mulsd (%rdi,%rax,8), %xmm0
spmv_rf_l8: addq $1, %rax
spmv_rf_l9: cmpq %r11, %rax
spmv_rf_l10: addsd %xmm0, %xmm1
spmv_rf_l11: jne .col_loop_rf
.row_loop_back_rf:
spmv_rf_l12: movsd %xmm1, (%r8,%rbx,8)
spmv_rf_l13: addq $1, %rbx
spmv_rf_l14: cmpq %rbx, %r9
spmv_rf_l15: jne .row_loop_entry_rf
                   jmp .spmv_interrupt_exit

.col_loop_par:
spmv_col_l0: movq (%rdx,%rax,8), %r10
spmv_col_l1: movsd (%rcx,%r10,8), %xmm0
spmv_col_l2: mulsd (%rdi,%rax,8), %xmm0
spmv_col_l3: addq $1, %rax
spmv_col_l4: cmpq %r11, %rax
spmv_col_l5: addsd %xmm0, %xmm1
spmv_col_l6: jne .col_loop_par
                    movq 88(%r15), %r10
                    movsd %xmm1, (%r10)
                    jmp .spmv_interrupt_exit

.col_loop_par_rf:
spmv_col_rf_l0: jmp .col_loop_par_comp_to

spmv_col_rf_l1: movsd (%rcx,%r10,8), %xmm0
spmv_col_rf_l2: mulsd (%rdi,%rax,8), %xmm0
spmv_col_rf_l3: addq $1, %rax
spmv_col_rf_l4: cmpq %r11, %rax
spmv_col_rf_l5: addsd %xmm0, %xmm1
spmv_col_rf_l6: jne .col_loop_par_rf
                       movq 88(%r15), %r10
                       movsd %xmm1, (%r10)
                       jmp .spmv_interrupt_exit


spmv_interrupt:
        pushq %rbp
        movq %rsp, %rbp
        pushq %rbx
        pushq %r12
 pushq %r13
        pushq %r14
        pushq %r15
        movq %rdi, %r15
        movq 48(%r15), %r9
        movq 40(%r15), %rbx
        movq 32(%r15), %r8
        movq 24(%r15), %rcx
        movq 16(%r15), %rdx
        movq 8(%r15), %rsi
        movq 0(%r15), %rdi
        testq %r9, %r9
        jle .spmv_interrupt_exit
        xorl %ebx, %ebx
        jmp .row_loop_entry

.spmv_interrupt_exit:
 popq %r12
 popq %r13
 popq %r14
 popq %r15
        popq %rbx
        popq %rbp
 ret

spmv_interrupt_row_loop:
        pushq %rbp
        movq %rsp, %rbp
        pushq %rbx
        pushq %r12
 pushq %r13
        pushq %r14
        pushq %r15
        movq %rdi, %r15
        movq 64(%r15), %r11
        movq 56(%r15), %rax
        movq 48(%r15), %r9
        movq 40(%r15), %rbx
        movq 32(%r15), %r8
        movq 24(%r15), %rcx
        movq 16(%r15), %rdx
        movq 8(%r15), %rsi
        movq 0(%r15), %rdi
        jmp .row_loop_entry

spmv_interrupt_col_loop:
        pushq %rbp
        movq %rsp, %rbp
        pushq %rbx
        pushq %r12
 pushq %r13
        pushq %r14
        pushq %r15
        movq %rdi, %r15
        movq 64(%r15), %r11
        movq 56(%r15), %rax
        movq 48(%r15), %r9
        movq 40(%r15), %rbx
        movq 32(%r15), %r8
        movq 24(%r15), %rcx
        movq 16(%r15), %rdx
        movq 8(%r15), %rsi
        movq 0(%r15), %rdi
        jmp .col_loop_par

.col_loop_comp_to:
        movsd %xmm1, 80(%r15)
        movq %r11, 64(%r15)
        movq %rax, 56(%r15)
        movq %r9, 48(%r15)
        movq %rbx, 40(%r15)
        movq %r8, 32(%r15)
        movq %rcx, 24(%r15)
        movq %rdx, 16(%r15)
        movq %rsi, 8(%r15)
        movq %rdi, 0(%r15)
        movq %r15, %rdi
        pushq %r15
        call spmv_interrupt_promote
        popq %r15
        movsd 80(%r15), %xmm1
        movq 64(%r15), %r11
        movq 56(%r15), %rax
        movq 48(%r15), %r9
        movq 40(%r15), %rbx
        movq 32(%r15), %r8
        movq 24(%r15), %rcx
        movq 16(%r15), %rdx
        movq 8(%r15), %rsi
        movq 0(%r15), %rdi
        movq 88(%r15), %r14
        testq %r14, %r14
        jne spmv_col_l0
        jmp spmv_l5

.row_loop_comp_to:
        movsd %xmm1, 80(%r15)
        movq %r11, 64(%r15)
        movq %rax, 56(%r15)
        movq %r9, 48(%r15)
        movq %rbx, 40(%r15)
        movq %r8, 32(%r15)
        movq %rcx, 24(%r15)
        movq %rdx, 16(%r15)
        movq %rsi, 8(%r15)
        movq %rdi, 0(%r15)
        movq %r15, %rdi
        pushq %r15
        call spmv_interrupt_promote
        popq %r15
        movsd 80(%r15), %xmm1
        movq 64(%r15), %r11
        movq 56(%r15), %rax
        movq 48(%r15), %r9
        movq 40(%r15), %rbx
        movq 32(%r15), %r8
        movq 24(%r15), %rcx
        movq 16(%r15), %rdx
        movq 8(%r15), %rsi
        movq 0(%r15), %rdi
        movq 88(%r15), %r14
        testq %r14, %r14
        jne spmv_col_l0
        jmp spmv_l0

.col_loop_par_comp_to:
        movsd %xmm1, 80(%r15)
        movq %r11, 64(%r15)
        movq %rax, 56(%r15)
        movq %r9, 48(%r15)
        movq %rbx, 40(%r15)
        movq %r8, 32(%r15)
        movq %rcx, 24(%r15)
        movq %rdx, 16(%r15)
        movq %rsi, 8(%r15)
        movq %rdi, 0(%r15)
        movq %r15, %rdi
        pushq %r15
        call spmv_col_interrupt_promote
        popq %r15
        movsd 80(%r15), %xmm1
        movq 64(%r15), %r11
        movq 56(%r15), %rax
        movq 48(%r15), %r9
        movq 40(%r15), %rbx
        movq 32(%r15), %r8
        movq 24(%r15), %rcx
        movq 16(%r15), %rdx
        movq 8(%r15), %rsi
        movq 0(%r15), %rdi
        jmp spmv_col_l0

 .size spmv_interrupt, .-spmv_interrupt
 .ident "GCC: (GNU) 7.4.0"
 .section .note.GNU-stack,"",@progbits
