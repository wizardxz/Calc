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

REM compiling C
arm-none-eabi-gcc -I./ -c -mthumb -O0 -g -mcpu=cortex-m4 ./src/main.c -o ./build/main.o
arm-none-eabi-gcc -I./ -c -mthumb -O0 -g -mcpu=cortex-m4 ./src/biz.c -o ./build/biz.o
arm-none-eabi-gcc -I./ -c -mthumb -O0 -g -mcpu=cortex-m4 ./src/calc.c -o ./build/calc.o


REM linking
arm-none-eabi-gcc -nostartfiles -g -Wl,--no-gc-sections -Wl,-Map,./build/Calc.map -Wl,-T ./build/linkCalcSTM32F4_01.ld ^
-o./build/Calc.elf ./build/*.o -lgcc

REM hex file
arm-none-eabi-objcopy -O ihex ./build/Calc.elf ./build/Calc.hex

REM AXF file
copy build\Calc.elf build\Calc.AXF

REM list file
arm-none-eabi-objdump -S  ./build/Calc.axf >./build/Calc.lst

pause
