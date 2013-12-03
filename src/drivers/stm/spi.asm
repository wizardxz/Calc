	.equ SPI2,		0x40003800
	.equ SPI3,		0x40003C00

	@;I2SCFGR
	.equ SPI_I2SCFGR, 0x1C
	.equ SPI_I2SCFGR_I2SMODE_pin, 11;	.equ SPI_I2SCFGR_I2SMODE_bits, (1<<SPI_I2SCFGR_I2SMODE_pin)
	.equ SPI_I2SCFGR_I2SCFG_pin, 8;		.equ SPI_I2SCFGR_I2SCFG_bits, (3<<SPI_I2SCFGR_I2SCFG_pin)

	@;I2SPR
	.equ SPI_I2SPR, 0x20
	.equ SPI_I2SPR_I2SDIV_pin, 0;		.equ SPI_I2SPR_I2SDIV_bits, (0x1FF<<SPI_I2SPR_I2SDIV_pin)
	.equ SPI_I2SPR_MCKOE_pin, 9;		.equ SPI_I2SPR_MCKOE_bits, (1<<SPI_I2SPR_MCKOE_pin)
	
	@;Initialize SPI by setting i2smode, i2scfg, mckoe and i2sdiv.
	.macro spi_init base i2smode i2scfg mckoe i2sdiv
	set_reg \base, SPI_I2SCFGR, SPI_I2SCFGR_I2SMODE_pin, SPI_I2SCFGR_I2SMODE_bits, \i2smode
	set_reg \base, SPI_I2SCFGR, SPI_I2SCFGR_I2SCFG_pin, SPI_I2SCFGR_I2SCFG_bits, \i2scfg
	set_reg \base, SPI_I2SPR, SPI_I2SPR_I2SDIV_pin, SPI_I2SPR_I2SDIV_bits, \i2sdiv
	set_reg \base, SPI_I2SPR, SPI_I2SPR_MCKOE_pin, SPI_I2SPR_MCKOE_bits, \mckoe
	.endm
	