#include "io.h"

__attribute__((naked)) void out(unsigned int address __attribute__((unused)), unsigned int value __attribute__((unused)))
{
    asm("sw a1,0(a0)");
    asm("ret");
}

__attribute__((naked)) unsigned int in(unsigned int address __attribute__((unused)))
{
    asm("lw a0,0(a0)");
    asm("ret");
}
