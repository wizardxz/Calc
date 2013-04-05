
REM fix path as necessary
set path=.\;C:\yagarto\bin;

REM assemble with '-g' omitted where we want to hide things in the AXF
arm-none-eabi-as -g -mcpu=cortex-m4 -o ./obj/startup.o ./source/SimpleStartSTM32F4_01.asm
arm-none-eabi-as -g -mcpu=cortex-m4 -o ./obj/display_driver.o ./source/drivers/display.asm
arm-none-eabi-as -g -mcpu=cortex-m4 -o ./obj/switch_driver.o ./source/drivers/switch.asm
arm-none-eabi-as -g -mcpu=cortex-m4 -o ./obj/framework.o ./source/framework.asm

REM compiling C
arm-none-eabi-gcc -I./  -c -mthumb -O0 -g -mcpu=cortex-m4 ./source/main.c -o ./obj/main.o
arm-none-eabi-gcc -I./  -c -mthumb -O0 -g -mcpu=cortex-m4 ./source/biz.c -o ./obj/biz.o

REM linking
arm-none-eabi-gcc -nostartfiles -g -Wl,--no-gc-sections -Wl,-Map,HEARm.map -Wl,-T linkHEARmSTM32F4_01.ld -oHEARm.elf ./obj/startup.o ./obj/display_driver.o ./obj/switch_driver.o ./obj/framework.o ./obj/main.o ./obj/biz.o -lgcc

REM hex file
arm-none-eabi-objcopy -O ihex HEARm.elf HEARm.hex

REM AXF file
copy HEARm.elf HEARm.AXF
pause

REM list file
arm-none-eabi-objdump -S  HEARm.axf >HEARm.lst
