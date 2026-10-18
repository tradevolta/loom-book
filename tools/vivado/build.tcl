# SPDX-License-Identifier: Apache-2.0
# build.tcl -- non-project Vivado flow for one book project: read the
# project's RTL and constraints, synthesize, implement, write reports
# and a bitstream. Fails on any error, on DRC errors at bitstream time
# (for example an unconstrained port) and on negative setup or hold
# slack.
#
#   vivado -mode batch -source tools/vivado/build.tcl \
#     -tclargs projects/ch01_hello_fabric hello_fabric
#
# Results go to <project-dir>/build/: <top>.bit, checkpoints, and
# reports/ (timing, utilization, DRC, I/O, summary.txt).

set part xc7z007sclg400-1

if {[llength $argv] != 2} {
  error "usage: build.tcl <project-dir> <top-module>"
}
lassign $argv proj top
set proj [file normalize $proj]
set root [file dirname [file dirname [file dirname \
  [file normalize [info script]]]]]
set out [file join $proj build]
set rpt [file join $out reports]
file mkdir $rpt

# The book is written and tested on one Vivado release. Warn, do not
# stop, when this one differs (see "Upgrading to newer Vivado
# versions" in Chapter 2 and Appendix B).
proc pinned_version {lock tool} {
  set f [open $lock r]
  set text [read $f]
  close $f
  set pattern "^${tool}\\s*=\\s*\"(\[^\"\]+)\""
  if {[regexp -line $pattern $text -> v]} {
    return $v
  }
  return ""
}
set want [pinned_version [file join $root tools versions.lock] vivado]
set have [version -short]
if {$want ne "" && $have ne $want} {
  puts "WARNING: running Vivado $have; the book is pinned to $want"
}

set sources [glob -nocomplain [file join $proj rtl *.sv]]
set constraints [glob -nocomplain [file join $proj constr *.xdc]]
if {[llength $sources] == 0} {
  error "no SystemVerilog sources in [file join $proj rtl]"
}
if {[llength $constraints] == 0} {
  error "no constraints in [file join $proj constr]"
}
read_verilog -sv [lsort $sources]
read_xdc [lsort $constraints]

synth_design -top $top -part $part
write_checkpoint -force [file join $out post_synth.dcp]
report_utilization -file [file join $rpt utilization_synth.rpt]

opt_design
place_design
route_design
write_checkpoint -force [file join $out post_route.dcp]

report_timing_summary -file [file join $rpt timing_summary.rpt]
report_utilization -file [file join $rpt utilization.rpt]
report_drc -file [file join $rpt drc.rpt]
report_io -file [file join $rpt io.rpt]

# Timing gate. A design without clocks (Chapter 1) has no timed
# paths; the gate then reports "n/a" and passes.
proc worst_slack {kind} {
  set paths [get_timing_paths -max_paths 1 -nworst 1 $kind]
  if {[llength $paths] == 0} {
    return "n/a"
  }
  set slack [get_property SLACK [lindex $paths 0]]
  if {![string is double -strict $slack]} {
    return "n/a"
  }
  return $slack
}
set wns [worst_slack -setup]
set whs [worst_slack -hold]
set cw [get_msg_config -count -severity {CRITICAL WARNING}]
proc count_cells {group} {
  return [llength [get_cells -hier -filter "PRIMITIVE_GROUP == $group"]]
}
set luts [count_cells LUT]
set ffs [count_cells FLOP_LATCH]

set f [open [file join $rpt summary.txt] w]
puts $f "vivado $have"
puts $f "part $part"
puts $f "top $top"
puts $f "wns_ns $wns"
puts $f "whs_ns $whs"
puts $f "critical_warnings $cw"
puts $f "luts $luts"
puts $f "flip_flops $ffs"
close $f

foreach {name value} [list WNS $wns WHS $whs] {
  if {$value ne "n/a" && $value < 0} {
    error "timing gate: $name is $value ns (negative slack)"
  }
}
puts "timing gate: WNS $wns ns, WHS $whs ns: pass"

write_bitstream -force [file join $out $top.bit]
puts "bitstream: [file join $out $top.bit]"
