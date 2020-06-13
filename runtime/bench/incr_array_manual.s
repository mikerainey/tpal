	.text
	.p2align 4,,15
	.globl	incr_array_interrupt
	.type	incr_array_interrupt, @function
	.globl	incr_array_interrupt_l0
	.type	incr_array_interrupt_l0, @function
	.globl	incr_array_interrupt_l1
	.type	incr_array_interrupt_l1, @function
	.globl	incr_array_interrupt_l2
	.type	incr_array_interrupt_l2, @function
	.globl	incr_array_interrupt_l3
	.type	incr_array_interrupt_l3, @function
	.globl	incr_array_interrupt_rf_l0
	.type	incr_array_interrupt_rf_l0, @function
	.globl	incr_array_interrupt_rf_l1
	.type	incr_array_interrupt_rf_l1, @function
	.globl	incr_array_interrupt_rf_l2
	.type	incr_array_interrupt_rf_l2, @function
	.globl	incr_array_interrupt_rf_l3
	.type	incr_array_interrupt_rf_l3, @function
// a = %rdi, lo = %rsi, hi = %rdx, p = %rcx
incr_array_interrupt:
	cmpq	%rdx, %rsi
	movq	%rdi, %rax
        movq    %rcx, %r9
	je	.L2
	leaq	(%rdi,%rsi,8), %rcx
	leaq	(%rdi,%rdx,8), %rdx
	.p2align 4,,10
	.p2align 3
// loop body
// a = %rax, alo = %rcx, ahi = %rdx, p = %r9    
.body:
incr_array_interrupt_l0:        addq	$1, (%rcx)
incr_array_interrupt_l1:	addq	$8, %rcx
incr_array_interrupt_l2:	cmpq	%rdx, %rcx
incr_array_interrupt_l3:	jne	.body
.L2:
	                        rep ret
.body_rollforward:		jmp	.body_compensation_to
incr_array_interrupt_rf_l0:     addq	$1, (%rcx)
incr_array_interrupt_rf_l1:     addq	$8, %rcx
incr_array_interrupt_rf_l2:     cmpq	%rdx, %rcx
incr_array_interrupt_rf_l3: 	jne	.body_rollforward
.L3:				rep ret
// a = %rax, alo = %rcx, ahi = %rdx, p = %r9
.body_compensation_to:
	// store a in first argument slot
	movq	%rax, %rdi
	// lo := (alo-a)/8; store lo in second argument slot
	subq	%rdi, %rcx
	shrq	$3, %rcx
	movq	%rcx, %rsi
	// hi := (ahi-a)/8; store hi in third argument slot
	subq    %rdi, %rdx
	shrq	$3, %rdx
// a = %rdi, lo = %rsi, hi = %rdx, p = %r9
.body_try_promote:
	pushq	%rdi
	pushq	%rsi
        pushq   %r9
        movq    %r9, %rcx
	subq	$16, %rsp
	movq	%rdx, (%rsp)
	movq	%rsp, %rdx
	call	incr_array_interrupt_promote
	movq	(%rsp), %rdx
	addq	$16, %rsp
        popq    %r9
	popq	%rsi
	popq	%rdi
// a = %rdi, lo = %rsi, hi = %rdx, p = %r9
.body_compensation_from:
	movq	%rdi, %rax
	leaq	(%rdi, %rsi, 8), %rcx
	leaq	(%rdi, %rdx, 8), %rdx
	jmp	.body
	.size	incr_array_interrupt, .-incr_array_interrupt
	.ident	"GCC: (GNU) 7.4.0"
	.section	.note.GNU-stack,"",@progbits
