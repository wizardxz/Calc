	.equ SYSTICK,	0xE000E010

	.macro systick_init frequency
	@;SYST_RVR = SysTick_RVR_RELOAD(frequency);
	mov.w	r3, \systickport_L
	movt	r3, \systickport_H
	ldr		r2, =\frequency
	str		r2,	[r3, #4]
	
	@;SYST_CVR = SysTick_CVR_CURRENT(0);
	movs	r2, #0
	str		r2, [r3, #8]
	
	@;SYST_CSR |= SysTick_CSR_ENABLE_MASK | SysTick_CSR_TICKINT_MASK | SysTick_CSR_CLKSOURCE_SHIFT;
	ldr		r2, [r3]
	movs	r1, #3
	orrs	r2, r1
	str		r2, [r3]
	.endm
