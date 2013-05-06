
	.syntax unified				@; ARM Unified Assembler Language (UAL). 
								@; Code written using UAL can be assembled 
								@; for ARM, Thumb-2, or pre-Thumb-2 Thumb
	.thumb						@; Use thmb instructions only

	.include "src/drivers/hardware.i"
	
@; --- begin code memory
	.text						@;start the code section

	.macro get_sw port1 port2 bit mask
	
	ldr r1, =\port1
	ldr r2, =\bit<<16
	str r2, [r1, #0x18]
	ldr r1, =\port2
	ldr r0, [r1, #0x10]
	ands r0, r0, 1<<\mask
	movs r0, r0, lsr \mask
	ldr r1, =\port1
	ldr r2, =\bit
	str r2, [r1, #0x18]

	.endm


	.global get_s1
	.thumb_func
get_s1:
	push {r3-r7,lr}
	get_sw S1port1 S1port2 S1bit S1mask
	pop {r3-r7,lr}
	bx lr

	.global get_s2
	.thumb_func
get_s2:
	push {r3-r7,lr}
	get_sw S2port1 S2port2 S2bit S2mask
	pop {r3-r7,lr}
	bx lr

	.global get_s3
	.thumb_func
get_s3:
	push {r3-r7,lr}
	get_sw S3port1 S3port2 S3bit S3mask
	pop {r3-r7,lr}
	bx lr

	.global get_s4
	.thumb_func
get_s4:
	push {r3-r7,lr}
	get_sw S4port1 S4port2 S4bit S4mask
	pop {r3-r7,lr}
	bx lr

	.global get_s5
	.thumb_func
get_s5:
	push {r3-r7,lr}
	get_sw S5port1 S5port2 S5bit S5mask
	pop {r3-r7,lr}
	bx lr

	.global get_s6
	.thumb_func
get_s6:
	push {r3-r7,lr}
	get_sw S6port1 S6port2 S6bit S6mask
	pop {r3-r7,lr}
	bx lr

	.global get_s7
	.thumb_func
get_s7:
	push {r3-r7,lr}
	get_sw S7port1 S7port2 S7bit S7mask
	pop {r3-r7,lr}
	bx lr

	.global get_s8
	.thumb_func
get_s8:
	push {r3-r7,lr}
	get_sw S8port1 S8port2 S8bit S8mask
	pop {r3-r7,lr}
	bx lr

	.global get_s9
	.thumb_func
get_s9:
	push {r3-r7,lr}
	get_sw S9port1 S9port2 S9bit S9mask
	pop {r3-r7,lr}
	bx lr

	.global get_s10
	.thumb_func
get_s10:
	push {r3-r7,lr}
	get_sw S10port1 S10port2 S10bit S10mask
	pop {r3-r7,lr}
	bx lr

	.global get_s11
	.thumb_func
get_s11:
	push {r3-r7,lr}
	get_sw S11port1 S11port2 S11bit S11mask
	pop {r3-r7,lr}
	bx lr

	.global get_s12
	.thumb_func
get_s12:
	push {r3-r7,lr}
	get_sw S12port1 S12port2 S12bit S12mask
	pop {r3-r7,lr}
	bx lr

	.include "src/drivers/gpio_init.asm"

	.macro switch_init_bsrr port bit
	ldr r1, =\port
	ldr r2, =(1<<\bit)
	str r2, [r1, #0x18]
	.endm
	
	.global switch_init
	.thumb_func
switch_init:
	push {r3-r7, lr}
	enable_gpio RCCBbit
	enable_gpio RCCCbit
	enable_gpio RCCDbit

	set_init_unit PB 0 0 0 _ _ _ 0 1
	set_init_unit PD 2 0 0 _ _ _ 0 1
	set_init_unit PB 1 0 0 _ _ _ 0 1
	set_init_unit PB 6 0 0 _ _ _ 0 1
	set_init_unit PB 9 0 1 0 1 0 0 1
	set_init_unit PC 10 0 1 0 1 0 0 1
	set_init_unit PC 11 0 1 0 1 0 0 1
	
	@;orr.w	r1, r1, 0x2000000
	
	@;switch_init_bsrr PB 9
	@;switch_init_bsrr PC 10
	@;switch_init_bsrr PC 11
	
	pop {r3-r7, lr}
	bx lr

