	.equ PA,			0x40020000
	.equ PB,			0x40020400
	.equ PC,			0x40020800
	.equ PD,			0x40020c00

	.macro gpio_init_unit value port ofs bit
	.if \value == _
	.else
		ldr	r1, [r2, \ofs]
		.if \value == 1
			orr.w	r1, r1, \bit
		.else @; value == 0
			bic.w	r1, r1, \bit
		.endif
		str	r1, [r2, \ofs]
	.endif
	.endm

	.macro gpio_init port pin moder1 moder0 otyper ospeeder1 ospeeder0 pupdr1 pupdr0
	ldr r2, =\port
	gpio_init_unit \moder1 		\port 0 1<<(\pin<<1+1)	
	gpio_init_unit \moder0 		\port 0 1<<(\pin<<1)		
	gpio_init_unit \otyper 		\port 4 1<<\pin			
	gpio_init_unit \ospeeder1	\port 8 1<<(\pin<<1+1)	
	gpio_init_unit \ospeeder0	\port 8 1<<(\pin<<1)	
	gpio_init_unit \pupdr1 		\port 12 1<<(\pin<<1+1)	
	gpio_init_unit \pupdr0 		\port 12 1<<(\pin<<1)	
	.endm

	
	.macro set_bit port bit
	ldr		r2, =\port
	ldr		r3, =\bit
	str		r3, [r2, #0x18]
	.endm

	.macro reset_bit port bit
	ldr		r2, =\port
	ldr		r3, =\bit
	lsls	r3, #16
	str		r3, [r2, #0x18]
	.endm

	.macro read_bit port bit
	ldr 	r1, =\port
	ldr 	r0, [r1, #0x10]
	tst 	r0, \bit
	bne 	1f
	movs 	r0, #0
	b 		2f
1:
	movs	r0, #1
2:
	.endm
