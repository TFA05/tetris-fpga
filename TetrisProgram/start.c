extern unsigned int _data_load, _data_start, _data_end;
extern unsigned int _data_load, _data_start, _data_end;
extern unsigned int _bss_start, _bss_end;

extern int main(void);
void _start_c(void);

__attribute__((naked, section(".text.start"))) void _start(void)
{
    asm volatile(
        "li sp, 0x04008000\n"
        "call _start_c\n"
        "1: j 1b\n"
    );
}

void _start_c(void)
{
    unsigned int *src = &_data_load;
    unsigned int *dst = &_data_start;
    while (dst < &_data_end)
        *dst++ = *src++;

    dst = &_bss_start;
    while (dst < &_bss_end)
        *dst++ = 0;

    main();
}
