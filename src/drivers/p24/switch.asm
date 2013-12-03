
	.syntax unified				@; ARM Unified Assembler Language (UAL). 
								@; Code written using UAL can be assembled 
								@; for ARM, Thumb-2, or pre-Thumb-2 Thumb
	.thumb						@; Use thmb instructions only

	.include "src/drivers/stm/common.asm"
	.include "src/drivers/stm/rcc.asm"
	.include "src/drivers/stm/gpio.asm"

	.equ S1lockbase,GPIOB;	.equ S1lockport,9;		.equ S1base,GPIOB;	.equ S1port,0
	.equ S2lockbase,GPIOB;	.equ S2lockport,9;		.equ S2base,GPIOD;	.equ S2port,2
	.equ S3lockbase,GPIOB;	.equ S3lockport,9;		.equ S3base,GPIOB;	.equ S3port,1
	.equ S4lockbase,GPIOB;	.equ S4lockport,9;		.equ S4base,GPIOB;	.equ S4port,6
	.equ S5lockbase,GPIOC;	.equ S5lockport,10;		.equ S5base,GPIOB;	.equ S5port,0
	.equ S6lockbase,GPIOC;	.equ S6lockport,10;		.equ S6base,GPIOD;	.equ S6port,2
	.equ S7lockbase,GPIOC;	.equ S7lockport,10;		.equ S7base,GPIOB;	.equ S7port,1
	.equ S8lockbase,GPIOC;	.equ S8lockport,10;		.equ S8base,GPIOB;	.equ S8port,6
	.equ S9lockbase,GPIOC;	.equ S9lockport,11;		.equ S9base,GPIOB;	.equ S9port,0
	.equ S10lockbase,GPIOC;	.equ S10lockport,11;	.equ S10base,GPIOD;	.equ S10port,2
	.equ S11lockbase,GPIOC;	.equ S11lockport,11;	.equ S11base,GPIOB;	.equ S11port,1
	.equ S12lockbase,GPIOC;	.equ S12lockport,11;	.equ S12base,GPIOB;	.equ S12port,6

	
@; --- begin code memory
	.text						@;start the code section

@;Initialize switches, set RCC and GPIO
def switch_init
	push {lr}
	set_reg RCC,RCC_AHB1ENR,RCC_AHB1ENR_GPIOBEN_pin,RCC_AHB1ENR_GPIOBEN_bits,1		@;Enable GPIOB
	set_reg RCC,RCC_AHB1ENR,RCC_AHB1ENR_GPIOCEN_pin,RCC_AHB1ENR_GPIOCEN_bits,1		@;Enable GPIOC
	set_reg RCC,RCC_AHB1ENR,RCC_AHB1ENR_GPIODEN_pin,RCC_AHB1ENR_GPIODEN_bits,1		@;Enable GPIOD

	gpio_enable GPIOB,0,0,_,_,1		@;moder=input, pupd=pullup
	gpio_enable GPIOD,2,0,_,_,1		@;moder=input, pupd=pullup
	gpio_enable GPIOB,1,0,_,_,1		@;moder=input, pupd=pullup
	gpio_enable GPIOB,6,0,_,_,1		@;moder=input, pupd=pullup
	gpio_enable GPIOB,9,1,0,2,1		@;moder=output, otyper=pupd, ospeeder=50MHz, pupd=pullup
	gpio_enable GPIOC,10,1,0,2,1	@;moder=output, otyper=pupd, ospeeder=50MHz, pupd=pullup
	gpio_enable GPIOC,11,1,0,2,1	@;moder=output, otyper=pupd, ospeeder=50MHz, pupd=pullup	
	pop {lr}
	bx lr

@;Test macro, test the status of a switch
	.macro test_sw_macro lockbase lockport base port
	reset_port \lockbase,\lockport
	test_reg \base,GPIO_IDR,(1<<\port)
	set_port \lockbase,\lockport
	.endm

@;Test function, test the status of a switch
@;Parameter r0: number of switch we want to test
def test_sw
	push {lr}
1:	cmp r0,0; 	bne 1f;	test_sw_macro S1lockbase,S1lockport,S1base,S1port;		b 2f
1:	cmp r0,1; 	bne 1f;	test_sw_macro S2lockbase,S2lockport,S2base,S2port;		b 2f
1:	cmp r0,2; 	bne 1f;	test_sw_macro S3lockbase,S3lockport,S3base,S3port;		b 2f
1:	cmp r0,3; 	bne 1f;	test_sw_macro S4lockbase,S4lockport,S4base,S4port;		b 2f
1:	cmp r0,4; 	bne 1f;	test_sw_macro S5lockbase,S5lockport,S5base,S5port;		b 2f
1:	cmp r0,5; 	bne 1f;	test_sw_macro S6lockbase,S6lockport,S6base,S6port;		b 2f
1:	cmp r0,6; 	bne 1f;	test_sw_macro S7lockbase,S7lockport,S7base,S7port;		b 2f
1:	cmp r0,7; 	bne 1f;	test_sw_macro S8lockbase,S8lockport,S8base,S8port;		b 2f
1:	cmp r0,8; 	bne 1f;	test_sw_macro S9lockbase,S9lockport,S9base,S9port;		b 2f
1:	cmp r0,9; 	bne 1f;	test_sw_macro S10lockbase,S10lockport,S10base,S10port;	b 2f
1:	cmp r0,10; 	bne 1f;	test_sw_macro S11lockbase,S11lockport,S11base,S11port;	b 2f
1:	cmp r0,11; 	bne 1f;	test_sw_macro S12lockbase,S12lockport,S12base,S12port;	b 2f

1:
2:	pop {lr}
	bx lr


