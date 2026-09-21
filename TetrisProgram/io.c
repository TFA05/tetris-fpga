#include "io.h"

__attribute__((naked)) void out(unsigned int address, unsigned int value)
{
    asm("sw a1,0(a0)");
    asm("ret");
}

__attribute__((naked)) unsigned int in(unsigned int address)
{
    asm("lw a0,0(a0)");
    asm("ret");
}
