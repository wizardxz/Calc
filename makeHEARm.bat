
REM fix path as necessary
set path=.\;C:\yagarto\bin;

rmdir build /s /q
mkdir build
copy keil\* build

REM assemble with '-g' omitted where we want to hide things in the AXF
arm-none-eabi-as -g -mcpu=cortex-m4 -o ./build/startup.o ./source/SimpleStartSTM32F4_01.asm
arm-none-eabi-as -g -mcpu=cortex-m4 -o ./build/display_driver.o ./source/drivers/display.asm
arm-none-eabi-as -g -mcpu=cortex-m4 -o ./build/switch_driver.o ./source/drivers/switch.asm
arm-none-eabi-as -g -mcpu=cortex-m4 -o ./build/framework.o ./source/framework.asm

REM compiling C
arm-none-eabi-gcc -I./  -c -mthumb -O0 -g -mcpu=cortex-m4 ./source/main.c -o ./build/main.o
arm-none-eabi-gcc -I./  -c -mthumb -O0 -g -mcpu=cortex-m4 ./source/biz.c -o ./build/biz.o

REM linking
arm-none-eabi-gcc -nostartfiles -g -Wl,--no-gc-sections -Wl,-Map,./build/HEARm.map -Wl,-T ./build/linkHEARmSTM32F4_01.ld -o./build/HEARm.elf ./build/startup.o ./build/display_driver.o ./build/switch_driver.o ./build/framework.o ./build/main.o ./build/biz.o -lgcc

REM hex file
arm-none-eabi-objcopy -O ihex ./build/HEARm.elf ./build/HEARm.hex

REM AXF file
copy build\HEARm.elf build\HEARm.AXF
pause

REM list file
arm-none-eabi-objdump -S  ./build/HEARm.axf >./build/HEARm.lst
