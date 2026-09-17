# Integracioni test mem_top: magistrala, MMIO, renderer i SDRAM kontroler.
# SDRAM je Tcl model: pamti upise i vraca ih pri citanju.
# Priprema: Create HDL Design File (VHDL) za sve izmenjene seme.
# Pokretanje iz korena projekta:  vsim -c -do Memory/sim/tb_top.do
onerror {quit -f}
onbreak {resume}
if {[file exists work]} {vdel -all -lib work}
vlib work
foreach f {
  reg16 init_wait_cnt seq_cnt pixel_cnt refresh_cnt raf_cnt ctrl_cnt ctrl_rom init_rom line_buf
  lpm_constant0 lpm_constant223 lpm_constant400 lpm_mux1 lpm_mux3 lpm_mux4 lpm_mux5 lpm_mux6
  sdram_init sdram_ctrl
  zero32 lpm_decode0 mmio_rd_mux timer_pre timer_cnt reg12 mmio_regs
  gfx_add12 gfx_sub12 gfx_mux9 gfx_mux10 gfx_mux12 gfx_cmp9 gfx_cmp10 gfx_cmp13s gfx_xcnt gfx_ycnt gfx_engine
  rom ram read_mux const_sdram mem_top
} { if {[file exists Memory/$f.vhd]} { vcom -93 -quiet -work work Memory/$f.vhd } else { vcom -93 -quiet -work work Components/$f.vhd } }
vsim -c -quiet -L altera_mf -L lpm work.mem_top

set errs 0
array set cmds {0000 LMR 0001 REF 0010 PRE 0011 ACT 0100 WR 0101 RD}
array set cnt {LMR 0 REF 0 PRE 0 ACT 0 WR 0 RD 0}
array set mem {}
set wlog {}
set row 0
set rdwait -1
set rdbase 0
set rdidx 0
set wr_before_init 0

proc hx {sig} {
  set v [examine -radix hex $sig]
  if {[regexp {^[0-9A-Fa-f]+$} $v]} { return [expr 0x$v] }
  return -1
}
proc chk {what got exp} {
  global errs
  if {$got != $exp} { echo "GRESKA $what: [format %X $got], ocekivano [format %X $exp]"; incr errs } else { echo "ok    $what" }
}

proc sdram_mon {} {
  global cmds cnt mem wlog row rdwait rdbase rdidx wr_before_init
  if {$rdwait > 0} { incr rdwait -1; if {$rdwait == 0} { set rdidx 0 } }
  if {$rdwait == 0} {
    if {$rdidx < 8} {
      set w [expr {$rdbase + $rdidx}]
      set v [expr {[info exists mem($w)] ? $mem($w) : 0}]
      force -freeze /mem_top/DRAM_DQ [format "16#%04X#" $v] 3 ns
      incr rdidx
    } else { noforce /mem_top/DRAM_DQ; set rdwait -1 }
  }
  set c [join [examine -radix bin /mem_top/DRAM_CS_N /mem_top/DRAM_RAS_N /mem_top/DRAM_CAS_N /mem_top/DRAM_WE_N] ""]
  if {[info exists cmds($c)]} {
    set k $cmds($c)
    if {[examine /mem_top/b2v_sdram/init_done] != "1"} {
      if {$k == "WR"} { incr wr_before_init }
    } else {
      incr cnt($k)
      set a [expr {[hx /mem_top/DRAM_ADDR] & 0xFFF}]
      set ba [hx /mem_top/DRAM_BA]
      if {$k == "ACT"} { set row $a }
      if {$k == "WR"} {
        set w [expr {($ba << 20) | ($row << 8) | ($a & 0xFF)}]
        set d [hx /mem_top/DRAM_DQ]
        set mem($w) $d
        lappend wlog [list $w $d]
      }
      if {$k == "RD"} { set rdbase [expr {($ba << 20) | ($row << 8) | ($a & 0xFF)}]; set rdwait 1 }
    }
  }
}

when -label mon {/mem_top/CLK'event and /mem_top/CLK = '1'} { sdram_mon }

proc bus_wr {addr data} {
  force ADDR [format "16#%07X#" $addr]; force DATA_W [format "16#%08X#" $data]
  force WE 1; run 10 ns; force WE 0
  set r [examine READY]
  run 10 ns
  return $r
}
proc bus_rd {addr} {
  force ADDR [format "16#%07X#" $addr]
  force RE 1; run 10 ns; force RE 0
  set v [hx DATA_R]
  run 10 ns
  return $v
}
proc gfx_wait {} {
  set n 0
  while {([bus_rd 0x8000000] & 2) && $n < 5000} { run 200 ns; incr n }
  return $n
}
proc adr {t x y} { expr {($t << 20) | ($y << 10) | $x} }
proc ref_line {x0 y0 x1 y1 t c} {
  set c [expr {$c}]
  set dx [expr {abs($x1 - $x0)}]; set sx [expr {$x0 < $x1 ? 1 : -1}]
  set dy [expr {-abs($y1 - $y0)}]; set sy [expr {$y0 < $y1 ? 1 : -1}]
  set err [expr {$dx + $dy}]; set L {}
  while 1 {
    lappend L [list [adr $t $x0 $y0] $c]
    if {$x0 == $x1 && $y0 == $y1} break
    set e2 [expr {2 * $err}]
    if {$e2 >= $dy} { incr err $dy; incr x0 $sx }
    if {$e2 <= $dx} { incr err $dx; incr y0 $sy }
  }
  return $L
}

force CLK 0 0 ns, 1 5 ns -repeat 10 ns
force CLK_VGA 0 0 ns, 1 20 ns -repeat 40 ns
force RST_N 0; force locked 0; force WE 0; force RE 0; force ADDR 16#0000000#; force DATA_W 16#00000000#
force LINE_REQ 0; force LINE_Y 16#000#; force PIX_X 16#000#; force VSYNC 0
force PS2_KEYS_LO 16#00000000#; force PS2_KEYS_HI 16#00000000#; force IRQ_STATUS 16#00000000#
run 50 ns
force RST_N 1; force locked 1
run 20 ns

echo "---- magistrala: ROM / RAM / neiskorisceni SDRAM prozor"
chk "ROM @0x0000_0000" [bus_rd 0x0000000] 0xDEADBEEF
chk "ROM @0x0000_0400" [bus_rd 0x0000400] 0xC0DE0100
chk "READY posle upisa" [bus_wr 0x4000010 0x12345678] 1
chk "RAM @0x0400_0010" [bus_rd 0x4000010] 0x12345678
chk "ROM i dalje @0" [bus_rd 0x0000000] 0xDEADBEEF
chk "SDRAM prozor cita konstantu" [bus_rd 0xC000000] 0xBADC0DE1

echo "---- tacka zadata PRE zavrsetka SDRAM inicijalizacije"
bus_wr 0x8000008 10
bus_wr 0x800000C 20
bus_wr 0x8000018 0xF00
bus_wr 0x800001C 1
chk "VGA_STATUS.busy odmah posle CMD" [expr {[bus_rd 0x8000000] & 2}] 2
gfx_wait
chk "WRITE pre init_done" $wr_before_init 0
chk "init_done" [hx /mem_top/b2v_sdram/init_done] 1

echo "---- pravougaonik (100,50)-(103,51) i linija (0,0)-(5,2)"
bus_wr 0x8000008 100; bus_wr 0x800000C 50; bus_wr 0x8000010 103; bus_wr 0x8000014 51
bus_wr 0x8000018 0x0F0; bus_wr 0x800001C 3
gfx_wait
bus_wr 0x8000008 0; bus_wr 0x800000C 0; bus_wr 0x8000010 5; bus_wr 0x8000014 2
bus_wr 0x8000018 0x00F; bus_wr 0x800001C 2
gfx_wait
run 1 us

set exp [list [list [adr 1 10 20] [expr 0xF00]]]
for {set y 50} {$y <= 51} {incr y} { for {set x 100} {$x <= 103} {incr x} { lappend exp [list [adr 1 $x $y] [expr 0x0F0]] } }
set exp [concat $exp [ref_line 0 0 5 2 1 0x00F]]
if {$wlog != $exp} {
  echo "GRESKA upisi u SDRAM: [llength $wlog] upisa, ocekivano [llength $exp]"
  foreach g $wlog e $exp { if {$g != $e} { echo "   dobijeno $g ocekivano $e" } }
  incr errs
} else { echo "ok    SDRAM upisi: [llength $wlog] piksela, adrese i boje tacne (bafer B)" }

echo "---- swap i prikaz: linija y=20 iz bafera B"
bus_wr 0x8000004 1
chk "VGA_CTRL.buf_sel" [bus_rd 0x8000004] 1
force LINE_Y 16#014#
force LINE_REQ 1; run 40 ns; force LINE_REQ 0
set n 0
while {[examine LINE_READY] != "1" && $n < 5000} { run 100 ns; incr n }
chk "LINE_READY" [hx LINE_READY] 1
foreach {x v} {10 0xF00 11 0 9 0 0 0 639 0} {
  force PIX_X [format "16#%03X#" $x]
  run 200 ns
  chk "PIX_DATA x=$x" [hx PIX_DATA] $v
}
force LINE_Y 16#033#
force LINE_REQ 1; run 40 ns; force LINE_REQ 0
run 100 ns
set n 0
while {[examine LINE_READY] != "1" && $n < 5000} { run 100 ns; incr n }
foreach {x v} {99 0 100 0x0F0 103 0x0F0 104 0} {
  force PIX_X [format "16#%03X#" $x]
  run 200 ns
  chk "PIX_DATA y=51 x=$x" [hx PIX_DATA] $v
}

echo "---- posle swap-a crta se u bafer A"
set wlog {}
bus_wr 0x8000008 1; bus_wr 0x800000C 2; bus_wr 0x8000018 0xABC; bus_wr 0x800001C 1
gfx_wait
run 1 us
chk "tacka posle swap-a ide u BA=0" [lindex [lindex $wlog 0] 0] [adr 0 1 2]

echo "---- ostali MMIO"
bus_wr 0x8000030 0x123456
chk "SEG7 izlaz" [hx SEG7_DATA] 0x123456
force PS2_KEYS_LO 16#00000081#
run 10 ns
chk "PS2_KEYS_LO" [bus_rd 0x8000020] 0x81
nowhen mon
run 1100 us
when -label mon {/mem_top/CLK'event and /mem_top/CLK = '1'} { sdram_mon }
set t [bus_rd 0x8000034]
if {$t >= 1} { echo "ok    TIMER = $t ms" } else { echo "GRESKA TIMER = $t"; incr errs }
chk "RAM netaknut posle svega" [bus_rd 0x4000010] 0x12345678

echo "---- READY na upisu u SDRAM prozor"
# sd_bypass = 1 (podrazumevano): upis se ignorise, READY je 1 takt, kao ranije
set wlog {}
force ADDR 16#C000020#; force DATA_W 16#00000ABC#; force WE 1
run 10 ns
set r_byp [examine READY]
force WE 0
run 200 ns
chk "bypass: READY = 1 posle 1 takta" [expr {$r_byp == 1}] 1
chk "bypass: nema upisa u SDRAM" [llength $wlog] 0

# sd_bypass = 0: READY ceka potvrdu (sd_cpu_ack) koju ce dati put upisa (stavka 1)
force -freeze /mem_top/sd_bypass 0
force ADDR 16#C000020#; force DATA_W 16#00000ABC#; force WE 1
run 10 ns
set r0 [examine READY]
run 50 ns
set r1 [examine READY]
set req [examine /mem_top/sd_cpu_req]
chk "stall: READY ostaje 0" [expr {$r0 == 0 && $r1 == 0}] 1
chk "stall: sd_cpu_req postavljen" [expr {$req == 1}] 1
force -freeze /mem_top/sd_cpu_ack 1
run 2 ns
set r2 [examine READY]
run 8 ns
force -freeze /mem_top/sd_cpu_ack 0; force WE 0
run 30 ns
chk "stall: READY na potvrdu" [expr {$r2 == 1}] 1
chk "stall: sd_cpu_req obrisan" [expr {[examine /mem_top/sd_cpu_req] == 0}] 1
noforce /mem_top/sd_bypass; noforce /mem_top/sd_cpu_ack
run 50 ns
chk "posle svega READY miruje" [expr {[examine READY] == 0}] 1

echo "     SDRAM komande: ACT=$cnt(ACT) WR=$cnt(WR) RD=$cnt(RD) PRE=$cnt(PRE) REF=$cnt(REF)"
if {$cnt(REF) < 1} { echo "GRESKA nema refresh-a"; incr errs }
echo "REZULTAT mem_top: $errs gresaka"
quit -f
