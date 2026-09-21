#ifndef GFX_H
#define GFX_H

#include "common.h"

void gfxWaitReady(void);
void gfxWaitVsync(void);

void gfxDrawPoint(dword_t x, dword_t y, dword_t color);
void gfxDrawLine(dword_t x0, dword_t y0, dword_t x1, dword_t y1, dword_t color);
void gfxDrawRect(dword_t x0, dword_t y0, dword_t x1, dword_t y1, dword_t color);
void gfxFillRect(dword_t x0, dword_t y0, dword_t x1, dword_t y1, dword_t color);

void gfxSwapBuffers(void);
void gfxDrawFront(bool_t on);
void gfxClear(dword_t color);

#endif
