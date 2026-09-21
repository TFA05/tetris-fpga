#include "common.h"
#include "gfx.h"
#include "input.h"
#include "timer.h"
#include "score.h"

#define IND_SIZE 60
#define IND_Y     300
#define IND_GAP   20

#define COLOR_OFF 0x888
#define COLOR_ON  0x0F0
#define COLOR_BG  0x000

static dword_t indicatorX[4];
static const dword_t indicatorBit[4] = {
    KEY_LEFT_BIT, KEY_RIGHT_BIT, KEY_DOWN_BIT, KEY_ROTATE_BIT
};
static bool_t prevHeld[4];

static dword_t tickCounter;
static dword_t lastSecond;

static void drawGfxTestPattern(void)
{
    gfxDrawLine(20, 20, 300, 20, 0xF00);
    gfxDrawLine(20, 20, 20, 120, 0x0F0);
    gfxDrawLine(20, 120, 300, 20, 0x00F);

    gfxDrawRect(340, 20, 500, 120, 0xFF0);
    gfxFillRect(540, 20, 700, 120, 0xF0F);

    {
        int i;
        for (i = 0; i < 30; i++)
            gfxDrawPoint(20 + i * 3, 150 + i * 2, 0x0FF);
    }
}

static void setupIndicators(void)
{
    int i;
    for (i = 0; i < 4; i++)
    {
        indicatorX[i] = 40 + i * (IND_SIZE + IND_GAP);
        gfxFillRect(indicatorX[i], IND_Y, indicatorX[i] + IND_SIZE, IND_Y + IND_SIZE, COLOR_OFF);
    }
}

static void updateIndicators(void)
{
    int i;
    for (i = 0; i < 4; i++)
    {
        bool_t held = inputHeld(indicatorBit[i]);
        if (held != prevHeld[i])
        {
            dword_t c = held ? COLOR_ON : COLOR_OFF;
            gfxFillRect(indicatorX[i], IND_Y, indicatorX[i] + IND_SIZE, IND_Y + IND_SIZE, c);
            prevHeld[i] = held;
        }
    }
}

static void setup(void)
{
    gfxFillRect(0, 0, SCREEN_W - 1, SCREEN_H - 1, COLOR_BG);
    gfxWaitVsync();
    gfxSwapBuffers();
    gfxFillRect(0, 0, SCREEN_W - 1, SCREEN_H - 1, COLOR_BG);

    drawGfxTestPattern();
    setupIndicators();

    lastSecond = timerNow();
    scoreSetValue(0);
}

int main(void)
{
    setup();

    while (1)
    {
        inputRead();
        updateIndicators();

        if (timerElapsed(&lastSecond, 1000))
        {
            tickCounter++;
            scoreSetValue(tickCounter);
        }

        gfxWaitVsync();
        gfxSwapBuffers();
    }

    return 0;
}
