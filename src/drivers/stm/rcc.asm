	.equ RCC,			0x40023800
	@;GPIO
	.equ RCCApin, 		0
	.equ RCCBpin, 		1
	.equ RCCCpin, 		2
	.equ RCCDpin, 		3
	@;TIMER
	.equ TIM2pin,		0
	.equ TIM3pin,		1
	.equ TIM4pin,		2
	
	
	.macro rcc_gpio_init pin
	ldr 	r2, =RCC
	ldr		r1, [r2, #0x30]
	orr.w	r1, r1, (1<<\pin)
	str		r1, [r2, #0x30]
	.endm
	
	.macro rcc_timer_init pin
	ldr 	r2, =RCC
	ldr		r1, [r2, #0x40]
	orr.w	r1, r1, (1<<\pin)
	str		r1, [r2, #0x40]
	.endm
	