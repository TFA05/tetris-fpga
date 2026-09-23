
#include "common.h"
#include "io.h"
#include "gfx.h"
#include "game.h"

volatile dword_t g_keyEvents = 0;
volatile dword_t g_frames = 0;

void __attribute__((interrupt)) _isr(void)
{
    dword_t st = in(REG_IRQ_STATUS);
    if (st & IRQ_KEYBOARD)
        g_keyEvents++;
    if (st & IRQ_VSYNC)
        g_frames++;
    out(REG_IRQ_CLEAR, st);
}

int main(void)
{
    gfxDrawFront(FALSE);
    asm volatile("csrsi mstatus, 8");

    gameInit();
    for (;;)
        gameUpdate();
}
