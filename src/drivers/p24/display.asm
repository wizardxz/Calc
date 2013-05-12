
	.syntax unified				@; ARM Unified Assembler Language (UAL). 
								@; Code written using UAL can be assembled 
								@; for ARM, Thumb-2, or pre-Thumb-2 Thumb
	.thumb						@; Use thmb instructions only


	.include "src/drivers/stm/rcc.asm"
	.include "src/drivers/stm/gpio.asm"

	.equ LAT0port, 		PC		@;CA_A/LED5-COLON
	.equ LAT0pin, 		2
	.equ LAT1port, 		PA		@;CA_B/LED6-DIGIT4
	.equ LAT1pin, 		0
	.equ LAT2port, 		PC		@;CA_C/LED1-DIGIT2
	.equ LAT2pin, 		3
	.equ LAT3port, 		PA		@;CA_D
	.equ LAT3pin, 		7
	.equ LAT4port, 		PA		@;CA_E-AN_R
	.equ LAT4pin, 		4
	.equ LAT5port, 		PC		@;CA_F/LED4-DIGIT1
	.equ LAT5pin, 		0
	.equ LAT6port, 		PA		@;CA_G/LED2-DIGIT3
	.equ LAT6pin, 		1
	.equ LAT7port, 		PA		@;CA_DP/LED3-AN_G
	.equ LAT7pin, 		5

	.equ CA_NENport, 	PC
	.equ CA_NENpin,		1
	.equ AN_NENport, 	PA
	.equ AN_NENpin,		6
	.equ CA_CLKport, 	PC
	.equ CA_CLKpin,		5
	.equ AN_CLKport, 	PC
	.equ AN_CLKpin,		4

@; --- begin code memory
	.text						@;start the code section

	.global display_init
	.thumb_func
display_init:
	push {r3-r7, lr}
	rcc_gpio_init RCCApin
	rcc_gpio_init RCCCpin

	gpio_init PC 4 1 0 2 1
	gpio_init PA 6 1 0 2 1
	gpio_init PC 5 1 0 2 1
	gpio_init PC 1 1 0 2 1
	gpio_init PC 2 1 0 2 1
	gpio_init PA 0 1 0 2 1
	gpio_init PC 3 1 0 2 1
	gpio_init PA 7 1 0 2 1
	gpio_init PA 4 1 0 2 1
	gpio_init PC 0 1 0 2 1
	gpio_init PA 1 1 0 2 1
	gpio_init PA 5 1 0 2 1
	pop {r3-r7, lr}
	bx lr

	.macro set_value port pin value
	.if \value == 0
		set_bit \port \pin
	.else @; value == 1
		reset_bit \port \pin
	.endif
	.endm

	.macro set_lat v0 v1 v2 v3 v4 v5 v6 v7
	set_value LAT0port LAT0pin \v0
	set_value LAT1port LAT1pin \v1
	set_value LAT2port LAT2pin \v2
	set_value LAT3port LAT3pin \v3
	set_value LAT4port LAT4pin \v4
	set_value LAT5port LAT5pin \v5
	set_value LAT6port LAT6pin \v6
	set_value LAT7port LAT7pin \v7
	.endm

	.global write_digit
	.thumb_func 
write_digit:
	push {r3-r7,lr}
	set_bit AN_NENport AN_NENpin
	set_bit CA_NENport CA_NENpin
	
write_digit_ca_null:	
	cmp r0, #0
	bne write_digit_ca0
	set_lat 0 0 0 0 0 0 0 0
	b write_digit_ca_over

write_digit_ca0:	
	cmp r0, #48
	bne write_digit_ca1
	set_lat 1 1 1 1 1 1 0 0
	b write_digit_ca_over

write_digit_ca1:
	cmp r0, #49
	bne write_digit_ca2
	set_lat 0 1 1 0 0 0 0 0
	b write_digit_ca_over

write_digit_ca2:
	cmp r0, #50
	bne write_digit_ca3
	set_lat 1 1 0 1 1 0 1 0
	b write_digit_ca_over

write_digit_ca3:
	cmp r0, #51
	bne write_digit_ca4
	set_lat 1 1 1 1 0 0 1 0
	b write_digit_ca_over

write_digit_ca4:	
	cmp r0, #52
	bne write_digit_ca5
	set_lat 0 1 1 0 0 1 1 0
	b write_digit_ca_over

write_digit_ca5:	
	cmp r0, #53
	bne write_digit_ca6
	set_lat 1 0 1 1 0 1 1 0
	b write_digit_ca_over

write_digit_ca6:	
	cmp r0, #54
	bne write_digit_ca7
	set_lat 1 0 1 1 1 1 1 0
	b write_digit_ca_over

write_digit_ca7:	
	cmp r0, #55
	bne write_digit_ca8
	set_lat 1 1 1 0 0 0 0 0
	b write_digit_ca_over

write_digit_ca8:	
	cmp r0, #56
	bne write_digit_ca9
	set_lat 1 1 1 1 1 1 1 0
	b write_digit_ca_over

write_digit_ca9:	
	cmp r0, #57
	bne write_digit_ca_dash
	set_lat 1 1 1 1 0 1 1 0
	
write_digit_ca_dash:
	cmp r0, #45
	bne write_digit_ca_over
	set_lat 0 0 0 0 0 0 1 0
	
write_digit_ca_over:
	reset_bit CA_CLKport CA_CLKpin
	set_bit CA_CLKport CA_CLKpin
	
write_digit_an0:
	cmp r1, #0
	bne write_digit_an1
	set_lat 0 0 0 0 0 1 0 0
	b write_digit_an_over

write_digit_an1: 
	cmp r1, #1
	bne write_digit_an2
	set_lat 0 0 1 0 0 0 0 0
	b write_digit_an_over
	
write_digit_an2: 
	cmp r1, #2
	bne write_digit_an3
	set_lat 0 0 0 0 0 0 1 0
	b write_digit_an_over

write_digit_an3: 
	cmp r1, #3
	bne write_digit_an_over
	set_lat 0 1 0 0 0 0 0 0
write_digit_an_over:
	reset_bit AN_CLKport AN_CLKpin
	set_bit AN_CLKport AN_CLKpin

	reset_bit AN_NENport AN_NENpin
	reset_bit CA_NENport CA_NENpin
	
	pop {r3-r7,lr}
	bx lr

	.global write_led
	.thumb_func 
write_led:
	push {r3-r7,lr}
	set_bit AN_NENport AN_NENpin
	set_bit CA_NENport CA_NENpin
	
write_led_ca0:	
	cmp r0, #0
	bne write_led_ca1
	set_lat 0 0 1 0 0 0 0 0
	b write_led_ca_over

write_led_ca1:	
	cmp r0, #1
	bne write_led_ca2
	set_lat 0 0 0 0 0 0 1 0
	b write_led_ca_over

write_led_ca2:	
	cmp r0, #2
	bne write_led_ca3
	set_lat 0 0 0 0 0 0 0 1
	b write_led_ca_over

write_led_ca3:	
	cmp r0, #3
	bne write_led_ca4
	set_lat 0 0 0 0 0 1 0 0
	b write_led_ca_over

write_led_ca4:	
	cmp r0, #4
	bne write_led_ca5
	set_lat 1 0 0 0 0 0 0 0
	b write_led_ca_over

write_led_ca5:	
	cmp r0, #5
	bne write_led_ca_over
	set_lat 0 1 0 0 0 0 0 0

write_led_ca_over:
	reset_bit CA_CLKport CA_CLKpin
	set_bit CA_CLKport CA_CLKpin
	
write_led_an0: 
	cmp r1, #0
	bne write_led_an1
	set_lat 0 0 0 0 1 0 0 0
	b write_led_an_over

write_led_an1: 
	cmp r1, #1
	bne write_led_an_over
	set_lat 0 0 0 0 0 0 0 1
	
write_led_an_over:
	reset_bit AN_CLKport AN_CLKpin
	set_bit AN_CLKport AN_CLKpin

	reset_bit AN_NENport AN_NENpin
	reset_bit CA_NENport CA_NENpin
	
	pop {r3-r7,lr}
	bx lr

	

