	.equ SYSTICK,	0xE000E000

	.equ STK_CTRL, 0x10
	.equ STK_CTRL_ENABLE_pin, 0;		.equ STK_CTRL_ENABLE_bits, (1<<STK_CTRL_ENABLE_pin)
	.equ STK_CTRL_TICKINT_pin, 1;		.equ STK_CTRL_TICKINT_bits, (1<<STK_CTRL_TICKINT_pin)
	.equ STK_CTRL_CLKSOURCE_pin, 2;		.equ STK_CTRL_CLKSOURCE_bits, (1<<STK_CTRL_CLKSOURCE_pin)
	
	.equ STK_LOAD, 0x14
	.equ STK_LOAD_RELOAD_pin, 0;		.equ STK_LOAD_RELOAD_bits, (0xFFF<<STK_LOAD_RELOAD_pin)

	
	.equ STK_VAL, 0x18
	.equ STK_VAL_CURRENT_pin, 0;		.equ STK_VAL_CURRENT_bits, (0xFFF<<STK_VAL_CURRENT_pin)

