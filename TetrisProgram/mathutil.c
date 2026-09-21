#include "mathutil.h"

dword_t udivmod(dword_t value, dword_t divisor, dword_t *remainder)
{
    dword_t quotient = 0;
    dword_t part = 0;
    int i;

    if (divisor == 0)
    {
        if (remainder) *remainder = 0;
        return 0;
    }

    for (i = 31; i >= 0; i--)
    {
        part = (part << 1) | ((value >> i) & 1u);
        if (part >= divisor)
        {
            part -= divisor;
            quotient |= (1u << i);
        }
    }
    if (remainder) *remainder = part;
    return quotient;
}
