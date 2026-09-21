#ifndef INPUT_H
#define INPUT_H

#include "common.h"

#define KEY_ROTATE_BIT  7
#define KEY_UP_BIT      6
#define KEY_LEFT_BIT    5
#define KEY_DOWN_BIT    4
#define KEY_RIGHT_BIT   3
#define KEY_THEME_BIT   2   /* T      */
#define KEY_DROP_BIT    1   /* razmak */
#define KEY_PAUSE_BIT   0   /* P      */

void inputRead(void);

bool_t inputHeld(dword_t bit);
bool_t inputPressed(dword_t bit);
bool_t inputReleased(dword_t bit);
bool_t inputRepeat(dword_t bit,dword_t delayMs,dword_t rateMs);

#endif
