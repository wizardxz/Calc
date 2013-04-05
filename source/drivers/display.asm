
	.syntax unified				@; ARM Unified Assembler Language (UAL). 
								@; Code written using UAL can be assembled 
								@; for ARM, Thumb-2, or pre-Thumb-2 Thumb
	.thumb						@; Use thmb instructions only


	.include "source/drivers/hardware.i"

@; --- begin code memory
	.text						@;start the code section

	.macro set_value port bit value
	@;set bit value
	@;port, bit and value are parameters
	@;reg1, reg2 are temporary registers
	
	ldr		r2, =\port
	ldr		r3, =\bit
	lsls	r3, \value<<4
	str		r3, [r2, #0x18]

	.endm

	.macro set_on port bit
	set_value \port \bit 0
	.endm

	.macro set_off port bit
	set_value \port \bit 1
	.endm

	.macro set_lat v0 v1 v2 v3 v4 v5 v6 v7

	set_value LAT0port LAT0bit \v0
	set_value LAT1port LAT1bit \v1
	set_value LAT2port LAT2bit \v2
	set_value LAT3port LAT3bit \v3
	set_value LAT4port LAT4bit \v4
	set_value LAT5port LAT5bit \v5
	set_value LAT6port LAT6bit \v6
	set_value LAT7port LAT7bit \v7

	.endm

	.global write_digit
	.thumb_func 
write_digit:
	push {r3-r7,lr}
	set_on AN_NENport AN_NENbit
	set_on CA_NENport CA_NENbit
	
write_digit_ca0:	
	cmp r0, #0
	bne write_digit_ca1
	set_lat 1 1 1 1 1 1 0 0
	b write_digit_ca_over

write_digit_ca1:
	cmp r0, #1
	bne write_digit_ca2
	set_lat 0 1 1 0 0 0 0 0
	b write_digit_ca_over

write_digit_ca2:
	cmp r0, #2
	bne write_digit_ca3
	set_lat 1 1 0 1 1 0 1 0
	b write_digit_ca_over

write_digit_ca3:
	cmp r0, #3
	bne write_digit_ca4
	set_lat 1 1 1 1 0 0 1 0
	b write_digit_ca_over

write_digit_ca4:	
	cmp r0, #4
	bne write_digit_ca5
	set_lat 0 1 1 0 0 1 1 0
	b write_digit_ca_over

write_digit_ca5:	
	cmp r0, #5
	bne write_digit_ca6
	set_lat 1 0 1 1 0 1 1 0
	b write_digit_ca_over

write_digit_ca6:	
	cmp r0, #6
	bne write_digit_ca7
	set_lat 1 0 1 1 1 1 1 0
	b write_digit_ca_over

write_digit_ca7:	
	cmp r0, #7
	bne write_digit_ca8
	set_lat 1 1 1 0 0 0 0 0
	b write_digit_ca_over

write_digit_ca8:	
	cmp r0, #8
	bne write_digit_ca9
	set_lat 1 1 1 1 1 1 1 0
	b write_digit_ca_over

write_digit_ca9:	
	cmp r0, #9
	bne write_digit_ca_over
	set_lat 1 1 1 1 0 1 1 0
write_digit_ca_over:


	set_off CA_CLKport CA_CLKbit
	set_on CA_CLKport CA_CLKbit
	
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
	

	set_off AN_CLKport AN_CLKbit
	set_on AN_CLKport AN_CLKbit

	set_off AN_NENport AN_NENbit
	set_off CA_NENport CA_NENbit
	
	pop {r3-r7,lr}
	bx lr

	.global write_led
	.thumb_func 
write_led:
	push {r3-r7,lr}
	set_on AN_NENport AN_NENbit
	set_on CA_NENport CA_NENbit
	
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

	set_off CA_CLKport CA_CLKbit
	set_on CA_CLKport CA_CLKbit
	
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

	set_off AN_CLKport AN_CLKbit
	set_on AN_CLKport AN_CLKbit

	set_off AN_NENport AN_NENbit
	set_off CA_NENport CA_NENbit
	
	pop {r3-r7,lr}
	bx lr


	.macro enable_gpio bit
	ldr r2, =RCC
	ldr	r1, [r2, #0]
	orr.w	r1, r1, \bit
	str	r1, [r2, #0]
	.endm

	.macro set_init_unit_bit0 port ofs bit
	ldr	r1, [r2, \ofs]
	bic.w	r1, r1, \bit
	str	r1, [r2, \ofs]
	.endm

	.macro set_init_unit_bit1 port ofs bit
	ldr	r1, [r2, \ofs]
	orr.w	r1, r1, \bit
	str	r1, [r2, \ofs]
	.endm
	
	.macro set_init_unit_bit_ port ofs bit
	.endm

	.macro set_init_unit port num v0 v1 v2 v3 v4 v5 v6
	ldr r2, =\port
	set_init_unit_bit\v0	\port 0	1<<(\num<<1+1)	
	set_init_unit_bit\v1	\port 0	1<<(\num<<1)		
	set_init_unit_bit\v2	\port 4	1<<\num			
	set_init_unit_bit\v3	\port 8	1<<(\num<<1+1)	
	set_init_unit_bit\v4	\port 8	1<<(\num<<1)	
	set_init_unit_bit\v5	\port 12	1<<(\num<<1+1)	
	set_init_unit_bit\v6	\port 12	1<<(\num<<1)	
	.endm

	.global display_init
	.thumb_func
display_init:
	push {r3-r7, lr}
	enable_gpio RCCAbit
	enable_gpio RCCCbit

	set_init_unit PC 4 0 1 0 1 0 0 1
	set_init_unit PA 6 0 1 0 1 0 0 1
	set_init_unit PC 5 0 1 0 1 0 0 1
	set_init_unit PC 1 0 1 0 1 0 0 1
	set_init_unit PC 2 0 1 0 1 0 0 1
	set_init_unit PA 0 0 1 0 1 0 0 1
	set_init_unit PC 3 0 1 0 1 0 0 1
	set_init_unit PA 7 0 1 0 1 0 0 1
	set_init_unit PA 4 0 1 0 1 0 0 1
	set_init_unit PC 0 0 1 0 1 0 0 1
	set_init_unit PA 1 0 1 0 1 0 0 1
	set_init_unit PA 5 0 1 0 1 0 0 1
	pop {r3-r7, lr}
	bx lr
	

