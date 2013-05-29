@;Problem1.asm wmh 2013-02-01 : structure of .asm file with link to main()

@; --- characterize target syntax, processor
	.syntax unified				@; ARM Unified Assembler Language (UAL). 
								@; Code written using UAL can be assembled 
								@; for ARM, Thumb-2, or pre-Thumb-2 Thumb
	.thumb						@; Use thmb instructions only

@; --- bss
	.bss
	
	.macro var name size
	.global \name
\name:	.space \size*4, 0
	.endm
	
	var number,4
	var number_cursor,1
	var led,6
	var led_cursor,1
	var button_state,12
	var prev_button_state,12
	var switch_up_event,1
	var switch_down_event,1
	var rotary_cw_event,1
	var rotary_ccw_event,1
	
	var present_tones_timer,1
	var present_tones_status,1
	
	var review_timer,1
	var review_status,1
	var review_warning_timer,1
	var review_warning_status,1

	.include "src/drivers/stm/common.asm"
	.include "src/drivers/stm/rcc.asm"
	.include "src/drivers/stm/gpio.asm"
	.include "src/drivers/stm/nvic.asm"
	.include "src/drivers/stm/timer.asm"
	.include "src/drivers/stm/exti.asm"
	.include "src/drivers/stm/systick.asm"

	
@; --- begin code memory
	.text						@;start the code section

	
def init
	push {lr}
	@;Set up TIM2
	set_reg RCC,RCC_APB1ENR,RCC_APB1ENR_TIM2EN_pin,RCC_APB1ENR_TIM2EN_bits,1
	timer_init TIM2,(1<<5),(1<<5)
	set_reg_n NVIC,NVIC_ISER,NVIC_ISER_width,NVIC_TIM2IRQ,1 @; Enable tim2 nvic
	set_reg TIM2,TIM_CR1,TIM_CR1_CEN_pin,TIM_CR1_CEN_bits,1	@; Enable counter
	
	@;Set up SYSTICK
	set_reg SYSTICK,STK_LOAD,STK_LOAD_RELOAD_pin,STK_LOAD_RELOAD_bits,(1<<14) @;interval = 1ms
	set_reg SYSTICK,STK_VAL,STK_VAL_CURRENT_pin,STK_VAL_CURRENT_bits,0
	set_reg SYSTICK,STK_CTRL,STK_CTRL_TICKINT_pin,STK_CTRL_TICKINT_bits,1
	set_reg SYSTICK,STK_CTRL,STK_CTRL_CLKSOURCE_pin,STK_CTRL_CLKSOURCE_bits,1
	set_reg SYSTICK,STK_CTRL,STK_CTRL_ENABLE_pin,STK_CTRL_ENABLE_bits,1
	
	pop {lr}
	bx LR

def SysTick_Handler
	push {lr}
	bl		present_tones_handler
	bl		review_handler
@;	ldr		r0, =review_status
@;	ldr		r0,[r0]
@;	cmp		r0,#4
@;	bne		1f
@;	b		main
@;1:
	pop {lr}
	bx LR
	
def TIM2_IRQHandler
	push 	{lr}
	test_reg TIM2,TIM_SR,TIM_SR_UIF_bits,TIM_SR_UIF_bits
	bne		1f

	bl 		update_number
	bl 		refresh_number
	bl 		update_led
	bl 		refresh_led

1:	set_reg TIM2,TIM_SR,TIM_SR_UIF_pin,TIM_SR_UIF_bits,0		@; Clear the update flag
	pop 	{lr}
	bx		lr
	
def refresh_number
	push 	{lr}
	
	ldr 	r0, =number_cursor
	ldr 	r1, [r0]
	
	ldr 	r2, =number
	adds	r2, r2, r1, lsl #2
	ldr 	r0, [r2]
	bl 		write_digit

	@;update cursor
	ldr 	r0, =number_cursor
	ldr 	r1, [r0]
	adds 	r1, #1
	bics 	r1, r1, ~3
	str 	r1, [r0]

	pop 	{lr}
	bx 		lr	

def refresh_led
	push 	{lr}
	
	ldr 	r0, =led_cursor
	ldr 	r1, [r0]
	
	ldr		r2, =led
	adds	r2, r2, r1, lsl #2
	ldr		r0, [r2]
	bl 		write_led

	@;update cursor
	ldr 	r0, =led_cursor
	ldr 	r1, [r0]
	adds 	r1, #1
	cmp 	r1, #6
	blt 	1f
	subs 	r1, r1, #6
1:	str 	r1, [r0]

	pop 	{lr}
	bx 		lr

	.macro switch_handler_unit num
	movs 	r0, \num
	bl		test_sw
	beq		1f
	movs	r0, #0
	bl		2f
1:	movs	r0, #1
2:
	ldr 	r1, =button_state
	str 	r0, [r1, \num*4]
	ldr 	r1, =prev_button_state
	ldr 	r0, [r1, \num*4]
	ldr 	r1, =button_state
	ldr 	r1, [r1, \num*4]
	cmp 	r0, r1
	beq 	1f
	blt 	2f
	movs 	r0, \num
	ldr 	r3, =switch_down_event
	ldr 	r3, [r3]
	blx 	r3
	b 		1f
2:
	mov 	r0, \num
	ldr 	r3, =switch_up_event
	ldr 	r3, [r3]
	blx 	r3
	
1:
	ldr 	r1, =button_state
	ldr 	r0, [r1, \num*4]
	ldr 	r1, =prev_button_state
	str 	r0, [r1, \num*4]

	.endm

def switch_handler
	push 	{lr}
	set_reg TIM2,TIM_CR1,TIM_CR1_CEN_pin,TIM_CR1_CEN_bits,0	@; Disable counter

	.irp num,0,1,2,3,4,5,6,7,8,9,10,11
		switch_handler_unit \num
	.endr
	
	set_reg TIM2,TIM_CR1,TIM_CR1_CEN_pin,TIM_CR1_CEN_bits,1	@; Enable counter

	pop 	{lr}
	bx 		lr

def EXTI15_10_IRQHandler
	push {lr}
	test_reg EXTI,EXTI_PR,(1<<12)
	bne 	1f
	mov.w	r1, (1<<12)
2:	subs	r1, #1
	bne		2b
	test_reg GPIOC,GPIO_IDR,(1<<12)
	bne		3f
	test_reg GPIOB,GPIO_IDR,(1<<5)
	beq		4f
	
	ldr 	r3, =rotary_cw_event
	cmp		r3, #0
	beq		3f
	ldr 	r3, [r3]
	blx 	r3
	b		3f

4:	ldr 	r3, =rotary_ccw_event
	cmp		r3, #0
	beq		3f
	ldr 	r3, [r3]
	blx 	r3
	
3:	set_reg_n EXTI, EXTI_PR, EXTI_PR_width, 12, 1

1:	pop {lr}
	bx lr

	