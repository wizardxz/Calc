	.equ RCC,			0x40023800
	@;GPIO
	.equ RCCAbit, 		(1<<0)
	.equ RCCBbit, 		(1<<1)
	.equ RCCCbit, 		(1<<2)
	.equ RCCDbit, 		(1<<3)
	@;TIMER
	.equ TIM2bit,		(1<<0)
	.equ TIM3bit,		(1<<1)
	.equ TIM4bit,		(1<<2)
	
	
	.macro rcc_gpio_init bit
	ldr 	r2, =RCC
	ldr		r1, [r2, #0x30]
	orr.w	r1, r1, \bit
	str		r1, [r2, #0x30]
	.endm
	
	.macro rcc_timer_init bit
	ldr 	r2, =RCC
	ldr		r1, [r2, #0x40]
	orr.w	r1, r1, \bit
	str		r1, [r2, #0x40]
	.endm
	