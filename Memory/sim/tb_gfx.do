# Test gfx_engine: rukovanje se emulira u Tcl-u, a svaki upisan piksel
# poredi se sa referentnim algoritmom.
# Priprema: Create HDL Design File (VHDL) za reg12 i gfx_engine.
# Pokretanje iz korena projekta:  vsim -c -do Memory/sim/tb_gfx.do
onerror {quit -f}
onbreak {resume}
if {[file exists work]} {vdel -all -lib work}
vlib work
foreach f {lpm_constant0 gfx_add12 gfx_sub12 gfx_mux9 gfx_mux10 gfx_mux12 gfx_cmp9 gfx_cmp10 gfx_cmp13s gfx_xcnt gfx_ycnt reg12 gfx_engine} {
  vcom -93 -quiet -work work Memory/$f.vhd
}
vsim -c -quiet -L altera_mf -L lpm work.gfx_engine

set errs 0
set pix {}
set st idle
set wcnt 0
set delays {2 4 1 5 3}
set di 0

proc hx {sig} {
  set v [examine -radix hex $sig]
  if {[regexp {^[0-9A-Fa-f]+$} $v]} { return [expr 0x$v] }
  return -1
}

# Emulator kontrolera, radi na silaznoj ivici (sve stabilno usred takta):
# vidi req_wr -> ceka par taktova -> wr_done 1 takt (tada belezi adresu) -> zauzet 5 taktova
when {/gfx_engine/CLK'event and /gfx_engine/CLK = '0'} {
  global st wcnt pix delays di
  switch $st {
    idle {
      if {[examine /gfx_engine/req_wr] == "1"} {
        set wcnt [lindex $delays [expr {$di % [llength $delays]}]]; incr di
        set st wait
      }
    }
    wait {
      incr wcnt -1
      if {$wcnt <= 0} {
        lappend pix [list [hx /gfx_engine/req_addr] [hx /gfx_engine/req_data]]
        force -freeze /gfx_engine/wr_done 1
        set st done
      }
    }
    done { force -freeze /gfx_engine/wr_done 0; set st busy; set wcnt 5 }
    busy { incr wcnt -1; if {$wcnt <= 0} { set st idle } }
  }
}

proc adr {t x y} { expr {($t << 20) | ($y << 10) | $x} }
proc ref_rect {x0 y0 x1 y1 t c} {
  set c [expr {$c}]
  set L {}
  for {set y $y0} {$y <= $y1} {incr y} { for {set x $x0} {$x <= $x1} {incr x} { lappend L [list [adr $t $x $y] $c] } }
  return $L
}
proc ref_line {x0 y0 x1 y1 t c} {
  set c [expr {$c}]
  set dx [expr {abs($x1 - $x0)}]; set sx [expr {$x0 < $x1 ? 1 : -1}]
  set dy [expr {-abs($y1 - $y0)}]; set sy [expr {$y0 < $y1 ? 1 : -1}]
  set err [expr {$dx + $dy}]
  set L {}
  while 1 {
    lappend L [list [adr $t $x0 $y0] $c]
    if {$x0 == $x1 && $y0 == $y1} break
    set e2 [expr {2 * $err}]
    if {$e2 >= $dy} { incr err $dy; incr x0 $sx }
    if {$e2 <= $dx} { incr err $dx; incr y0 $sy }
  }
  return $L
}

proc draw {name cmd x0 y0 x1 y1 c expected} {
  global pix errs
  set pix {}
  force cmd $cmd
  force x0 [format "16#%03X#" $x0]; force y0 [format "16#%03X#" $y0]
  force x1 [format "16#%03X#" $x1]; force y1 [format "16#%03X#" $y1]
  force color [format "16#%03X#" $c]
  run 10 ns
  force start 1; run 10 ns; force start 0
  set n 0
  while {[examine /gfx_engine/busy] == "1" && $n < 20000} { run 10 ns; incr n }
  run 100 ns
  if {[examine /gfx_engine/busy] != "0"} { echo "GRESKA $name: busy ne pada"; incr errs; return }
  if {[llength $pix] != [llength $expected]} {
    echo "GRESKA $name: [llength $pix] piksela, ocekivano [llength $expected]"; incr errs
  }
  set bad 0
  foreach g $pix e $expected {
    if {$g != $e} {
      if {$bad < 3} {
        set ga [lindex $g 0]
        echo "GRESKA $name: dobijeno x=[expr {$ga & 0x3FF}] y=[expr {($ga >> 10) & 0x1FF}] buf=[expr {$ga >> 20}] d=[format %X [lindex $g 1]], ocekivano $e"
      }
      incr bad
    }
  }
  if {$bad} { incr errs } else { echo "ok    $name ([llength $pix] piksela)" }
}

force CLK 0 0 ns, 1 5 ns -repeat 10 ns
force rst_n 0; force start 0; force cmd 00; force x0 16#000#; force y0 16#000#; force x1 16#000#; force y1 16#000#
force color 16#000#; force buf_sel 0; force draw_front 0; force wr_done 0; force init_done 1
run 30 ns
force rst_n 1
run 20 ns

# ciljni bafer: buf_sel=0, draw_front=0 -> zadnji = 1
draw "tacka"                 01   5   7   0   0 0xABC [ref_rect 5 7 5 7 1 0xABC]
draw "pravougaonik 4x3"      11   3   4   6   6 0x123 [ref_rect 3 4 6 6 1 0x123]
draw "pravougaonik 1 red"    11   0   0   9   0 0xFFF [ref_rect 0 0 9 0 1 0xFFF]
draw "pravougaonik 1 kolona" 11 639 470 639 479 0x00F [ref_rect 639 470 639 479 1 0x00F]
draw "linija blaga"          10  10  10  20  15 0x0F0 [ref_line 10 10 20 15 1 0x0F0]
draw "linija blaga obrnuto"  10  20  15  10  10 0x0F0 [ref_line 20 15 10 10 1 0x0F0]
draw "linija strma"          10   5  40   8  20 0x111 [ref_line 5 40 8 20 1 0x111]
draw "linija vertikalna"     10 100 100 100  90 0x222 [ref_line 100 100 100 90 1 0x222]
draw "linija horizontalna"   10  50  50  40  50 0x333 [ref_line 50 50 40 50 1 0x333]
draw "linija duzine 0"       10   7   7   7   7 0x444 [ref_line 7 7 7 7 1 0x444]
set i 0
foreach {ex ey} {340 210 310 240 290 240 260 210 260 190 290 160 310 160 340 190} {
  draw "linija oktant $i" 10 300 200 $ex $ey 0x555 [ref_line 300 200 $ex $ey 1 0x555]
  incr i
}
draw "linija dijagonala ekrana" 10 639 0 0 479 0x666 [ref_line 639 0 0 479 1 0x666]

force draw_front 1
draw "tacka u prikazani bafer" 01 1 2 0 0 0x777 [ref_rect 1 2 1 2 0 0x777]
force buf_sel 1; force draw_front 0
draw "tacka posle swap-a"     01 1 2 0 0 0x888 [ref_rect 1 2 1 2 0 0x888]
force buf_sel 0

# cmd=00 se ignorise
set pix {}
force cmd 00; force start 1; run 10 ns; force start 0; run 200 ns
if {[llength $pix] != 0 || [examine /gfx_engine/busy] != "0"} { echo "GRESKA cmd=00 nije ignorisan"; incr errs } else { echo "ok    cmd=00 ignorisan" }

# start dok je busy se ignorise
set pix {}
force cmd 11; force x0 16#000#; force y0 16#000#; force x1 16#004#; force y1 16#001#; force color 16#999#
run 10 ns
force start 1; run 10 ns; force start 0
run 200 ns
force cmd 01; force x0 16#3FF#; force start 1; run 10 ns; force start 0; force cmd 11; force x0 16#000#
set n 0
while {[examine /gfx_engine/busy] == "1" && $n < 20000} { run 10 ns; incr n }
run 100 ns
set exp [ref_rect 0 0 4 1 1 0x999]
if {$pix != $exp} { echo "GRESKA start tokom busy: [llength $pix] piksela"; incr errs } else { echo "ok    start tokom busy ignorisan" }

echo "REZULTAT gfx_engine: $errs gresaka"
quit -f
