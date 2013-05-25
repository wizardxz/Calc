	.macro set_reg base offset pin bits value mode=load_and_set
	ldr		r1, =\base
	.if \mode == load_and_set
		ldr		r2, [r1, \offset]
		ldr		r3, =\bits
		bic.w	r2, r3
		ldr		r3, =\value<<\pin
		orr.w	r2, r3
	.elseif \mode == only_set
		ldr		r2, =\value
		lsls	r2, r2, \pin
	.endif
	str		r2, [r1, \offset]
	.endm

	.macro set_reg_n base offset width n value mode=load_and_set
	.if \value == _
	.else
		ldr		r1, =\base
		.if \mode == load_and_set
			ldr		r2, [r1, \offset]
			bic.w	r2, r2, (1<<\width-1)<<(\n*\width)
			orr.w	r2, r2, \value<<(\n*\width)
		.elseif \mode == only_set
			mov.w	r2, \value<<(\n*\width)
		.endif
		str		r2, [r1, \offset]
	.endif
	.endm

	.macro test_reg base offset bits value=default
	ldr		r3, =\base
	ldr 	r2, [r3, \offset]
	ldr		r3, =\bits
	ands	r2, r2, r3
	.if \value == default
		ldr		r3, =\bits
	.else
		ldr		r3, =\value
	.endif
	cmp 	r2, r3
	.endm
	
	.macro def function		@;create a python-like function define
	.global \function
	.thumb_func
\function:
	.endm
	

