OBJFLAGS=-march=rv32i_zicsr -mabi=ilp32
ELFFLAGS=-march=rv32i_zicsr -mabi=ilp32 -Wl,--gc-sections -nostartfiles
CC=C:\Users\thetr\Downloads\xpack-riscv-none-elf-gcc-13.2.0-1-win32-x64\xpack-riscv-none-elf-gcc-13.2.0-1\bin\riscv-none-elf-gcc

# C:\Users\thetr\Downloads\xpack-riscv-none-elf-gcc-13.2.0-1-win32-x64\xpack-riscv-none-elf-gcc-13.2.0-1\bin\riscv-none-elf-gcc -c -march=rv32i_zicsr -mabi=ilp32 main.c -o main.o
# C:\Users\thetr\Downloads\xpack-riscv-none-elf-gcc-13.2.0-1-win32-x64\xpack-riscv-none-elf-gcc-13.2.0-1\bin\riscv-none-elf-gcc -march=rv32i_zicsr -mabi=ilp32 -Wl,--gc-sections -nostartfiles -T linker_script.ld startup.o main.o -o result.elf
# C:\Users\thetr\Downloads\xpack-riscv-none-elf-gcc-13.2.0-1-win32-x64\xpack-riscv-none-elf-gcc-13.2.0-1\bin\riscv-none-elf-objcopy -O verilog result.elf init.mem

# C:\Users\thetr\Downloads\xpack-riscv-none-elf-gcc-13.2.0-1-win32-x64\xpack-riscv-none-elf-gcc-13.2.0-1\bin\riscv-none-elf-objcopy --verilog-data-width=4 -O verilog -j .text result.elf init_instr.mem
# C:\Users\thetr\Downloads\xpack-riscv-none-elf-gcc-13.2.0-1-win32-x64\xpack-riscv-none-elf-gcc-13.2.0-1\bin\riscv-none-elf-objcopy --verilog-data-width=4 -O verilog -j .data -j .bss -j .sdata result.elf init_data.mem

# C:\Users\thetr\Downloads\xpack-riscv-none-elf-gcc-13.2.0-1-win32-x64\xpack-riscv-none-elf-gcc-13.2.0-1\bin\riscv-none-elf-objdump -D result.elf > disasmed_result.S