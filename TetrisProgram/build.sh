#!/bin/sh
set -e

RISCV_GCC=riscv64-linux-gnu-gcc
RISCV_OBJDUMP=riscv64-linux-gnu-objdump

$RISCV_GCC -g -Wall -Wextra -march=rv32i -mabi=ilp32 -mstrict-align \
    -nostdlib -ffreestanding -fno-pic -fno-pie -no-pie \
    -fno-asynchronous-unwind-tables -fno-unwind-tables \
    -Wl,--no-dynamic-linker -Wl,-e,_start -Wl,--build-id=none -T tetris.ld \
    -o tetris.elf \
    start.c io.c gfx.c input.c timer.c score.c mathutil.c \
    tetromino.c board.c game.c mouse.c main.c

$RISCV_OBJDUMP -d -s tetris.elf > tetris.s

if [ ! -f ./elf2mif ]; then
    gcc -O2 -o elf2mif elf2mif.c
fi

riscv64-linux-gnu-objcopy -O binary tetris.elf tetris_rom.bin
./elf2mif tetris_rom.bin tetris.mif

echo "Kompajlirano OK -> tetris.elf, tetris.s, tetris.mif"
echo "tetris.mif je spreman za ucitavanje u Quartus (CPU/instruction.mif)"
