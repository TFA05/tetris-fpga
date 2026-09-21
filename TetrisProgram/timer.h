#ifndef TIMER_H
#define TIMER_H

#include "common.h"

dword_t timerNow(void);

bool_t timerElapsed(dword_t *lastTick, dword_t intervalMs);

#endif
