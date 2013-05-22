@echo off
REM fix path as necessary
set path=.\;C:\yagarto\bin;

rmdir build /s /q
mkdir build
copy keil\* build

REM assemble with '-g' omitted where we want to hide things in the AXF
arm-none-eabi-as -mcpu=cortex-m4 -o ./build/startup.o ./src/startup.asm
arm-none-eabi-as -mcpu=cortex-m4 -o ./build/display_driver.o ./src/drivers/p24/display.asm
arm-none-eabi-as -mcpu=cortex-m4 -o ./build/switch_driver.o ./src/drivers/p24/switch.asm
arm-none-eabi-as -mcpu=cortex-m4 -o ./build/rotary_driver.o ./src/drivers/p24/rotary.asm
arm-none-eabi-as -mcpu=cortex-m4 -o ./build/framework.o ./src/framework.asm

SET LIB_BASE=E:/ENEE440/stsw-stm32068/STM32F4-Discovery_FW_V1.1.0

SET GCC_COMPILE=^
-Iinc/ ^
-I%LIB_BASE%/Libraries/CMSIS/ST/STM32F4xx/Include/ ^
-I%LIB_BASE%/Libraries/CMSIS/Include/ ^
-I%LIB_BASE%/Utilities/Third_Party/fat_fs/inc/ ^
-I%LIB_BASE%/Libraries/STM32F4xx_StdPeriph_Driver/inc/ ^
-I%LIB_BASE%/Libraries/STM32_USB_HOST_Library/Core/inc/ ^
-I%LIB_BASE%/Libraries/STM32_USB_HOST_Library/Class/MSC/inc/ ^
-I%LIB_BASE%/Libraries/STM32_USB_OTG_Driver/inc/ ^
-I%LIB_BASE%/Utilities/STM32F4-Discovery/ ^
-D__MICROLIB ^
-DUSE_STDPERIPH_DRIVER ^
-DUSE_USB_OTG_FS ^
-DSTM32F4XX ^
-DMEDIA_IntFLASH ^
-c -mthumb -O0 -g -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16 -fsingle-precision-constant
  
REM compiling C
arm-none-eabi-gcc %GCC_COMPILE% ./src/main.c -o ./build/main.o
arm-none-eabi-gcc %GCC_COMPILE% ./src/codec.c -o ./build/codec.o
arm-none-eabi-gcc %GCC_COMPILE% ./src/biz.c -o ./build/biz.o
REM arm-none-eabi-gcc %GCC_COMPILE% ./src/stm32f4xx_it.c -o ./build/stm32f4xx_it.o
REM arm-none-eabi-gcc %GCC_COMPILE% ./src/system_stm32f4xx.c -o ./build/system_stm32f4xx.o
arm-none-eabi-gcc %GCC_COMPILE% %LIB_BASE%/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_syscfg.c -o ./build/stm32f4xx_syscfg.o
REM arm-none-eabi-gcc %GCC_COMPILE% %LIB_BASE%/Libraries/STM32F4xx_StdPeriph_Driver/src/misc.c -o ./build/misc.o
REM arm-none-eabi-gcc %GCC_COMPILE% %LIB_BASE%/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_adc.c -o ./build/stm32f4xx_adc.o
REM arm-none-eabi-gcc %GCC_COMPILE% %LIB_BASE%/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dac.c -o ./build/stm32f4xx_dac.o
REM arm-none-eabi-gcc %GCC_COMPILE% %LIB_BASE%/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dma.c -o ./build/stm32f4xx_dma.o
REM arm-none-eabi-gcc %GCC_COMPILE% %LIB_BASE%/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_exti.c -o ./build/stm32f4xx_exti.o
REM arm-none-eabi-gcc %GCC_COMPILE% %LIB_BASE%/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_flash.c -o ./build/stm32f4xx_flash.o
arm-none-eabi-gcc %GCC_COMPILE% %LIB_BASE%/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_gpio.c -o ./build/stm32f4xx_gpio.o
arm-none-eabi-gcc %GCC_COMPILE% %LIB_BASE%/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_i2c.c -o ./build/stm32f4xx_i2c.o
arm-none-eabi-gcc %GCC_COMPILE% %LIB_BASE%/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rcc.c -o ./build/stm32f4xx_rcc.o
arm-none-eabi-gcc %GCC_COMPILE% %LIB_BASE%/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_spi.c -o ./build/stm32f4xx_spi.o
REM arm-none-eabi-gcc %GCC_COMPILE% %LIB_BASE%/Libraries/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_tim.c -o ./build/stm32f4xx_tim.o


REM linking
arm-none-eabi-gcc -nostartfiles -g -Wl,--no-gc-sections -Wl,-Map,./build/HEARm.map -Wl,-T ./build/linkHEARmSTM32F4_01.ld -o./build/HEARm.elf ./build/*.o -lgcc

REM hex file
arm-none-eabi-objcopy -O ihex ./build/HEARm.elf ./build/HEARm.hex

REM AXF file
copy build\HEARm.elf build\HEARm.AXF

REM list file
arm-none-eabi-objdump -S  ./build/HEARm.axf >./build/HEARm.lst

pause
