	.arch armv5t
	.fpu softvfp
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 2
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"loop_index_increase_decrease.c"
	.text
	.align	2
	.global	foo1_0
	.type	foo1_0, %function
foo1_0:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L5
	add	ip, r3, #4000
.L2:
	ldr	r2, [r3], #4
	adds	r0, r0, r2
	adc	r1, r1, r2, asr #31
	cmp	r3, ip
	bne	.L2
	bx	lr
.L6:
	.align	2
.L5:
	.word	a
	.size	foo1_0, .-foo1_0
	.align	2
	.global	foo1_1
	.type	foo1_1, %function
foo1_1:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L10
	add	ip, r3, #4000
.L8:
	ldr	r2, [r3, #4]!
	adds	r0, r0, r2
	adc	r1, r1, r2, asr #31
	cmp	r3, ip
	bne	.L8
	bx	lr
.L11:
	.align	2
.L10:
	.word	a-4
	.size	foo1_1, .-foo1_1
	.align	2
	.global	foo2_0
	.type	foo2_0, %function
foo2_0:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L15
	sub	ip, r3, #4000
.L13:
	ldr	r2, [r3], #-4
	adds	r0, r0, r2
	adc	r1, r1, r2, asr #31
	cmp	r3, ip
	bne	.L13
	bx	lr
.L16:
	.align	2
.L15:
	.word	a+3996
	.size	foo2_0, .-foo2_0
	.align	2
	.global	foo2_2
	.type	foo2_2, %function
foo2_2:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L20
	sub	ip, r3, #4000
.L18:
	ldr	r2, [r3, #-4]!
	adds	r0, r0, r2
	adc	r1, r1, r2, asr #31
	cmp	r3, ip
	bne	.L18
	bx	lr
.L21:
	.align	2
.L20:
	.word	a+4000
	.size	foo2_2, .-foo2_2
	.comm	a,4000,4
	.ident	"GCC: (Ubuntu/Linaro 4.7.3-12ubuntu1) 4.7.3"
	.section	.note.GNU-stack,"",%progbits
