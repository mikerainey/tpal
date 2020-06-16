	.text
	.p2align 4,,15
	.globl	plus_reduce_array_interrupt
	.type	plus_reduce_array_interrupt, @function
	.globl	plus_reduce_array_interrupt_l0
	.type	plus_reduce_array_interrupt_l0, @function
	.globl	plus_reduce_array_interrupt_l1
	.type	plus_reduce_array_interrupt_l1, @function
	.globl	plus_reduce_array_interrupt_l2
	.type	plus_reduce_array_interrupt_l2, @function
	.globl	plus_reduce_array_interrupt_l3
	.type	plus_reduce_array_interrupt_l3, @function
	.globl	plus_reduce_array_interrupt_rf_l0
	.type	plus_reduce_array_interrupt_rf_l0, @function
	.globl	plus_reduce_array_interrupt_rf_l1
	.type	plus_reduce_array_interrupt_rf_l1, @function
	.globl	plus_reduce_array_interrupt_rf_l2
	.type	plus_reduce_array_interrupt_rf_l2, @function
	.globl	plus_reduce_array_interrupt_rf_l3
	.type	plus_reduce_array_interrupt_rf_l3, @function
// a = %rdi, lo = %rsi, hi = %rdx, dst = %rcx, p = %r8
plus_reduce_array_interrupt:
	cmpq	%rdx, %rsi
	je	.early_exit
	movq	%rdi, %r9
	leaq	(%rdi,%rsi,8), %rax
	leaq	(%rdi,%rdx,8), %rsi
	xorl	%edx, %edx
	.p2align 4,,10
	.p2align 3
// loop body
// a = %r9, alo = %rax, ahi = %rsi, dst = %rcx, p = %r8
.loop_body:
plus_reduce_array_interrupt_l0:		addq	(%rax), %rdx
plus_reduce_array_interrupt_l1:		addq	$8, %rax
plus_reduce_array_interrupt_l2:		cmpq	%rsi, %rax
plus_reduce_array_interrupt_l3:		jne	.loop_body
					movq	%rdx, (%rcx)
					ret
.loop_body_rollforward:			jmp	.body_compensation_to
plus_reduce_array_interrupt_rf_l0:	addq	(%rax), %rdx
plus_reduce_array_interrupt_rf_l1:	addq	$8, %rax
plus_reduce_array_interrupt_rf_l2:	cmpq	%rsi, %rax
plus_reduce_array_interrupt_rf_l3:	jne	.loop_body_rollforward
					movq	%rdx, (%rcx)
					ret
	.p2align 4,,10
	.p2align 3
.early_exit:
	xorl	%edx, %edx
	movq	%rdx, (%rcx)
	ret
	.size	plus_reduce_array_interrupt, .-plus_reduce_array_interrupt
	.p2align 4,,15
// a = %r9, alo = %rax, ahi = %rsi, dst = %rcx, p = %r8
.body_compensation_to:
	// save accumulator of loop_body
	movq	%rdx, %r10
	// lo := (alo-a)/8
	subq	%r9, %rax
	shrq	$3, %rax
	// hi := (ahi-a)/8
	subq	%r9, %rsi
	shrq	$3, %rsi
	// store hi in third argument slot
	movq	%rsi, %rdx
	// store lo in second argument slot
	movq	%rax, %rsi
	// store a in first argument slot
	movq	%r9, %rdi
.plus_reduce_array_try_promote:
	pushq	%r10
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movq	%rsp, %rdx
	pushq	%rcx
	movq	%rsp, %rcx
	pushq	%r8
	subq	$8, %rsp
	call	plus_reduce_array_interrupt_promote
	addq	$8, %rsp
	popq	%r8
	popq	%rcx
	popq	%rdx
	popq	%rsi
	popq	%rdi
	popq	%r10
// a = %rdi, lo = %rsi, hi = %rdi, dst = %rcx, p = %r8
plus_reduce_array_from:
	movq	%rdi, %r9
	leaq	(%r9,%rsi,8), %rax
	leaq	(%r9,%rdx,8), %rsi
	movq	%r10, %rdx
	jmp	.loop_body
	.ident	"GCC: (GNU) 7.4.0"
	.section	.note.GNU-stack,"",@progbits
