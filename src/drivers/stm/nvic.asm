	.equ nvic,			0xE000E000
@;	TIMER
	.equ TIM2IRQ,		28
	.equ TIM3IRQ,		29
	.equ TIM4IRQ,		30
	
	.macro nvic_timer_init irq
	mov.w	r1, (1<<\irq)
	mov.w	r2, (\irq>>5)
	ldr		r3, =nvic
	add.w	r2, r3, r2, lsl #2
	str.w	r1, [r2, #0x100]	@;NVIC_ISER0
	.endm
