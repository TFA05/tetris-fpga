#include "timer.h"
#include "io.h"

dword_t timerNow(void)
{
    return in(REG_TIMER);
}

bool_t timerElapsed(dword_t *lastTick, dword_t intervalMs)
{
    dword_t now = timerNow();
    if ((now - *lastTick) >= intervalMs)
    {
        *lastTick = now;
        return TRUE;
    }
    return FALSE;
}
