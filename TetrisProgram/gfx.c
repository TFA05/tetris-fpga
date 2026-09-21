#include "gfx.h"
#include "io.h"

void gfxWaitReady(void)
{
    while (in(REG_STATUS) & STATUS_GFX_BUSY_MASK);
}

void gfxWaitVsync(void)
{
    while (!(in(REG_STATUS) & STATUS_VSYNC_MASK));
}

void gfxSwapBuffers(void)
{
    out(REG_VGA_CTRL, 1);//
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

void gfxDrawRect(dword_t x0, dword_t y0, dword_t x1, dword_t y1, dword_t color)
{
    gfxWaitReady();
    out(REG_GFX_X0, x0);
    out(REG_GFX_Y0, y0);
    out(REG_GFX_X1, x1);
    out(REG_GFX_Y1, y1);
    out(REG_GFX_COLOR, color);
    out(REG_GFX_CMD, GFX_CMD_RECT);
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
