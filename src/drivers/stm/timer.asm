	.equ TIM2, 0x40000000
	.equ TIM3, 0x40000400
	.equ TIM4, 0x40000800

	.macro timer_init port psc arr
	movw	r0, \psc	@; PSC
	ldr		r1, =\port	
	strh	r0, [r1, #40]	
	
	movw	r0, \arr	@; ARR
	str		r0, [r1, #44]	
	
	ldr		r1, =\port	@; Force update
	ldrh	r0, [r1, #20]
	orr.w	r0, r0, #1
	strh	r0, [r1, #20]
	
	ldr		r1, =\port	@; Clear the update flag
	ldrh	r0, [r1, #16]
	bic.w	r0, r0, #1
	strh	r0, [r1, #16]
	
	ldr		r1, =\port	@; Enable interrupt on update event
	ldrh	r0, [r1, #12]
	orr.w	r0, r0, #1
	strh	r0, [r1, #12]
	.endm
	
	.macro timer_enable port
	ldr		r1, =\port @; Enable counter
	ldrh	r0, [r1, #0]
	orr.w	r0, r0, #1
	strh	r0, [r1, #0]
	.endm
