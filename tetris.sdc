# Takt sa ploce (50 MHz) i taktovi iz PLL-a
create_clock -name CLOCK_50 -period 20.000 [get_ports {CLOCK_50}]
derive_pll_clocks
derive_clock_uncertainty
