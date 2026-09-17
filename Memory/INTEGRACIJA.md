# Memorija — stanje i uvezivanje

Beleska o memorijskom podsistemu: sta je gotovo, sta jos treba i kako se
povezuje sa ostalim delovima.

---

## 1. Stanje projekta

| Deo | Stanje |
|---|---|
| **CPU** (`CPU/tetris_cpu.bdf`) | radi samostalno; ima sopstveni instrukcijski ROM i data RAM, spolja samo `CLK` i `IZLAZ[31..0]` |
| **Program** (`CPU/instruction.mif`) | 3 test instrukcije |
| **Tastatura** (`KbController/`) | `CodeDetector` (PS/2 → `INTR`, `CODE[7..0]`), `CodeInterpeter` (→ `KEYDATA[7..0]`) |
| **Mis** (`MouseController/`) | radi, ali na drugom stilu magistrale (bidir `DATA` sa tri-state) |
| **GPU** (`GPU/GPU.bdf`) | skica: u semi su samo komparator i konstanta, nema VGA tajminga |
| **Memorija** (`Memory/`) | gotova i simulirana |
| **Top** (`Tetris.bdf`) | skica: samo tastatura i mis |

---

## 2. Sta memorija nudi (`Memory/mem_top.bdf`)

- ROM 32 KB (`0x0000_0000`), RAM 32 KB (`0x0400_0000`), MMIO (`0x0800_0000`)
- SDRAM kontroler sa dvostrukim baferovanjem (frejm-baferi u SDRAM-u)
- Renderer: tacka, pravougaonik i linija (Bresenham), preko `GFX_*` registara
- Ucitavanje cele linije u `line_buf` za VGA

Portovi: `CLK`, `CLK_VGA`, `locked`, `RST_N`, `ADDR[27..0]`, `DATA_W[31..0]`,
`DATA_R[31..0]`, `WE`, `RE`, `READY`, `LINE_REQ`, `LINE_Y[8..0]`, `LINE_READY`,
`PIX_X[9..0]`, `PIX_DATA[15..0]`, `VSYNC`, `PS2_KEYS_LO/HI[31..0]`,
`IRQ_STATUS[31..0]`, `IRQ_CLEAR[11..0]`, `IRQ_CLEAR_STB`, `SEG7_DATA[23..0]`,
`DRAM_*`.

### MMIO registri (baza `0x0800_0000`, dekodovanje nad `ADDR[5:2]`)

| Ofset | Registar | Smer | Sadrzaj |
|---|---|---|---|
| `0x00` | `VGA_STATUS` | R | bit0 = VSYNC, bit1 = gfx busy |
| `0x04` | `VGA_CTRL` | W/R | bit0 = swap bafera, bit1 = crtanje u prikazani bafer |
| `0x08` | `GFX_X0` | W/R | 10 bita |
| `0x0C` | `GFX_Y0` | W/R | 9 bita |
| `0x10` | `GFX_X1` | W/R | 10 bita |
| `0x14` | `GFX_Y1` | W/R | 9 bita |
| `0x18` | `GFX_COLOR` | W/R | 12 bita |
| `0x1C` | `GFX_CMD` | W/R | 1 = tacka, 2 = linija, 3 = pravougaonik |
| `0x20` | `PS2_KEYS_LO` | R | bit-mapa tastera |
| `0x24` | `PS2_KEYS_HI` | R | bit-mapa tastera |
| `0x28` | `IRQ_STATUS` | R | |
| `0x2C` | `IRQ_CLEAR` | W/R | 12-bitna maska + impuls `IRQ_CLEAR_STB` |
| `0x30` | `SEG7` | W/R | 24 bita na `SEG7_DATA` |
| `0x34` | `TIMER` | R | milisekunde od reseta |

Pravila za program:

- pre novog `GFX_CMD` i pre menjanja `GFX_*` registara sacekati
  `VGA_STATUS` bit1 = 0
- crta se u zadnji bafer; swap tek kad je crtanje gotovo
- pravougaonik trazi `X0 ≤ X1` i `Y0 ≤ Y1`, linija radi u svim smerovima
- brisanje celog ekrana traje oko 80–100 ms, pa ne brisati ceo ekran svaki
  frejm nego crtati samo promenjena polja

### Testovi

`Memory/sim/`: `tb_sdram.do`, `tb_mmio.do`, `tb_gfx.do`, `tb_top.do`.
Pokrecu se iz korena projekta, npr. `vsim -c -do Memory/sim/tb_top.do`.
Pre pokretanja treba napraviti VHDL za izmenjene seme
(File → Create/Update → Create HDL Design File for Current File).

---

## 3. Sta je uradjeno pri uvezivanju

1. U `Memory/` je prebacena nova verzija: ispravljen `sdram_ctrl`, novi
   `mem_top`, `mmio_regs`, `gfx_engine`, `reg12`, `reg16` i pripadajuce
   megafunkcije, plus testovi.
2. Izbaceni su duplirani entiteti: `Components/init_wait_cnt`, `pixel_cnt`,
   `seq_cnt` i `refresh_cnt` su iste megafunkcije kao u `Memory/`, pa je
   Quartus javljao „primary unit already exists in library work".
   Uklonjeni su iz `.qsf`-a; fajlovi su ostali u `Components/` neiskorisceni.
3. Uredjaj ispravljen sa `5CGXFC7C7F23C8` na `5CEBA4F23C7` (DE0-CV).
4. Ispravljene dve ranije greske u `.qsf`-u, zbog kojih se `Tetris` top nije
   mogao sintetisati: `Components/cmp13.qip` je prazan fajl pa entitet `cmp13`
   nije bio definisan (dodat `cmp13.vhd`), a `mx4x1.qip` je bio naveden bez
   foldera.
5. Dodati `de0cv_pins.tcl` (pinovi SDRAM-a) i `tetris.sdc` (vremenska
   ogranicenja).

Posle toga se i `Tetris` top i `mem_top` sintetisu bez gresaka.

---

## 4. Sta jos treba

### 4.1 Upis procesora u SDRAM

Piksel se upisuje jednom `store` instrukcijom, pa `mem_top` mora da primi CPU
upis u prozor `0x0C00_0000`. Fali put podataka i arbitraza (mux
`req_addr`/`req_data`/`req_wr` izmedju renderera i CPU-a, sa prioritetom).

Strana `READY`-ja je gotova. U `mem_top` postoje:

| Signal | Smer | Znacenje |
|---|---|---|
| `sd_cpu_req` | iz READY logike | 1 = CPU trazi upis; drzi se do potvrde |
| `ADDR[22..1]` | | adresa reci piksela (piksel = 2 bajta) |
| `DATA_W[15..0]` | | podatak piksela |
| `sd_cpu_ack` | u READY logiku | potvrda, impuls od 1 takta; sada vezan na GND. Vazi samo uz postavljen `sd_cpu_req`, pa slucajna potvrda ne moze da pomeri `READY` |
| `sd_bypass` | prekidac | VCC = upis se ignorise, `READY` je 1 takt; GND = `READY` ceka potvrdu |

Kad put upisa bude gotov: `sd_cpu_ack` odvezati sa GND i povezati na potvrdu
arbitra, a `sd_bypass` prebaciti sa VCC na GND. Do tada se sistem ponasa kao
i ranije.

`READY` za ROM, RAM, MMIO i citanje SDRAM prozora je 1 takt.

### 4.2 CPU

- spoljna magistrala: `ADDR[27..0]`, `DATA_W`, `DATA_R`, `WE`, `RE`
- zastoj na `READY`: zaustaviti PC i upis u registarski fajl dok je `READY` = 0
- instrukcije za crtanje se razlazu u niz upisa u `GFX_X0`…`GFX_CMD`
- prekidi: ulaz `INTR`, cuvanje PC-a, skok na rukovaoca, brisanje preko
  `IRQ_CLEAR`
- `data_mem` se moze izbaciti (RAM je u `mem_top`), instrukcijski ROM moze
  ostati u procesoru

### 4.3 GPU

- generator tajminga 640×480@60 na 25 MHz
- na pocetku linije `LINE_Y` i impuls `LINE_REQ`, cekanje `LINE_READY`,
  zatim `PIX_X`
- `PIX_DATA[11..0]` na R/G/B (`[11:8]` = R, `[7:4]` = G, `[3:0]` = B)
- `VS` nazad u `mem_top.VSYNC`

### 4.4 Sistemski top

| Signal | Izvor | Odrediste |
|---|---|---|
| `CLOCK_50` (PIN_M9) | pin | `sys_pll.refclk` |
| `outclk_0` (100 MHz) | PLL | `mem_top.CLK`, CPU |
| `outclk_1` (100 MHz, -3 ns) | PLL | pin `DRAM_CLK` |
| `outclk_2` (25 MHz) | PLL | `mem_top.CLK_VGA`, GPU |
| `locked` | PLL | `mem_top.locked` |
| `KEY[0]` | pin | `RST_N` |
| CPU `ADDR/DATA_W/WE/RE` | CPU | `mem_top` |
| `DATA_R`, `READY` | memorija | CPU |
| `LINE_*`, `PIX_*` | memorija ↔ GPU | GPU |
| `GPU.VS` | GPU | `mem_top.VSYNC` |
| `KEYDATA[7..0]` | tastatura | `mem_top.PS2_KEYS_LO[7..0]` |
| `DRAM_*` | memorija | pinovi SDRAM-a |
| `SEG7_DATA[23..0]` | memorija | 7-segmentni displeji |

`mem_top.ADDR` je 28 bita, a CPU i GPU koriste 32 — vezati `ADDR[27..0]`.

### 4.5 Ostalo

- program za Tetris
- pinovi za VGA, PS/2, `KEY` i `HEX` (SDRAM i `CLOCK_50` su pokriveni)

---

## 5. Vremenska analiza

`tetris.sdc` je upisan u `.qsf`. Provereno `quartus_fit` + `quartus_sta` nad
kosturom `CLOCK_50 → sys_pll → mem_top`; na 100 MHz (spori model) sve rezerve
su pozitivne: upis ka SDRAM-u +0,60 ns, citanje `DRAM_DQ` +0,89 ns, najgora
unutrasnja putanja +3,25 ns.

Dve stvari ne dirati:

- `set_instance_assignment -name FAST_INPUT_REGISTER ON -to *dq_reg*` u `.qsf`
  (ulazni registar na `DRAM_DQ` mora u I/O blok, inace fali oko 0,7 ns)
- `set_multicycle_path` za `DRAM_DQ` u `tetris.sdc` (procitana rec se prihvata
  dva takta posle READ komande; bez toga analiza prijavljuje laznih −12 ns)

---

## 6. Predlozeni redosled

1. GPU: VGA tajming i `LINE_*` interfejs
2. CPU: magistrala i zastoj na `READY`
3. sistemski top i pinovi, pa prvi test na ploci
4. instrukcije za crtanje i prekidi
5. program
