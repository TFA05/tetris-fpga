#ifndef BOARD_H
#define BOARD_H

#include "common.h"

void boardClear(void);

byte_t boardGet(dword_t row, dword_t col);

void boardSet(dword_t row, dword_t col, byte_t value);

bool_t boardCollides(dword_t pieceType, dword_t rotation, sdword_t boardRow, sdword_t boardCol);


void boardLockPiece(dword_t pieceType, dword_t rotation, sdword_t boardRow, sdword_t boardCol);

dword_t boardClearLines(void);

#endif // BOARD_H
