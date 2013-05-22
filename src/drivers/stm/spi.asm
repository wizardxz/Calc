	.equ SPI2,		0x40003800
	.equ SPI3,		0x40003C00

	@;SPI_I2SCFGR
	.equ i2smodepin,	11
	.equ i2smspin,		9 @;master = 1, slave = 0
	.equ i2strpin,		8 @;transmit = 1, receive = 0
	@;SPI_I2SPR
	.equ mckoepin,		9
	.equ i2sdivpin,		0
	
	.macro spi_i2scfgr spi pin value
	ldr 	r2, =\spi

	ldr		r1, [r2, #0x1C]
	.if \value == 1
		orr.w	r1, r1, (1<<\pin)
	.else
		bic.w	r1, r1, (1<<\pin)
	.endif
	str		r1, [r2, #0x1C]
	.endm
		
	.macro spi_i2spr spi pin value
	ldr 	r2, =\spi

	ldr		r1, [r2, #0x20]
	.if \value == 1
		orr.w	r1, r1, (1<<\pin)
	.else
		bic.w	r1, r1, (1<<\pin)
	.endif
	str		r1, [r2, #0x20]
	.endm
	
	.macro spi_i2scfgr_init spi i2smode i2sms i2str mckoe i2sdiv
	spi_i2scfgr \spi i2smodepin \i2smode
	spi_i2scfgr \spi i2smspin \i2sms
	spi_i2scfgr \spi i2strpin \i2str
	spi_i2spr \spi mckoepin \mckoe
	
	ldr 	r2, =\spi
	ldr		r1, [r2, #0x20]
	orr		r1, r1, \i2sdiv
	str		r1, [r2, #0x20]
	
	.endm
	