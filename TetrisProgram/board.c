#include "board.h"
#include "tetromino.h"


//20x10 Matrix board
static byte_t grid[BOARD_ROWS][BOARD_COLS];

void boardClear(void)
{
    dword_t r, c;
    for (r = 0; r < BOARD_ROWS; r++)
        for (c = 0; c < BOARD_COLS; c++)
            grid[r][c] = 0;
}

byte_t boardGet(dword_t row, dword_t col)
{
    return grid[row][col];
}

void boardSet(dword_t row, dword_t col, byte_t value)
{
    grid[row][col] = value;
}
//Uzima celu matricu fifgure i proverava da li se sudara sa zidom ili drugom figurom 
bool_t boardCollides(dword_t pieceType, dword_t rotation, sdword_t boardRow, sdword_t boardCol)
{
    word_t shape = tetrominoShape(pieceType, rotation);
    int i;

    for (i = 0; i < 16; i++)
    {
        if (shape & (0x8000u >> i))
        {
            sdword_t r = boardRow + (i >> 2);
            sdword_t c = boardCol + (i & 3);

            if (c < 0 || c >= (sdword_t)BOARD_COLS)
                return TRUE;
            if (r >= (sdword_t)BOARD_ROWS)
                return TRUE;
            if (r < 0)
                continue;
            if (grid[r][c] != 0)
                return TRUE;
        }
    }
    return FALSE;
}
//Kada figura sleti upisuje je u matricu mape
void boardLockPiece(dword_t pieceType, dword_t rotation, sdword_t boardRow, sdword_t boardCol)
{
    word_t shape = tetrominoShape(pieceType, rotation);
    dword_t dr,dc;
    for (dr = 0; dr < 4; dr++) {
        for (dc = 0; dc < 4; dc++) {
            dword_t bit = dr *4 +dc;
            if (shape & (0x8000u >> bit)) {

                sdword_t r = boardRow + (sdword_t)dr;
                sdword_t c = boardCol + (sdword_t)dc;

                if (r >= 0 && r < BOARD_ROWS && c >= 0 && c < BOARD_COLS)
                    grid[r][c] = (byte_t)(pieceType + 1);
            }
        }
    }

}

static bool_t rowIsFull(dword_t row)
{
    dword_t c;
    for (c = 0; c < BOARD_COLS; c++)
        if (grid[row][c] == 0)
            return FALSE;
    return TRUE;
}

static void clearRow(dword_t row)
{
    dword_t c;
    for (c = 0; c < BOARD_COLS; c++)
        grid[row][c] = 0;
}

static void shiftDownFrom(dword_t row)
{
    sdword_t r;
    dword_t c;
    for (r = (sdword_t)row; r > 0; r--)
        for (c = 0; c < BOARD_COLS; c++)
            grid[r][c] = grid[r - 1][c];
    clearRow(0);
}

dword_t boardClearLines(void)
{
    dword_t cleared = 0;
    sdword_t r;

    for (r = BOARD_ROWS - 1; r >= 0; r--)
    {
        if (rowIsFull((dword_t)r))
        {
            shiftDownFrom((dword_t)r);
            cleared++;
            r++;
        }
    }
    return cleared;
}
