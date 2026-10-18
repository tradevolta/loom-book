# SPDX-License-Identifier: Apache-2.0
# hello_fabric.xdc -- pins for Project 1 on the RealDigital
# Blackboard Rev D, copied from board/blackboard.xdc. I/O standard
# LVCMOS33 (3.3 V), as in RealDigital's master XDC.

# Slide switches SW0..SW9
set_property -dict {
  PACKAGE_PIN R17 IOSTANDARD LVCMOS33
} [get_ports {sw[0]}]
set_property -dict {
  PACKAGE_PIN U20 IOSTANDARD LVCMOS33
} [get_ports {sw[1]}]
set_property -dict {
  PACKAGE_PIN R16 IOSTANDARD LVCMOS33
} [get_ports {sw[2]}]
set_property -dict {
  PACKAGE_PIN N16 IOSTANDARD LVCMOS33
} [get_ports {sw[3]}]
set_property -dict {
  PACKAGE_PIN R14 IOSTANDARD LVCMOS33
} [get_ports {sw[4]}]
set_property -dict {
  PACKAGE_PIN P14 IOSTANDARD LVCMOS33
} [get_ports {sw[5]}]
set_property -dict {
  PACKAGE_PIN L15 IOSTANDARD LVCMOS33
} [get_ports {sw[6]}]
set_property -dict {
  PACKAGE_PIN M15 IOSTANDARD LVCMOS33
} [get_ports {sw[7]}]
set_property -dict {
  PACKAGE_PIN T10 IOSTANDARD LVCMOS33
} [get_ports {sw[8]}]
set_property -dict {
  PACKAGE_PIN T12 IOSTANDARD LVCMOS33
} [get_ports {sw[9]}]

# Discrete LEDs LD0..LD9
set_property -dict {
  PACKAGE_PIN N20 IOSTANDARD LVCMOS33
} [get_ports {led[0]}]
set_property -dict {
  PACKAGE_PIN P20 IOSTANDARD LVCMOS33
} [get_ports {led[1]}]
set_property -dict {
  PACKAGE_PIN R19 IOSTANDARD LVCMOS33
} [get_ports {led[2]}]
set_property -dict {
  PACKAGE_PIN T20 IOSTANDARD LVCMOS33
} [get_ports {led[3]}]
set_property -dict {
  PACKAGE_PIN T19 IOSTANDARD LVCMOS33
} [get_ports {led[4]}]
set_property -dict {
  PACKAGE_PIN U13 IOSTANDARD LVCMOS33
} [get_ports {led[5]}]
set_property -dict {
  PACKAGE_PIN V20 IOSTANDARD LVCMOS33
} [get_ports {led[6]}]
set_property -dict {
  PACKAGE_PIN W20 IOSTANDARD LVCMOS33
} [get_ports {led[7]}]
set_property -dict {
  PACKAGE_PIN W19 IOSTANDARD LVCMOS33
} [get_ports {led[8]}]
set_property -dict {
  PACKAGE_PIN Y19 IOSTANDARD LVCMOS33
} [get_ports {led[9]}]
