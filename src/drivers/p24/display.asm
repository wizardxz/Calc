
	.syntax unified				@; ARM Unified Assembler Language (UAL). 
								@; Code written using UAL can be assembled 
								@; for ARM, Thumb-2, or pre-Thumb-2 Thumb
	.thumb						@; Use thmb instructions only


	.include "src/drivers/stm/common.asm"
	.include "src/drivers/stm/rcc.asm"
	.include "src/drivers/stm/gpio.asm"

	.equ LAT0_base, 	GPIOC;	.equ LAT0_port, 2		@;CA_A/LED5-COLON
	.equ LAT1_base, 	GPIOA;	.equ LAT1_port, 0		@;CA_B/LED6-DIGIT4
	.equ LAT2_base, 	GPIOC;	.equ LAT2_port, 3		@;CA_C/LED1-DIGIT2
	.equ LAT3_base, 	GPIOA;	.equ LAT3_port, 7		@;CA_D
	.equ LAT4_base, 	GPIOA;	.equ LAT4_port, 4		@;CA_E-AN_R
	.equ LAT5_base, 	GPIOC;	.equ LAT5_port, 0		@;CA_F/LED4-DIGIT1
	.equ LAT6_base, 	GPIOA;	.equ LAT6_port, 1		@;CA_G/LED2-DIGIT3
	.equ LAT7_base, 	GPIOA;	.equ LAT7_port, 5		@;CA_DP/LED3-AN_G

	.equ CA_NEN_base,	GPIOC;	.equ CA_NEN_port, 1
	.equ AN_NEN_base,	GPIOA;	.equ AN_NEN_port, 6
	.equ CA_CLK_base,	GPIOC;	.equ CA_CLK_port, 5
	.equ AN_CLK_base,	GPIOC;	.equ AN_CLK_port, 4

@; --- begin code memory
	.text						@;start the code section

@;Display initialization, set RCC and GPIO
def display_init
	push {lr}
	set_reg RCC RCC_AHB1ENR,RCC_AHB1ENR_GPIOAEN_pin,RCC_AHB1ENR_GPIOAEN_bits,1	@;Enable GPIOA
	set_reg RCC RCC_AHB1ENR,RCC_AHB1ENR_GPIOCEN_pin,RCC_AHB1ENR_GPIOCEN_bits,1	@;Enable GPIOC

	gpio_enable GPIOC,4,1,0,2,1			@;moder=output, otyper=pupd, ospeeder=50MHz, pupder=pullup
	gpio_enable GPIOA,6,1,0,2,1         @;moder=output, otyper=pupd, ospeeder=50MHz, pupder=pullup
	gpio_enable GPIOC,5,1,0,2,1         @;moder=output, otyper=pupd, ospeeder=50MHz, pupder=pullup
	gpio_enable GPIOC,1,1,0,2,1         @;moder=output, otyper=pupd, ospeeder=50MHz, pupder=pullup
	gpio_enable GPIOC,2,1,0,2,1         @;moder=output, otyper=pupd, ospeeder=50MHz, pupder=pullup
	gpio_enable GPIOA,0,1,0,2,1         @;moder=output, otyper=pupd, ospeeder=50MHz, pupder=pullup
	gpio_enable GPIOC,3,1,0,2,1         @;moder=output, otyper=pupd, ospeeder=50MHz, pupder=pullup
	gpio_enable GPIOA,7,1,0,2,1         @;moder=output, otyper=pupd, ospeeder=50MHz, pupder=pullup
	gpio_enable GPIOA,4,1,0,2,1         @;moder=output, otyper=pupd, ospeeder=50MHz, pupder=pullup
	gpio_enable GPIOC,0,1,0,2,1         @;moder=output, otyper=pupd, ospeeder=50MHz, pupder=pullup
	gpio_enable GPIOA,1,1,0,2,1         @;moder=output, otyper=pupd, ospeeder=50MHz, pupder=pullup
	gpio_enable GPIOA,5,1,0,2,1         @;moder=output, otyper=pupd, ospeeder=50MHz, pupder=pullup
	pop {lr}
	bx lr
	
	.ltorg		@;literal poll

	@;Set lat0-lat7 value, here we do it inversely. 0 is set, 1 is reset.
	.macro set_value base port value
	.if \value == 0
		set_port \base,\port
	.else @; value == 1
		reset_port \base,\port
	.endif
	.endm

	@;Set many lat values together
	.macro set_lat v0 v1 v2 v3 v4 v5 v6 v7
	set_value LAT0_base,LAT0_port,\v0
	set_value LAT1_base,LAT1_port,\v1
	set_value LAT2_base,LAT2_port,\v2
	set_value LAT3_base,LAT3_port,\v3
	set_value LAT4_base,LAT4_port,\v4
	set_value LAT5_base,LAT5_port,\v5
	set_value LAT6_base,LAT6_port,\v6
	set_value LAT7_base,LAT7_port,\v7
	.endm

@;Write digit
@;Parameter r0 is the index of number we want to write.
@;Parameter r1 is the value of number we want to write.
def write_digit
	push {r3-r7,lr}
	push {r1}
	set_port AN_NEN_base,AN_NEN_port
	set_port CA_NEN_base,CA_NEN_port

1:	cmp r0, #0;		bne 1f;	set_lat 0,0,0,0,0,0,0,0;	b 2f	@;turn off
1:	cmp r0, #48;	bne 1f;	set_lat 1,1,1,1,1,1,0,0;	b 2f	@;write '0'
1:	cmp r0, #49;	bne 1f;	set_lat 0,1,1,0,0,0,0,0;	b 2f	@;write '1'
1:	cmp r0, #50;	bne 1f;	set_lat 1,1,0,1,1,0,1,0;	b 2f	@;write '2'
1:	cmp r0, #51;	bne 1f;	set_lat 1,1,1,1,0,0,1,0;	b 2f	@;write '3'
1:	cmp r0, #52;	bne 1f;	set_lat 0,1,1,0,0,1,1,0;	b 2f	@;write '4'
1:	cmp r0, #53;	bne 1f;	set_lat 1,0,1,1,0,1,1,0;	b 2f	@;write '5'
1:	cmp r0, #54;	bne 1f;	set_lat 1,0,1,1,1,1,1,0;	b 2f	@;write '6'
1:	cmp r0, #55;	bne 1f;	set_lat 1,1,1,0,0,0,0,0;	b 2f	@;write '7'
1:	cmp r0, #56;	bne 1f;	set_lat 1,1,1,1,1,1,1,0;	b 2f	@;write '8'
1:	cmp r0, #57;	bne 1f;	set_lat 1,1,1,1,0,1,1,0;	b 2f	@;write '9'
1:	cmp r0, #45;	bne 1f;	set_lat 0,0,0,0,0,0,1,0;	b 2f	@;write '-'

1:
2:	reset_port CA_CLK_base,CA_CLK_port
	set_port CA_CLK_base,CA_CLK_port
	
	pop {r1}
	
1: cmp r1, #0;		bne 1f;	set_lat 0,0,0,0,0,1,0,0;	b 2f	@;an1	
1: cmp r1, #1;		bne 1f;	set_lat 0,0,1,0,0,0,0,0;	b 2f	@;an2	
1: cmp r1, #2;		bne 1f;	set_lat 0,0,0,0,0,0,1,0;	b 2f	@;an3	
1: cmp r1, #3;		bne 1f;	set_lat 0,1,0,0,0,0,0,0;	b 2f	@;an4	

1:
2:	reset_port AN_CLK_base,AN_CLK_port
	set_port AN_CLK_base,AN_CLK_port

	reset_port AN_NEN_base,AN_NEN_port
	reset_port CA_NEN_base,CA_NEN_port
	
	pop {r3-r7,lr}
	bx lr

@;Write led
@;Parameter r0 is the index of led we want to write.
@;Parameter r1 is the value of led we want to write.
def write_led
	push {r3-r7,lr}
	push {r0}
	push {r1}
	set_port AN_NEN_base,AN_NEN_port
	set_port CA_NEN_base,CA_NEN_port
	
	pop {r1}
1:	cmp r1, #0;		bne 1f;	set_lat 0,0,1,0,0,0,0,0;	b 2f	@;ca1
1:	cmp r1, #1;		bne 1f;	set_lat 0,0,0,0,0,0,1,0;	b 2f	@;ca2
1:	cmp r1, #2;		bne 1f;	set_lat 0,0,0,0,0,0,0,1;	b 2f	@;ca3
1:	cmp r1, #3;		bne 1f;	set_lat 0,0,0,0,0,1,0,0;	b 2f	@;ca4
1:	cmp r1, #4;		bne 1f;	set_lat 1,0,0,0,0,0,0,0;	b 2f	@;ca5
1:	cmp r1, #5;		bne 1f;	set_lat 0,1,0,0,0,0,0,0;	b 2f	@;ca6

1:
2:	reset_port CA_CLK_base,CA_CLK_port
	set_port CA_CLK_base,CA_CLK_port
	pop {r0}

1:	cmp r0, #0;		bne 1f;	set_lat 0,0,0,0,0,0,0,0;	b 2f	@;turn off
1:	cmp r0, #1;		bne 1f;	set_lat 0,0,0,0,1,0,0,0;	b 2f	@;red
1:	cmp r0, #2;		bne 1f;	set_lat 0,0,0,0,0,0,0,1;	b 2f	@;green

1:
2:	reset_port AN_CLK_base,AN_CLK_port
	set_port AN_CLK_base,AN_CLK_port

	reset_port AN_NEN_base,AN_NEN_port
	reset_port CA_NEN_base,CA_NEN_port

	pop {r3-r7,lr}
	bx lr

	

