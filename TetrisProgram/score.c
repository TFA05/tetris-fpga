#include "score.h"
#include "io.h"
#include "mathutil.h"

void scoreSetValue(dword_t value)
{
    dword_t digits[6];
    dword_t packed;
    dword_t rem;
    int i;

    if (value > 999999u)
        value = 999999u;

    for (i = 0; i < 6; i++)
    {
        value = udivmod(value, 10u, &rem);
        digits[i] = rem;
    }

    packed = (digits[0] <<  0) | (digits[1] <<  4) | (digits[2] <<  8) | (digits[3] << 12) | (digits[4] << 16) | (digits[5] << 20);

    out(REG_SEG7, packed);
}
