
	.syntax unified				@; ARM Unified Assembler Language (UAL). 
								@; Code written using UAL can be assembled 
								@; for ARM, Thumb-2, or pre-Thumb-2 Thumb
	.thumb						@; Use thmb instructions only

	.include "src/drivers/stm/rcc.asm"
	.include "src/drivers/stm/gpio.asm"

	.equ S1lockport,	PB
	.equ S1lockpin, 	9
	.equ S1port,		PB
	.equ S1pin, 		0
	.equ S2lockport,	PB
	.equ S2lockpin, 	9
	.equ S2port, 		PD
	.equ S2pin, 		2
	.equ S3lockport,	PB
	.equ S3lockpin, 	9
	.equ S3port, 		PB
	.equ S3pin, 		1
	.equ S4lockport,	PB
	.equ S4lockpin, 	9
	.equ S4port, 		PB
	.equ S4pin, 		6
	.equ S5lockport,	PC
	.equ S5lockpin, 	10
	.equ S5port, 		PB
	.equ S5pin, 		0
	.equ S6lockport,	PC
	.equ S6lockpin, 	10
	.equ S6port, 		PD
	.equ S6pin, 		2
	.equ S7lockport,	PC
	.equ S7lockpin, 	10
	.equ S7port, 		PB
	.equ S7pin, 		1
	.equ S8lockport,	PC
	.equ S8lockpin, 	10
	.equ S8port, 		PB
	.equ S8pin, 		6
	.equ S9lockport,	PC
	.equ S9lockpin, 	11
	.equ S9port, 		PB
	.equ S9pin, 		0
	.equ S10lockport,	PC
	.equ S10lockpin, 	11
	.equ S10port, 		PD
	.equ S10pin, 		2
	.equ S11lockport,	PC
	.equ S11lockpin, 	11
	.equ S11port, 		PB
	.equ S11pin, 		1
	.equ S12lockport,	PC
	.equ S12lockpin, 	11
	.equ S12port, 		PB
	.equ S12pin, 		6
	
@; --- begin code memory
	.text						@;start the code section

	.global switch_init
	.thumb_func
switch_init:
	push {r3-r7, lr}
	rcc_gpio_init RCCBpin
	rcc_gpio_init RCCCpin
	rcc_gpio_init RCCDpin

	gpio_init PB 0 0 _ _ 1
	gpio_init PD 2 0 _ _ 1
	gpio_init PB 1 0 _ _ 1
	gpio_init PB 6 0 _ _ 1
	gpio_init PB 9 1 0 2 1
	gpio_init PC 10 1 0 2 1
	gpio_init PC 11 1 0 2 1
	

	pop {r3-r7, lr}
	bx lr


	.macro get_sw lockport lockpin port pin
	reset_bit \lockport \lockpin
	read_bit \port \pin
	set_bit \lockport \lockpin
	.endm


	.global get_s1
	.thumb_func
get_s1:
	push {lr}
	get_sw S1lockport S1lockpin S1port S1pin
	pop {lr}
	bx lr

	.global get_s2
	.thumb_func
get_s2:
	push {lr}
	get_sw S2lockport S2lockpin S2port S2pin
	pop {lr}
	bx lr

	.global get_s3
	.thumb_func
get_s3:
	push {lr}
	get_sw S3lockport S3lockpin S3port S3pin
	pop {lr}
	bx lr

	.global get_s4
	.thumb_func
get_s4:
	push {lr}
	get_sw S4lockport S4lockpin S4port S4pin
	pop {lr}
	bx lr

	.global get_s5
	.thumb_func
get_s5:
	push {lr}
	get_sw S5lockport S5lockpin S5port S5pin
	pop {lr}
	bx lr

	.global get_s6
	.thumb_func
get_s6:
	push {lr}
	get_sw S6lockport S6lockpin S6port S6pin
	pop {lr}
	bx lr

	.global get_s7
	.thumb_func
get_s7:
	push {lr}
	get_sw S7lockport S7lockpin S7port S7pin
	pop {lr}
	bx lr

	.global get_s8
	.thumb_func
get_s8:
	push {lr}
	get_sw S8lockport S8lockpin S8port S8pin
	pop {lr}
	bx lr

	.global get_s9
	.thumb_func
get_s9:
	push {lr}
	get_sw S9lockport S9lockpin S9port S9pin
	pop {lr}
	bx lr

	.global get_s10
	.thumb_func
get_s10:
	push {lr}
	get_sw S10lockport S10lockpin S10port S10pin
	pop {lr}
	bx lr

	.global get_s11
	.thumb_func
get_s11:
	push {lr}
	get_sw S11lockport S11lockpin S11port S11pin
	pop {lr}
	bx lr

	.global get_s12
	.thumb_func
get_s12:
	push {lr}
	get_sw S12lockport S12lockpin S12port S12pin
	pop {lr}
	bx lr

