#include "mouse.h"
#include "io.h"
#include "gfx.h"

/* Kontroler misa daje tastere i poslednji pomeraj (8 bita sa znakom), pa se
   polozaj kursora sabira ovde i drzi unutar slike. */

static dword_t g_status = 0;
static dword_t g_prev = 0;
static sdword_t g_x = SCREEN_W / 2;
static sdword_t g_y = SCREEN_H / 2;

static sdword_t saZnakom(dword_t v)
{
    return (v & 0x80u) ? (sdword_t)v - 256 : (sdword_t)v;
}

void mouseRead(void)
{
    sdword_t dx, dy;

    g_prev = g_status;
    g_status = in(REG_MOUSE_STATUS);

    dx = saZnakom((g_status >> MOUSE_DX_SHIFT) & MOUSE_MOVE_MASK);
    dy = saZnakom((g_status >> MOUSE_DY_SHIFT) & MOUSE_MOVE_MASK);

    if (g_status != g_prev)
    {
        g_x += dx;
        g_y -= dy;                      /* mis broji nagore, ekran nadole */
        if (g_x < 0) g_x = 0;
        if (g_y < 0) g_y = 0;
        if (g_x > (sdword_t)SCREEN_W - 1) g_x = SCREEN_W - 1;
        if (g_y > (sdword_t)SCREEN_H - 1) g_y = SCREEN_H - 1;
    }
}

dword_t mouseX(void)
{
    return (dword_t)g_x;
}

dword_t mouseY(void)
{
    return (dword_t)g_y;
}

bool_t mouseLeftDown(void)
{
    return (g_status & MOUSE_BTN_LEFT) != 0;
}

bool_t mouseRightDown(void)
{
    return (g_status & MOUSE_BTN_RIGHT) != 0;
}

bool_t mouseLeftPressed(void)
{
    return (g_status & MOUSE_BTN_LEFT) && !(g_prev & MOUSE_BTN_LEFT);
}

bool_t mouseRightPressed(void)
{
    return (g_status & MOUSE_BTN_RIGHT) && !(g_prev & MOUSE_BTN_RIGHT);
}

bool_t mouseChanged(void)
{
    return g_status != g_prev;
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
