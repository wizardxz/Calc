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
