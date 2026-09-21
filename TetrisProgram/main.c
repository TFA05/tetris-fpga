/* Tetris na plocici DE0-CV.

   Tastatura: strelice levo/desno pomeraju, strelica dole ubrzava pad,
   Z ili strelica gore okrecu tetrominu, razmak je trenutni pad, P pauzira.
   Temu boja menja levi (sledeca) ili desni (prethodna) taster misa, kao i taster T.
   Broj poena se ispisuje na HEX displeju ploce. */

#include "common.h"
#include "io.h"
#include "gfx.h"
#include "game.h"

/* brojaci koje uvecava prekidna rutina */
volatile dword_t g_keyEvents = 0;
volatile dword_t g_frames = 0;

void __attribute__((interrupt)) _isr(void)
{
    dword_t st = in(REG_IRQ_STATUS);
    if (st & IRQ_KEYBOARD)
        g_keyEvents++;
    if (st & IRQ_VSYNC)
        g_frames++;
    out(REG_IRQ_CLEAR, st);
}

int main(void)
{
    gfxDrawFront(FALSE);
    asm volatile("csrsi mstatus, 8");    /* dozvola prekida */

    gameInit();
    for (;;)
        gameUpdate();
}
