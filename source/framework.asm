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
.global number_start		
number_start:		.word 0
.global led					
led:				.word 0, 0, 0, 0, 0, 0
.global led_start			
led_start:			.word 0
.global button_state		
button_state:		.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
.global prev_button_state	
prev_button_state:	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
.global switch_up_event		
switch_up_event:	.word 0
.global switch_down_event	
switch_down_event:	.word 0

	.equ systickport, 0xE000E010
	.equ systickfreq,	1000
	
@; --- begin code memory
	.text						@;start the code section

	.global systick_init
	.thumb_func
systick_init:
	push {lr}
	@;SYST_RVR = SysTick_RVR_RELOAD(1000);
	ldr		r3, =systickport
	ldr		r2, =systickfreq
	str		r2,	[r3, #4]
	
	@;SYST_CVR = SysTick_CVR_CURRENT(0);
	movs	r2, #0
	str		r2, [r3, #8]
	
	@;SYST_CSR |= SysTick_CSR_ENABLE_MASK | SysTick_CSR_TICKINT_MASK | SysTick_CSR_CLKSOURCE_SHIFT;
	ldr		r2, [r3]
	movs	r1, #3
	orrs	r2, r1
	str		r2, [r3]

	pop {lr}
	bx LR


	.macro refresh_number_unit num
	ldr r3, =number
	ldr r0, [r3, \num<<2]
	mov r1, \num
	bl write_digit
	.endm

	.global refresh_number
	.thumb_func
refresh_number:
	push {r3-r7, lr}
	
	ldr r0, =number_start
	ldr r0, [r0]
refresh_number_from_0:
	cmp r0, #0
	bne refresh_number_from_1
	refresh_number_unit 0
	refresh_number_unit 1
	refresh_number_unit 2
	refresh_number_unit 3
	b refresh_number_over
refresh_number_from_1:
	cmp r0, #1
	bne refresh_number_from_2
	refresh_number_unit 1
	refresh_number_unit 2
	refresh_number_unit 3
	refresh_number_unit 0
	b refresh_number_over
refresh_number_from_2:
	cmp r0, #2
	bne refresh_number_from_3
	refresh_number_unit 2
	refresh_number_unit 3
	refresh_number_unit 0
	refresh_number_unit 1
	b refresh_number_over
refresh_number_from_3:
	refresh_number_unit 3
	refresh_number_unit 0
	refresh_number_unit 1
	refresh_number_unit 2
refresh_number_over:
	ldr r0, =number_start
	ldr r1, [r0]
	adds r1, #1
	bics r1, r1, #4
	str r1, [r0]

	pop {r3-r7, lr}
	bx lr	


	.macro refresh_led_unit num
	ldr r3, =led
	ldr r1, [r3, \num<<2]
	cmp r1, #0
	beq 1f
	mov r0, \num
	subs r1, #1
	bl write_led
1:
	.endm

	.global refresh_led
	.thumb_func
refresh_led:
	push {r3-r7, lr}
	
	ldr r0, =led_start
	ldr r0, [r0]
refresh_led_from_0:
	cmp r0, #0
	bne refresh_led_from_1
	refresh_led_unit 0
	refresh_led_unit 1
	refresh_led_unit 2
	refresh_led_unit 3
	refresh_led_unit 4
	refresh_led_unit 5
	b refresh_led_over
refresh_led_from_1:
	cmp r0, #1
	bne refresh_led_from_2
	refresh_led_unit 1
	refresh_led_unit 2
	refresh_led_unit 3
	refresh_led_unit 4
	refresh_led_unit 5
	refresh_led_unit 0
	b refresh_led_over
refresh_led_from_2:
	cmp r0, #1
	bne refresh_led_from_3
	refresh_led_unit 2
	refresh_led_unit 3
	refresh_led_unit 4
	refresh_led_unit 5
	refresh_led_unit 0
	refresh_led_unit 1
	b refresh_led_over
refresh_led_from_3:
	cmp r0, #1
	bne refresh_led_from_4
	refresh_led_unit 3
	refresh_led_unit 4
	refresh_led_unit 5
	refresh_led_unit 0
	refresh_led_unit 1
	refresh_led_unit 2
	b refresh_led_over
refresh_led_from_4:
	cmp r0, #1
	bne refresh_led_from_5
	refresh_led_unit 4
	refresh_led_unit 5
	refresh_led_unit 0
	refresh_led_unit 1
	refresh_led_unit 2
	refresh_led_unit 3
	b refresh_led_over
refresh_led_from_5:
	refresh_led_unit 5
	refresh_led_unit 0
	refresh_led_unit 1
	refresh_led_unit 2
	refresh_led_unit 3
	refresh_led_unit 4

refresh_led_over:
	ldr r0, =led_start
	ldr r1, [r0]
	adds r1, #1
	cmp r1, #6
	blt refresh_led_over1
	subs r1, r1, #6
refresh_led_over1:
	str r1, [r0]

	pop {r3-r7, lr}
	bx lr

	.macro switch_handler_unit get_switch_func num
	bl \get_switch_func
	ldr r1, =button_state
	str r0, [r1, \num<<2]
	ldr r1, =prev_button_state
	ldr r0, [r1, \num<<2]
	ldr r1, =button_state
	ldr r1, [r1, \num<<2]
	cmp r0, r1
	beq 1f
	blt 2f
	mov r0, \num
	ldr r3, =switch_up_event
	ldr r3, [r3]
	blx r3
	b 1f
2:
	mov r0, \num
	ldr r3, =switch_down_event
	ldr r3, [r3]
	blx r3
	
1:
	ldr r1, =button_state
	ldr r0, [r1, \num<<2]
	ldr r1, =prev_button_state
	str r0, [r1, \num<<2]

	.endm

	.global switch_handler
	.thumb_func
switch_handler:
	push {r3-r7, lr}
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
	pop {r3-r7, lr}
	bx lr
