@;SimpleStartSTM32F4_01.asm wmh 2013-02-03 : adaptation of LPC1768 startup for STM32F04
@; -todo: fix stuff with !! markers
@;SimpleStartLPC1768_02.s wmh 2011-11-10 startup code for NXP LPC1768
@; adapted from http://embeddedfreak.wordpress.com/2009/08/09/cortex-m3-blinky-in-assembly
@; with additions from http://tech.munts.com/MCU/Frameworks/ARM/lpc17xx/ 
 
/* Simple startup file for Cortex-M3 */


 .syntax unified	@; to allow thumb-2 instruction set

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
 .long  WWDG_IRQHandler                        
 .long  PVD_IRQHandler                         
 .long  TAMP_STAMP_IRQHandler                  
 .long  RTC_WKUP_IRQHandler                    
 .long  FLASH_IRQHandler                  
 .long  RCC_IRQHandler                    
 .long  EXTI0_IRQHandler                       
 .long  EXTI1_IRQHandler                       
 .long  EXTI2_IRQHandler                       
 .long  EXTI3_IRQHandler                       
 .long  EXTI4_IRQHandler                       
 .long  DMA1_Stream0_IRQHandler           
 .long  DMA1_Stream1_IRQHandler           
 .long  DMA1_Stream2_IRQHandler           
 .long  DMA1_Stream3_IRQHandler           
 .long  DMA1_Stream4_IRQHandler           
 .long  DMA1_Stream5_IRQHandler           
 .long  DMA1_Stream6_IRQHandler           
 .long  ADC_IRQHandler                    
 .long  CAN1_TX_IRQHandler                     
 .long  CAN1_RX0_IRQHandler                    
 .long  CAN1_RX1_IRQHandler                    
 .long  CAN1_SCE_IRQHandler                    
 .long  EXTI9_5_IRQHandler                     
 .long  TIM1_BRK_TIM9_IRQHandler          
 .long  TIM1_UP_TIM10_IRQHandler          
 .long  TIM1_TRG_COM_TIM11_IRQHandler     
 .long  TIM1_CC_IRQHandler                     
 .long  TIM2_IRQHandler                   
 .long  TIM3_IRQHandler                   
 .long  TIM4_IRQHandler                   
 .long  I2C1_EV_IRQHandler                     
 .long  I2C1_ER_IRQHandler                     
 .long  I2C2_EV_IRQHandler                     
 .long  I2C2_ER_IRQHandler                       
 .long  SPI1_IRQHandler                   
 .long  SPI2_IRQHandler                   
 .long  USART1_IRQHandler                 
 .long  USART2_IRQHandler                 
 .long  USART3_IRQHandler                 
 .long  EXTI15_10_IRQHandler                   
 .long  RTC_Alarm_IRQHandler                   
 .long  OTG_FS_WKUP_IRQHandler                     
 .long  TIM8_BRK_TIM12_IRQHandler         
 .long  TIM8_UP_TIM13_IRQHandler          
 .long  TIM8_TRG_COM_TIM14_IRQHandler     
 .long  TIM8_CC_IRQHandler                     
 .long  DMA1_Stream7_IRQHandler                
 .long  FSMC_IRQHandler                   
 .long  SDIO_IRQHandler                   
 .long  TIM5_IRQHandler                   
 .long  SPI3_IRQHandler                   
 .long  UART4_IRQHandler                  
 .long  UART5_IRQHandler                  
 .long  TIM6_DAC_IRQHandler               
 .long  TIM7_IRQHandler                   
 .long  DMA2_Stream0_IRQHandler           
 .long  DMA2_Stream1_IRQHandler           
 .long  DMA2_Stream2_IRQHandler           
 .long  DMA2_Stream3_IRQHandler           
 .long  DMA2_Stream4_IRQHandler           
 .long  ETH_IRQHandler                    
 .long  ETH_WKUP_IRQHandler                    
 .long  CAN2_TX_IRQHandler                     
 .long  CAN2_RX0_IRQHandler                    
 .long  CAN2_RX1_IRQHandler                    
 .long  CAN2_SCE_IRQHandler                    
 .long  OTG_FS_IRQHandler                 
 .long  DMA2_Stream5_IRQHandler           
 .long  DMA2_Stream6_IRQHandler           
 .long  DMA2_Stream7_IRQHandler           
 .long  USART6_IRQHandler                 
 .long  I2C3_EV_IRQHandler                     
 .long  I2C3_ER_IRQHandler                     
 .long  OTG_HS_EP1_OUT_IRQHandler         
 .long  OTG_HS_EP1_IN_IRQHandler          
 .long  OTG_HS_WKUP_IRQHandler                 
 .long  OTG_HS_IRQHandler                 
 .long  DCMI_IRQHandler                   
 .long  CRYP_IRQHandler                   
 .long  HASH_RNG_IRQHandler               
 .long  FPU_IRQHandler 
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
	initPLL:	@; !!todo -- fix this!				
				@; put code here to set up PLL 
	@;bl SystemInit
	@; do the 'C' global variable inits 'by hand' (since the above doesn't work)
@;	bl CortexM3cOps_init @; !!todo -- fix this!	
	@; do the asm variable inits 'by hand' (since the above doesnt work)
@;	bl CortexM3asmOps_init @; !!todo -- fix this!	
	@;here with everything set up and ready to go
	
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


/* This is how the lazy guy doing it: by aliasing all the
 * interrupts into single address
 */
	.macro weakdef function
	.thumb_func
	.weak \function
\function:
	.endm
weakdef NMI_Handler
weakdef HardFault_Handler
weakdef MemManage_Handler
weakdef BusFault_Handler
weakdef UsageFault_Handler
weakdef SVC_Handler
weakdef DebugMon_Handler
weakdef PendSV_Handler
weakdef SysTick_Handler
weakdef WWDG_IRQHandler
weakdef PVD_IRQHandler
weakdef TAMP_STAMP_IRQHandler
weakdef RTC_WKUP_IRQHandler
weakdef FLASH_IRQHandler
weakdef RCC_IRQHandler
weakdef EXTI0_IRQHandler
weakdef EXTI1_IRQHandler
weakdef EXTI2_IRQHandler
weakdef EXTI3_IRQHandler
weakdef EXTI4_IRQHandler
weakdef DMA1_Stream0_IRQHandler
weakdef DMA1_Stream1_IRQHandler
weakdef DMA1_Stream2_IRQHandler
weakdef DMA1_Stream3_IRQHandler
weakdef DMA1_Stream4_IRQHandler
weakdef DMA1_Stream5_IRQHandler
weakdef DMA1_Stream6_IRQHandler
weakdef ADC_IRQHandler
weakdef CAN1_TX_IRQHandler
weakdef CAN1_RX0_IRQHandler
weakdef CAN1_RX1_IRQHandler
weakdef CAN1_SCE_IRQHandler
weakdef EXTI9_5_IRQHandler
weakdef TIM1_BRK_TIM9_IRQHandler
weakdef TIM1_UP_TIM10_IRQHandler
weakdef TIM1_TRG_COM_TIM11_IRQHandler
weakdef TIM1_CC_IRQHandler
weakdef TIM2_IRQHandler
weakdef TIM3_IRQHandler
weakdef TIM4_IRQHandler
weakdef I2C1_EV_IRQHandler
weakdef I2C1_ER_IRQHandler
weakdef I2C2_EV_IRQHandler
weakdef I2C2_ER_IRQHandler
weakdef SPI1_IRQHandler
weakdef SPI2_IRQHandler
weakdef USART1_IRQHandler
weakdef USART2_IRQHandler
weakdef USART3_IRQHandler
weakdef EXTI15_10_IRQHandler
weakdef RTC_Alarm_IRQHandler
weakdef OTG_FS_WKUP_IRQHandler
weakdef TIM8_BRK_TIM12_IRQHandler
weakdef TIM8_UP_TIM13_IRQHandler
weakdef TIM8_TRG_COM_TIM14_IRQHandler
weakdef TIM8_CC_IRQHandler
weakdef DMA1_Stream7_IRQHandler
weakdef FSMC_IRQHandler
weakdef SDIO_IRQHandler
weakdef TIM5_IRQHandler
weakdef SPI3_IRQHandler
weakdef UART4_IRQHandler
weakdef UART5_IRQHandler
weakdef TIM6_DAC_IRQHandler
weakdef TIM7_IRQHandler
weakdef DMA2_Stream0_IRQHandler
weakdef DMA2_Stream1_IRQHandler
weakdef DMA2_Stream2_IRQHandler
weakdef DMA2_Stream3_IRQHandler
weakdef DMA2_Stream4_IRQHandler
weakdef ETH_IRQHandler
weakdef ETH_WKUP_IRQHandler
weakdef CAN2_TX_IRQHandler
weakdef CAN2_RX0_IRQHandler
weakdef CAN2_RX1_IRQHandler
weakdef CAN2_SCE_IRQHandler
weakdef OTG_FS_IRQHandler
weakdef DMA2_Stream5_IRQHandler
weakdef DMA2_Stream6_IRQHandler
weakdef DMA2_Stream7_IRQHandler
weakdef USART6_IRQHandler
weakdef I2C3_EV_IRQHandler
weakdef I2C3_ER_IRQHandler
weakdef OTG_HS_EP1_OUT_IRQHandler
weakdef OTG_HS_EP1_IN_IRQHandler
weakdef OTG_HS_WKUP_IRQHandler
weakdef OTG_HS_IRQHandler
weakdef DCMI_IRQHandler
weakdef CRYP_IRQHandler
weakdef HASH_RNG_IRQHandler
weakdef FPU_IRQHandler
	bx  r14	 /* put a breakpoint here when we're debugging so we can trap here but then return to interrupted code */
 