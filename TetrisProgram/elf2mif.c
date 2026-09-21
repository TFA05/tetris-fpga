#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define ROM_DEPTH_WORDS_DEFAULT 8192u
#define NOP_INSTRUCTION 0x00000013u

int main(int argc, char *argv[])
{
    if (argc < 3)
    {
        fprintf(stderr, "Upotreba: %s <ulaz.bin> <izlaz.mif> [depth]\n", argv[0]);
        return 1;
    }

    const char *bin_path = argv[1];
    const char *mif_path = argv[2];
    unsigned long depth = (argc > 3) ? strtoul(argv[3], NULL, 10) : ROM_DEPTH_WORDS_DEFAULT;

    FILE *bin_file = fopen(bin_path, "rb");
    if (!bin_file)
    {
        perror("Ne mogu da otvorim ulazni fajl");
        return 1;
    }

    fseek(bin_file, 0, SEEK_END);
    long file_size = ftell(bin_file);
    fseek(bin_file, 0, SEEK_SET);

    if (file_size < 0)
    {
        fclose(bin_file);
        fprintf(stderr, "Greska pri citanju velicine fajla\n");
        return 1;
    }

    size_t byte_count = (size_t)file_size;
    size_t padded_size = ((byte_count + 3) / 4) * 4;

    uint8_t *buffer = (uint8_t *)calloc(padded_size ? padded_size : 1, 1);
    if (!buffer)
    {
        fclose(bin_file);
        fprintf(stderr, "Nema dovoljno memorije\n");
        return 1;
    }

    if (fread(buffer, 1, byte_count, bin_file) != byte_count)
    {
        fprintf(stderr, "Greska pri citanju sadrzaja fajla\n");
        fclose(bin_file);
        free(buffer);
        return 1;
    }
    fclose(bin_file);

    size_t word_count = padded_size / 4;

    if (word_count > depth)
    {
        fprintf(stderr, "GRESKA: program ima %zu reci, ROM prima samo %lu\n",
                word_count, depth);
        free(buffer);
        return 1;
    }

    FILE *mif_file = fopen(mif_path, "w");
    if (!mif_file)
    {
        perror("Ne mogu da napravim izlazni fajl");
        free(buffer);
        return 1;
    }

    fprintf(mif_file, "WIDTH=32;\n");
    fprintf(mif_file, "DEPTH=%lu;\n\n", depth);
    fprintf(mif_file, "ADDRESS_RADIX=UNS;\n");
    fprintf(mif_file, "DATA_RADIX=UNS;\n\n");
    fprintf(mif_file, "CONTENT BEGIN\n");

    for (size_t i = 0; i < word_count; i++)
    {
        uint32_t b0 = buffer[i * 4 + 0];
        uint32_t b1 = buffer[i * 4 + 1];
        uint32_t b2 = buffer[i * 4 + 2];
        uint32_t b3 = buffer[i * 4 + 3];
        uint32_t word = b0 | (b1 << 8) | (b2 << 16) | (b3 << 24);
        fprintf(mif_file, "\t%zu : %u;\n", i, word);
    }

    if (word_count < depth)
    {
        if (word_count == depth - 1)
            fprintf(mif_file, "\t%zu : %u;\n", word_count, NOP_INSTRUCTION);
        else
            fprintf(mif_file, "\t[%zu..%lu] : %u;\n", word_count, depth - 1, NOP_INSTRUCTION);
    }

    fprintf(mif_file, "END;\n");
    fclose(mif_file);
    free(buffer);

    printf("Napisano %zu reci (%zu bajta od %lu) -> %s\n",
           word_count, word_count * 4, depth * 4, mif_path);
    printf("Neiskoriscen prostor popunjen NOP-om (0x%08X), ne nulom\n", NOP_INSTRUCTION);

    return 0;
}
