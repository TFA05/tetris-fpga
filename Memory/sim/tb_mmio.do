# Test mmio_regs: upis i citanje registara, impulsi, swap, status, timer.
# Priprema: Create HDL Design File (VHDL) za reg12 i mmio_regs.
# Pokretanje iz korena projekta:  vsim -c -do Memory/sim/tb_mmio.do
onerror {quit -f}
onbreak {resume}
if {[file exists work]} {vdel -all -lib work}
vlib work
foreach f {zero32 lpm_decode0 mmio_rd_mux timer_pre timer_cnt reg12 mmio_regs} { vcom -93 -quiet -work work Memory/$f.vhd }
vsim -c -quiet -L altera_mf -L lpm work.mmio_regs

set errs 0
set starts 0
set stbs 0
proc hx {sig} {
  set v [examine -radix hex $sig]
  if {[regexp {^[0-9A-Fa-f]+$} $v]} { return [expr 0x$v] }
  return -1
}
proc chk {what got exp} {
  global errs
  if {$got != $exp} { echo "GRESKA $what: [format %X $got], ocekivano [format %X $exp]"; incr errs } else { echo "ok    $what" }
}
proc wr {off data {cycles 1}} {
  force ADDR [format "16#%X#" [expr {$off >> 2}]]
  force DATA_W [format "16#%08X#" $data]
  force mmio_cs 1; force WE 1
  run [expr {10 * $cycles}] ns
  force WE 0; force mmio_cs 0
  run 10 ns
}
proc rd {off} {
  force ADDR [format "16#%X#" [expr {$off >> 2}]]
  force mmio_cs 1
  run 10 ns
  force mmio_cs 0
  return [hx DATA_R]
}
when {/mmio_regs/gfx_start'event and /mmio_regs/gfx_start = '1'} { global starts; incr starts }
when {/mmio_regs/irq_clear_stb'event and /mmio_regs/irq_clear_stb = '1'} { global stbs; incr stbs }

force CLK 0 0 ns, 1 5 ns -repeat 10 ns
force rst_n 0; force mmio_cs 0; force WE 0; force ADDR 16#0#; force DATA_W 16#00000000#
force vsync_in 0; force gfx_busy 0
force ps2_lo 16#00000000#; force ps2_hi 16#00000000#; force irq_status 16#00000000#
run 20 ns
force rst_n 1
run 20 ns

chk "reset buf_sel" [hx buf_sel] 0
chk "reset gfx_cmd" [hx gfx_cmd] 0

wr 0x08 0x123;       chk "GFX_X0 izlaz" [hx gfx_x0] 0x123;   chk "GFX_X0 citanje" [rd 0x08] 0x123
wr 0x0C 0xFFFFF1AB;  chk "GFX_Y0 izlaz (9 bita)" [hx gfx_y0] 0x1AB; chk "GFX_Y0 citanje" [rd 0x0C] 0x1AB
wr 0x10 0x3FF;       chk "GFX_X1 citanje" [rd 0x10] 0x3FF
wr 0x14 0x1DF;       chk "GFX_Y1 citanje" [rd 0x14] 0x1DF
wr 0x18 0xABCF0F;    chk "GFX_COLOR izlaz (12 bita)" [hx gfx_color] 0xF0F; chk "GFX_COLOR citanje" [rd 0x18] 0xF0F
wr 0x30 0x12ABCDEF;  chk "SEG7 izlaz (24 bita)" [hx seg7] 0xABCDEF; chk "SEG7 citanje" [rd 0x30] 0xABCDEF

set starts 0
wr 0x1C 3 2
run 30 ns
chk "GFX_CMD=3, WE 2 takta -> tacno 1 start" $starts 1
chk "gfx_start se vratio na 0" [hx gfx_start] 0
chk "GFX_CMD citanje" [rd 0x1C] 3

wr 0x04 1 2;  chk "swap #1 (WE 2 takta) -> buf_sel=1" [hx buf_sel] 1
wr 0x04 1;    chk "swap #2 -> buf_sel=0" [hx buf_sel] 0
wr 0x04 2;    chk "draw_front=1 bez swap-a" [hx buf_sel] 0; chk "draw_front" [hx draw_front] 1
chk "VGA_CTRL citanje = 2" [rd 0x04] 2
wr 0x04 3;    chk "VGA_CTRL citanje = 3" [rd 0x04] 3

force vsync_in 1; force gfx_busy 1
run 30 ns
chk "VGA_STATUS = 3" [rd 0x00] 3
force vsync_in 0
run 30 ns
chk "VGA_STATUS = 2" [rd 0x00] 2
force gfx_busy 0

force ps2_lo 16#DEADBEEF#; force ps2_hi 16#CAFEF00D#; force irq_status 16#00000005#
run 10 ns
chk "PS2_KEYS_LO" [rd 0x20] 0xDEADBEEF
chk "PS2_KEYS_HI" [rd 0x24] 0xCAFEF00D
chk "IRQ_STATUS" [rd 0x28] 5

set stbs 0
wr 0x2C 0xA5 2
run 30 ns
chk "IRQ_CLEAR maska" [hx irq_clear] 0xA5
chk "IRQ_CLEAR tacno 1 impuls" $stbs 1
chk "IRQ_CLEAR citanje" [rd 0x2C] 0xA5

force ADDR 16#2#; force DATA_W 16#00000077#; force WE 1; force mmio_cs 0
run 10 ns
force WE 0
run 10 ns
chk "upis bez mmio_cs se ignorise" [hx gfx_x0] 0x123

chk "0x38 cita 0" [rd 0x38] 0
chk "0x3C cita 0" [rd 0x3C] 0

run 2100 us
set t [rd 0x34]
chk "TIMER posle ~2.1 ms (ocekivano 2)" $t 2

echo "REZULTAT mmio_regs: $errs gresaka"
quit -f
