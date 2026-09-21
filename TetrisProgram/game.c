#include "game.h"
#include "board.h"
#include "tetromino.h"
#include "gfx.h"
#include "input.h"
#include "timer.h"
#include "score.h"
#include "mathutil.h"

static dword_t rngState;

static dword_t rngNext(void)
{
    dword_t x = rngState;
    x ^= x << 13;
    x ^= x >> 17;
    x ^= x << 5;
    rngState = x;
    return x;
}

static dword_t randomPieceType(void)
{
    dword_t rem;
    udivmod(rngNext(), PIECE_COUNT, &rem);
    return rem;
}


#define SPAWN_ROW 0
#define SPAWN_COL 3

static dword_t curType;
static dword_t curRotation;
static sdword_t curRow, curCol;

static dword_t score = 0;
static dword_t level = 0;
static dword_t linesUntilLevelUp;

static dword_t gravityLastTick = 0;
static bool_t gameOver = FALSE;


static const dword_t GRAVITY_MS[10] = {
    800, 700, 600, 500, 400, 350, 300, 250, 200, 150
};
#define SOFT_DROP_MS 50

static const dword_t LINE_SCORE[5] = { 0, 100, 300, 500, 800 };


static void drawBorder(void)
{
    dword_t x0 = BOARD_ORIGIN_X - 2;
    dword_t y0 = BOARD_ORIGIN_Y - 2;
    dword_t x1 = BOARD_ORIGIN_X + BOARD_COLS * CELL_SIZE + 1;
    dword_t y1 = BOARD_ORIGIN_Y + BOARD_ROWS * CELL_SIZE + 1;

    gfxDrawRect(x0, y0, x1, y1, COLOR_BORDER);
}

static dword_t pieceColorForCell(byte_t cellValue)
{
    return tetrominoColor(cellValue - 1);
}


static void drawBoardContents(void)
{
    dword_t r, c;
    word_t shape;
    int i;

    for (r = 0; r < BOARD_ROWS; r++)
    {
        for (c = 0; c < BOARD_COLS; c++)
        {
            byte_t v = boardGet(r, c);
            dword_t px = BOARD_ORIGIN_X + c * CELL_SIZE;
            dword_t py = BOARD_ORIGIN_Y + r * CELL_SIZE;
            dword_t color = (v == 0) ? COLOR_EMPTY : pieceColorForCell(v);
            gfxFillRect(px, py, px + CELL_SIZE - 2, py + CELL_SIZE - 2, color);
        }
    }

    if (!gameOver)
    {
        shape = tetrominoShape(curType, curRotation);
        for (i = 0; i < 16; i++)
        {
            if (shape & (0x8000u >> i))
            {
                sdword_t r2 = curRow + (i >> 2);
                sdword_t c2 = curCol + (i & 3);
                if (r2 >= 0 && r2 < (sdword_t)BOARD_ROWS && c2 >= 0 && c2 < (sdword_t)BOARD_COLS)
                {
                    dword_t px = BOARD_ORIGIN_X + c2 * CELL_SIZE;
                    dword_t py = BOARD_ORIGIN_Y + r2 * CELL_SIZE;
                    gfxFillRect(px, py, px + CELL_SIZE - 2, py + CELL_SIZE - 2, tetrominoColor(curType));
                }
            }
        }
    }
}

static void spawnPiece(void)
{
    curType = randomPieceType();
    curRotation = 0;
    curRow = SPAWN_ROW;
    curCol = SPAWN_COL;

    if (boardCollides(curType, curRotation, curRow, curCol))
        gameOver = TRUE;
}

static void lockCurrentPiece(void)
{
    dword_t cleared;

    boardLockPiece(curType, curRotation, curRow, curCol);
    cleared = boardClearLines();

    if (cleared > 0)
    {
        score += LINE_SCORE[cleared];
        scoreSetValue(score);

        while (cleared > 0 && linesUntilLevelUp <= cleared)
        {
            cleared -= linesUntilLevelUp;
            linesUntilLevelUp = 10;
            if (level < 9)
                level++;
        }
        if (cleared > 0)
            linesUntilLevelUp -= cleared;
    }

    spawnPiece();
}

static void tryMove(sdword_t dRow, sdword_t dCol)
{
    sdword_t newRow = curRow + dRow;
    sdword_t newCol = curCol + dCol;

    if (!boardCollides(curType, curRotation, newRow, newCol))
    {
        curRow = newRow;
        curCol = newCol;
    }
    else if (dRow > 0)
    {
        lockCurrentPiece();
    }
}

static void tryRotate(void)
{
    dword_t newRot = (curRotation + 1) & 3u;
    if (!boardCollides(curType, newRot, curRow, curCol))
        curRotation = newRot;
}

void gameInit(void)
{
    boardClear();
    rngState = timerNow() | 1u; // razlicit seed svaki put, nikad 0

    score = 0;
    level = 0;
    linesUntilLevelUp = 10;
    gameOver = FALSE;
    scoreSetValue(0);

    spawnPiece();

    gfxFillRect(0, 0, SCREEN_W - 1, SCREEN_H - 1, COLOR_BG);
    gfxWaitVsync();
    gfxSwapBuffers();
    gfxFillRect(0, 0, SCREEN_W - 1, SCREEN_H - 1, COLOR_BG);
    drawBorder();
    gfxWaitVsync();
    gfxSwapBuffers();
    drawBorder();

    gravityLastTick = timerNow();
}

bool_t gameIsOver(void)
{
    return gameOver;
}

void gameUpdate(void)
{
    inputRead();

    if (gameOver)
    {
        if (inputPressed(KEY_ROTATE_BIT))
            gameInit();
    }
    else
    {

        if (inputRepeat(KEY_LEFT_BIT,  170, 50)) tryMove(0, -1);
        if (inputRepeat(KEY_RIGHT_BIT, 170, 50)) tryMove(0, 1);
        if (inputPressed(KEY_ROTATE_BIT)) tryRotate();

        {
            dword_t interval = GRAVITY_MS[level];
            if (inputHeld(KEY_DOWN_BIT) && SOFT_DROP_MS < interval)
                interval = SOFT_DROP_MS;

            if (timerElapsed(&gravityLastTick, interval))
                tryMove(1, 0);
        }
    }

    drawBoardContents();
    gfxWaitVsync();
    gfxSwapBuffers();
}
