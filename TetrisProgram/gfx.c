#include "gfx.h"
#include "io.h"

void gfxWaitReady(void)
{
    while (in(REG_STATUS) & STATUS_GFX_BUSY_MASK);
}

void gfxWaitVsync(void)
{
    while (in(REG_STATUS) & STATUS_VSYNC_MASK);
    while (!(in(REG_STATUS) & STATUS_VSYNC_MASK));
}

void gfxSwapBuffers(void)
{
    gfxWaitReady();
    out(REG_VGA_CTRL, VGA_CTRL_SWAP);
}

/* bit 1 bira da li se crta u bafer koji se prikazuje */
void gfxDrawFront(bool_t on)
{
    gfxWaitReady();
    out(REG_VGA_CTRL, on ? VGA_CTRL_DRAW_FRONT : 0);
}

/* Brise se cela vrsta koju memorija dovlaci, a ne samo sirina slike, da se iza
   desne ivice ne bi videlo ono sto je ranije bilo u memoriji. */
void gfxClear(dword_t color)
{
    gfxFillRect(0, 0, FB_ROW_W - 1, SCREEN_H - 1, color);
}

void gfxDrawPoint(dword_t x, dword_t y, dword_t color)
{
    gfxWaitReady();
    out(REG_GFX_X0, x);
    out(REG_GFX_Y0, y);
    out(REG_GFX_COLOR, color);
    out(REG_GFX_CMD, GFX_CMD_POINT);
}

void gfxDrawLine(dword_t x0, dword_t y0, dword_t x1, dword_t y1, dword_t color)
{
    gfxWaitReady();
    out(REG_GFX_X0, x0);
    out(REG_GFX_Y0, y0);
    out(REG_GFX_X1, x1);
    out(REG_GFX_Y1, y1);
    out(REG_GFX_COLOR, color);
    out(REG_GFX_CMD, GFX_CMD_LINE);
}

/* grafika crta tacku, liniju i pun pravougaonik, pa je okvir od cetiri linije */
void gfxDrawRect(dword_t x0, dword_t y0, dword_t x1, dword_t y1, dword_t color)
{
    gfxDrawLine(x0, y0, x1, y0, color);
    gfxDrawLine(x0, y1, x1, y1, color);
    gfxDrawLine(x0, y0, x0, y1, color);
    gfxDrawLine(x1, y0, x1, y1, color);
}

void gfxFillRect(dword_t x0, dword_t y0, dword_t x1, dword_t y1, dword_t color)
{
    gfxWaitReady();
    out(REG_GFX_X0, x0);
    out(REG_GFX_Y0, y0);
    out(REG_GFX_X1, x1);
    out(REG_GFX_Y1, y1);
    out(REG_GFX_COLOR, color);
    out(REG_GFX_CMD, GFX_CMD_FILLRECT);
}
