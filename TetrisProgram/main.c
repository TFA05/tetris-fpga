#include "common.h"
#include "game.h"
#include "gfx.h"
/*
int main(void)
{
    gameInit();
    while (1)
    {
        gameUpdate();
    }
    return 0;
}
*/

int main(void)
{
    out(REG_SEG7, 0x123456);                                /* CPU živ? */
    gfxFillRect(0, 0, SCREEN_W - 1, SCREEN_H - 1, 0xF00);   /* crveno */
    gfxWaitVsync();
    gfxSwapBuffers();
    gfxFillRect(0, 0, SCREEN_W - 1, SCREEN_H - 1, 0xF00);
    while (1) ;
}