#include "mouse.h"
#include "io.h"
#include "gfx.h"

static dword_t g_status = 0;

void mouseRead(void)
{
    g_status = in(REG_MOUSE_STATUS);
}

dword_t mouseX(void)
{
    return (g_status >> 12) & MOUSE_COORD_MASK;
}

dword_t mouseY(void)
{
    return (g_status >> 22) & MOUSE_COORD_MASK;
}

bool_t mouseLeftDown(void)
{
    return (g_status >> 1) & 1u;
}

bool_t mouseRightDown(void)
{
    return (g_status >> 2) & 1u;
}

bool_t mouseChanged(void)
{
    return (g_status & MOUSE_CHANGED_MASK) != 0;
}

bool_t mouseReady(void)
{
    return (g_status & MOUSE_ACKED_MASK) != 0;
}

void mouseDrawCursor(dword_t color)
{
    dword_t x = mouseX();
    dword_t y = mouseY();

    gfxDrawLine(x - 5, y, x + 5, y, color);
    gfxDrawLine(x, y - 5, x, y + 5, color);
}
