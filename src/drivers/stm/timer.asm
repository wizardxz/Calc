	.equ TIM2,		0x40000000
	.equ TIM3,		0x40000400
	.equ TIM4,		0x40000800

	@;TIMx_CR1
	.equ	TIM_CR1, 0x00
	.equ	TIM_CR1_CEN_pin, 0;	.equ TIM_CR1_CEN_bits, (1<<TIM_CR1_CEN_pin)

	@;TIMx_DIER
	.equ	TIM_DIER, 0x0C
	.equ	TIM_DIER_UIE_pin, 0;	.equ TIM_DIER_UIE_bits, (1<<TIM_DIER_UIE_pin)
	
	@;TIMx_SR
	.equ	TIM_SR, 0x10
	.equ	TIM_SR_UIF_pin, 0;	.equ TIM_SR_UIF_bits, (1<<TIM_SR_UIF_pin)
	
	@;TIMx_EGR
	.equ	TIM_EGR, 0x14
	.equ	TIM_EGR_UG_pin, 0;	.equ TIM_EGR_UG_bits, (1<<TIM_EGR_UG_pin)
	
	@;TIMx_PSC
	.equ	TIM_PSC, 0x28
	.equ	TIM_PSC_PSC_pin, 0;	.equ TIM_PSC_PSC_bits, ((1<<16)<<TIM_PSC_PSC_pin)
	
	@;TIMx_ARR
	.equ	TIM_ARR, 0x2C
	.equ	TIM_ARR_ARR_pin, 0;	.equ TIM_ARR_ARR_bits, ((1<<16)<<TIM_ARR_ARR_pin)
	
	
	.macro timer_init base psc arr
	set_reg \base,TIM_PSC,TIM_PSC_PSC_pin,TIM_PSC_PSC_bits,\psc,only_set
	set_reg \base,TIM_ARR,TIM_ARR_ARR_pin,TIM_ARR_ARR_bits,\arr,only_set
	set_reg \base,TIM_EGR,TIM_EGR_UG_pin,TIM_EGR_UG_bits,1		@; Force update
	set_reg \base,TIM_SR,TIM_SR_UIF_pin,TIM_SR_UIF_bits,0		@; Clear the update flag
	set_reg \base,TIM_DIER,TIM_DIER_UIE_pin,TIM_DIER_UIE_bits,1	@; Enable interrupt on update event
	.endm
	
