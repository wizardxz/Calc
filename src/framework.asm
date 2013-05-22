@;Problem1.asm wmh 2013-02-01 : structure of .asm file with link to main()

@; --- characterize target syntax, processor
	.syntax unified				@; ARM Unified Assembler Language (UAL). 
								@; Code written using UAL can be assembled 
								@; for ARM, Thumb-2, or pre-Thumb-2 Thumb
	.thumb						@; Use thmb instructions only

@; --- bss
	.bss
	
	.global number				
number:				.word 0, 0, 0, 0
	.global number_cursor		
number_cursor:		.word 0
	.global led					
led:				.word 0, 0, 0, 0, 0, 0
	.global led_cursor			
led_cursor:			.word 0
	.global button_state		
button_state:		.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.global prev_button_state	
prev_button_state:	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.global switch_up_event
switch_up_event:	.word 0
	.global switch_down_event
switch_down_event:	.word 0
	.global rotary_cw_event
rotary_cw_event:	.word 0
	.global rotary_ccw_event
rotary_ccw_event:	.word 0

	.include "src/drivers/stm/common.asm"
	.include "src/drivers/stm/rcc.asm"
	.include "src/drivers/stm/gpio.asm"
	.include "src/drivers/stm/nvic.asm"
	.include "src/drivers/stm/timer.asm"
	.include "src/drivers/stm/exti.asm"

	
@; --- begin code memory
	.text						@;start the code section

	
	.global tim_init
	.thumb_func
tim_init:
	push {lr}
	set_reg RCC RCC_APB1ENR RCC_APB1ENR_TIM2EN_pin RCC_APB1ENR_TIM2EN_bits 1
	timer_init TIM2,(1<<5),(1<<5)
	set_reg_n NVIC,NVIC_ISER,NVIC_ISER_width,NVIC_TIM2IRQ,1 @; Enable tim2 nvic
	set_reg TIM2,TIM_CR1,TIM_CR1_CEN_pin,TIM_CR1_CEN_bits,1	@; Enable counter
	
	pop {lr}
	bx LR

	.global TIM2_IRQHandler
	.thumb_func
TIM2_IRQHandler:
	push 	{lr}
	ldr		r0, =TIM2 		@; If update flag is set
	ldrh	r0, [r0, #16]
	tst.w	r0, #1
	beq		TIM2_IRQHandler_complete

	bl 		update_number
	bl 		refresh_number
	bl 		update_led
	bl 		refresh_led

TIM2_IRQHandler_complete:
	set_reg TIM2,TIM_SR,TIM_SR_UIF_pin,TIM_SR_UIF_bits,0		@; Clear the update flag
	
	pop 	{lr}
	bx		lr
	
	.global refresh_number
	.thumb_func
refresh_number:
	push 	{r3-r7, lr}
	
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

	pop 	{r3-r7, lr}
	bx 		lr	

	.global refresh_led
	.thumb_func
refresh_led:
	push 	{r3-r7, lr}
	
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
	blt 	refresh_led_over1
	subs 	r1, r1, #6
refresh_led_over1:
	str 	r1, [r0]

	pop 	{r3-r7, lr}
	bx 		lr

	.macro switch_handler_unit get_switch_func num
	bl 		\get_switch_func
	ldr 	r1, =button_state
	str 	r0, [r1, \num<<2]
	ldr 	r1, =prev_button_state
	ldr 	r0, [r1, \num<<2]
	ldr 	r1, =button_state
	ldr 	r1, [r1, \num<<2]
	cmp 	r0, r1
	beq 	1f
	blt 	2f
	movs 	r0, \num
	ldr 	r3, =switch_up_event
	ldr 	r3, [r3]
	blx 	r3
	b 		1f
2:
	mov 	r0, \num
	ldr 	r3, =switch_down_event
	ldr 	r3, [r3]
	blx 	r3
	
1:
	ldr 	r1, =button_state
	ldr 	r0, [r1, \num<<2]
	ldr 	r1, =prev_button_state
	str 	r0, [r1, \num<<2]

	.endm

	.global switch_handler
	.thumb_func
switch_handler:
	push 	{r3-r7, lr}
	set_reg TIM2,TIM_CR1,TIM_CR1_CEN_pin,TIM_CR1_CEN_bits,0	@; Disable counter

	switch_handler_unit get_s1 0
	switch_handler_unit get_s2 1
	switch_handler_unit get_s3 2
	switch_handler_unit get_s4 3
	switch_handler_unit get_s5 4
	switch_handler_unit get_s6 5
	switch_handler_unit get_s7 6
	switch_handler_unit get_s8 7
	switch_handler_unit get_s9 8
	switch_handler_unit get_s10 9
	switch_handler_unit get_s11 10
	switch_handler_unit get_s12 11
	
	set_reg TIM2,TIM_CR1,TIM_CR1_CEN_pin,TIM_CR1_CEN_bits,1	@; Enable counter

	pop 	{r3-r7, lr}
	bx 		lr

@;	.global timer_on
@;	.thumb_func
@;timer_on:
@;	set_reg TIM2,TIM_CR1,TIM_CR1_CEN_pin,TIM_CR1_CEN_bits,1	@; Enable counter
@;	bx lr
@;
@;	.global timer_off
@;	.thumb_func
@;timer_off:
@;	set_reg TIM2,TIM_CR1,TIM_CR1_CEN_pin,TIM_CR1_CEN_bits,0	@; Disable counter
@;	bx lr
	
	
	.global EXTI15_10_IRQHandler
	.thumb_func
EXTI15_10_IRQHandler:
	push {lr}
	read_bit_n EXTI, EXTI_PR, 12
	cmp 	r0, 0
	beq 	1f
	mov.w	r1, (1<<12)
2:	subs	r1, #1
	bne		2b
	read_bit_n GPIOC, GPIO_IDR, 12
	cmp		r0, #1
	bne		3f
	read_bit_n GPIOB, GPIO_IDR, 5
	cmp		r0, #0
	bne		4f
	
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
	
3:	set_reg_n EXTI, EXTI_PR, EXTI_PR_width, 12, 1, 1

1:	pop {lr}
	bx lr

	.global test1
	.thumb_func
test1:
	push {lr}
	read_bit_n EXTI, EXTI_PR, 12
	pop {lr}
	bx lr
	
	.global test2
	.thumb_func
test2:
	push {lr}
	mov.w	r1, (1<<12)
2:	subs	r1, #1
	bne		2b
	pop {lr}
	bx lr

	.global test3
	.thumb_func
test3:
	push {lr}
	read_bit_n GPIOC, GPIO_IDR, 12
	pop {lr}
	bx lr
	
	.global test4
	.thumb_func
test4:
	push {lr}
	read_bit_n GPIOB, GPIO_IDR, 5
	pop {lr}
	bx lr

	.global test5
	.thumb_func
test5:
	push {lr}
	set_reg_n EXTI, EXTI_PR, EXTI_PR_width, 12, 1, 1
	pop {lr}
	bx lr
	