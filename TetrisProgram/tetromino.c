#include "tetromino.h"

static const word_t SHAPES[PIECE_COUNT][4] = {
    /* I */ { 0x0F00, 0x2222, 0x0F00, 0x2222 },
    /* O */ { 0x6600, 0x6600, 0x6600, 0x6600 },
    /* T */ { 0x4E00, 0x4640, 0x0E40, 0x4C40 },
    /* S */ { 0x6C00, 0x4620, 0x6C00, 0x4620 },
    /* Z */ { 0xC600, 0x2640, 0xC600, 0x2640 },
    /* J */ { 0x8E00, 0x6440, 0x0E20, 0x44C0 },
    /* L */ { 0x2E00, 0x4460, 0x0E80, 0xC440 },
};

static const dword_t COLORS[PIECE_COUNT] = {
    0x0FF, // I - svetloplava (cyan)
    0xFF0, // O - zuta
    0x90F, // T - ljubicasta
    0x0F0, // S - zelena
    0xF00, // Z - crvena
    0x00F, // J - plava
    0xF80, // L - narandzasta
};

word_t tetrominoShape(dword_t pieceType, dword_t rotation)
{
    return SHAPES[pieceType][rotation & 3u];
}

dword_t tetrominoColor(dword_t pieceType)
{
    return COLORS[pieceType];
}
