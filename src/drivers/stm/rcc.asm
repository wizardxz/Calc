
	.equ RCC, 		0x40023800
	@;CR
	.equ RCC_CR, 0x00
	.equ RCC_CR_HSEON_pin, 16;			.equ RCC_CR_HSEON_bits, (1<<RCC_CR_HSEON_pin)
	.equ RCC_CR_PLLI2SON_pin, 26;		.equ RCC_CR_PLLI2SON_bits, (1<<RCC_CR_PLLI2SON_pin)
	@;AHB1ENR
	.equ RCC_AHB1ENR, 0x30
	.equ RCC_AHB1ENR_GPIOAEN_pin, 0;	.equ RCC_AHB1ENR_GPIOAEN_bits, (1<<RCC_AHB1ENR_GPIOAEN_pin)
	.equ RCC_AHB1ENR_GPIOBEN_pin, 1;	.equ RCC_AHB1ENR_GPIOBEN_bits, (1<<RCC_AHB1ENR_GPIOBEN_pin)
	.equ RCC_AHB1ENR_GPIOCEN_pin, 2;	.equ RCC_AHB1ENR_GPIOCEN_bits, (1<<RCC_AHB1ENR_GPIOCEN_pin)
	.equ RCC_AHB1ENR_GPIODEN_pin, 3;	.equ RCC_AHB1ENR_GPIODEN_bits, (1<<RCC_AHB1ENR_GPIODEN_pin)
	@;APB1ENR
	.equ RCC_APB1ENR, 0x40
	.equ RCC_APB1ENR_TIM2EN_pin, 0;		.equ RCC_APB1ENR_TIM2EN_bits, (1<<RCC_APB1ENR_TIM2EN_pin)
	.equ RCC_APB1ENR_TIM3EN_pin, 1;		.equ RCC_APB1ENR_TIM3EN_bits, (1<<RCC_APB1ENR_TIM3EN_pin)
	.equ RCC_APB1ENR_TIM4EN_pin, 2;		.equ RCC_APB1ENR_TIM4EN_bits, (1<<RCC_APB1ENR_TIM4EN_pin)
	.equ RCC_APB1ENR_SPI2EN_pin, 14;	.equ RCC_APB1ENR_SPI2EN_bits, (1<<RCC_APB1ENR_SPI2EN_pin)
	.equ RCC_APB1ENR_SPI3EN_pin, 15;	.equ RCC_APB1ENR_SPI3EN_bits, (1<<RCC_APB1ENR_SPI3EN_pin)
	.equ RCC_APB1ENR_I2C1EN_pin, 21;	.equ RCC_APB1ENR_I2C1EN_bits, (1<<RCC_APB1ENR_I2C1EN_pin)
	.equ RCC_APB1ENR_I2C2EN_pin, 22;	.equ RCC_APB1ENR_I2C2EN_bits, (1<<RCC_APB1ENR_I2C2EN_pin)
	.equ RCC_APB1ENR_I2C3EN_pin, 23;	.equ RCC_APB1ENR_I2C3EN_bits, (1<<RCC_APB1ENR_I2C3EN_pin)
	@;APB1RSTR
	.equ RCC_APB1RSTR, 0x20
	.equ RCC_APB1RSTR_TIM2RST_pin, 0;	.equ RCC_APB1RSTR_TIM2RST_bits, (1<<RCC_APB1RSTR_TIM2RST_pin)
	.equ RCC_APB1RSTR_TIM3RST_pin, 1;	.equ RCC_APB1RSTR_TIM3RST_bits, (1<<RCC_APB1RSTR_TIM3RST_pin)
	.equ RCC_APB1RSTR_TIM4RST_pin, 2;	.equ RCC_APB1RSTR_TIM4RST_bits, (1<<RCC_APB1RSTR_TIM4RST_pin)
	.equ RCC_APB1RSTR_SPI2RST_pin, 14;	.equ RCC_APB1RSTR_SPI2RST_bits, (1<<RCC_APB1RSTR_SPI2RST_pin)
	.equ RCC_APB1RSTR_SPI3RST_pin, 15;	.equ RCC_APB1RSTR_SPI3RST_bits, (1<<RCC_APB1RSTR_SPI3RST_pin)
	.equ RCC_APB1RSTR_I2C1RST_pin, 21;	.equ RCC_APB1RSTR_I2C1RST_bits, (1<<RCC_APB1RSTR_I2C1RST_pin)
	.equ RCC_APB1RSTR_I2C2RST_pin, 22;	.equ RCC_APB1RSTR_I2C2RST_bits, (1<<RCC_APB1RSTR_I2C2RST_pin)
	.equ RCC_APB1RSTR_I2C3RST_pin, 23;	.equ RCC_APB1RSTR_I2C3RST_bits, (1<<RCC_APB1RSTR_I2C3RST_pin)
	@;APB2ENR
	.equ RCC_APB2ENR, 0x44
	.equ RCC_APB2ENR_SYSCFGEN_pin, 14; .equ RCC_APB2ENR_SYSCFGEN_bits, (1<<RCC_APB2ENR_SYSCFGEN_pin)
	
	
