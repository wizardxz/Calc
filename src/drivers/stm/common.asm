	@;This file is about register access and function definition.
	@;
	@;set_reg and set_reg_n are both register write macro.
	@;test_reg is register read macro


	@;set_reg is to set specific register bits, 
	@;for example, to enable TIM2, I have to set enable bits in RCC
	@;set_reg RCC,RCC_APB1ENR,RCC_APB1ENR_TIM2EN_pin,RCC_APB1ENR_TIM2EN_bits,1
	@;
	@;Parameter base is the base address, (RCC=0x40023800)
	@;Parameter offset is the register offset relative to base, (RCC_APB1ENR=0x40)
	@;Parameter pin is the bit start position in the register, (RCC_APB1ENR_TIM2EN_pin=0)
	@;Parameter bits is the range that the bit affects, most time the length of range is 1, 
	@;			but sometimes it might be 2 or more, (RCC_APB1ENR_TIM2EN_bits=0x0001)
	@;Parameter value is the value we want to set on that bit of the register
	@;Parameter mode is the method we set bits. There are 2 modes, load_and_set and only_set.
	@;			the former one is to load that register first, then do bits clear, then do
	@;			bits or; the later one is to write bits without load.
	.macro set_reg base offset pin bits value mode=load_and_set
	ldr		r1, =\base
	.if \mode == load_and_set
		ldr		r2, [r1, \offset]
		ldr		r3, =\bits
		bic.w	r2, r3
		ldr		r3, =\value<<\pin
		orr.w	r2, r3
	.elseif \mode == only_set
		ldr		r2, =\value
		lsls	r2, r2, \pin
	.endif
	str		r2, [r1, \offset]
	.endm

	@;set_reg_n is to set register bits which repeatedly appears in register map,
	@;for example, GPIOx has 16 ports, to set moder of PD15 a value of 01(output)
	@;set_reg_n GPIOD,GPIO_MODER,GPIO_MODER_width,15,1
	@;
	@;Parameter base is the base address, (GPIOD=0x40020C00)
	@;Parameter offset is the register offset relative to base, (GPIO_MODER=0x00)
	@;Parameter width is the bit width, (GPIO_MODER_width=2)
	@;Parameter n is the port number(n=15)
	@;Parameter value is the value we want to set on that bit of the register
	@;Parameter mode is the method we set bits. There are 2 modes, load_and_set and only_set.
	@;			the former one is to load that register first, then do bits clear, then do
	@;			bits or; the later one is to write bits without load.
	.macro set_reg_n base offset width n value mode=load_and_set
	.if \value == _
	.else
		ldr		r1, =\base
		.if \mode == load_and_set
			ldr		r2, [r1, \offset]
			bic.w	r2, r2, (1<<\width-1)<<(\n*\width)
			orr.w	r2, r2, \value<<(\n*\width)
		.elseif \mode == only_set
			mov.w	r2, \value<<(\n*\width)
		.endif
		str		r2, [r1, \offset]
	.endif
	.endm

	@;test_reg is to test if register bits equals to value
	@;for example, read PA0
	@;test_reg GPIOA,GPIO_IDR,(1<<0)
	@;Parameter base is the base address, (GPIOA=0x40020000)
	@;Parameter offset is the register offset relative to base, (GPIO_IDR=0x10)
	@;Parameter bits are bits which we are interested in.
	@;Parameter value are what we are expected, the default value is all 1.
	@;Return value is zero flag. 
	.macro test_reg base offset bits value=default	
	ldr		r3, =\base
	ldr 	r2, [r3, \offset]
	ldr		r3, =\bits
	ands	r2, r2, r3
	.if \value == default
		ldr		r3, =\bits
	.else
		ldr		r3, =\value
	.endif
	cmp 	r2, r3
	.endm
	
	@;create a python-like function definition
	.macro def function		
	.global \function
	.thumb_func
\function:
	.endm
	

