#include "spmv_offsets.h"
        
	.text
	.p2align 4,,15
	.globl	spmv_interrupt
	.type	spmv_interrupt, @function
	.globl	spmv_interrupt_row_loop
	.type	spmv_interrupt_row_loop, @function
	.globl	spmv_interrupt_col_loop
	.type	spmv_interrupt_col_loop, @function
        
        .globl	spmv_l0
	.type	spmv_l0, @function
        .globl	spmv_l1
	.type	spmv_l1, @function
        .globl	spmv_l2
	.type	spmv_l2, @function
        .globl	spmv_l3
	.type	spmv_l3, @function
        .globl	spmv_l4
	.type	spmv_l4, @function
        .globl	spmv_l5
	.type	spmv_l5, @function
        .globl	spmv_l6
	.type	spmv_l6, @function
        .globl	spmv_l7
	.type	spmv_l7, @function
        .globl	spmv_l8
	.type	spmv_l8, @function
        .globl	spmv_l9
	.type	spmv_l9, @function
        .globl	spmv_l10
	.type	spmv_l10, @function
        .globl	spmv_l11
	.type	spmv_l11, @function
        .globl	spmv_l12
	.type	spmv_l12, @function
        .globl	spmv_l13
	.type	spmv_l13, @function
        .globl	spmv_l14
	.type	spmv_l14, @function
        .globl	spmv_l15
	.type	spmv_l15, @function

        .globl	spmv_rf_l0
	.type	spmv_rf_l0, @function
        .globl	spmv_rf_l1
	.type	spmv_rf_l1, @function
        .globl	spmv_rf_l2
	.type	spmv_rf_l2, @function
        .globl	spmv_rf_l3
	.type	spmv_rf_l3, @function
        .globl	spmv_rf_l4
	.type	spmv_rf_l4, @function
        .globl	spmv_rf_l5
	.type	spmv_rf_l5, @function
        .globl	spmv_rf_l6
	.type	spmv_rf_l6, @function
        .globl	spmv_rf_l7
	.type	spmv_rf_l7, @function
        .globl	spmv_rf_l8
	.type	spmv_rf_l8, @function
        .globl	spmv_rf_l9
	.type	spmv_rf_l9, @function
        .globl	spmv_rf_l10
	.type	spmv_rf_l10, @function
        .globl	spmv_rf_l11
	.type	spmv_rf_l11, @function
        .globl	spmv_rf_l12
	.type	spmv_rf_l12, @function
        .globl	spmv_rf_l13
	.type	spmv_rf_l13, @function
        .globl	spmv_rf_l14
	.type	spmv_rf_l14, @function
        .globl	spmv_rf_l15
	.type	spmv_rf_l15, @function
        
        .globl	spmv_col_l0
	.type	spmv_col_l0, @function
        .globl	spmv_col_l1
	.type	spmv_col_l1, @function
        .globl	spmv_col_l2
	.type	spmv_col_l2, @function
        .globl	spmv_col_l3
	.type	spmv_col_l3, @function
        .globl	spmv_col_l4
	.type	spmv_col_l4, @function
        .globl	spmv_col_l5
	.type	spmv_col_l5, @function
        .globl	spmv_col_l6
	.type	spmv_col_l6, @function

        .globl	spmv_col_rf_l0
	.type	spmv_col_rf_l0, @function
        .globl	spmv_col_rf_l1
	.type	spmv_col_rf_l1, @function
        .globl	spmv_col_rf_l2
	.type	spmv_col_rf_l2, @function
        .globl	spmv_col_rf_l3
	.type	spmv_col_rf_l3, @function
        .globl	spmv_col_rf_l4
	.type	spmv_col_rf_l4, @function
        .globl	spmv_col_rf_l5
	.type	spmv_col_rf_l5, @function
        .globl	spmv_col_rf_l6
	.type	spmv_col_rf_l6, @function


// val = %rdi, row_ptr = %rsi, col_ind = %rdx,
// x = %rcx, y = %r8, n = %r9
.row_loop_entry:
spmv_l0:        movq	(%rsi,%rbx,8), %rax
spmv_l1:        movq	8(%rsi,%rbx,8), %r11
spmv_l2:        pxor	%xmm1, %xmm1
spmv_l3:        cmpq	%r11, %rax
spmv_l4:        jge	.row_loop_back
// i = %rbx, k = %rax, row_ptr[i+1] = %r11
// t = %xmm1
.col_loop:
spmv_l5:        movq	(%rdx,%rax,8), %r10
spmv_l6:        movsd	(%rcx,%r10,8), %xmm0
spmv_l7:        mulsd	(%rdi,%rax,8), %xmm0
spmv_l8:        addq	$1, %rax
spmv_l9:        cmpq	%r11, %rax
spmv_l10:       addsd	%xmm0, %xmm1
spmv_l11:       jne	.col_loop
.row_loop_back: 
spmv_l12:       movsd	%xmm1, (%r8,%rbx,8)
spmv_l13:       addq	$1, %rbx
spmv_l14:       cmpq	%rbx, %r9
spmv_l15:       jne	.row_loop_entry
                jmp     .spmv_interrupt_exit

// rollforward loop body
.row_loop_entry_rf:
spmv_rf_l0:        jmp .row_loop_comp_to
        //movq	(%rsi,%rbx,8), %rax
spmv_rf_l1:        movq	8(%rsi,%rbx,8), %r11
spmv_rf_l2:        pxor	%xmm1, %xmm1
spmv_rf_l3:        cmpq	%r11, %rax
spmv_rf_l4:        jge	.row_loop_back_rf
.col_loop_rf:
spmv_rf_l5:        jmp .col_loop_comp_to
        //movq	(%rdx,%rax,8), %r10
spmv_rf_l6:        movsd	(%rcx,%r10,8), %xmm0
spmv_rf_l7:        mulsd	(%rdi,%rax,8), %xmm0
spmv_rf_l8:        addq	$1, %rax
spmv_rf_l9:	   cmpq	%r11, %rax
spmv_rf_l10:       addsd	%xmm0, %xmm1
spmv_rf_l11:       jne .col_loop_rf
.row_loop_back_rf: 
spmv_rf_l12:       movsd	%xmm1, (%r8,%rbx,8)
spmv_rf_l13:       addq	$1, %rbx
spmv_rf_l14:       cmpq	%rbx, %r9
spmv_rf_l15:       jne .row_loop_entry_rf
                   jmp .spmv_interrupt_exit

.col_loop_par:
spmv_col_l0:        movq	(%rdx,%rax,8), %r10
spmv_col_l1:        movsd	(%rcx,%r10,8), %xmm0
spmv_col_l2:        mulsd	(%rdi,%rax,8), %xmm0
spmv_col_l3:        addq	$1, %rax
spmv_col_l4:        cmpq	%r11, %rax
spmv_col_l5:        addsd	%xmm0, %xmm1
spmv_col_l6:        jne	.col_loop_par 
                    movq        SPMV_OFF12(SPMV_ENV_REG), %r10
                    movsd       %xmm1, (%r10)
                    jmp .spmv_interrupt_exit

.col_loop_par_rf:
spmv_col_rf_l0:        jmp .col_loop_par_comp_to
        //movq	(%rdx,%rax,8), %r10
spmv_col_rf_l1:        movsd	(%rcx,%r10,8), %xmm0
spmv_col_rf_l2:        mulsd	(%rdi,%rax,8), %xmm0
spmv_col_rf_l3:        addq	$1, %rax
spmv_col_rf_l4:        cmpq	%r11, %rax
spmv_col_rf_l5:        addsd	%xmm0, %xmm1
spmv_col_rf_l6:        jne	.col_loop_par_rf
                       movq        SPMV_OFF12(SPMV_ENV_REG), %r10
                       movsd       %xmm1, (%r10)
                       jmp .spmv_interrupt_exit

// env = %rdi
spmv_interrupt:
        pushq   %rbp
        movq    %rsp, %rbp
        pushq   %rbx
        pushq   %r12
	pushq   %r13
        pushq   %r14
        pushq   %r15
        movq    %rdi, SPMV_ENV_REG
        movq    SPMV_OFF07(SPMV_ENV_REG), %r9
        movq    SPMV_OFF06(SPMV_ENV_REG), %rbx
        movq    SPMV_OFF05(SPMV_ENV_REG), %r8
        movq    SPMV_OFF04(SPMV_ENV_REG), %rcx 
        movq    SPMV_OFF03(SPMV_ENV_REG), %rdx
        movq    SPMV_OFF02(SPMV_ENV_REG), %rsi
        movq    SPMV_OFF01(SPMV_ENV_REG), %rdi
        testq	%r9, %r9
        jle	.spmv_interrupt_exit
        xorl	%ebx, %ebx
        jmp     .row_loop_entry
        
.spmv_interrupt_exit:
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
        popq    %rbx
        popq	%rbp
	ret

spmv_interrupt_row_loop:
        pushq   %rbp
        movq    %rsp, %rbp
        pushq   %rbx
        pushq   %r12
	pushq   %r13
        pushq   %r14
        pushq   %r15
        movq    %rdi, SPMV_ENV_REG
        movq    SPMV_OFF09(SPMV_ENV_REG), %r11
        movq    SPMV_OFF08(SPMV_ENV_REG), %rax
        movq    SPMV_OFF07(SPMV_ENV_REG), %r9
        movq    SPMV_OFF06(SPMV_ENV_REG), %rbx
        movq    SPMV_OFF05(SPMV_ENV_REG), %r8
        movq    SPMV_OFF04(SPMV_ENV_REG), %rcx 
        movq    SPMV_OFF03(SPMV_ENV_REG), %rdx
        movq    SPMV_OFF02(SPMV_ENV_REG), %rsi
        movq    SPMV_OFF01(SPMV_ENV_REG), %rdi
        jmp     .row_loop_entry

spmv_interrupt_col_loop:
        pushq   %rbp
        movq    %rsp, %rbp
        pushq   %rbx
        pushq   %r12
	pushq   %r13
        pushq   %r14
        pushq   %r15
        movq    %rdi, SPMV_ENV_REG
        movq    SPMV_OFF09(SPMV_ENV_REG), %r11
        movq    SPMV_OFF08(SPMV_ENV_REG), %rax
        movq    SPMV_OFF07(SPMV_ENV_REG), %r9
        movq    SPMV_OFF06(SPMV_ENV_REG), %rbx
        movq    SPMV_OFF05(SPMV_ENV_REG), %r8
        movq    SPMV_OFF04(SPMV_ENV_REG), %rcx 
        movq    SPMV_OFF03(SPMV_ENV_REG), %rdx
        movq    SPMV_OFF02(SPMV_ENV_REG), %rsi
        movq    SPMV_OFF01(SPMV_ENV_REG), %rdi
        jmp     .col_loop_par

.col_loop_comp_to:
        movsd   %xmm1, SPMV_OFF11(SPMV_ENV_REG)
        movq    %r11, SPMV_OFF09(SPMV_ENV_REG)
        movq    %rax, SPMV_OFF08(SPMV_ENV_REG)
        movq    %r9, SPMV_OFF07(SPMV_ENV_REG)
        movq    %rbx, SPMV_OFF06(SPMV_ENV_REG)
        movq    %r8, SPMV_OFF05(SPMV_ENV_REG)
        movq    %rcx, SPMV_OFF04(SPMV_ENV_REG)
        movq    %rdx, SPMV_OFF03(SPMV_ENV_REG)
        movq    %rsi, SPMV_OFF02(SPMV_ENV_REG)
        movq    %rdi, SPMV_OFF01(SPMV_ENV_REG)
        movq    SPMV_ENV_REG, %rdi
        pushq   SPMV_ENV_REG
        call    spmv_interrupt_promote
        popq    SPMV_ENV_REG
        movsd   SPMV_OFF11(SPMV_ENV_REG), %xmm1
        movq    SPMV_OFF09(SPMV_ENV_REG), %r11
        movq    SPMV_OFF08(SPMV_ENV_REG), %rax
        movq    SPMV_OFF07(SPMV_ENV_REG), %r9
        movq    SPMV_OFF06(SPMV_ENV_REG), %rbx
        movq    SPMV_OFF05(SPMV_ENV_REG), %r8
        movq    SPMV_OFF04(SPMV_ENV_REG), %rcx 
        movq    SPMV_OFF03(SPMV_ENV_REG), %rdx
        movq    SPMV_OFF02(SPMV_ENV_REG), %rsi
        movq    SPMV_OFF01(SPMV_ENV_REG), %rdi
        movq    SPMV_OFF12(SPMV_ENV_REG), %r14
        testq   %r14, %r14
        jne     spmv_col_l0
        jmp     spmv_l5

.row_loop_comp_to:
        movsd   %xmm1, SPMV_OFF11(SPMV_ENV_REG)
        movq    %r11, SPMV_OFF09(SPMV_ENV_REG)
        movq    %rax, SPMV_OFF08(SPMV_ENV_REG)
        movq    %r9, SPMV_OFF07(SPMV_ENV_REG)
        movq    %rbx, SPMV_OFF06(SPMV_ENV_REG)
        movq    %r8, SPMV_OFF05(SPMV_ENV_REG)
        movq    %rcx, SPMV_OFF04(SPMV_ENV_REG)
        movq    %rdx, SPMV_OFF03(SPMV_ENV_REG)
        movq    %rsi, SPMV_OFF02(SPMV_ENV_REG)
        movq    %rdi, SPMV_OFF01(SPMV_ENV_REG)
        movq    SPMV_ENV_REG, %rdi
        pushq   SPMV_ENV_REG
        call    spmv_interrupt_promote
        popq    SPMV_ENV_REG
        movsd   SPMV_OFF11(SPMV_ENV_REG), %xmm1
        movq    SPMV_OFF09(SPMV_ENV_REG), %r11
        movq    SPMV_OFF08(SPMV_ENV_REG), %rax
        movq    SPMV_OFF07(SPMV_ENV_REG), %r9
        movq    SPMV_OFF06(SPMV_ENV_REG), %rbx
        movq    SPMV_OFF05(SPMV_ENV_REG), %r8
        movq    SPMV_OFF04(SPMV_ENV_REG), %rcx 
        movq    SPMV_OFF03(SPMV_ENV_REG), %rdx
        movq    SPMV_OFF02(SPMV_ENV_REG), %rsi
        movq    SPMV_OFF01(SPMV_ENV_REG), %rdi
        movq    SPMV_OFF12(SPMV_ENV_REG), %r14
        testq   %r14, %r14
        jne     spmv_col_l0
        jmp     spmv_l0

.col_loop_par_comp_to:
        movsd   %xmm1, SPMV_OFF11(SPMV_ENV_REG)
        movq    %r11, SPMV_OFF09(SPMV_ENV_REG)
        movq    %rax, SPMV_OFF08(SPMV_ENV_REG)
        movq    %r9, SPMV_OFF07(SPMV_ENV_REG)
        movq    %rbx, SPMV_OFF06(SPMV_ENV_REG)
        movq    %r8, SPMV_OFF05(SPMV_ENV_REG)
        movq    %rcx, SPMV_OFF04(SPMV_ENV_REG)
        movq    %rdx, SPMV_OFF03(SPMV_ENV_REG)
        movq    %rsi, SPMV_OFF02(SPMV_ENV_REG)
        movq    %rdi, SPMV_OFF01(SPMV_ENV_REG)
        movq    SPMV_ENV_REG, %rdi
        pushq   SPMV_ENV_REG
        call    spmv_col_interrupt_promote
        popq    SPMV_ENV_REG
        movsd   SPMV_OFF11(SPMV_ENV_REG), %xmm1
        movq    SPMV_OFF09(SPMV_ENV_REG), %r11
        movq    SPMV_OFF08(SPMV_ENV_REG), %rax
        movq    SPMV_OFF07(SPMV_ENV_REG), %r9
        movq    SPMV_OFF06(SPMV_ENV_REG), %rbx
        movq    SPMV_OFF05(SPMV_ENV_REG), %r8
        movq    SPMV_OFF04(SPMV_ENV_REG), %rcx 
        movq    SPMV_OFF03(SPMV_ENV_REG), %rdx
        movq    SPMV_OFF02(SPMV_ENV_REG), %rsi
        movq    SPMV_OFF01(SPMV_ENV_REG), %rdi
        jmp     spmv_col_l0

	.size	spmv_interrupt, .-spmv_interrupt
	.ident	"GCC: (GNU) 7.4.0"
	.section	.note.GNU-stack,"",@progbits
