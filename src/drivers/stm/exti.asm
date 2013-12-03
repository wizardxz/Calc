	.equ EXTI,	0x40013C00
	
	@;IMR
	.equ EXTI_IMR, 0x00
	.equ EXTI_IMR_width, 1

	@;EMR
	.equ EXTI_EMR, 0x04
	.equ EXTI_EMR_width, 1

	@;RTSR
	.equ EXTI_RTSR, 0x08
	.equ EXTI_RTSR_width, 1

	@;FTSR
	.equ EXTI_FTSR, 0x0C
	.equ EXTI_FTSR_width, 1
	
	@;SWIER
	.equ EXTI_SWIER, 0x10
	.equ EXTI_SWIER_width, 1
	
	@;PR
	.equ EXTI_PR, 0x14
	.equ EXTI_PR_width, 1
	