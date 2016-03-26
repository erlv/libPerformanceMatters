	.file	"loop_index_increase_decrease.c"
	.text
	.p2align 4,,15
	.globl	foo1_0
	.type	foo1_0, @function
foo1_0:
.LFB0:
	.cfi_startproc
	pxor	%xmm0, %xmm0
	movl	$a, %eax
	pxor	%xmm4, %xmm4
	.p2align 4,,10
	.p2align 3
.L3:
	movdqa	(%rax), %xmm1
	movdqa	%xmm4, %xmm2
	addq	$16, %rax
	pcmpgtd	%xmm1, %xmm2
	movdqa	%xmm1, %xmm5
	cmpq	$a+4000, %rax
	punpckldq	%xmm2, %xmm5
	punpckhdq	%xmm2, %xmm1
	paddq	%xmm5, %xmm0
	paddq	%xmm1, %xmm0
	jne	.L3
	movdqa	%xmm0, %xmm6
	psrldq	$8, %xmm6
	paddq	%xmm6, %xmm0
	movdqa	%xmm0, -24(%rsp)
	movq	-24(%rsp), %rax
	ret
	.cfi_endproc
.LFE0:
	.size	foo1_0, .-foo1_0
	.p2align 4,,15
	.globl	foo1_1
	.type	foo1_1, @function
foo1_1:
.LFB1:
	.cfi_startproc
	pxor	%xmm0, %xmm0
	movl	$a, %eax
	pxor	%xmm4, %xmm4
	.p2align 4,,10
	.p2align 3
.L7:
	movdqa	(%rax), %xmm1
	movdqa	%xmm4, %xmm2
	addq	$16, %rax
	pcmpgtd	%xmm1, %xmm2
	movdqa	%xmm1, %xmm5
	cmpq	$a+4000, %rax
	punpckldq	%xmm2, %xmm5
	punpckhdq	%xmm2, %xmm1
	paddq	%xmm5, %xmm0
	paddq	%xmm1, %xmm0
	jne	.L7
	movdqa	%xmm0, %xmm6
	psrldq	$8, %xmm6
	paddq	%xmm6, %xmm0
	movdqa	%xmm0, -24(%rsp)
	movq	-24(%rsp), %rax
	ret
	.cfi_endproc
.LFE1:
	.size	foo1_1, .-foo1_1
	.p2align 4,,15
	.globl	foo2_0
	.type	foo2_0, @function
foo2_0:
.LFB2:
	.cfi_startproc
	pxor	%xmm0, %xmm0
	movl	$a+3984, %eax
	pxor	%xmm4, %xmm4
	.p2align 4,,10
	.p2align 3
.L10:
	pshufd	$27, (%rax), %xmm1
	movdqa	%xmm4, %xmm2
	subq	$16, %rax
	cmpq	$a-16, %rax
	pcmpgtd	%xmm1, %xmm2
	movdqa	%xmm1, %xmm5
	punpckhdq	%xmm2, %xmm1
	punpckldq	%xmm2, %xmm5
	paddq	%xmm5, %xmm0
	paddq	%xmm1, %xmm0
	jne	.L10
	movdqa	%xmm0, %xmm6
	psrldq	$8, %xmm6
	paddq	%xmm6, %xmm0
	movdqa	%xmm0, -24(%rsp)
	movq	-24(%rsp), %rax
	ret
	.cfi_endproc
.LFE2:
	.size	foo2_0, .-foo2_0
	.p2align 4,,15
	.globl	foo2_2
	.type	foo2_2, @function
foo2_2:
.LFB3:
	.cfi_startproc
	pxor	%xmm0, %xmm0
	movl	$a+3984, %eax
	pxor	%xmm4, %xmm4
	.p2align 4,,10
	.p2align 3
.L13:
	pshufd	$27, (%rax), %xmm1
	movdqa	%xmm4, %xmm2
	subq	$16, %rax
	cmpq	$a-16, %rax
	pcmpgtd	%xmm1, %xmm2
	movdqa	%xmm1, %xmm5
	punpckhdq	%xmm2, %xmm1
	punpckldq	%xmm2, %xmm5
	paddq	%xmm5, %xmm0
	paddq	%xmm1, %xmm0
	jne	.L13
	movdqa	%xmm0, %xmm6
	psrldq	$8, %xmm6
	paddq	%xmm6, %xmm0
	movdqa	%xmm0, -24(%rsp)
	movq	-24(%rsp), %rax
	ret
	.cfi_endproc
.LFE3:
	.size	foo2_2, .-foo2_2
	.comm	a,4000,32
	.ident	"GCC: (Ubuntu 4.8.4-2ubuntu1~14.04.1) 4.8.4"
	.section	.note.GNU-stack,"",@progbits
