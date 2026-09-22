# Vremenska ogranicenja projekta.
# Osnovni takt je 50 MHz sa ploce; ostale taktove (50 MHz, 50 MHz sa pomerajem
# i 40 MHz za VGA) izvodi PLL, pa ih Quartus sam prepoznaje.

create_clock -name CLOCK_50 -period 20.000 [get_ports {CLOCK_50}]

derive_pll_clocks
derive_clock_uncertainty

# ---------------------------------------------------------------- veza sa SDRAM-om
# Takt koji ide na cip je outclk_1 iz PLL-a, izveden na pin DRAM_CLK.
set sdram_pll_pin {PLL|sys_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}
create_generated_clock -name DRAM_CLK_PIN -source [get_pins $sdram_pll_pin] [get_ports {DRAM_CLK}]

# Podaci koje cip salje: tAC = 5,4 ns, tOH = 2,5 ns (IS42S16320, -7),
# uz oko 0,4 ns kasnjenja na vezama ploce.
set_input_delay -clock DRAM_CLK_PIN -max 5.8 [get_ports {DRAM_DQ[*]}]
set_input_delay -clock DRAM_CLK_PIN -min 2.1 [get_ports {DRAM_DQ[*]}]

# Sve sto ploca salje cipu: tSU = 1,5 ns, tH = 0,8 ns.
set sdram_out [get_ports {DRAM_DQ[*] DRAM_ADDR[*] DRAM_BA[*] DRAM_CAS_N DRAM_CKE \
                          DRAM_CS_N DRAM_LDQM DRAM_UDQM DRAM_RAS_N DRAM_WE_N}]
set_output_delay -clock DRAM_CLK_PIN -max  1.9 $sdram_out
set_output_delay -clock DRAM_CLK_PIN -min -1.2 $sdram_out

# ---------------------------------------------------------------- dva takta iz PLL-a
# Sistemski takt (50 MHz) i takt piksela (40 MHz) izlaze iz istog PLL-a, pa ih
# TimeQuest analizira kao povezane: najgori odnos ivica je samo 5 ns. Signali koji
# prelaze iz jednog u drugi (LINE_REQ, VSYNC, LINE_Y) idu kroz dva flip-flopa u
# `line_sync` i stoje mnogo duze od takta, a bafer linije `line_buf` od sada cita
# adresu taktom VGA bloka, pa preko granice ne ide nijedan put kome treba tacno
# vreme. Zato se ti putevi ne analiziraju.
set clk_sys {PLL|sys_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}
set clk_vga {PLL|sys_pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}
set_false_path -from [get_clocks $clk_vga] -to [get_clocks $clk_sys]
set_false_path -from [get_clocks $clk_sys] -to [get_clocks $clk_vga]

# ---------------------------------------------------------------- ostali izlazi i ulazi
# Tasteri i PS/2 linije nisu u ritmu takta, a izlazi na displej, LED i VGA
# nemaju zahtev prema spoljasnjem uredjaju, pa se ti putevi ne analiziraju.
set_false_path -from [get_ports {KEY[*] PS2_CLK PS2_DAT}]
set_false_path -from [get_ports {PS2_CLK2 PS2_DAT2}]
set_false_path -to   [get_ports {PS2_CLK2 PS2_DAT2}]
set_false_path -to   [get_ports {HEX0[*] HEX1[*] HEX2[*] HEX3[*] HEX4[*] HEX5[*] LEDR[*]}]
set_false_path -to   [get_ports {VGA_R[*] VGA_G[*] VGA_B[*] VGA_HS VGA_VS}]
