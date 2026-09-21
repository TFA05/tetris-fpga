#ifndef THEME_H
#define THEME_H

#include "common.h"

#define THEME_COUNT 4

void themeNext(void);
void themePrev(void);

dword_t themeIndex(void);
dword_t themeColor(dword_t piece);
dword_t themeBorder(void);

#endif
