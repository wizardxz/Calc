
	.syntax unified				@; ARM Unified Assembler Language (UAL). 
								@; Code written using UAL can be assembled 
								@; for ARM, Thumb-2, or pre-Thumb-2 Thumb
	.thumb						@; Use thmb instructions only

	.include "src/drivers/hardware.i"
	
@; --- begin code memory
	.text						@;start the code section

	.global get_rotary
	.thumb_func
get_rotary:
	push {r3-r7, lr}

	movs 	r4, #0

	ldr		r0, =ROT_Aport
	ldr		r1, =ROT_Abit
	ldr		r3, [r0, #0x10]
	tst		r3, r1			@;get 0
	bne 	get_rotary_return

	ldr		r0, =ROT_Bport
	ldr		r1, =ROT_Bbit
	ldr		r3, [r0, #0x10]
	tst		r3, r1
	beq 	ccw 			@;get 0
cw:
	movs 	r4, #1
	b		wait_until_PC12_reset
ccw:
	movs 	r4, #2

wait_until_PC12_reset:
	ldr		r0, =ROT_Aport
	ldr		r1, =ROT_Abit
	ldr		r3, [r0, #0x10]
	tst		r3, r1			@;get 0
	beq		wait_until_PC12_reset
	
get_rotary_return:
	mov 	r0, r4
	
	pop {r3-r7, lr}
	bx lr
	
	
	.include "src/drivers/gpio_init.asm"

	.global rotary_init
	.thumb_func
rotary_init:
	push {r3-r7, lr}
	enable_gpio RCCBbit
	enable_gpio RCCCbit

	set_init_unit PC 12 0 0 _ _ _ 0 1
	set_init_unit PB 5 0 0 _ _ _ 0 1
	
	pop {r3-r7, lr}
	bx lr

