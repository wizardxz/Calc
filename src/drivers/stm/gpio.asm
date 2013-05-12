	.equ PA,			0x40020000
	.equ PB,			0x40020400
	.equ PC,			0x40020800
	.equ PD,			0x40020c00

	.macro gpio_init_unit port pin num value ofs
	.if \value == _
	.else
		ldr 	r2, =\port
		ldr		r3, [r2, \ofs]
		bic.w	r3, r3, (1<<\num-1)<<(\pin*\num)
		orr.w	r3, r3, \value<<(\pin*\num)
		str		r3, [r2, \ofs]
	.endif
	.endm

	.macro gpio_init port pin moder otyper ospeeder pupdr
	gpio_init_unit \port \pin 2 \moder 0
	gpio_init_unit \port \pin 1 \otyper 4
	gpio_init_unit \port \pin 2 \ospeeder 8
	gpio_init_unit \port \pin 2 \pupdr 12
	.endm

	
	.macro set_bit port pin
	ldr		r2, =\port
	ldr		r3, =(1<<\pin)			@;bsrr low
	str		r3, [r2, #0x18]
	.endm

	.macro reset_bit port pin
	ldr		r2, =\port
	ldr		r3, =(1<<(\pin+16))		@;bsrr high
	str		r3, [r2, #0x18]
	.endm

	.macro read_bit port pin
	ldr 	r1, =\port
	ldr 	r0, [r1, #0x10]
	tst 	r0, (1<<\pin)
	bne 	1f
	movs 	r0, #0
	b 		2f
1:
	movs	r0, #1
2:
	.endm
	
	.macro gpio_af_conf port pin af
	ldr 	r2, =\port
	orr.w	r3, r3, \af<<((\pin%8)*4)
	str		r3, [r2, #0x20+\pin/8*4]
	.endm
