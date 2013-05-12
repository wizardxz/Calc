
	.syntax unified				@; ARM Unified Assembler Language (UAL). 
								@; Code written using UAL can be assembled 
								@; for ARM, Thumb-2, or pre-Thumb-2 Thumb
	.thumb						@; Use thmb instructions only

	.include "src/drivers/stm/rcc.asm"
	.include "src/drivers/stm/gpio.asm"

	.equ S1lockport,	PB
	.equ S1lockbit, 	(1<<9)
	.equ S1port,		PB
	.equ S1bit, 		(1<<0)
	.equ S2lockport,	PB
	.equ S2lockbit, 	(1<<9)
	.equ S2port, 		PD
	.equ S2bit, 		(1<<2)
	.equ S3lockport,	PB
	.equ S3lockbit, 	(1<<9)
	.equ S3port, 		PB
	.equ S3bit, 		(1<<1)
	.equ S4lockport,	PB
	.equ S4lockbit, 	(1<<9)
	.equ S4port, 		PB
	.equ S4bit, 		(1<<6)
	.equ S5lockport,	PC
	.equ S5lockbit, 	(1<<10)
	.equ S5port, 		PB
	.equ S5bit, 		(1<<0)
	.equ S6lockport,	PC
	.equ S6lockbit, 	(1<<10)
	.equ S6port, 		PD
	.equ S6bit, 		(1<<2)
	.equ S7lockport,	PC
	.equ S7lockbit, 	(1<<10)
	.equ S7port, 		PB
	.equ S7bit, 		(1<<1)
	.equ S8lockport,	PC
	.equ S8lockbit, 	(1<<10)
	.equ S8port, 		PB
	.equ S8bit, 		(1<<6)
	.equ S9lockport,	PC
	.equ S9lockbit, 	(1<<11)
	.equ S9port, 		PB
	.equ S9bit, 		(1<<0)
	.equ S10lockport,	PC
	.equ S10lockbit, 	(1<<11)
	.equ S10port, 		PD
	.equ S10bit, 		(1<<2)
	.equ S11lockport,	PC
	.equ S11lockbit, 	(1<<11)
	.equ S11port, 		PB
	.equ S11bit, 		(1<<1)
	.equ S12lockport,	PC
	.equ S12lockbit, 	(1<<11)
	.equ S12port, 		PB
	.equ S12bit, 		(1<<6)
	
@; --- begin code memory
	.text						@;start the code section

	.global switch_init
	.thumb_func
switch_init:
	push {r3-r7, lr}
	rcc_gpio_init RCCBbit
	rcc_gpio_init RCCCbit
	rcc_gpio_init RCCDbit

	gpio_init PB 0 0 0 _ _ _ 0 1
	gpio_init PD 2 0 0 _ _ _ 0 1
	gpio_init PB 1 0 0 _ _ _ 0 1
	gpio_init PB 6 0 0 _ _ _ 0 1
	gpio_init PB 9 0 1 0 1 0 0 1
	gpio_init PC 10 0 1 0 1 0 0 1
	gpio_init PC 11 0 1 0 1 0 0 1
	

	pop {r3-r7, lr}
	bx lr


	.macro get_sw lockport lockbit port bit
	reset_bit \lockport \lockbit
	read_bit \port \bit
	set_bit \lockport \lockbit
	.endm


	.global get_s1
	.thumb_func
get_s1:
	push {lr}
	get_sw S1lockport S1lockbit S1port S1bit
	pop {lr}
	bx lr

	.global get_s2
	.thumb_func
get_s2:
	push {lr}
	get_sw S2lockport S2lockbit S2port S2bit
	pop {lr}
	bx lr

	.global get_s3
	.thumb_func
get_s3:
	push {lr}
	get_sw S3lockport S3lockbit S3port S3bit
	pop {lr}
	bx lr

	.global get_s4
	.thumb_func
get_s4:
	push {lr}
	get_sw S4lockport S4lockbit S4port S4bit
	pop {lr}
	bx lr

	.global get_s5
	.thumb_func
get_s5:
	push {lr}
	get_sw S5lockport S5lockbit S5port S5bit
	pop {lr}
	bx lr

	.global get_s6
	.thumb_func
get_s6:
	push {lr}
	get_sw S6lockport S6lockbit S6port S6bit
	pop {lr}
	bx lr

	.global get_s7
	.thumb_func
get_s7:
	push {lr}
	get_sw S7lockport S7lockbit S7port S7bit
	pop {lr}
	bx lr

	.global get_s8
	.thumb_func
get_s8:
	push {lr}
	get_sw S8lockport S8lockbit S8port S8bit
	pop {lr}
	bx lr

	.global get_s9
	.thumb_func
get_s9:
	push {lr}
	get_sw S9lockport S9lockbit S9port S9bit
	pop {lr}
	bx lr

	.global get_s10
	.thumb_func
get_s10:
	push {lr}
	get_sw S10lockport S10lockbit S10port S10bit
	pop {lr}
	bx lr

	.global get_s11
	.thumb_func
get_s11:
	push {lr}
	get_sw S11lockport S11lockbit S11port S11bit
	pop {lr}
	bx lr

	.global get_s12
	.thumb_func
get_s12:
	push {lr}
	get_sw S12lockport S12lockbit S12port S12bit
	pop {lr}
	bx lr

