
	.syntax unified				@; ARM Unified Assembler Language (UAL). 
								@; Code written using UAL can be assembled 
								@; for ARM, Thumb-2, or pre-Thumb-2 Thumb
	.thumb						@; Use thmb instructions only


	.include "src/drivers/stm/common.asm"
	.include "src/drivers/stm/rcc.asm"
	.include "src/drivers/stm/gpio.asm"

	.equ LAT0port, 	GPIOC;	.equ LAT0pin, 2		@;CA_A/LED5-COLON
	.equ LAT1port, 	GPIOA;	.equ LAT1pin, 0		@;CA_B/LED6-DIGIT4
	.equ LAT2port, 	GPIOC;	.equ LAT2pin, 3		@;CA_C/LED1-DIGIT2
	.equ LAT3port, 	GPIOA;	.equ LAT3pin, 7		@;CA_D
	.equ LAT4port, 	GPIOA;	.equ LAT4pin, 4		@;CA_E-AN_R
	.equ LAT5port, 	GPIOC;	.equ LAT5pin, 0		@;CA_F/LED4-DIGIT1
	.equ LAT6port, 	GPIOA;	.equ LAT6pin, 1		@;CA_G/LED2-DIGIT3
	.equ LAT7port, 	GPIOA;	.equ LAT7pin, 5		@;CA_DP/LED3-AN_G

	.equ CA_NENport, GPIOC;	.equ CA_NENpin, 1
	.equ AN_NENport, GPIOA;	.equ AN_NENpin, 6
	.equ CA_CLKport, GPIOC;	.equ CA_CLKpin, 5
	.equ AN_CLKport, GPIOC;	.equ AN_CLKpin, 4

@; --- begin code memory
	.text						@;start the code section

def display_init
	push {lr}
	set_reg RCC RCC_AHB1ENR,RCC_AHB1ENR_GPIOAEN_pin,RCC_AHB1ENR_GPIOAEN_bits,1
	set_reg RCC RCC_AHB1ENR,RCC_AHB1ENR_GPIOCEN_pin,RCC_AHB1ENR_GPIOCEN_bits,1

	pop {lr}
	bx lr

def display_on
	push {lr}
	gpio_enable GPIOC,4,1,0,2,1
	gpio_enable GPIOA,6,1,0,2,1
	gpio_enable GPIOC,5,1,0,2,1
	gpio_enable GPIOC,1,1,0,2,1
	gpio_enable GPIOC,2,1,0,2,1
	gpio_enable GPIOA,0,1,0,2,1
	gpio_enable GPIOC,3,1,0,2,1
	gpio_enable GPIOA,7,1,0,2,1
	gpio_enable GPIOA,4,1,0,2,1
	gpio_enable GPIOC,0,1,0,2,1
	gpio_enable GPIOA,1,1,0,2,1
	gpio_enable GPIOA,5,1,0,2,1
	pop {lr}
	bx lr
	
def display_off
	push {lr}
	gpio_disable GPIOC,4
	gpio_disable GPIOA,6
	gpio_disable GPIOC,5
	gpio_disable GPIOC,1
	gpio_disable GPIOC,2
	gpio_disable GPIOA,0
	gpio_disable GPIOC,3
	gpio_disable GPIOA,7
	gpio_disable GPIOA,4
	gpio_disable GPIOC,0
	gpio_disable GPIOA,1
	gpio_disable GPIOA,5
	pop {lr}
	bx lr
	.ltorg

	.macro set_value port pin value
	.if \value == 0
		set_bit \port,\pin
	.else @; value == 1
		reset_bit \port,\pin
	.endif
	.endm

	.macro set_lat v0 v1 v2 v3 v4 v5 v6 v7
	set_value LAT0port,LAT0pin,\v0
	set_value LAT1port,LAT1pin,\v1
	set_value LAT2port,LAT2pin,\v2
	set_value LAT3port,LAT3pin,\v3
	set_value LAT4port,LAT4pin,\v4
	set_value LAT5port,LAT5pin,\v5
	set_value LAT6port,LAT6pin,\v6
	set_value LAT7port,LAT7pin,\v7
	.endm

def write_digit
	push {r3-r7,lr}
	push {r1}
	set_bit AN_NENport,AN_NENpin
	set_bit CA_NENport,CA_NENpin

1:	cmp r0, #0;		bne 1f;	set_lat 0,0,0,0,0,0,0,0;	b 2f	@;off
1:	cmp r0, #48;	bne 1f;	set_lat 1,1,1,1,1,1,0,0;	b 2f	@;0
1:	cmp r0, #49;	bne 1f;	set_lat 0,1,1,0,0,0,0,0;	b 2f	@;1
1:	cmp r0, #50;	bne 1f;	set_lat 1,1,0,1,1,0,1,0;	b 2f	@;2
1:	cmp r0, #51;	bne 1f;	set_lat 1,1,1,1,0,0,1,0;	b 2f	@;3
1:	cmp r0, #52;	bne 1f;	set_lat 0,1,1,0,0,1,1,0;	b 2f	@;4
1:	cmp r0, #53;	bne 1f;	set_lat 1,0,1,1,0,1,1,0;	b 2f	@;5
1:	cmp r0, #54;	bne 1f;	set_lat 1,0,1,1,1,1,1,0;	b 2f	@;6
1:	cmp r0, #55;	bne 1f;	set_lat 1,1,1,0,0,0,0,0;	b 2f	@;7
1:	cmp r0, #56;	bne 1f;	set_lat 1,1,1,1,1,1,1,0;	b 2f	@;8
1:	cmp r0, #57;	bne 1f;	set_lat 1,1,1,1,0,1,1,0;	b 2f	@;9
1:	cmp r0, #45;	bne 1f;	set_lat 0,0,0,0,0,0,1,0;	b 2f	@;-

1:
2:	reset_bit CA_CLKport,CA_CLKpin
	set_bit CA_CLKport,CA_CLKpin
	
	pop {r1}
	
1: cmp r1, #0;		bne 1f;	set_lat 0,0,0,0,0,1,0,0;	b 2f	@;an1	
1: cmp r1, #1;		bne 1f;	set_lat 0,0,1,0,0,0,0,0;	b 2f	@;an2	
1: cmp r1, #2;		bne 1f;	set_lat 0,0,0,0,0,0,1,0;	b 2f	@;an3	
1: cmp r1, #3;		bne 1f;	set_lat 0,1,0,0,0,0,0,0;	b 2f	@;an4	

1:
2:	reset_bit AN_CLKport,AN_CLKpin
	set_bit AN_CLKport,AN_CLKpin

	reset_bit AN_NENport,AN_NENpin
	reset_bit CA_NENport,CA_NENpin
	
	pop {r3-r7,lr}
	bx lr

def write_led
	push {r3-r7,lr}
	push {r0}
	push {r1}
	set_bit AN_NENport AN_NENpin
	set_bit CA_NENport CA_NENpin
	
	pop {r1}
1:	cmp r1, #0;		bne 1f;	set_lat 0,0,1,0,0,0,0,0;	b 2f	@;ca1
1:	cmp r1, #1;		bne 1f;	set_lat 0,0,0,0,0,0,1,0;	b 2f	@;ca2
1:	cmp r1, #2;		bne 1f;	set_lat 0,0,0,0,0,0,0,1;	b 2f	@;ca3
1:	cmp r1, #3;		bne 1f;	set_lat 0,0,0,0,0,1,0,0;	b 2f	@;ca4
1:	cmp r1, #4;		bne 1f;	set_lat 1,0,0,0,0,0,0,0;	b 2f	@;ca5
1:	cmp r1, #5;		bne 1f;	set_lat 0,1,0,0,0,0,0,0;	b 2f	@;ca6

1:
2:	reset_bit CA_CLKport,CA_CLKpin
	set_bit CA_CLKport,CA_CLKpin
	pop {r0}

1:	cmp r0, #0;		bne 1f;	set_lat 0,0,0,0,0,0,0,0;	b 2f	@;off
1:	cmp r0, #1;		bne 1f;	set_lat 0,0,0,0,1,0,0,0;	b 2f	@;red
1:	cmp r0, #2;		bne 1f;	set_lat 0,0,0,0,0,0,0,1;	b 2f	@;green

1:
2:	reset_bit AN_CLKport,AN_CLKpin
	set_bit AN_CLKport,AN_CLKpin

	reset_bit AN_NENport,AN_NENpin
	reset_bit CA_NENport,CA_NENpin

	pop {r3-r7,lr}
	bx lr

	

