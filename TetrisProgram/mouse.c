#include "mouse.h"
#include "io.h"
#include "gfx.h"

static dword_t g_btn = 0;
static dword_t g_btnPrev = 0;
static dword_t g_toggle = 0;
static bool_t g_haveToggle = FALSE;
static bool_t g_ready = FALSE;
static bool_t g_newPacket = FALSE;

static sdword_t g_x = SCREEN_W / 2;
static sdword_t g_y = SCREEN_H / 2;

static sdword_t saZnakom(dword_t v)
{
    return (v & 0x80u) ? (sdword_t)v - 256 : (sdword_t)v;
}

static void pomeri(dword_t status)
{
    sdword_t dx = saZnakom((status >> MOUSE_DX_SHIFT) & MOUSE_MOVE_MASK);
    sdword_t dy = saZnakom((status >> MOUSE_DY_SHIFT) & MOUSE_MOVE_MASK);

    g_x += dx;
    g_y -= dy;

    if (g_x < 0) g_x = 0;
    if (g_y < 0) g_y = 0;
    if (g_x > (sdword_t)SCREEN_W - 1) g_x = SCREEN_W - 1;
    if (g_y > (sdword_t)SCREEN_H - 1) g_y = SCREEN_H - 1;
}

void mouseRead(void)
{
    dword_t status = in(REG_MOUSE_STATUS);
    dword_t toggle = status & MOUSE_PKT_MASK;

    g_newPacket = FALSE;
    g_btnPrev = g_btn;

    if (!g_haveToggle)
    {
        g_toggle = toggle;
        g_haveToggle = TRUE;
        return;
    }

    if (toggle == g_toggle)
        return;

    g_toggle = toggle;
    g_newPacket = TRUE;

    if (!g_ready)
    {
        g_ready = TRUE;
        g_btn = status & MOUSE_BTN_MASK;
        g_btnPrev = g_btn;
        return;
    }

    g_btn = status & MOUSE_BTN_MASK;
    pomeri(status);
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
    return (g_btn & MOUSE_BTN_LEFT) != 0;
}

bool_t mouseRightDown(void)
{
    return (g_btn & MOUSE_BTN_RIGHT) != 0;
}

bool_t mouseLeftPressed(void)
{
    return (g_btn & MOUSE_BTN_LEFT) && !(g_btnPrev & MOUSE_BTN_LEFT);
}

bool_t mouseRightPressed(void)
{
    return (g_btn & MOUSE_BTN_RIGHT) && !(g_btnPrev & MOUSE_BTN_RIGHT);
}

bool_t mouseChanged(void)
{
    return g_newPacket;
}

bool_t mouseReady(void)
{
    return g_ready;
}

void mouseDrawCursor(dword_t color)
{
    dword_t x = mouseX();
    dword_t y = mouseY();
    dword_t x0 = (x > 5u) ? x - 5u : 0u;
    dword_t y0 = (y > 5u) ? y - 5u : 0u;
    dword_t x1 = (x + 5u < SCREEN_W) ? x + 5u : SCREEN_W - 1u;
    dword_t y1 = (y + 5u < SCREEN_H) ? y + 5u : SCREEN_H - 1u;

    gfxDrawLine(x0, y, x1, y, color);
    gfxDrawLine(x, y0, x, y1, color);
}
