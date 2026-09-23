#!/bin/sh
set -e

PREFIX=riscv64-linux-gnu-
command -v ${PREFIX}gcc >/dev/null 2>&1 || PREFIX=riscv64-unknown-elf-
RISCV_GCC=${PREFIX}gcc
RISCV_OBJDUMP=${PREFIX}objdump
RISCV_OBJCOPY=${PREFIX}objcopy

$RISCV_GCC -Os -Wall -Wextra -march=rv32i -mabi=ilp32 -mstrict-align \
    -nostdlib -ffreestanding -fno-pic -fno-pie -no-pie \
    -fno-asynchronous-unwind-tables -fno-unwind-tables \
    -Wl,--no-dynamic-linker -Wl,-e,_start -Wl,--build-id=none -T tetris.ld \
    -o tetris.elf \
    start.c io.c gfx.c input.c timer.c score.c mathutil.c theme.c \
    tetromino.c board.c mouse.c game.c main.c

$RISCV_OBJDUMP -d -s tetris.elf > tetris.s

if grep -qE '^\s+[0-9a-f]+:.*\b(lb|lbu|lh|lhu|sb|sh|mul|mulh|mulhu|div|divu|rem|remu)\b' tetris.s; then
    echo "GRESKA: program koristi instrukciju koju procesor nema:"
    grep -nE '^\s+[0-9a-f]+:.*\b(lb|lbu|lh|lhu|sb|sh|mul|mulh|mulhu|div|divu|rem|remu)\b' tetris.s | head
    exit 1
fi

if [ ! -f ./elf2mif ] && [ ! -f ./elf2mif.exe ]; then
    gcc -O2 -o elf2mif elf2mif.c
fi

$RISCV_OBJCOPY -O binary tetris.elf tetris_rom.bin
./elf2mif tetris_rom.bin ../Memory/rom_init.mif

echo "Kompajlirano OK -> tetris.elf, tetris.s, Memory/rom_init.mif"
