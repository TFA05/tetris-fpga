# Tetris na FPGA ploči DE0-CV

Računarski sistem sa sopstvenim RISC-V procesorom, grafikom u SDRAM-u, VGA izlazom,
PS/2 tastaturom i mišem. Kao demonstraciona igra radi Tetris.

Ceo hardver je urađen **šematski** (`.bdf`); jedini VHDL su komponente koje pravi
ugrađeni MegaWizard (brojači, komparatori, multiplekseri, memorije, PLL).

Projekat: `Tetris.qpf`, vrh sistema: `Tetris.bdf`, ploča: DE0-CV (Cyclone V 5CEBA4F23C7),
alat: Quartus II 13.1.

## Kako se pokreće

1. `TetrisProgram/build.sh` prevodi igru i upisuje je u `Memory/rom_init.mif`
   (potreban je RISC-V prevodilac, `riscv64-linux-gnu-gcc` ili `riscv64-unknown-elf-gcc`).
2. U Quartusu: Processing → Start Compilation.
3. Programator: `output_files/Tetris.sof` na ploču.
4. Tastatura ide u PS/2 priključak; miš se dodaje preko Y-razdelnika (drugi par linija).

Ako se na HEX displeju ništa ne menja, a slika je crna, ploča nije dobila program —
treba ponoviti korak 1 pa kompilaciju.

## Upravljanje

| Taster | Radnja |
|---|---|
| strelica levo / desno | pomeranje tetromine |
| strelica dole | brži pad |
| Z ili strelica gore | okretanje |
| razmak | trenutni pad |
| P | pauza |
| T ili taster miša | sledeća tema boja (desni taster miša — prethodna) |
| KEY0 | reset celog sistema |

Broj poena se ispisuje na HEX displeju, a traka pored polja pokazuje nivo
(zelena = igra traje, žuta = pauza, crvena = kraj igre).

## Delovi sistema

| Folder | Šta sadrži |
|---|---|
| `CPU/` | procesor: putanja podataka, mikroprogramska upravljačka jedinica, adapter magistrale |
| `Memory/` | ROM, RAM, memorijski preslikan U/I, grafički crtač, kontroler i arbitar SDRAM-a |
| `GPU/` | VGA kontroler 800×600 (slika 400×300, uvećana dvostruko) |
| `KbController/` | prijem PS/2 kodova i bit-mapa pritisnutih tastera |
| `MouseController/` | kontroler miša (šalje 0xF4, prima pakete od tri bajta) |
| `Components/` | zajedničke komponente: displej, kontroler prekida, registri, multiplekseri |
| `TetrisProgram/` | program igre u C-u i alat koji od njega pravi `.mif` |

Detaljan opis procesora, mape adresa i veza među blokovima je u
[`RV32_specifikacija.md`](RV32_specifikacija.md).

## Mapa adresa

| Opseg | Šta je |
|---|---|
| `0x00000000` | ROM sa programom (8192 reči) |
| `0x04000000` | RAM (8192 reči, vrh steka `0x04008000`) |
| `0x08000000` | periferije (grafika, tastatura, miš, prekidi, displej, tajmer) |
| `0x0C000000` | SDRAM: dva bafera slike 400×300, piksel je `(bafer<<20) | (y<<10) | x` |

## Registri periferija (`0x08000000 + pomeraj`)

| Pomeraj | Registar |
|---|---|
| `0x00` | stanje: bit 0 vertikalna sinhronizacija, bit 1 grafika radi |
| `0x04` | upravljanje slikom: bit 0 zamena bafera, bit 1 crtanje u prikazani bafer |
| `0x08`–`0x1C` | X0, Y0, X1, Y1, boja, naredba (1 tačka, 2 linija, 3 pun pravougaonik) |
| `0x20` | bit-mapa tastera |
| `0x24` | miš: bitovi 2..0 tasteri, 10..3 pomeraj po x, 18..11 pomeraj po y |
| `0x28` / `0x2C` | zastavice prekida / brisanje zastavica (bit 0 tastatura, bit 1 nova slika) |
| `0x30` | šest cifara za HEX displej |
| `0x34` | tajmer, broji milisekunde |
