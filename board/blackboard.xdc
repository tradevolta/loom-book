# SPDX-License-Identifier: Apache-2.0
# blackboard.xdc -- corrected master constraints for the RealDigital
# Blackboard Rev D (XC7Z007S-1CLG400C), used by every project in the
# book. Derived from RealDigital's master XDC (research copy of 17 Oct
# 2026) and checked against the Rev D schematic; see board/README.md
# for every change and the errata still to be confirmed on hardware.
#
# Every line is commented out. Copy the lines a design needs into the
# project's constr/ file (or uncomment them in a copy of this file).
# Each group of ports sets its I/O standard once, with one
# IOSTANDARD line over the group's ports; then one PACKAGE_PIN line
# per port.
# Port names follow RealDigital's master XDC, except where a name was
# not a legal SystemVerilog identifier (GYRO_*_A/G, see README).
# Section headers give the schematic net names.

## Clock: 100 MHz PL oscillator
#set_property IOSTANDARD LVCMOS33 [get_ports {clk}]
#set_property PACKAGE_PIN H16 [get_ports {clk}]
#create_clock -name sys_clk -period 10.000 [get_ports clk]

## Discrete LEDs: led[0]..led[9] = schematic nets LD0..LD9
#set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]
#set_property PACKAGE_PIN N20 [get_ports {led[0]}]
#set_property PACKAGE_PIN P20 [get_ports {led[1]}]
#set_property PACKAGE_PIN R19 [get_ports {led[2]}]
#set_property PACKAGE_PIN T20 [get_ports {led[3]}]
#set_property PACKAGE_PIN T19 [get_ports {led[4]}]
#set_property PACKAGE_PIN U13 [get_ports {led[5]}]
#set_property PACKAGE_PIN V20 [get_ports {led[6]}]
#set_property PACKAGE_PIN W20 [get_ports {led[7]}]
#set_property PACKAGE_PIN W19 [get_ports {led[8]}]
#set_property PACKAGE_PIN Y19 [get_ports {led[9]}]

## RGB LEDs: RGB_led_A = LD10_R/G/B, RGB_led_B = LD11_R/G/B ([0]=R [1]=G [2]=B)
#set_property IOSTANDARD LVCMOS33 [get_ports {RGB_led_A[*] RGB_led_B[*]}]
#set_property PACKAGE_PIN W18 [get_ports {RGB_led_A[0]}]
#set_property PACKAGE_PIN W16 [get_ports {RGB_led_A[1]}]
#set_property PACKAGE_PIN Y18 [get_ports {RGB_led_A[2]}]
#set_property PACKAGE_PIN Y14 [get_ports {RGB_led_B[0]}]
#set_property PACKAGE_PIN Y16 [get_ports {RGB_led_B[1]}]
#set_property PACKAGE_PIN Y17 [get_ports {RGB_led_B[2]}]

## Slide switches: sw[0]..sw[11] = schematic nets SW0..SW11
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[*]}]
#set_property PACKAGE_PIN R17 [get_ports {sw[0]}]
#set_property PACKAGE_PIN U20 [get_ports {sw[1]}]
#set_property PACKAGE_PIN R16 [get_ports {sw[2]}]
#set_property PACKAGE_PIN N16 [get_ports {sw[3]}]
#set_property PACKAGE_PIN R14 [get_ports {sw[4]}]
#set_property PACKAGE_PIN P14 [get_ports {sw[5]}]
#set_property PACKAGE_PIN L15 [get_ports {sw[6]}]
#set_property PACKAGE_PIN M15 [get_ports {sw[7]}]
#   schematic net SW8 (master XDC comment: VGA_R4_CON)
#set_property PACKAGE_PIN T10 [get_ports {sw[8]}]
#   schematic net SW9 (master XDC comment: VGA_R5_CON)
#set_property PACKAGE_PIN T12 [get_ports {sw[9]}]
#   schematic net SW10 (master XDC comment: VGA_R6_CON)
#set_property PACKAGE_PIN T11 [get_ports {sw[10]}]
#   schematic net SW11 (master XDC comment: VGA_R7_CON)
#set_property PACKAGE_PIN T14 [get_ports {sw[11]}]

## PL push buttons: btn[0]..btn[3] = BTN0..BTN3 (two more are on PS MIO)
#set_property IOSTANDARD LVCMOS33 [get_ports {btn[*]}]
#set_property PACKAGE_PIN W14 [get_ports {btn[0]}]
#set_property PACKAGE_PIN W13 [get_ports {btn[1]}]
#set_property PACKAGE_PIN P15 [get_ports {btn[2]}]
#set_property PACKAGE_PIN M14 [get_ports {btn[3]}]

## Seven-segment anodes: seg_an[0]..seg_an[3] = SSEG_AN0..SSEG_AN3
#set_property IOSTANDARD LVCMOS33 [get_ports {seg_an[*]}]
#set_property PACKAGE_PIN K19 [get_ports {seg_an[0]}]
#set_property PACKAGE_PIN H17 [get_ports {seg_an[1]}]
#set_property PACKAGE_PIN M18 [get_ports {seg_an[2]}]
#set_property PACKAGE_PIN L16 [get_ports {seg_an[3]}]

## Seven-segment cathodes: seg_cat[0]..seg_cat[7] = SSEG_CA..SSEG_CG, SSEG_DP
#set_property IOSTANDARD LVCMOS33 [get_ports {seg_cat[*]}]
#set_property PACKAGE_PIN K14 [get_ports {seg_cat[0]}]
#set_property PACKAGE_PIN H15 [get_ports {seg_cat[1]}]
#set_property PACKAGE_PIN J18 [get_ports {seg_cat[2]}]
#set_property PACKAGE_PIN J15 [get_ports {seg_cat[3]}]
#set_property PACKAGE_PIN M17 [get_ports {seg_cat[4]}]
#set_property PACKAGE_PIN J16 [get_ports {seg_cat[5]}]
#set_property PACKAGE_PIN H18 [get_ports {seg_cat[6]}]
#set_property PACKAGE_PIN K18 [get_ports {seg_cat[7]}]

## LSM9DS1 IMU (SPI): port = schematic net, with A/G written AG or A_G
#set_property IOSTANDARD LVCMOS33 [get_ports {
#  GYRO_SCL GYRO_SDA GYRO_SDO_AG GYRO_SDO_M GYRO_CS_AG GYRO_CS_M
#  DEN_A_G DRDY_M INT_A_G INT_M
#}]
#set_property PACKAGE_PIN H20 [get_ports {GYRO_SCL}]
#set_property PACKAGE_PIN J19 [get_ports {GYRO_SDA}]
#set_property PACKAGE_PIN J20 [get_ports {GYRO_SDO_AG}]
#set_property PACKAGE_PIN L17 [get_ports {GYRO_SDO_M}]
#set_property PACKAGE_PIN K17 [get_ports {GYRO_CS_AG}]
#set_property PACKAGE_PIN K16 [get_ports {GYRO_CS_M}]
#set_property PACKAGE_PIN J14 [get_ports {DEN_A_G}]
#set_property PACKAGE_PIN L20 [get_ports {DRDY_M}]
#set_property PACKAGE_PIN M20 [get_ports {INT_A_G}]
#set_property PACKAGE_PIN L19 [get_ports {INT_M}]

## PDM microphone
#set_property IOSTANDARD LVCMOS33 [get_ports {M_clk M_data}]
#set_property PACKAGE_PIN N15 [get_ports {M_clk}]
#set_property PACKAGE_PIN L14 [get_ports {M_data}]

## PWM audio out (headphone amplifier)
#set_property IOSTANDARD LVCMOS33 [get_ports {headphone}]
#set_property PACKAGE_PIN G18 [get_ports {headphone}]

## HDMI source. TMDS I/O standards are chosen in Chapter 13; the
## LVCMOS33 values below are RealDigital's. hdmi_out_en (F17) was
## removed: F17 is JA1_N (erratum 1 in board/README.md).
#set_property IOSTANDARD LVCMOS33 [get_ports {
#  hdmi_clk_n hdmi_clk_p hdmi_tx_n[*] hdmi_tx_p[*]
#  hdmi_cec hdmi_hpd hdmi_scl hdmi_sda
#}]
#set_property PACKAGE_PIN U19 [get_ports {hdmi_clk_n}]
#set_property PACKAGE_PIN U18 [get_ports {hdmi_clk_p}]
#set_property PACKAGE_PIN V18 [get_ports {hdmi_tx_n[0]}]
#set_property PACKAGE_PIN V17 [get_ports {hdmi_tx_p[0]}]
#set_property PACKAGE_PIN P18 [get_ports {hdmi_tx_n[1]}]
#set_property PACKAGE_PIN N17 [get_ports {hdmi_tx_p[1]}]
#set_property PACKAGE_PIN P19 [get_ports {hdmi_tx_n[2]}]
#set_property PACKAGE_PIN N18 [get_ports {hdmi_tx_p[2]}]
#set_property PACKAGE_PIN U17 [get_ports {hdmi_cec}]
#set_property PACKAGE_PIN P16 [get_ports {hdmi_hpd}]
#set_property PACKAGE_PIN T17 [get_ports {hdmi_scl}]
#set_property PACKAGE_PIN R18 [get_ports {hdmi_sda}]

## Pmod JA: ports named after the schematic nets (JA1_P..JA4_N); the
## mapping to Pmod pin numbers is tabled in Appendix A (JA1_N is JA pin 2)
## (200 ohm series resistors; routed as differential pairs)
#set_property IOSTANDARD LVCMOS33 [get_ports {JA1_P JA1_N JA2_P JA2_N JA3_P JA3_N JA4_P JA4_N}]
#set_property PACKAGE_PIN F16 [get_ports {JA1_P}]
#set_property PACKAGE_PIN F17 [get_ports {JA1_N}]
#set_property PACKAGE_PIN G19 [get_ports {JA2_P}]
#set_property PACKAGE_PIN G20 [get_ports {JA2_N}]
#set_property PACKAGE_PIN E18 [get_ports {JA3_P}]
#set_property PACKAGE_PIN E19 [get_ports {JA3_N}]
#set_property PACKAGE_PIN E17 [get_ports {JA4_P}]
#set_property PACKAGE_PIN D18 [get_ports {JA4_N}]

## Pmod JB: ports named after the schematic nets (JB1_P..JB4_N); the
## mapping to Pmod pin numbers is tabled in Appendix A (verify on hardware)
## (200 ohm series resistors; routed as differential pairs)
#set_property IOSTANDARD LVCMOS33 [get_ports {JB1_P JB1_N JB2_P JB2_N JB3_P JB3_N JB4_P JB4_N}]
#set_property PACKAGE_PIN D19 [get_ports {JB1_P}]
#set_property PACKAGE_PIN D20 [get_ports {JB1_N}]
#set_property PACKAGE_PIN F19 [get_ports {JB2_P}]
#set_property PACKAGE_PIN F20 [get_ports {JB2_N}]
#set_property PACKAGE_PIN C20 [get_ports {JB3_P}]
#set_property PACKAGE_PIN B20 [get_ports {JB3_N}]
#set_property PACKAGE_PIN B19 [get_ports {JB4_P}]
#set_property PACKAGE_PIN A20 [get_ports {JB4_N}]

## Pmod JC: ports named after the schematic nets JC1..JC10; JC7..JC10
## share package pins with the servo headers
#set_property IOSTANDARD LVCMOS33 [get_ports {JC1 JC2 JC3 JC4 JC7 JC8 JC9 JC10}]
#set_property PACKAGE_PIN V15 [get_ports {JC1}]
#set_property PACKAGE_PIN W15 [get_ports {JC2}]
#set_property PACKAGE_PIN V16 [get_ports {JC3}]
#set_property PACKAGE_PIN T16 [get_ports {JC4}]
#set_property PACKAGE_PIN M19 [get_ports {JC7}]
#set_property PACKAGE_PIN G14 [get_ports {JC8}]
#set_property PACKAGE_PIN G17 [get_ports {JC9}]
#set_property PACKAGE_PIN G15 [get_ports {JC10}]

## Servo headers (same package pins as JC9, JC10, JC8, JC7)
#   schematic net SERVO1, shared with JC9
#set_property IOSTANDARD LVCMOS33 [get_ports {servo[*]}]
#set_property PACKAGE_PIN G17 [get_ports {servo[0]}]
#   schematic net SERVO2, shared with JC10
#set_property PACKAGE_PIN G15 [get_ports {servo[1]}]
#   schematic net SERVO3, shared with JC8
#set_property PACKAGE_PIN G14 [get_ports {servo[2]}]
#   schematic net SERVO4, shared with JC7
#set_property PACKAGE_PIN M19 [get_ports {servo[3]}]
