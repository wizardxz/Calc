
	.syntax unified				@; ARM Unified Assembler Language (UAL). 
								@; Code written using UAL can be assembled 
								@; for ARM, Thumb-2, or pre-Thumb-2 Thumb
	.thumb						@; Use thmb instructions only

	.include "src/drivers/stm/common.asm"
	.include "src/drivers/stm/rcc.asm"
	.include "src/drivers/stm/gpio.asm"
	.include "src/drivers/stm/exti.asm"
	.include "src/drivers/stm/syscfg.asm"
	.include "src/drivers/stm/nvic.asm"
	

	.equ ROT_A_base,	GPIOC;	.equ ROT_A_pin,	12
	.equ ROT_B_base,	GPIOB;	.equ ROT_B_pin,	5
	
@; --- begin code memory
	.text						@;start the code section

@;Initialize rotary encoder, set RCC, GPIO and EXTI
def rotary_init
	push {lr}
	set_reg RCC RCC_AHB1ENR RCC_AHB1ENR_GPIOBEN_pin RCC_AHB1ENR_GPIOBEN_bits 1		@;Enable GPIOB
	set_reg RCC RCC_AHB1ENR RCC_AHB1ENR_GPIOCEN_pin RCC_AHB1ENR_GPIOCEN_bits 1		@;Enable GPIOC
	set_reg RCC RCC_APB2ENR RCC_APB2ENR_SYSCFGEN_pin RCC_APB2ENR_SYSCFGEN_bits 1	@;Enable SYSCFG
	
	set_reg_n SYSCFG, SYSCFG_EXTICR+(12/4)*4, SYSCFG_EXTICR_width, 12%12, 2
	set_reg_n EXTI, EXTI_IMR, EXTI_IMR_width, 12, 1									@;Enable software interrupt
	set_reg_n EXTI, EXTI_EMR, EXTI_EMR_width, 12, 0
	set_reg_n EXTI, EXTI_RTSR, EXTI_RTSR_width, 12, 1								@;We are interested in rising
	set_reg_n EXTI, EXTI_FTSR, EXTI_RTSR_width, 12, 0
	set_reg_n NVIC, NVIC_ISER+4, NVIC_ISER_width, EXTI15_10_IRQ-32, 1 				@;Enable NVIC
	set_reg_n EXTI, EXTI_SWIER, EXTI_SWIER_width, 12, 1								@;Generate interrupt request
	
	gpio_enable GPIOC,12,0,_,_,1	@;moder=input, pupd=pullup
	gpio_enable GPIOB,5,0,_,_,1		@;moder=input, pupd=pullup
		
	pop {lr}
	bx lr

	
