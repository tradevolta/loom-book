# SPDX-License-Identifier: Apache-2.0
# prog.tcl -- load a bitstream into the Blackboard's programmable
# logic over JTAG (the PROG UART micro-USB port). The design is held
# in configuration memory until power is removed.
#
#   vivado -mode batch -source tools/vivado/prog.tcl \
#     -tclargs projects/ch01_hello_fabric/build/hello_fabric.bit

if {[llength $argv] != 1} {
  error "usage: prog.tcl <bitstream.bit>"
}
set bit [file normalize [lindex $argv 0]]
if {![file exists $bit]} {
  error "no such file: $bit"
}

open_hw_manager
connect_hw_server
open_hw_target
set dev [lindex [get_hw_devices xc7z007s*] 0]
if {$dev eq ""} {
  error "no XC7Z007S on the JTAG chain: is the board on and connected?"
}
current_hw_device $dev
set_property PROGRAM.FILE $bit $dev
program_hw_devices $dev
puts "programmed $dev with $bit"
close_hw_target
disconnect_hw_server
close_hw_manager
