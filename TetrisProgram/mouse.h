#ifndef MOUSE_H
#define MOUSE_H

#include "common.h"

/* Citanje stanja misa; poziva se jednom po frejmu. */
void mouseRead(void);

dword_t mouseX(void);
dword_t mouseY(void);
bool_t mouseLeftDown(void);
bool_t mouseRightDown(void);
bool_t mouseLeftPressed(void);
bool_t mouseRightPressed(void);
bool_t mouseChanged(void);   /* stigao nov paket u ovom citanju */
bool_t mouseReady(void);     /* mis se javio bar jednim paketom */

void mouseDrawCursor(dword_t color);

#endif // MOUSE_H
