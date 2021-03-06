@;SimpleStartSTM32F4_01.asm wmh 2013-02-03 : adaptation of LPC1768 startup for STM32F04
@; -todo: fix stuff with !! markers
@;SimpleStartLPC1768_02.s wmh 2011-11-10 startup code for NXP LPC1768
@; adapted from http://embeddedfreak.wordpress.com/2009/08/09/cortex-m3-blinky-in-assembly
@; with additions from http://tech.munts.com/MCU/Frameworks/ARM/lpc17xx/ 
 
/* Simple startup file for Cortex-M3 */


 .syntax unified	@; to allow thumb-2 instruction set
 
.include "src/drivers/stm/common.asm" 
.include "src/drivers/stm/rcc.asm"

 @; --- Vector table definition
 .section ".cs3.interrupt_vector"
 .long  __cs3_stack                 /* Top of Stack                 */
 .long  Reset_Handler               /* Reset Handler                */
 .long  NMI_Handler                 /* NMI Handler                  */
 .long  HardFault_Handler           /* Hard Fault Handler           */
 .long  MemManage_Handler           /* MPU Fault Handler            */
 .long  BusFault_Handler            /* Bus Fault Handler            */
 .long  UsageFault_Handler          /* Usage Fault Handler          */
 .long  0                           /* Reserved                     */
 .long  0                           /* Reserved                     */
 .long  0                           /* Reserved                     */
 .long  0                           /* Reserved                     */
 .long  SVC_Handler                 /* SVCall Handler               */
 .long  DebugMon_Handler            /* Debug Monitor Handler        */
 .long  0                           /* Reserved                     */
 .long  PendSV_Handler              /* PendSV Handler               */
 .long  SysTick_Handler             /* SysTick Handler              */
 /* External Interrupts */
 .long	WWDG_IRQHandler             /* Window WatchDog          					*/                              
 .long	PVD_IRQHandler              /* PVD through EXTI Line detection              */          
 .long	TAMP_STAMP_IRQHandler       /* Tamper and TimeStamps through the EXTI line  */          
 .long	RTC_WKUP_IRQHandler         /* RTC Wakeup through the EXTI line             */          
 .long	FLASH_IRQHandler            /* FLASH                                        */   
 .long	RCC_IRQHandler              /* RCC                                          */   
 .long	EXTI0_IRQHandler            /* EXTI Line0                                   */          
 .long	EXTI1_IRQHandler            /* EXTI Line1                                   */          
 .long	EXTI2_IRQHandler            /* EXTI Line2                                   */          
 .long	EXTI3_IRQHandler            /* EXTI Line3                                   */          
 .long	EXTI4_IRQHandler            /* EXTI Line4                                   */          
 .long	DMA1_Stream0_IRQHandler     /* DMA1 Stream 0                                */   
 .long	DMA1_Stream1_IRQHandler     /* DMA1 Stream 1                                */   
 .long	DMA1_Stream2_IRQHandler     /* DMA1 Stream 2                                */   
 .long	DMA1_Stream3_IRQHandler     /* DMA1 Stream 3                                */   
 .long	DMA1_Stream4_IRQHandler     /* DMA1 Stream 4                                */   
 .long	DMA1_Stream5_IRQHandler     /* DMA1 Stream 5                                */   
 .long	DMA1_Stream6_IRQHandler     /* DMA1 Stream 6                                */   
 .long	ADC_IRQHandler              /* ADC1, ADC2 and ADC3s                         */   
 .long	CAN1_TX_IRQHandler          /* CAN1 TX                                      */          
 .long	CAN1_RX0_IRQHandler         /* CAN1 RX0                                     */          
 .long	CAN1_RX1_IRQHandler         /* CAN1 RX1                                     */          
 .long	CAN1_SCE_IRQHandler         /* CAN1 SCE                                     */          
 .long	EXTI9_5_IRQHandler          /* External Line[9:5]s                          */          
 .long	TIM1_BRK_TIM9_IRQHandler    /* TIM1 Break and TIM9                          */
 .long	TIM1_UP_TIM10_IRQHandler    /* TIM1 Update and TIM10                        */
 .long	TIM1_TRG_COM_TIM11_IRQHandler /* TIM1 Trigger and Commutation and TIM11       */
 .long	TIM1_CC_IRQHandler          /* TIM1 Capture Compare                         */          
 .long	TIM2_IRQHandler             /* TIM2                                         */   
 .long	TIM3_IRQHandler             /* TIM3                                         */   
 .long	TIM4_IRQHandler             /* TIM4                                         */   
 .long	I2C1_EV_IRQHandler          /* I2C1 Event                                   */          
 .long	I2C1_ER_IRQHandler          /* I2C1 Error                                   */          
 .long	I2C2_EV_IRQHandler          /* I2C2 Event                                   */          
 .long	I2C2_ER_IRQHandler          /* I2C2 Error                                   */            
 .long	SPI1_IRQHandler             /* SPI1                                         */   
 .long	SPI2_IRQHandler             /* SPI2                                         */   
 .long	USART1_IRQHandler           /* USART1                                       */   
 .long	USART2_IRQHandler           /* USART2                                       */   
 .long	USART3_IRQHandler           /* USART3                                       */   
 .long	EXTI15_10_IRQHandler        /* External Line[15:10]s                        */          
 .long	RTC_Alarm_IRQHandler        /* RTC Alarm (A and B) through EXTI Line        */          
 .long	OTG_FS_WKUP_IRQHandler      /* USB OTG FS Wakeup through EXTI line          */              
 .long	TIM8_BRK_TIM12_IRQHandler   /* TIM8 Break and TIM12                         */
 .long	TIM8_UP_TIM13_IRQHandler    /* TIM8 Update and TIM13                        */
 .long	TIM8_TRG_COM_TIM14_IRQHandler /* TIM8 Trigger and Commutation and TIM14       */
 .long	TIM8_CC_IRQHandler          /* TIM8 Capture Compare                         */          
 .long	DMA1_Stream7_IRQHandler     /* DMA1 Stream7                                 */          
 .long	FSMC_IRQHandler             /* FSMC                                         */   
 .long	SDIO_IRQHandler             /* SDIO                                         */   
 .long	TIM5_IRQHandler             /* TIM5                                         */   
 .long	SPI3_IRQHandler             /* SPI3                                         */   
 .long	UART4_IRQHandler            /* UART4                                        */   
 .long	UART5_IRQHandler            /* UART5                                        */   
 .long	TIM6_DAC_IRQHandler         /* TIM6 and DAC1&2 underrun errors              */     
 .long	TIM7_IRQHandler             /* TIM7                                         */
 .long	DMA2_Stream0_IRQHandler     /* DMA2 Stream 0                                */   
 .long	DMA2_Stream1_IRQHandler     /* DMA2 Stream 1                                */   
 .long	DMA2_Stream2_IRQHandler     /* DMA2 Stream 2                                */   
 .long	DMA2_Stream3_IRQHandler     /* DMA2 Stream 3                                */   
 .long	DMA2_Stream4_IRQHandler     /* DMA2 Stream 4                                */   
 .long	ETH_IRQHandler              /* Ethernet                                     */   
 .long	ETH_WKUP_IRQHandler         /* Ethernet Wakeup through EXTI line            */          
 .long	CAN2_TX_IRQHandler          /* CAN2 TX                                      */          
 .long	CAN2_RX0_IRQHandler         /* CAN2 RX0                                     */          
 .long	CAN2_RX1_IRQHandler         /* CAN2 RX1                                     */          
 .long	CAN2_SCE_IRQHandler         /* CAN2 SCE                                     */          
 .long	OTG_FS_IRQHandler           /* USB OTG FS                                   */   
 .long	DMA2_Stream5_IRQHandler     /* DMA2 Stream 5                                */   
 .long	DMA2_Stream6_IRQHandler     /* DMA2 Stream 6                                */   
 .long	DMA2_Stream7_IRQHandler     /* DMA2 Stream 7                                */   
 .long	USART6_IRQHandler           /* USART6                                       */    
 .long	I2C3_EV_IRQHandler          /* I2C3 event                                   */          
 .long	I2C3_ER_IRQHandler          /* I2C3 error                                   */          
 .long	OTG_HS_EP1_OUT_IRQHandler   /* USB OTG HS End Point 1 Out                   */   
 .long	OTG_HS_EP1_IN_IRQHandler    /* USB OTG HS End Point 1 In                    */   
 .long	OTG_HS_WKUP_IRQHandler      /* USB OTG HS Wakeup through EXTI               */          
 .long	OTG_HS_IRQHandler           /* USB OTG HS                                   */   
 .long	DCMI_IRQHandler             /* DCMI                                         */   
 .long	CRYP_IRQHandler             /* CRYP crypto                                  */   
 .long	HASH_RNG_IRQHandler         /* Hash and Rng                                 */
 .long	FPU_IRQHandler              /* FPU                                          */
 .long	UART7_IRQHandler            /* UART7                                        */
 .long	UART8_IRQHandler            /* UART8                                        */
 .long	SPI4_IRQHandler             /* SPI4                                         */
 .long	SPI5_IRQHandler             /* SPI5                                         */
 .long	SPI6_IRQHandler             /* SPI6                                         */
@; Vendor hardware-specific interrupts go here (Not implemented)

	
@; --- hardware reset routine
	.text					@; start the reset code section

	.global Reset_Handler	@; export label name to all modules 
	.thumb_func 			@; identify target type to linker
Reset_Handler:				@; @; start-from-reset code; initialize hardware and system data, launch main()
	@; copy .data section (initialized data) from flash to RAM (currently we must do this in each source file)
	@; (!!todo: figure out how we can get the compiler/asembler/linker to place constants in .rodata, etc)
copy_data:	
	ldr r1, DATA_BEG
	ldr r2, TEXT_END
	ldr r3, DATA_END
	subs r3, r3, r1			@; length of initialized data
	beq zero_bss			@; skip if none
copy_data_loop: 
	ldrb r4,[r2], #1		@; read byte from flash
	strb r4, [r1], #1  		@; store byte to RAM
	subs r3, r3, #1  		@; decrement counter
	bgt copy_data_loop		@; repeat until done

	@; zero out .bss section (uninitialized data) (currently we must do this in each source file)
	@; (!!todo: figure out how to get the linker to give us the extents of the merged .bss sections)
zero_bss: 	
	ldr r1, BSS_BEG
	ldr r3, BSS_END
	subs r3, r3, r1			@; Length of uninitialized data
	beq initPLL				@; Skip if none
	mov r2, #0				@; value to initialize .bss with
zero_bss_loop: 	
	strb r2, [r1],#1		@; Store zero
	subs r3, r3, #1			@; Decrement counter
	bgt zero_bss_loop		@; Repeat until done

	@; necessary hardware stuff (todo: crib from disassembly of Keil initPLL.c)
initPLL:
@;	bl SystemInit
	mov.w	r3, #60672	@; 0xed00		 - set 'full access' mode in Coprocessor access control register (CPACR) (see reference above)
	movt	r3, #57344	@; 0xe000    	 - ..
	mov.w	r2, #60672	@; 0xed00		 - ..
	movt	r2, #57344	@; 0xe000		 - ..
	ldr.w	r2, [r2, #136]	@; 0x88		 - ..
	orr.w	r2, r2, #15728640	@; 0xf00000 - ..
	str.w	r2, [r3, #136]	@; 0x88		 - ..

	@;default clock is HSI, M=16, N=192, P=2, SYSCLK=96MHz
	
	
	@exit to main (wont return)
call_main:	
	mov	r0, #0				@; argc=0
	mov r1, #0				@; argv=NULL
	bl	main 				@; gone
	b .						@; trap if return

	@; pointer data for 'copy_data' and 'zero_bss' functions 
TEXT_END:	.word	__sidata	@; __text_end__
DATA_BEG:	.word	__sdata		@; __data_beg__
DATA_END:	.word	__edata		@; __data_end__
BSS_BEG:	.word	__sbss		@; __bss_beg__ 
BSS_END:	.word	__ebss		@; __bss_end__


.macro defweak fun 
	.thumb_func
	.weak \fun
\fun:
.endm

defweak NMI_Handler
defweak HardFault_Handler
defweak MemManage_Handler
defweak BusFault_Handler
defweak UsageFault_Handler
defweak SVC_Handler
defweak DebugMon_Handler
defweak PendSV_Handler
defweak SysTick_Handler
defweak WWDG_IRQHandler
defweak PVD_IRQHandler
defweak TAMP_STAMP_IRQHandler
defweak RTC_WKUP_IRQHandler
defweak FLASH_IRQHandler
defweak RCC_IRQHandler
defweak EXTI0_IRQHandler
defweak EXTI1_IRQHandler
defweak EXTI2_IRQHandler
defweak EXTI3_IRQHandler
defweak EXTI4_IRQHandler
defweak DMA1_Stream0_IRQHandler
defweak DMA1_Stream1_IRQHandler
defweak DMA1_Stream2_IRQHandler
defweak DMA1_Stream3_IRQHandler
defweak DMA1_Stream4_IRQHandler
defweak DMA1_Stream5_IRQHandler
defweak DMA1_Stream6_IRQHandler
defweak ADC_IRQHandler
defweak CAN1_TX_IRQHandler
defweak CAN1_RX0_IRQHandler
defweak CAN1_RX1_IRQHandler
defweak CAN1_SCE_IRQHandler
defweak EXTI9_5_IRQHandler
defweak TIM1_BRK_TIM9_IRQHandler
defweak TIM1_UP_TIM10_IRQHandler
defweak TIM1_TRG_COM_TIM11_IRQHandler
defweak TIM1_CC_IRQHandler
defweak TIM2_IRQHandler
defweak TIM3_IRQHandler
defweak TIM4_IRQHandler
defweak I2C1_EV_IRQHandler
defweak I2C1_ER_IRQHandler
defweak I2C2_EV_IRQHandler
defweak I2C2_ER_IRQHandler
defweak SPI1_IRQHandler
defweak SPI2_IRQHandler
defweak USART1_IRQHandler
defweak USART2_IRQHandler
defweak USART3_IRQHandler
defweak EXTI15_10_IRQHandler
defweak RTC_Alarm_IRQHandler
defweak OTG_FS_WKUP_IRQHandler
defweak TIM8_BRK_TIM12_IRQHandler
defweak TIM8_UP_TIM13_IRQHandler
defweak TIM8_TRG_COM_TIM14_IRQHandler
defweak TIM8_CC_IRQHandler
defweak DMA1_Stream7_IRQHandler
defweak FSMC_IRQHandler
defweak SDIO_IRQHandler
defweak TIM5_IRQHandler
defweak SPI3_IRQHandler
defweak UART4_IRQHandler
defweak UART5_IRQHandler
defweak TIM6_DAC_IRQHandler
defweak TIM7_IRQHandler
defweak DMA2_Stream0_IRQHandler
defweak DMA2_Stream1_IRQHandler
defweak DMA2_Stream2_IRQHandler
defweak DMA2_Stream3_IRQHandler
defweak DMA2_Stream4_IRQHandler
defweak ETH_IRQHandler
defweak ETH_WKUP_IRQHandler
defweak CAN2_TX_IRQHandler
defweak CAN2_RX0_IRQHandler
defweak CAN2_RX1_IRQHandler
defweak CAN2_SCE_IRQHandler
defweak OTG_FS_IRQHandler
defweak DMA2_Stream5_IRQHandler
defweak DMA2_Stream6_IRQHandler
defweak DMA2_Stream7_IRQHandler
defweak USART6_IRQHandler
defweak I2C3_EV_IRQHandler
defweak I2C3_ER_IRQHandler
defweak OTG_HS_EP1_OUT_IRQHandler
defweak OTG_HS_EP1_IN_IRQHandler
defweak OTG_HS_WKUP_IRQHandler
defweak OTG_HS_IRQHandler
defweak DCMI_IRQHandler
defweak CRYP_IRQHandler
defweak HASH_RNG_IRQHandler
defweak FPU_IRQHandler
defweak UART7_IRQHandler
defweak UART8_IRQHandler
defweak SPI4_IRQHandler
defweak SPI5_IRQHandler
defweak SPI6_IRQHandler
	bx lr
