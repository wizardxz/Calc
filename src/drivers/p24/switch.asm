
	.syntax unified				@; ARM Unified Assembler Language (UAL). 
								@; Code written using UAL can be assembled 
								@; for ARM, Thumb-2, or pre-Thumb-2 Thumb
	.thumb						@; Use thmb instructions only

	.include "src/drivers/stm/common.asm"
	.include "src/drivers/stm/rcc.asm"
	.include "src/drivers/stm/gpio.asm"

	.equ S1lockport,GPIOB;	.equ S1lockpin,9;	.equ S1port,GPIOB;	.equ S1pin,0
	.equ S2lockport,GPIOB;	.equ S2lockpin,9;	.equ S2port,GPIOD;	.equ S2pin,2
	.equ S3lockport,GPIOB;	.equ S3lockpin,9;	.equ S3port,GPIOB;	.equ S3pin,1
	.equ S4lockport,GPIOB;	.equ S4lockpin,9;	.equ S4port,GPIOB;	.equ S4pin,6
	.equ S5lockport,GPIOC;	.equ S5lockpin,10;	.equ S5port,GPIOB;	.equ S5pin,0
	.equ S6lockport,GPIOC;	.equ S6lockpin,10;	.equ S6port,GPIOD;	.equ S6pin,2
	.equ S7lockport,GPIOC;	.equ S7lockpin,10;	.equ S7port,GPIOB;	.equ S7pin,1
	.equ S8lockport,GPIOC;	.equ S8lockpin,10;	.equ S8port,GPIOB;	.equ S8pin,6
	.equ S9lockport,GPIOC;	.equ S9lockpin,11;	.equ S9port,GPIOB;	.equ S9pin,0
	.equ S10lockport,GPIOC;	.equ S10lockpin,11;	.equ S10port,GPIOD;	.equ S10pin,2
	.equ S11lockport,GPIOC;	.equ S11lockpin,11;	.equ S11port,GPIOB;	.equ S11pin,1
	.equ S12lockport,GPIOC;	.equ S12lockpin,11;	.equ S12port,GPIOB;	.equ S12pin,6

	
@; --- begin code memory
	.text						@;start the code section

def switch_init
	push {r3-r7, lr}
	set_reg RCC,RCC_AHB1ENR,RCC_AHB1ENR_GPIOBEN_pin,RCC_AHB1ENR_GPIOBEN_bits,1
	set_reg RCC,RCC_AHB1ENR,RCC_AHB1ENR_GPIOCEN_pin,RCC_AHB1ENR_GPIOCEN_bits,1
	set_reg RCC,RCC_AHB1ENR,RCC_AHB1ENR_GPIODEN_pin,RCC_AHB1ENR_GPIODEN_bits,1

	gpio_enable GPIOB,0,0,_,_,1
	gpio_enable GPIOD,2,0,_,_,1
	gpio_enable GPIOB,1,0,_,_,1
	gpio_enable GPIOB,6,0,_,_,1
	gpio_enable GPIOB,9,1,0,2,1
	gpio_enable GPIOC,10,1,0,2,1
	gpio_enable GPIOC,11,1,0,2,1
	

	pop {r3-r7, lr}
	bx lr


	.macro get_sw lockport lockpin port pin
	reset_bit \lockport \lockpin
	read_bit_n \port GPIO_IDR \pin
	set_bit \lockport \lockpin
	.endm


def get_s1
	push {lr}
	get_sw S1lockport S1lockpin S1port S1pin
	pop {lr}
	bx lr

def get_s2
	push {lr}
	get_sw S2lockport S2lockpin S2port S2pin
	pop {lr}
	bx lr

def get_s3
	push {lr}
	get_sw S3lockport S3lockpin S3port S3pin
	pop {lr}
	bx lr

def get_s4
	push {lr}
	get_sw S4lockport S4lockpin S4port S4pin
	pop {lr}
	bx lr

def get_s5
	push {lr}
	get_sw S5lockport S5lockpin S5port S5pin
	pop {lr}
	bx lr

def get_s6
	push {lr}
	get_sw S6lockport S6lockpin S6port S6pin
	pop {lr}
	bx lr

def get_s7
	push {lr}
	get_sw S7lockport S7lockpin S7port S7pin
	pop {lr}
	bx lr

def get_s8
	push {lr}
	get_sw S8lockport S8lockpin S8port S8pin
	pop {lr}
	bx lr

def get_s9
	push {lr}
	get_sw S9lockport S9lockpin S9port S9pin
	pop {lr}
	bx lr

def get_s10
	push {lr}
	get_sw S10lockport S10lockpin S10port S10pin
	pop {lr}
	bx lr

def get_s11
	push {lr}
	get_sw S11lockport S11lockpin S11port S11pin
	pop {lr}
	bx lr

def get_s12
	push {lr}
	get_sw S12lockport S12lockpin S12port S12pin
	pop {lr}
	bx lr

