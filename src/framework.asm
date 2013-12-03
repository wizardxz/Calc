@;Problem1.asm wmh 2013-02-01 : structure of .asm file with link to main()

@; --- characterize target syntax, processor
	.syntax unified				@; ARM Unified Assembler Language (UAL). 
								@; Code written using UAL can be assembled 
								@; for ARM, Thumb-2, or pre-Thumb-2 Thumb
	.thumb						@; Use thmb instructions only

@; --- bss
	.bss
	
	@;Global variable definition macro
	.macro var name size
	.global \name
\name:	.space \size*4, 0
	.endm
	
	var number,4				@;4 number displayed on displayer
	var number_cursor,1			@;the number we want to refresh at the moment
	var point,4					@;4 point
	var led,6					@;6 led status
	var led_cursor,1			@;the led we want to refresh at the moment
	var button_state,12			@;current button state: 0-up, 1-down
	var prev_button_state,12	@;previous button state
	var switch_up_event,1		@;callback function when switch up
	var switch_down_event,1		@;callback function when switch down
	var rotary_cw_event,1		@;callback function when rotary move clockwise
	var rotary_ccw_event,1		@;callback function when rotary move counter-clockwise
	
	var cursor_timer,1			@;count times when present tones: -1 means disabled
	var cursor_status,1			@;cursor status
	
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
	timer_init TIM2,(1<<8),24								@; frequency=96MHz/4/256/24/4=1KHz
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
	bl		cursor_handler
	pop {lr}
	bx LR
	
@; number and LED refresh requires TIM2
def TIM2_IRQHandler
	push 	{lr}
	test_reg TIM2,TIM_SR,TIM_SR_UIF_bits,TIM_SR_UIF_bits		@;test if UIF is on
	bne		1f

	bl 		update_number
	bl 		refresh_number
	bl 		update_led
	bl 		refresh_led

1:	set_reg TIM2,TIM_SR,TIM_SR_UIF_pin,TIM_SR_UIF_bits,0		@; Clear the update flag
	pop 	{lr}
	bx		lr
	
@; Refresh number
@; write current number and increase number_cursor
def refresh_number
	push 	{lr}
	
	ldr 	r0, =number_cursor
	ldr 	r1, [r0]					@;read number_cursor
	
	ldr 	r2, =number
	adds	r2, r2, r1, lsl #2
	ldr 	r0, [r2]					@;read current number
	
	ldr		r2, =point
	adds	r2, r2, r1, lsl #2
	ldr 	r2, [r2]					@;read current point
	cmp		r2, #1
	beq		1f
	bl 		write_digit
	b		2f
1:	bl		write_digit_with_dot
2:

	@;update cursor
	ldr 	r0, =number_cursor
	ldr 	r1, [r0]
	adds 	r1, #1
	bics 	r1, r1, ~3
	str 	r1, [r0]

	pop 	{lr}
	bx 		lr	

@; Refresh LED
@; write current LED and increase led_cursor
def refresh_led
	push 	{lr}
	
	ldr 	r0, =led_cursor
	ldr 	r1, [r0]					@;read led_cursor
	
	ldr		r2, =led
	adds	r2, r2, r1, lsl #2
	ldr		r0, [r2]					@;read led
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

@; Handle one switch
	.macro switch_handler_unit num
	movs 	r0, \num
	bl		test_sw						
	beq		1f
	movs	r0, #0
	bl		2f
1:	movs	r0, #1						@;read sw and store result in r0
2:
	ldr 	r1, =button_state
	str 	r0, [r1, \num*4]			@;store button state
	ldr 	r1, =prev_button_state
	ldr 	r0, [r1, \num*4]			@;read prev button state
	ldr 	r1, =button_state
	ldr 	r1, [r1, \num*4]			@;read button state
	cmp 	r0, r1						@;compare current and prev state
	beq 	1f
	blt 	2f
	movs 	r0, \num
	ldr 	r3, =switch_down_event		@;trigger switch down event
	ldr 	r3, [r3]
	blx 	r3
	b 		1f
2:
	mov 	r0, \num
	ldr 	r3, =switch_up_event		@;trigger switch up event
	ldr 	r3, [r3]
	blx 	r3
	
1:
	ldr 	r1, =button_state
	ldr 	r0, [r1, \num*4]
	ldr 	r1, =prev_button_state
	str 	r0, [r1, \num*4]			@;update prev button state

	.endm

@; Handle all switches
def switch_handler
	push 	{lr}
	set_reg TIM2,TIM_CR1,TIM_CR1_CEN_pin,TIM_CR1_CEN_bits,0	@; Disable TIM2

	.irp num,0,1,2,3,4,5,6,7,8,9,10,11
		switch_handler_unit \num
	.endr
	
	set_reg TIM2,TIM_CR1,TIM_CR1_CEN_pin,TIM_CR1_CEN_bits,1	@; Enable TIM2

	pop 	{lr}
	bx 		lr

@; Handle rotate encoder event
def EXTI15_10_IRQHandler
	push {lr}
	test_reg EXTI,EXTI_PR,(1<<12)		@;test EXTI line 12
	bne 	1f
	mov.w	r1, (1<<12)					@;delay 2048 cycles for de-bounce
2:	subs	r1, #1
	bne		2b
	test_reg GPIOC,GPIO_IDR,(1<<12)		@;read PC12 again
	bne		3f
	test_reg GPIOB,GPIO_IDR,(1<<5)		@;read PB5 decide ccw or cw
	beq		4f
	
	ldr 	r3, =rotary_cw_event		@;trigger rotary_cw_event
	cmp		r3, #0
	beq		3f
	ldr 	r3, [r3]
	blx 	r3
	b		3f

4:	ldr 	r3, =rotary_ccw_event		@;trigger rotary_ccw_event
	cmp		r3, #0
	beq		3f
	ldr 	r3, [r3]
	blx 	r3
	
3:	set_reg_n EXTI, EXTI_PR, EXTI_PR_width, 12, 1	@;clear EXTI PR 12

1:	pop {lr}
	bx lr

	