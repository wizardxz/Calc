	.equ RCC,			0x40023830
	.equ RCCAbit, 		(1<<0)
	.equ RCCBbit, 		(1<<1)
	.equ RCCCbit, 		(1<<2)
	.equ RCCDbit, 		(1<<3)
	
	.macro enable_gpio bit
	ldr 	r2, =RCC
	ldr		r1, [r2, #0]
	orr.w	r1, r1, \bit
	str		r1, [r2, #0]
	.endm
	
	