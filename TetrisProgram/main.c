#include "common.h"
#include "game.h"

int main(void)
{
    gameInit();
    while (1)
    {
        gameUpdate();
    }
    return 0;
}
