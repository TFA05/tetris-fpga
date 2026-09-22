#include "game.h"
#include "board.h"
#include "tetromino.h"
#include "gfx.h"
#include "input.h"
#include "timer.h"
#include "score.h"
#include "mathutil.h"
#include "theme.h"
#include "mouse.h"

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
static bool_t paused = FALSE;

#define NO_PIECE 0xFFu

static dword_t nextType=0;
static dword_t holdType=NO_PIECE;
static bool_t holdUsed=FALSE;

/* slika u memoriji je 400x300, pa su kutije manje */
#define PREVIEW_CELL 10
#define PREVIEW_BOX  (4 * PREVIEW_CELL + 8)
#define HOLD_BOX_X   (BOARD_ORIGIN_X - 16 - PREVIEW_BOX)
#define NEXT_BOX_X   (BOARD_ORIGIN_X + BOARD_COLS * CELL_SIZE + 16)
#define PREVIEW_BOX_Y BOARD_ORIGIN_Y

/* traka stanja uz desnu ivicu polja: visina pokazuje nivo, boja stanje igre */
#define BAR_X0  (BOARD_ORIGIN_X + BOARD_COLS * CELL_SIZE + 4)
#define BAR_X1  (BAR_X0 + 6)
#define BAR_Y0  BOARD_ORIGIN_Y
#define BAR_Y1  (BOARD_ORIGIN_Y + BOARD_ROWS * CELL_SIZE - 1)
#define BAR_H   (BAR_Y1 - BAR_Y0 + 1)

#define COLOR_PLAYING 0x0F0
#define COLOR_PAUSED  0xFF0
#define COLOR_OVER    0xF00


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

    gfxDrawRect(x0, y0, x1, y1, themeBorder());
}

static dword_t pieceColorForCell(byte_t cellValue)
{
    return tetrominoColor(cellValue - 1);
}

static void drawPreview(dword_t bx, dword_t by, dword_t type)
{
    int i;

    /* redraw svaki frejm, kao i tabla (dupli bafer) */
    gfxFillRect(bx, by, bx + PREVIEW_BOX - 1, by + PREVIEW_BOX - 1, COLOR_BG);
    gfxDrawRect(bx, by, bx + PREVIEW_BOX - 1, by + PREVIEW_BOX - 1, themeBorder());

    if (type == NO_PIECE)
        return;

    word_t shape = tetrominoShape(type, 0);
    for (i = 0; i < 16; i++)
    {
        if (shape & (0x8000u >> i))
        {
            dword_t px = bx + 4 + (i & 3) * PREVIEW_CELL;
            dword_t py = by + 4 + (i >> 2) * PREVIEW_CELL;
            gfxFillRect(px, py, px + PREVIEW_CELL - 2, py + PREVIEW_CELL - 2,
                        tetrominoColor(type));
        }
    }
}
/* zelena = igra traje, zuta = pauza, crvena = kraj igre;
   visina obojenog dela je nivo (od 1 do 10 desetina) */
static void drawStatusBar(void)
{
    dword_t color = gameOver ? COLOR_OVER : (paused ? COLOR_PAUSED : COLOR_PLAYING);
    dword_t h = (level + 1) * (BAR_H / 10);
    dword_t top = BAR_Y1 + 1 - h;

    gfxFillRect(BAR_X0, BAR_Y0, BAR_X1, BAR_Y1, COLOR_EMPTY);
    gfxFillRect(BAR_X0, top, BAR_X1, BAR_Y1, color);
    gfxDrawRect(BAR_X0 - 1, BAR_Y0 - 1, BAR_X1 + 1, BAR_Y1 + 1, themeBorder());
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
    drawBorder();
    drawStatusBar();
    drawPreview(HOLD_BOX_X, PREVIEW_BOX_Y, holdType);
    drawPreview(NEXT_BOX_X, PREVIEW_BOX_Y, nextType);

    /* kursor se crta poslednji, da bi bio preko svega */
    if (mouseReady())
        mouseDrawCursor(themeBorder());
}

static void spawnPiece(void)
{
    curType = nextType;
    nextType = randomPieceType();
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
    holdUsed = FALSE;
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

static void hardDrop(void)
{
    while (!boardCollides(curType, curRotation, curRow + 1, curCol))
        curRow++;
    lockCurrentPiece();
}

static void tryRotate(void)
{
    dword_t newRot = (curRotation + 1) & 3u;
    if (!boardCollides(curType, newRot, curRow, curCol))
        curRotation = newRot;
}
static void tryHold(void)
{
    if (holdUsed)
        return;

    if (holdType == NO_PIECE)
    {
        holdType = curType;
        spawnPiece();              /* uzima nextType */
    }
    else
    {
        dword_t tmp = curType;
        curType = holdType;
        holdType = tmp;
        curRotation = 0;
        curRow = SPAWN_ROW;
        curCol = SPAWN_COL;
        if (boardCollides(curType, curRotation, curRow, curCol))
            gameOver = TRUE;
    }
    holdUsed = TRUE;
}
void gameInit(void)
{
    boardClear();
    rngState = timerNow() | 1u; // razlicit seed svaki put, nikad 0

    score = 0;
    level = 0;
    linesUntilLevelUp = 10;
    gameOver = FALSE;
    paused = FALSE;
    scoreSetValue(0);

    holdType = NO_PIECE;
    holdUsed = FALSE;
    nextType = randomPieceType();

    spawnPiece();

    gfxClear(COLOR_BG);
    gfxWaitVsync();
    gfxSwapBuffers();
    gfxClear(COLOR_BG);
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

/* temu boja menja levi (sledeca) ili desni (prethodna) taster misa, kao i taster T */
static void handleTheme(void)
{
    mouseRead();
    if (inputPressed(KEY_THEME_BIT) || mouseLeftPressed())
        themeNext();
    else if (mouseRightPressed())
        themePrev();
}

void gameUpdate(void)
{
    inputRead();
    handleTheme();

    if (gameOver)
    {
        if (inputPressed(KEY_ROTATE_BIT) || inputPressed(KEY_DROP_BIT))
            gameInit();
    }
    else
    {

        if (inputPressed(KEY_PAUSE_BIT))
            paused = !paused;

        if (!paused)
        {
            if (inputRepeat(KEY_LEFT_BIT,  170, 50)) tryMove(0, -1);
            if (inputRepeat(KEY_RIGHT_BIT, 170, 50)) tryMove(0, 1);
            if (inputPressed(KEY_ROTATE_BIT)) tryRotate();
            if (inputPressed(KEY_UP_BIT)) tryHold();
            if (inputPressed(KEY_DROP_BIT)) hardDrop();

            {
                dword_t interval = GRAVITY_MS[level];
                if (inputHeld(KEY_DOWN_BIT) && SOFT_DROP_MS < interval)
                    interval = SOFT_DROP_MS;

                if (timerElapsed(&gravityLastTick, interval))
                    tryMove(1, 0);
            }
        }
    }

    drawBoardContents();
    gfxWaitVsync();
    gfxSwapBuffers();
}
