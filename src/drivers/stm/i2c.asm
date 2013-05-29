	.equ I2C1, 0x40005400
	.equ I2C2, 0x40005800
	.equ I2C3, 0x40005C00
	
	@;CR1
	.equ I2C_CR1, 0x00
	.equ I2C_CR1_PE_pin, 0;			.equ I2C_CR1_PE_bits, (1<<I2C_CR1_PE_pin)
	.equ I2C_CR1_START_pin, 8;		.equ I2C_CR1_START_bits, (1<<I2C_CR1_START_pin)
	.equ I2C_CR1_STOP_pin, 9;		.equ I2C_CR1_STOP_bits, (1<<I2C_CR1_STOP_pin)
	.equ I2C_CR1_ACK_pin, 10;		.equ I2C_CR1_ACK_bits, (1<<I2C_CR1_ACK_pin)
	@;CR2	
	.equ I2C_CR2, 0x04
	.equ I2C_CR2_FREQ_pin, 0;		.equ I2C_CR2_FREQ_bits, (0x3F<<I2C_CR2_FREQ_pin)
	@;DR
	.equ I2C_DR, 0x10
	.equ I2C_DR_DR_pin, 0;			.equ I2C_DR_DR_bits, (0xFF<<I2C_DR_DR_pin)
	@;SR1
	.equ I2C_SR1, 0x14
	.equ I2C_SR1_SB_pin, 0;			.equ I2C_SR1_SB_bits, (1<<I2C_SR1_SB_pin)
	.equ I2C_SR1_ADDR_pin, 1;		.equ I2C_SR1_ADDR_bits, (1<<I2C_SR1_ADDR_pin)
	.equ I2C_SR1_BTF_pin, 2;		.equ I2C_SR1_BTF_bits, (1<<I2C_SR1_BTF_pin)
	.equ I2C_SR1_ADD10_pin, 3;		.equ I2C_SR1_ADD10_bits, (1<<I2C_SR1_ADD10_pin)
	.equ I2C_SR1_STOPF_pin, 4;		.equ I2C_SR1_STOPF_bits, (1<<I2C_SR1_STOPF_pin)
	.equ I2C_SR1_RxNE_pin, 6;		.equ I2C_SR1_RxNE_bits, (1<<I2C_SR1_RxNE_pin)
	.equ I2C_SR1_TxE_pin, 7;		.equ I2C_SR1_TxE_bits, (1<<I2C_SR1_TxE_pin)
	.equ I2C_SR1_BERR_pin, 8;		.equ I2C_SR1_BERR_bits, (1<<I2C_SR1_BERR_pin)
	.equ I2C_SR1_ARLO_pin, 9;		.equ I2C_SR1_ARLO_bits, (1<<I2C_SR1_ARLO_pin)
	.equ I2C_SR1_AF_pin, 10;		.equ I2C_SR1_AF_bits, (1<<I2C_SR1_AF_pin)
	.equ I2C_SR1_OVR_pin, 11;		.equ I2C_SR1_OVR_bits, (1<<I2C_SR1_OVR_pin)
	.equ I2C_SR1_PECERR_pin, 12;	.equ I2C_SR1_PECERR_bits, (1<<I2C_SR1_PECERR_pin)
	.equ I2C_SR1_TIMEOUT_pin, 14;	.equ I2C_SR1_TIMEOUT_bits, (1<<I2C_SR1_TIMEOUT_pin)
	.equ I2C_SR1_SMBALERT_pin, 15;	.equ I2C_SR1_SMBALERT_bits, (1<<I2C_SR1_SMBALERT_pin)
	@;SR2
	.equ I2C_SR2, 0x18
	.equ I2C_SR2_MSL_pin, 0;		.equ I2C_SR2_MSL_bits, (1<<I2C_SR2_MSL_pin)
	.equ I2C_SR2_BUSY_pin, 1;		.equ I2C_SR2_BUSY_bits, (1<<I2C_SR2_BUSY_pin)
	.equ I2C_SR2_TRA_pin, 2;		.equ I2C_SR2_TRA_bits, (1<<I2C_SR2_TRA_pin)
	.equ I2C_SR2_GENCALL_pin, 4;	.equ I2C_SR2_GENCALL_bits, (1<<I2C_SR2_GENCALL_pin)
	.equ I2C_SR2_SMBDEFAULT_pin, 5;	.equ I2C_SR2_SMBDEFAULT_bits, (1<<I2C_SR2_SMBDEFAULT_pin)
	.equ I2C_SR2_SMBHOST_pin, 6;	.equ I2C_SR2_SMBHOST_bits, (1<<I2C_SR2_SMBHOST_pin)
	.equ I2C_SR2_DUALF_pin, 7;		.equ I2C_SR2_DUALF_bits, (1<<I2C_SR2_DUALF_pin)
	
	@;OAR1
	.equ I2C_OAR1, 0x08
	.equ I2C_OAR1_ADD0_pin, 0;		.equ I2C_OAR1_ADD0_bits, (1<<I2C_OAR1_ADD0_pin)
	.equ I2C_OAR1_ADD_pin, 0;		.equ I2C_OAR1_ADD_bits, (0x3FF<<I2C_OAR1_ADD_pin)
	.equ I2C_OAR1_ADDMODE_pin, 15;	.equ I2C_OAR1_ADDMODE_bits, (1<<I2C_OAR1_ADDMODE_pin)
	@;CCR
	.equ I2C_CCR, 0x1C
	.equ I2C_CCR_CCR_pin, 0;		.equ I2C_CCR_CCR_bits, (0xFFF<<I2C_CCR_CCR_pin)
	@;TRISE
	.equ I2C_TRISE, 0x20
	.equ I2C_TRISE_TRISE_pin, 0;	.equ I2C_TRISE_TRISE_bits, (0x3F<<I2C_TRISE_TRISE_pin)
	
	@;Initialize I2C by setting frequency, address, addmode, ccr and trise
	.macro i2c_init freq address addmode ccr trise
	set_reg I2C1, I2C_CR1, I2C_CR1_ACK_pin, I2C_CR1_ACK_bits, 1
	set_reg I2C1, I2C_CR2, I2C_CR2_FREQ_pin, I2C_CR2_FREQ_bits, \freq
	set_reg I2C1, I2C_OAR1, I2C_OAR1_ADD_pin, I2C_OAR1_ADD_bits, \address
	set_reg I2C1, I2C_OAR1, I2C_OAR1_ADDMODE_pin, I2C_OAR1_ADDMODE_bits, \addmode
	set_reg I2C1, I2C_CCR, I2C_CCR_CCR_pin, I2C_CCR_CCR_bits, \ccr
	set_reg I2C1, I2C_TRISE, I2C_TRISE_TRISE_pin, I2C_TRISE_TRISE_bits, \trise
	.endm
	
