# RV32 procesor: specifikacija i stanje izrade

## 1. Skup instrukcija (podskup RV32I + prilagođene)

Instrukcije su široke 32 bita i poravnate na 4 bajta. Procesor ima 32 registra, a `x0` je uvek 0.

| Grupa | Instrukcije | opcode | funct3 / funct7 |
|---|---|---|---|
| U | LUI, AUIPC | 0110111, 0010111 | |
| J | JAL | 1101111 | |
| I | JALR | 1100111 | 000 |
| B | BEQ, BNE, BLT, BGE, BLTU, BGEU | 1100011 | 000, 001, 100, 101, 110, 111 |
| Load | LW | 0000011 | 010 |
| Store | SW | 0100011 | 010 |
| OP-IMM | ADDI, SLTI, SLTIU, XORI, ORI, ANDI | 0010011 | 000, 010, 011, 100, 110, 111 |
| OP-IMM | SLLI, SRLI, SRAI | 0010011 | 001/0000000, 101/0000000, 101/0100000 |
| OP | ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND | 0110011 | standardni RV32I |
| custom-0 | DRAWP, DRAWL, DRAWR `rd, rs1, rs2` | 0001011 | 001, 010, 011 (= GFX_CMD) |
| SYSTEM | MRET, CSRSI mstatus,8, CSRCI mstatus,8 | 1110011 | 0x30200073, 0x30046073, 0x30047073 |

Instrukcije za crtanje:
- `rs1 = (x0 << 16) | y0` i `rs2 = (x1 << 16) | y1`.
- `rd` se **čita** i sadrži boju (RGB444). U `rd` se ništa ne upisuje.
- Kod DRAWP se koriste samo `x0` i `y0`.

Pošto `SLTIU`, `BLTU` i `BGEU` koriste isti komparator bez znaka kao `SLTU`, dobijaju se bez dodatnog hardvera.

## 2. Interfejs prema arbitru

| Signal | Smer | Opis |
|---|---|---|
| `ADDR[31..0]` | CPU → | bajtovska adresa |
| `DATA_W[31..0]` | CPU → | podatak za upis |
| `RD`, `WR` | CPU → | zahtev za čitanje ili upis |
| `DATA_R[31..0]` | → CPU | pročitani podatak, važi dok je READY=1 |
| `READY` | → CPU | ciklus je završen, traje 1 takt |
| `IRQ` | → CPU | zahtev za prekid |

- Procesor drži `ADDR`, `DATA_W` i `RD`/`WR` nepromenjene dok ne dobije `READY`.
- Ako posle `READY` signal `RD` ili `WR` ostane aktivan, a adresa se promeni, to je **novi** ciklus. Tako rade upisi jedan za drugim kod DRAW instrukcija.

## 3. Organizacija: višeciklusni procesor

### Registri
| Registar | Upis | Sadržaj |
|---|---|---|
| PC | `PC_WE` | adresa sledeće instrukcije (posle FETCH je PC+4) |
| OLD_PC | `IR_WE` | adresa tekuće instrukcije (za AUIPC, JAL i grananja) |
| IR | `IR_WE` | tekuća instrukcija |
| EPC | `EPC_WE` | povratna adresa iz prekida |
| RF 32×32 | `RF_WE` | registri (2× M10K) |

Blok-memorija M10K ima registrovanu adresu i neregistrovan izlaz, pa ta adresa služi kao registri A i B. Vrednosti rs1 i rs2 su spremne jedan takt posle stanja DECODE. Pri čitanju i upisu iste adrese u istom taktu čita se stara vrednost (OLD_DATA).

### Upravljački signali putanje podataka (šeme `pc`, `instruction`, `register_file`, `imm_gen`, `alu_src_mux`, `alu`, `pc_next`, `data_mem`)

| Signal | Vrednosti |
|---|---|
| `A_SEL[1..0]` | 0 rs1, 1 OLD_PC, 2 PC, 3 nula |
| `B_SEL[1..0]` | 0 rs2, 1 IMM, 2 konstanta 4, 3 nula |
| `IMM_SEL[2..0]` | 0 I, 1 S, 2 B, 3 U, 4 J |
| `ALU_FN` | 0 = sabiranje; 1 = operacija iz funct3/funct7 (ALT = IR[30] za OP, odnosno za SRAI) |
| `PC_SRC[1..0]` | 0 ALU & ~1, 1 EPC, 2 vektor prekida 0x10 |
| `WB_SEL[1..0]` | 0 ALU, 1 DATA_R, 2 PC (povratna adresa = OLD_PC+4) |
| `ADR_SEL[1..0]` | 0 PC, 1 ALU, 2 MMIO: `0x08000000 + MOFF*4` |
| `MOFF[2..0]` | 0 VGA_STATUS, 2 X0, 3 Y0, 4 X1, 5 Y1, 6 COLOR, 7 CMD |
| `WD_SEL[2..0]` | 0 rs2, 1 rs1[31..16], 2 rs1[15..0], 3 rs2[31..16], 4 rs2[15..0], 5 funct3 |
| `RS2_SEL` | 0 = drugi port za čitanje adresiran sa rs2, 1 = sa rd (boja kod DRAW) |
| `PC_WE`, `IR_WE`, `EPC_WE`, `RF_WE` | dozvole upisa |

Izlazi putanje podataka: `ADDR`, `DATA_W`, `IR` (ide u upravljačku jedinicu) i `TAKEN` (uslov grananja po funct3).

## 4. Tabela stanja upravljačke jedinice

U tabeli su navedeni samo signali koji nisu 0. Oznaka „**čeka**“ znači da se ostaje u stanju dok je READY=0. Dozvole upisa označene sa `*` važe samo u taktu kada je READY=1.

| Stanje | Signali | Sledeće stanje |
|---|---|---|
| FETCH | RD, A=2, B=2, IR_WE*, PC_WE* | **čeka** → DECODE |
| DECODE | – | po opcode-u (nepoznat opcode → KRAJ) |
| EX_LUI | A=3, B=1, IMM=U, RF_WE | KRAJ |
| EX_AUIPC | A=1, B=1, IMM=U, RF_WE | KRAJ |
| EX_JAL | A=1, B=1, IMM=J, PC_WE, RF_WE, WB=2 | KRAJ |
| EX_JALR | A=0, B=1, IMM=I, PC_WE, RF_WE, WB=2 | KRAJ |
| EX_BR | A=1, B=1, IMM=B, PC_WE=TAKEN | KRAJ |
| EX_OP | ALU_FN, RF_WE | KRAJ |
| EX_OPIMM | ALU_FN, B=1, IMM=I, RF_WE | KRAJ |
| MEM_LW | B=1, IMM=I, ADR=1, RD, WB=1, RF_WE* | **čeka** → KRAJ |
| MEM_SW | B=1, IMM=S, ADR=1, WR | **čeka** → KRAJ |
| DR_POLL | ADR=2, MOFF=0, RD | ako je READY i DATA_R[1]=0 → DR_X0, inače DR_POLL |
| DR_X0 | ADR=2, MOFF=2, WD=1, WR | **čeka** → DR_Y0 |
| DR_Y0 | ADR=2, MOFF=3, WD=2, WR | **čeka** → DR_X1 |
| DR_X1 | ADR=2, MOFF=4, WD=3, WR | **čeka** → DR_Y1 |
| DR_Y1 | ADR=2, MOFF=5, WD=4, WR | **čeka** → DR_SW |
| DR_SW | RS2_SEL=1 (jedan takt da M10K preuzme adresu rd) | DR_COL |
| DR_COL | RS2_SEL=1, ADR=2, MOFF=6, WD=0, WR | **čeka** → DR_CMD |
| DR_CMD | ADR=2, MOFF=7, WD=5, WR | **čeka** → KRAJ |
| EX_MRET | PC_SRC=1, PC_WE, IE ← 1 | KRAJ |
| INT | EPC_WE, PC_SRC=2, PC_WE, IE ← 0 | FETCH |

**KRAJ** znači: ako je `IRQ=1` i `IE=1`, sledeće stanje je INT, a inače FETCH. `IE` je flip-flop u upravljačkoj jedinici (korak 7).

Trajanje instrukcije je FETCH (1 + čekanje memorije) + DECODE + EX, dakle 3 takta plus čekanje. LW i SW imaju još jedan pristup memoriji.

## 5. Šta je urađeno i provereno

Fajlovi su u folderu `CPU/`:
- **Komponente iz MegaWizarda:** `pc_register` (LPM_SHIFTREG kao registar sa enable i aclr), `alu_adder`, `alu_compare`, `alu_compare_u`, `alu_shift`, `alu_sra` (LPM_CLSHIFT), `alu_mux`, `alu_src_mux_ip`, `mux4_32`, `mux2_5`, `mux4_5`, `mux8_1` (LPM_MUX), `reg_mem_a` (RAM: 2-PORT), `control_rom` (ROM: 1-PORT).
- **Šeme:** `tetris_cpu.bdf` (vrh), `instruction_decoder.bdf` (upravljačka jedinica), `pc.bdf`, `instruction.bdf`, `register_file.bdf`, `imm_gen.bdf`, `alu_src_mux.bdf`, `alu.bdf`, `pc_next.bdf`, `data_mem.bdf`; mikrokod `control_rom.mif`.

Provera:
- Quartus 13.1 Analysis & Synthesis: 0 grešaka, 0 upozorenja.
- Puna kompilacija za 5CEBA4F23C7: 619 ALM-ova, 128 registara, na 50 MHz rezerva 4,7 ns (oko 65 MHz).
- Simulacija u ModelSim-u, sa modelom upravljačke jedinice po tabeli iz odeljka 4: program od 81 instrukcije pokriva sve instrukcije osim MRET, uz memoriju koja kasni 3 takta. Svih 31 registara i svih 12 MMIO upisa za DRAWR/DRAWP se poklapaju sa referentnim simulatorom.

Napomena o šemama: konstantna nula je mreža `NULA`, koju pokreću dva GND simbola (`NULA[31..16]` i `NULA[15..0]`). Quartus konvertor u VHDL ne prepoznaje jedan GND na celoj magistrali koja se koristi u delovima.

## 6. Upravljačka jedinica (korak 4): `instruction_decoder.bdf`

- **Mikrokod ROM** `control_rom` (ROM: 1-PORT, 32 × 45 bita, `CPU/control_rom.mif`). Adresa ROM-a je **sledeće stanje**. M10K registruje adresu, pa taj registar služi i kao registar stanja: izlaz ROM-a daje kontrolne signale tekućeg stanja, bez kašnjenja od jednog takta.
- **Kodovi stanja:** stanja izvršavanja imaju kod jednak `opcode[6..2]`, pa je dispečovanje u DECODE samo `IR[6..2]` doveden na mux sledećeg stanja.

| Kod | Stanje | Kod | Stanje | Kod | Stanje |
|---|---|---|---|---|---|
| 0 | LW | 8 | SW | 16 | INT |
| 1 | FETCH (posle reseta) | 9 | DR_X1 | 24 | BR |
| 2 | DR_POLL (DRAW) | 10 | DR_Y1 | 25 | JALR |
| 3 | DECODE | 11 | DR_SW | 27 | JAL |
| 4 | OPIMM | 12 | OP | 28 | SYS (MRET, CSRSI, CSRCI) |
| 5 | AUIPC | 13 | LUI | ostali | nepoznat opcode → KRAJ |
| 6 | DR_X0 | 14 | DR_COL | | |
| 7 | DR_Y0 | 15 | DR_CMD | | |

- **Polja mikrokoda:** IR_WE[0], PC_WE[1], PC_BR[2], RF_WE[3], EPC_WE[4], GATE[5], RD[6], WR[7], RS2_SEL[8], ALU_FN[9], IMM[12..10], A[14..13], B[16..15], PC_SRC[18..17], WB[20..19], ADR[22..21], MOFF[25..23], WD[28..26], WAIT[29], POLL[30], MODE[32..31] (0 NEXT, 1 IR[6..2], 2 KRAJ), NEXT[37..33], CUR[42..38], SYSOP[43], IE_CLR[44].
- **Logika van ROM-a:**
  - `RDYOK = !GATE | READY`
  - `IR_WE`, `RF_WE` i deo `PC_WE` se množe sa RDYOK
  - `PC_WE = PC_WE·RDYOK + PC_BR·TAKEN + SYSOP·!IR[14]`
  - `STAY = WAIT·!READY + POLL·BUSY`, gde je `BUSY = DATA_R[1]`
  - `KRAJ = IRQ·IE ? INT(16) : FETCH(1)`
  - dok traje RESET, adresa ROM-a je FETCH (1)

## 7. Reset i prekidi (koraci 5 i 7): `tetris_cpu.bdf`

- **Reset:** `RESET_IN` (aktivan na 1, npr. `!KEY0 | !pll_locked`) se asinhrono postavlja, a sinhrono otpušta kroz 2 DFF-a. Resetuje PC (na 0), IR, OLD_PC, EPC i IE, a upravljačka jedinica kreće od FETCH. **Takt mora da radi dok je reset aktivan.**
- **Prekidi:**
  - Proveravaju se na kraju svake instrukcije.
  - Kada je `IRQ=1` i `IE=1`: EPC ← PC (adresa sledeće instrukcije), PC ← **0x00000010**, IE ← 0.
  - `csrsi mstatus,8` (0x30046073) uključuje prekide, a `csrci mstatus,8` (0x30047073) ih isključuje.
  - `mret` (0x30200073) radi PC ← EPC i IE ← 1.
  - IRQ je **nivo**: rutina mora da obriše izvor (upis u IRQ_CLEAR, 0x0800002C) pre `mret`.
  - Procesor ne čuva registre sam, pa rutina mora da sačuva sve registre koje menja.

Raspored programa:
```
0x00: jal x0, main        # posle reseta
0x04-0x0C: nop
0x10: prekidna rutina ... mret
main: csrsi mstatus,8     # dozvola prekida kada je sve spremno
```

## 8. Provera celog procesora

- **Quartus 13.1:** sinteza bez grešaka i upozorenja. Puna kompilacija (`tetris_cpu` kao vrh): 580 ALM-ova, 129 registara, 3,5 Kbit blok-memorije, **Fmax ≈ 60 MHz** u najsporijem uglu. Preporučeni takt je 50 MHz.
- **ModelSim, `tetris_cpu` sa modelom memorije** (kašnjenje od 3 takta) i MMIO modelom: program od 97 instrukcija sa prekidnom rutinom i dva spoljna IRQ zahteva.
  - Svih 31 registara i svih 12 MMIO upisa (DRAWR/DRAWP) se poklapaju sa referentnim simulatorom.
  - Oba prekida su obrađena (brojač = 2, dva upisa u IRQ_CLEAR), a glavni program ih ne primećuje.
- Fajlovi procesora (`CPU/`) su dodati u `Tetris.qsf`, ali `tetris_cpu` još nije postavljen u `Tetris.bdf`. Čeka se arbitar.

## 9. Povezivanje sa arbitrom (za kolegu)

`tetris_cpu` pinovi:
- **Ulazi:** `CLK`, `RESET_IN`, `DATA_R[31..0]`, `READY`, `IRQ`
- **Izlazi:** `ADDR[31..0]`, `DATA_W[31..0]`, `RD`, `WR`, `PC_DBG[31..0]` (za debug, može ostati nepovezan)

Protokol je opisan u odeljku 2. Procesor pristupa samo celim rečima (LW/SW), a `ADDR[1..0]` je uvek 00.

## 10. Prvi test na ploči (korak 1): `Tetris.bdf`

Glavna šema povezuje:
- **PLL `sys_pll` (izmenjen u wizardu na 50 MHz):** `outclk_0` 50 MHz je sistemski takt, `outclk_1` 50 MHz sa pomerajem −3 ns ide na `DRAM_CLK`, `outclk_2` 25 MHz ide na `CLK_VGA`.
- **Reset:** `RST_N = KEY[0] AND locked`, a `RESET_IN` procesora = `NOT RST_N`.
- **Procesor i memorija:** `tetris_cpu` → `bus_adapter` (`CPU/`) → `mem_top`. Adapter pretvara RD/WR, koji procesor drži do READY, u impuls RE/WE od jednog takta.
- **Displej:** `SEG7_DATA` → `seg7_display` (`Components/`, 6 × ROM `seg7_rom`) → `HEX0–HEX5`.
- **SDRAM:** `mem_top` ↔ svi `DRAM_*` pinovi.
- **Tastatura:** `CodeDetector` → `CodeInterpeter` i `kb_extra` → `PS2_KEYS_LO[7..0]`.
- **Miš:** `mouse_ps2` na `PS2_CLK2`/`PS2_DAT2` (preko `OPNDRN` bafera) → `PS2_KEYS_HI`.
- **Slika:** `vga640` uzima piksele iz `PIX_DATA` i daje `LINE_REQ`, `LINE_Y`, `PIX_X`, `VSYNC` i pinove `VGA_*`.
- **Prekidi:** `irq_ctrl` → `IRQ` procesora i `IRQ_STATUS` u `mem_top`.
- **LED-ovi:** `LEDR[9]` = PLL zaključan, `LEDR[8]` = IE, `LEDR[7..5]` = PC[4..2], `LEDR[4..0]` = korak procesora.

**Testni program** (`Memory/rom_init.mif`): samotest ALU-a, grananja, LUI, RAM-a i poziva potprograma.
- Ako prođe, prikazuje **00600d** oko 2 s, a zatim brojač: HEX3..0 = TIMER/256, HEX5..4 = broj prolaza petlje / 4096.
- Ako neki test padne, prikazuje **bad00N** (N = broj testa).

**Provera:**
- Puna kompilacija: 726 ALM-ova, 439 registara, 98 pinova, rezerva na taktu od 50 MHz je +3,05 ns.
- Simulacija sklopa sa pravim `mem_top`: samotest prolazi, svaki zahtev dobija tačno jedan READY, a tajmer i petlja rade.

**Otvoreno (za kolegu koji radi memoriju):** refresh SDRAM-a je 1500 taktova = 30 µs na 50 MHz. SDRAM traži 7,8 µs, pa brojač treba smanjiti na najviše 390 pre testa slike (korak 2).

## 11. Arbitar SDRAM-a (put A): `Memory/sdram_arb.bdf`

Grafika (`gfx_engine`) i procesor dele jedan ulaz za upis u `sdram_ctrl`, pa arbitar odlučuje ko piše.

- **Odluku donosi postojeći blok `Arbitrator`** (BR0 = grafika, BR1 = procesor; procesor ima prednost jer stoji dok čeka).
- **Dodela se drži** u flip-flopovima `BUSY` i `OWN` dok ne stigne `WR_DONE`, pa se adresa i podatak ne menjaju usred upisa.
- **Muxevi:** `mx2x1_22` za adresu i `mx2x1_16` za podatak.
- **Potvrda:** `CPU_ACK = WR_DONE · SEL`, `GFX_DONE = WR_DONE · /SEL`.
- **`INIT_DONE`:** dok SDRAM nije inicijalizovan (oko 200 µs), zahtevi čekaju. Bez toga se upis procesora gubio, a procesor je dobijao potvrdu.

Izmene u `mem_top.bdf`: ulazi `sdram_ctrl`-a (`req_wr`, `req_addr`, `req_data`) i `wr_done` za `gfx_engine` idu preko arbitra, `sd_cpu_ack` dolazi iz arbitra, a `sd_bypass` je sada 0 (upis procesora u SDRAM više se ne preskače). Adresa piksela za procesor je `ADDR[23..2]`, a podatak `DATA_W[15..0]`, dakle piksel (bafer, x, y) je na `0x0C000000 + 4*((bafer<<20)|(y<<10)|x)`.

**Provera u simulaciji** (procesor + adapter + pravi `mem_top`):
- upis piksela sa `SW` daje tačno jednu WRITE komandu, na adresi banka 1, red 0x008, kolona 3, što je traženi piksel
- `DRAWR` pravougaonika 3×21 daje tačno 63 upisa
- upis procesora dok grafika još crta prolazi bez zastoja; ukupno 65 upisa
- sinteza `mem_top` sa arbitrom: 0 grešaka

## 12. Glavna šema po putu A (bez arbitracije na vrhu)

`Tetris.bdf` sada sadrži:

| Blok | Veza |
|---|---|
| `sys_pll` (50 / 50 sa −3 ns / 25 MHz) | sistemski takt, `DRAM_CLK`, `CLK_VGA` |
| reset | `RST_N = KEY[0] AND locked`, `RESET_IN = NOT RST_N` |
| `tetris_cpu` → `bus_adapter` → `mem_top` | magistrala procesora |
| `mem_top` | ROM, RAM, MMIO, grafika, SDRAM i arbitar u sebi |
| *(mesto za VGA blok)* | radi kolega koji radi GPU; do tada su `LINE_REQ`, `LINE_Y`, `PIX_X` i `VSYNC` na nuli |
| `seg7_display` | `SEG7_DATA` → HEX0–HEX5 |
| `CodeDetector` → `CodeInterpeter` | tastatura → `PS2_KEYS_LO[7..0]` |
| LED | `LEDR[9]` = PLL zaključan, `LEDR[8]` = reset otpušten, `LEDR[7..3]` = PC[4..0] |

Arbitracija na vrhu (`Arbitrator`, `mx2x1_22`, signali `cpu_req`/`gpu_req`/grant) je uklonjena, jer je arbitar sada u `mem_top`. Stari `GPU/GPU.bdf` i `GPU/Controller.bdf` više nisu u projektu.

### VGA blok `GPU/vga640.bdf`
- 640×480 @ 60 Hz, piksel takt 25 MHz: linija 800 taktova (HS nisko 96), frejm 525 linija (VS nisko 2).
- Brojači su `vga_hcnt` i `vga_vcnt` (LPM_COUNTER sa modulom 800 i 525), poređenja su `vga_cmp10`.
- Sledeća linija se traži u „front porch“-u (`HC = 648`), a `LINE_Y = VC + 1`.
- Izlazi (HS, VS, boja) su registrovani taktom piksela i kasne 2 takta, koliko kasni i podatak iz bafera linije.

**Provereno u simulaciji:** HS perioda 32 µs i širina 3,84 µs, VS perioda 16,8 ms i širina 64 µs, po jedan zahtev za linijom u svakoj liniji.

**Puna kompilacija:** 881 ALM (5 %), 508 registara, 112 pinova, rezerva +3,16 ns na 50 MHz i +17,2 ns na 25 MHz.

### Provera slike u simulaciji (procesor + mem_top + vga640 + model SDRAM-a)
Program nacrta dva pravougaonika u prikazani bafer (`VGA_CTRL = 2`), a test gleda šta izlazi na VGA:
- u SDRAM je otišlo tačno 2222 piksela (dva pravougaonika 101×11)
- crveni pravougaonik se na ekranu vidi tačno od x=100 do x=200, dakle slika nije pomerena
- adresa piksela se zato traži **2 takta unapred** (`PIX_X = HC + 2`), koliko kasni podatak iz bafera linije

Napomena: model SDRAM-a u testu čita rafal linearno, a pravi čip unutar rafala „obmotava“ kolone, pa se rezultat razilazi tačno na granici kolone (x=256). Zbog toga se zeleni pravougaonik u testu vidi šire nego što je nacrtan. Isto pojednostavljenje ima i postojeći Tcl model u `Memory/sim/tb_top.do`.

## 13. Osvežavanje SDRAM-a

`Memory/refresh_cnt` (LPM_COUNTER) je preko wizarda promenjen sa modula **1500 na 384**:
- na 50 MHz to je jedan AUTO REFRESH na **7,68 µs**, a SDRAM na DE0-CV traži najviše 7,8125 µs (8192 reda za 64 ms)
- širina brojača ostaje 11 bita, pa je simbol nepromenjen i šema `sdram_ctrl` se ne dira

Provereno posle izmene: puna kompilacija bez grešaka (898 ALM, rezerva +3,0 / +17,2 ns), upis procesora i crtanje i dalje prolaze kroz arbitar, a slika i dalje izlazi na tačnim koordinatama. Uz brži refresh su se sada i oba pravougaonika u testu videla tačno (ranije se jedan video šire, zbog kasnijeg dohvata linije).

Napomena: u `Components/` postoji stara kopija `refresh_cnt` sa modulom 1500. Nije u projektu i ne koristi se.

## 14. VGA blok: `GPU/vga_kolege.bdf`

Vremena daje `Controller` kolege koji radi GPU, nepromenjen: **800×600**, X broji do
1039, Y do 665, sinhronizacija je aktivna na jedinici, a `NEWR_SIG` javlja kraj vidljivog
dela linije. Takt piksela je 40 MHz (`outclk_2` iz PLL-a).

Oko njega je veza prema `mem_top`:

| Signal | Smer | Značenje |
|---|---|---|
| `CLK_VGA` | ulaz | 40 MHz iz PLL-a |
| `RST_N` | ulaz | reset (aktivan na 0) |
| `PIX_DATA[15..0]` | ulaz | piksel iz bafera linije u `mem_top` (RGB444 u donjih 12 bita) |
| `LINE_REQ` | izlaz | zahtev za učitavanje vrste slike |
| `LINE_Y[8..0]` | izlaz | koja se vrsta traži |
| `PIX_X[9..0]` | izlaz | adresa piksela u baferu linije |
| `VSYNC` | izlaz | vertikalna sinhronizacija za `mem_top` |
| `VGA_R/G/B[3..0]`, `VGA_HS`, `VGA_VS` | izlaz | na pinove ploče |

**Slika u memoriji je 400×300 i uvećava se dvostruko**, kako je i zamišljeno u njegovom
GPU-u (`curY(8..1)`, `X(9..1)`). Zbog toga se nova vrsta traži samo na svakoj drugoj
liniji, pa memorija ima duplo više vremena da je donese — na 800×600 jedan na jedan
SDRAM ne bi stigao da isporuči sliku.

Ostalo što je moralo da se namesti:
- adresa piksela se traži **2 takta unapred** (`PIX_X = (curX + 2) / 2`), jer toliko kasni
  podatak iz bafera linije
- izlazi (HS, VS, boja) su registrovani taktom piksela
- na kraju kadra bi po njegovoj računici ispala vrsta 333, pa se sve preko 299 svodi na 0

Provereno u simulaciji: linija 26 µs (sinhro 2,98 µs), kadar 17,3 ms (sinhro 130 µs),
666 linija po kadru, 333 zahteva za vrstom, `LINE_Y` ide od 0 do 299.

**Njegov `GPU.bdf` se ne koristi** — nedovršen je: izlaz `X` iz `Controller`-a nije
povezan, oba bafera linije imaju isti signal upisa (`enableB` nigde nije vezan),
komparator koji treba da da `finished` ima nepovezane izlaze, a crvena i plava su
zamenjene. Posao koji on radi (čitanje SDRAM-a i bafer linije) ionako već radi
`sdram_ctrl`.

Napomena: `Controller` koristi ručno pisan VHDL (`RegisterX`, `ConstantX`,
`ComparatorX`), što odstupa od pravila da sve bude šematski uz komponente iz wizarda.

## 15. Prekidi: `Components/irq_ctrl.bdf`

Zastavice prekida stoje van `mem_top`, jer njihovi izvori nisu u memoriji:

| Bit | Izvor |
|---|---|
| 0 | stigao kod sa tastature (`KB_INTR` iz `CodeDetector`) |
| 1 | počela nova slika (`VSYNC` iz VGA bloka) |

Zastavica se postavlja na uzlaznu ivicu događaja i stoji dok je program ne obriše upisom
u `IRQ_CLEAR` (`0x0800002C`). `IRQ` je jedinica dok postoji bar jedna zastavica, pa ga
procesor vidi na kraju svake instrukcije. Prekidna rutina je na adresi `0x10`, a dozvola
prekida se uključuje sa `csrsi mstatus,8`.

## 16. Tastatura: `KbController/kb_extra.bdf`

`CodeDetector` prima PS/2 kodove, a `CodeInterpeter` od njih pravi bit-mapu za strelice
i taster Z (bitovi 7..3). Tri donja bita su bila slobodna, pa ih dodaje `kb_extra`, koji
gleda iste kodove:

| Bit | Taster | Kod |
|---|---|---|
| 0 | P (pauza) | `0x4D` |
| 1 | razmak (trenutni pad) | `0x29` |
| 2 | T (sledeća tema) | `0x2C` |

Kod `0xF0` najavljuje otpuštanje, pa se posle njega zastavica tastera briše. Cela
bit-mapa se čita sa adrese `PS2_KEYS_LO` (`0x08000020`).

## 17. Miš: `MouseController/mouse_ps2.bdf`

Miš se po uključenju ne javlja sam, pa mu kontroler prvo pošalje naredbu `0xF4`
(„šalji podatke“):

1. čeka ~100 ms da miš završi svoju proveru,
2. drži liniju takta na nuli 100 µs (najava slanja),
3. spušta liniju podataka (start bit) i pušta takt, pa miš sam daje takt,
4. na svaku silaznu ivicu izbacuje sledeći bit (podatak, parnost, stop, potvrda),
5. posle toga samo prima pakete od tri bajta.

U paketu su tasteri i znaci pomeraja (bajt 0, treći bit je uvek 1 i po njemu se paketi
poravnavaju), pomeraj po x (bajt 1) i po y (bajt 2). Linije PS/2 su tipa „otvoreni
kolektor“: kontroler ih samo spušta na nulu, a na glavnoj šemi su `OPNDRN` baferi.

Izlaz ide na `PS2_KEYS_HI` (`0x08000024`): bitovi 2..0 su tasteri, 10..3 pomeraj po x,
18..11 pomeraj po y. Miš se priključuje na drugi par PS/2 linija (`PS2_CLK2`, `PS2_DAT2`),
preko Y-razdelnika.

## 18. Program igre: `TetrisProgram/`

Program je u C-u i prevodi se sa `build.sh`, koji rezultat upisuje u `Memory/rom_init.mif`.
Pošto procesor nema pristup bajtu i polureči, ni množenje i deljenje:
- svi tipovi su 32-bitni (`common.h`), pa nema `lb`/`sb`,
- množenje je funkcija `umul` (pomeranje i sabiranje), a deljenje `udivmod`,
- `build.sh` posle prevođenja pregleda listing i prekida ako naiđe na instrukciju koju
  procesor nema.

Raspored: `board.c` (polje, oblici, brisanje redova), `gfx.c` (crtanje preko periferije),
`input.c` (bit-mapa tastera i tasteri miša), `theme.c` (četiri teme boja), `score.c`
(poeni na HEX displeju), `main.c` (tok igre i prekidna rutina).

Slika se crta u bafer koji se ne prikazuje, pa se na kraju kadra bafere zamene
(`VGA_CTRL = 1`) i sačeka vertikalna sinhronizacija.
