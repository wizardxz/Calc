	.equ GPIOA,		0x40020000
	.equ GPIOB,		0x40020400
	.equ GPIOC,		0x40020800
	.equ GPIOD,		0x40020C00

	@;MODER
	.equ GPIO_MODER, 0x00
	.equ GPIO_MODER_width, 2
	@;OTYPER
	.equ GPIO_OTYPER, 0x04
	.equ GPIO_OTYPER_width, 1
	@;OSPEEDER
	.equ GPIO_OSPEEDER, 0x08
	.equ GPIO_OSPEEDER_width, 2
	@;PUPDR
	.equ GPIO_PUPDR, 0x0C
	.equ GPIO_PUPDR_width, 2
	@;IDR
	.equ GPIO_IDR, 0x10
	.equ GPIO_IDR_width, 1
	@;BSRR
	.equ GPIO_BSRR, 0x18
	.equ GPIO_BSRR_width, 1
	@;AFR
	.equ GPIO_AFR, 0x20
	.equ GPIO_AFR_width, 4


	.macro gpio_init base n moder otyper ospeeder pupdr
	set_reg_n \base, GPIO_MODER,	GPIO_MODER_width,	 \n,\moder
	set_reg_n \base, GPIO_OTYPER,	GPIO_OTYPER_width,	 \n,\otyper
	set_reg_n \base, GPIO_OSPEEDER,	GPIO_OSPEEDER_width, \n,\ospeeder
	set_reg_n \base, GPIO_PUPDR,	GPIO_PUPDR_width,	 \n,\pupdr
	.endm
	
	.macro set_bit base n
	set_reg_n \base, GPIO_BSRR, GPIO_BSRR_width, \n, 1, 1 @;bsrr low
	.endm

	.macro reset_bit base n
	set_reg_n \base, GPIO_BSRR, GPIO_BSRR_width, \n+16, 1, 1 @;bsrr high
	.endm

	
