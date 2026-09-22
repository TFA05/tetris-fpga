#include "input.h"
#include "io.h"
#include "common.h"

static dword_t g_keyState = 0;
static dword_t g_prevKeyState = 0;
static dword_t g_nextRepeat[32];

//Sacuva trenutno stanje g_keyState u g_prevKeyState i procita sveze stanje sa hardvera
void inputRead(void)
{
    g_prevKeyState = g_keyState;
    g_keyState = in(REG_PS2_LO);
}

bool_t inputHeld(dword_t bit)
{
    return (g_keyState >> bit) & 1u;
}

bool_t inputPressed(dword_t bit)
{
    dword_t now  = (g_keyState >> bit) & 1u;
    dword_t prev = (g_prevKeyState >> bit) & 1u;
    return now && !prev;
}

bool_t inputReleased(dword_t bit)
{
    dword_t now  = (g_keyState >> bit) & 1u;
    dword_t prev = (g_prevKeyState >> bit) & 1u;
    return !now && prev;
}

bool_t inputRepeat(dword_t bit, dword_t delayMs, dword_t rateMs)
{
    dword_t now = in(REG_TIMER);

    //Taster je bas sad pritisnut prvi put
    if (inputPressed(bit)) {
        //Zakazi prvo ponavljanje tek posle delayMs
        g_nextRepeat[bit] = now + delayMs;
        return TRUE;
    }
    //Taster se i dalje drzi
    if (inputHeld(bit) && (sdword_t)(now - g_nextRepeat[bit]) >= 0) {
        //Zakazi sledece ponavljanje posle rateMs
        g_nextRepeat[bit] = now + rateMs;
        return TRUE;
    }
    //Ili se taster ne drzi uopste ili jos nije doslo vreme za sledece ponavljanje
    return FALSE;
}
