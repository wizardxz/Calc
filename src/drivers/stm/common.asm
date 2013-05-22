	.macro set_reg base offset pin bits value wo=0
	ldr		r1, =\base
	.if \wo == 0
		ldr		r2, [r1, \offset]
		bic		r2, \bits
		orr.w	r2, \value<<\pin
	.else
		mov.w	r2, \value<<\pin
	.endif
	str		r2, [r1, \offset]
	.endm

	.macro set_reg_n base offset width n value wo=0
	.if \value == _
	.else
		ldr		r1, =\base
		.if \wo == 0
			ldr		r2, [r1, \offset]
			bic.w	r2, r2, (1<<\width-1)<<(\n*\width)
			orr.w	r2, r2, \value<<(\n*\width)
		.else
			mov.w	r2, \value<<(\n*\width)
		.endif
		str		r2, [r1, \offset]
	.endif
	.endm

	.macro read_reg base offset pin
	ldr		r1, =\base
	ldr 	r0, [r1, \offset]
	tst 	r0, (1<<\pin)
	bne 	1f
	movs 	r0, #0
	b 		2f
1:
	movs	r0, #1
2:
	.endm
	
	.macro read_bit_n base offset n
	ldr		r1, =\base
	ldr 	r0, [r1, \offset]
	tst 	r0, (1<<\n)
	bne 	1f
	movs 	r0, #0
	b 		2f
1:
	movs	r0, #1
2:
	.endm
