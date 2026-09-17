# Test sdram_ctrl: upis, refresh i ucitavanje linije (SDRAM je Tcl model).
# Priprema: Create HDL Design File (VHDL) za sdram_init i sdram_ctrl.
# Pokretanje iz korena projekta:  vsim -c -do Memory/sim/tb_sdram.do
# Takt je 20 ns, pa je refresh period 1500*20 ns = 30 us.
onerror {quit -f}
onbreak {resume}
if {[file exists work]} {vdel -all -lib work}
vlib work
foreach f {reg16 init_wait_cnt seq_cnt pixel_cnt refresh_cnt raf_cnt ctrl_cnt ctrl_rom init_rom line_buf
           lpm_constant0 lpm_constant223 lpm_constant400 lpm_mux1 lpm_mux3 lpm_mux4 lpm_mux5 lpm_mux6
           sdram_init sdram_ctrl} {
  vcom -93 -quiet -work work Memory/$f.vhd
}
vsim -c -quiet -L altera_mf -L lpm work.sdram_ctrl

set errs 0
array set cmds {0000 LMR 0001 REF 0010 PRE 0011 ACT 0100 WR 0101 RD 0110 BST}
array set cnt {LMR 0 REF 0 PRE 0 ACT 0 WR 0 RD 0 BST 0}
set row 0
set rdwait -1
set rdbase 0
set rdidx 0

proc hx {sig} {
  set v [examine -radix hex $sig]
  if {[regexp {^[0-9A-Fa-f]+$} $v]} { return [expr 0x$v] }
  return -1
}
proc chk {what got exp} {
  global errs
  if {$got != $exp} { echo "GRESKA $what: $got, ocekivano $exp"; incr errs } else { echo "ok    $what" }
}

# Logovanje komandi + model citanja: CL=2, rafal 8, podatak = (rec_adresa + i) & 0xFFFF
when {/sdram_ctrl/CLK'event and /sdram_ctrl/CLK = '1'} {
  global cmds cnt row rdwait rdbase rdidx
  if {$rdwait > 0} { incr rdwait -1; if {$rdwait == 0} { set rdidx 0 } }
  if {$rdwait == 0} {
    if {$rdidx < 8} {
      force -freeze /sdram_ctrl/DRAM_DQ [format "16#%04X#" [expr {($rdbase + $rdidx) & 0xFFFF}]] 3 ns
      incr rdidx
    } else { noforce /sdram_ctrl/DRAM_DQ; set rdwait -1 }
  }
  set c [join [examine -radix bin /sdram_ctrl/DRAM_CS_N /sdram_ctrl/DRAM_RAS_N /sdram_ctrl/DRAM_CAS_N /sdram_ctrl/DRAM_WE_N] ""]
  if {[info exists cmds($c)] && [examine /sdram_ctrl/init_done] == "1"} {
    set k $cmds($c)
    incr cnt($k)
    set a [hx /sdram_ctrl/DRAM_ADDR]
    set ba [hx /sdram_ctrl/DRAM_BA]
    if {$k == "ACT"} { set row $a }
    if {$k == "RD"} { set rdbase [expr {($ba << 20) | ($row << 8) | ($a & 0xFF)}]; set rdwait 1 }
  }
}
proc zero {} { global cnt; foreach k [array names cnt] { set cnt($k) 0 } }

proc load_line {y} {
  global now
  force LINE_Y [format "16#%03X#" $y]
  force line_req 1; run 40 ns; force line_req 0
  set t0 $now
  while {[examine /sdram_ctrl/line_ready] != "1" && ($now - $t0) < 100000000} { run 20 ns }
  run 400 ns
}
proc check_line {name y} {
  global errs
  set bad 0
  foreach x {0 1 7 8 9 255 256 511 512 600 638 639} {
    force pixel [format "16#%03X#" $x]
    run 200 ns
    set got [hx /sdram_ctrl/rd_data]
    set exp [expr {(($y << 10) + $x) & 0xFFFF}]
    if {$got != $exp} { echo "GRESKA $name x=$x: [format %04X $got], ocekivano [format %04X $exp]"; incr bad }
  }
  if {$bad} { incr errs } else { echo "ok    $name: sadrzaj line_buf" }
}

force CLK 0 0 ns, 1 10 ns -repeat 20 ns
force CLK_VGA 0 0 ns, 1 20 ns -repeat 40 ns
force rst_n 0; force locked 0; force req_wr 0; force req_addr 16#000000#; force req_data 16#0000#
force line_req 0; force buf_sel 0; force LINE_Y 16#000#; force pixel 16#000#
run 100 ns
force rst_n 1; force locked 1
run 205 us
chk "init_done" [examine /sdram_ctrl/init_done] 1
zero

# T1: zahtev drzan dok ne stigne wr_done
force req_addr 16#100234#; force req_data 16#BEEF#; force req_wr 1
run 20 ns
while {[examine /sdram_ctrl/wr_done] != "1"} { run 20 ns }
run 20 ns
force req_wr 0
run 400 ns
chk "T1 upis sa wr_done: ACT/WR" "$cnt(ACT)/$cnt(WR)" "1/1"
zero

# T2, T3: impuls od 1 takta (ranije se WRITE gubio jer je done iz popune rusio busy)
foreach {a d} {000010 1111 000011 2222} {
  force req_addr 16#$a#; force req_data 16#$d#; force req_wr 1
  run 20 ns
  force req_wr 0
  run 600 ns
}
chk "T2/T3 dva impulsa: ACT/WR" "$cnt(ACT)/$cnt(WR)" "2/2"
zero

# T4: refresh posle upisa (ranije se AUTO REFRESH gubio)
run 30 us
chk "T4 refresh posle upisa: PRE/REF" "$cnt(PRE)/$cnt(REF)" "1/1"
zero

# T5: 20 uzastopnih upisa
for {set i 0} {$i < 20} {incr i} {
  force req_addr [format "16#%06X#" [expr {0x200000 + $i}]]; force req_data [format "16#%04X#" $i]; force req_wr 1
  run 20 ns
  while {[examine /sdram_ctrl/wr_done] != "1"} { run 20 ns }
  run 20 ns
}
force req_wr 0
run 400 ns
chk "T5 20 upisa: ACT/WR" "$cnt(ACT)/$cnt(WR)" "20/20"
zero

# T6: ucitavanje linije bez refresh-a u toku
while {[hx /sdram_ctrl/b2v_inst80/q] != 100} { run 20 ns }
load_line 0x089
chk "T6 linija 0x089: RD" $cnt(RD) 80
chk "T6 line_ready" [examine /sdram_ctrl/line_ready] 1
check_line "T6" 0x089
zero

# T7: refresh pada usred ucitavanja (ranije je done refresh-a brojao rafal)
while {[hx /sdram_ctrl/b2v_inst80/q] != 900} { run 20 ns }
load_line 0x1DF
chk "T7 linija 0x1DF: RD" $cnt(RD) 80
if {$cnt(REF) < 1} { echo "GRESKA T7: refresh se nije desio tokom ucitavanja"; incr errs } else { echo "ok    T7 refresh tokom ucitavanja (REF=$cnt(REF))" }
check_line "T7" 0x1DF

echo "REZULTAT sdram_ctrl: $errs gresaka"
quit -f
