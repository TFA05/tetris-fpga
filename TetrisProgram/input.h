#ifndef INPUT_H
#define INPUT_H

#include "common.h"

#define KEY_ROTATE_BIT  7
#define KEY_UP_BIT      6
#define KEY_LEFT_BIT    5
#define KEY_DOWN_BIT    4
#define KEY_RIGHT_BIT   3

void inputRead(void);

bool_t inputHeld(dword_t bit);
bool_t inputPressed(dword_t bit);
bool_t inputReleased(dword_t bit);

#endif
