
#include "common.h"
#include "io.h"
#include "gfx.h"

int main(void)
{
    dword_t x0 = BOARD_ORIGIN_X - 4;
    dword_t y0 = BOARD_ORIGIN_Y - 4;
    dword_t x1 = BOARD_ORIGIN_X + BOARD_COLS * CELL_SIZE + 3;
    dword_t y1 = BOARD_ORIGIN_Y + BOARD_ROWS * CELL_SIZE + 3;
    dword_t x, y;

    gfxDrawFront(TRUE);
    gfxFillRect(0, 0, 639, SCREEN_H - 1, 0x0F0);

    for (y = 16; y < SCREEN_H; y += 16)
        for (x = 16; x < SCREEN_W; x += 16)
            gfxDrawPoint(x, y, 0xF00);

    gfxDrawLine(SCREEN_W - 1, 0, SCREEN_W - 1, SCREEN_H - 1, 0xFFF);
    gfxDrawLine(SCREEN_W, 0, SCREEN_W, SCREEN_H - 1, 0xFFF);

    gfxDrawRect(x0, y0, x1, y1, 0xFFF);
    gfxDrawRect(x0 - 1, y0 - 1, x1 + 1, y1 + 1, 0xFFF);
    gfxWaitReady();
    for (;;)
        ;
}

void __attribute__((interrupt)) _isr(void)
{
    out(REG_IRQ_CLEAR, in(REG_IRQ_STATUS));
}
