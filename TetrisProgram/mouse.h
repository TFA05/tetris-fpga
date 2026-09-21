#ifndef MOUSE_H
#define MOUSE_H

#include "common.h"



void mouseRead(void);

dword_t mouseX(void);
dword_t mouseY(void);
bool_t mouseLeftDown(void);
bool_t mouseRightDown(void);
bool_t mouseChanged(void);
bool_t mouseReady(void);

void mouseDrawCursor(dword_t color);

#endif // MOUSE_H
