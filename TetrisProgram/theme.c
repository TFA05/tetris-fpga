#include "theme.h"

//Boje tetromina po temama, bira se preko misa ili tastera T
//Tema 0 su boje iz tetromino.c, ostale su njene varijante
static const dword_t g_themes[THEME_COUNT * 8] = {
    //0 = standard
    0x0FF, 0xFF0, 0x90F, 0x0F0, 0xF00, 0x00F, 0xF80, 0x000,
    //1 = pastelna
    0xAEF, 0xFEA, 0xFAE, 0xAFC, 0xFAA, 0xAAF, 0xFDA, 0x000,
    //2 = zelena
    0x0F8, 0x8F0, 0x0C4, 0x4F4, 0x6F2, 0x2A6, 0xAF6, 0x000,
    //3 = jednobojna
    0xFFF, 0xDDD, 0xBBB, 0x999, 0x777, 0x555, 0xCCC, 0x000,
};
static const dword_t g_borders[THEME_COUNT] = { 0x888, 0xFCE, 0x4C4, 0xAAA };

static dword_t g_theme = 0;

void themeNext(void)
{
    g_theme = (g_theme + 1) & (THEME_COUNT - 1);
}

void themePrev(void)
{
    g_theme = (g_theme + THEME_COUNT - 1) & (THEME_COUNT - 1);
}

dword_t themeIndex(void)
{
    return g_theme;
}

dword_t themeColor(dword_t piece)
{
    return g_themes[(g_theme << 3) + piece];
}

dword_t themeBorder(void)
{
    return g_borders[g_theme];
}
