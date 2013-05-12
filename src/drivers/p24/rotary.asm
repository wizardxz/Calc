
	.syntax unified				@; ARM Unified Assembler Language (UAL). 
								@; Code written using UAL can be assembled 
								@; for ARM, Thumb-2, or pre-Thumb-2 Thumb
	.thumb						@; Use thmb instructions only

	.include "src/drivers/stm/rcc.asm"
	.include "src/drivers/stm/gpio.asm"

	.equ ROT_Aport,	PC
	.equ ROT_Abit,	(1<<12)
	.equ ROT_Bport, PB
	.equ ROT_Bbit,	(1<<5)
	
@; --- begin code memory
	.text						@;start the code section

	.global rotary_init
	.thumb_func
rotary_init:
	push {r3-r7, lr}
	rcc_gpio_init RCCBbit
	rcc_gpio_init RCCCbit

	gpio_init PC 12 0 0 _ _ _ 0 1
	gpio_init PB 5 0 0 _ _ _ 0 1
	
	pop {r3-r7, lr}
	bx lr
	
	.global get_rotary
	.thumb_func
get_rotary:
	push {r3-r7, lr}

	movs 	r4, #0

	read_bit ROT_Aport ROT_Abit
	cmp		r0, #0
	bne 	get_rotary_return

	read_bit ROT_Bport ROT_Bbit
	cmp		r0, #0
	beq 	ccw
cw:
	movs 	r4, #1
	b		wait_until_PC12_reset
ccw:
	movs 	r4, #2

wait_until_PC12_reset:
	read_bit ROT_Aport ROT_Abit
	cmp		r0, #0
	beq		wait_until_PC12_reset
	
get_rotary_return:
	mov 	r0, r4
	
	pop {r3-r7, lr}
	bx lr
	
	

