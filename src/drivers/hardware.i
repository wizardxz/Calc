	.equ RCC,	0x40023830
	.equ PA, 	0x40020000
	.equ PB, 	0x40020400
	.equ PC, 	0x40020800
	.equ PD, 	0x40020c00

	.equ RCCAbit, (1<<0)
	.equ RCCBbit, (1<<1)
	.equ RCCCbit, (1<<2)
	.equ RCCDbit, (1<<3)

	.equ LAT0port, PC	@;CA_A/LED5-COLON
	.equ LAT0bit, (1<<2)
	.equ LAT1port, PA	@;CA_B/LED6-DIGIT4
	.equ LAT1bit, (1<<0)
	.equ LAT2port, PC	@;CA_C/LED1-DIGIT2
	.equ LAT2bit, (1<<3)
	.equ LAT3port, PA	@;CA_D
	.equ LAT3bit, (1<<7)
	.equ LAT4port, PA	@;CA_E-AN_R
	.equ LAT4bit, (1<<4)
	.equ LAT5port, PC	@;CA_F/LED4-DIGIT1
	.equ LAT5bit, (1<<0)
	.equ LAT6port, PA	@;CA_G/LED2-DIGIT3
	.equ LAT6bit, (1<<1)
	.equ LAT7port, PA	@;CA_DP/LED3-AN_G
	.equ LAT7bit, (1<<5)

	.equ CA_NENport, PC
	.equ CA_NENbit,	(1<<1)
	.equ AN_NENport, PA
	.equ AN_NENbit,	(1<<6)
	.equ CA_CLKport, PC
	.equ CA_CLKbit,	(1<<5)
	.equ AN_CLKport, PC
	.equ AN_CLKbit,	(1<<4)
	
	.equ S1port1,	PB
	.equ S1port2,	PB
	.equ S1bit, 	(1<<9)
	.equ S1mask, 	0
	.equ S2port1,	PB
	.equ S2port2, 	PD
	.equ S2bit, 	(1<<9)
	.equ S2mask, 	2
	.equ S3port1,	PB
	.equ S3port2, 	PB
	.equ S3bit, 	(1<<9)
	.equ S3mask, 	1
	.equ S4port1,	PB
	.equ S4port2, 	PB
	.equ S4bit, 	(1<<9)
	.equ S4mask, 	6
	.equ S5port1,	PC
	.equ S5port2, 	PB
	.equ S5bit, 	(1<<10)
	.equ S5mask, 	0
	.equ S6port1,	PC
	.equ S6port2, 	PD
	.equ S6bit, 	(1<<10)
	.equ S6mask, 	2
	.equ S7port1,	PC
	.equ S7port2, 	PB
	.equ S7bit, 	(1<<10)
	.equ S7mask, 	1
	.equ S8port1,	PC
	.equ S8port2, 	PB
	.equ S8bit, 	(1<<10)
	.equ S8mask, 	6
	.equ S9port1,	PC
	.equ S9port2, 	PB
	.equ S9bit, 	(1<<11)
	.equ S9mask, 	0
	.equ S10port1,	PC
	.equ S10port2, 	PD
	.equ S10bit, 	(1<<11)
	.equ S10mask, 	2
	.equ S11port1,	PC
	.equ S11port2, 	PB
	.equ S11bit, 	(1<<11)
	.equ S11mask, 	1
	.equ S12port1,	PC
	.equ S12port2, 	PB
	.equ S12bit, 	(1<<11)
	.equ S12mask, 	6

	.equ ROT_Aport,	PC
	.equ ROT_Abit,	(1<<12)
	.equ ROT_Bport, PB
	.equ ROT_Bbit,	(1<<5)
