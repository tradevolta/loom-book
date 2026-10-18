# Board files: RealDigital Blackboard Rev D

`blackboard.xdc` is the book's master constraints file for the
Blackboard Rev D (AMD Zynq-7000S XC7Z007S-1CLG400C). It restates the
package pins of RealDigital's master XDC, checked against the Rev D
schematic, with the corrections listed below. Every line is commented
out: each project copies the lines it needs into its own `constr/`
file, so a project's pins are visible in one place.

Sources (copies taken 17 October 2026): RealDigital's Blackboard
master XDC, the Rev D schematic (12 pages) and the Rev D BIST
hardware platform (XSA) from
`github.com/RealDigitalOrg/Blackboard` release 1.0.0-beta.

## Errata

Status **confirm on hardware** means the correction follows from the
schematic and the part numbers, but nobody has checked it on a board
for this book yet. Results go into this table and Appendix A.

| # | Erratum | What this repository does | Status |
|---|---|---|---|
| 1 | The master XDC assigns package pin F17 twice: to `hdmi_out_en` and to `JA1_N` (JA pin 2). The schematic shows F17 as JA1_N and has no HDMI_OUT_EN net. | `hdmi_out_en` is removed; F17 is `JA1_N` only. | **Confirm on hardware** (plan Q4): with a Pmod on JA, drive JA pin 2 from F17 and watch it with a meter or logic analyzer; check that HDMI works with no `hdmi_out_en` drive (Chapter 13). |
| 2 | The schematic's front page labels the QSPI flash "128MB". The part, S25FL128S (IC20, S25FL128SAGMFI00), is 128 Mbit = 16 MB, as RealDigital's product page says. | Code and book use 16 MB. | **Confirm on hardware**: read the marking on IC20; read the flash ID when QSPI is first used (Chapter 24). |
| 3 | The master XDC's comments for `sw[8]`..`sw[11]` say `VGA_R4_CON`..`VGA_R7_CON` (a legacy board). The schematic nets are SW8..SW11. | Comments give the schematic nets; the pins (T10, T12, T11, T14) are unchanged. | Comment only; switch function checked in Chapter 1's hardware checklist. |
| 4 | Several bank-pin-name comments in the master XDC are inconsistent: `seg_cat[4]` and `seg_cat[6]` both say `IO_L8P_T1_AD10P_35`, and `sw[11]` (T14) names a bank-35 pin although the schematic places T14 in bank 34. | Bank-pin-name comments are dropped; section headers give the schematic net names. Package pins are unchanged. | Comment only. |
| 5 | The master XDC names IMU ports `GYRO_SDO_A/G` and `GYRO_CS_A/G`; `/` is not legal in a SystemVerilog identifier. | Renamed `GYRO_SDO_AG` and `GYRO_CS_AG`. | Naming only. |
| 6 | RealDigital's product page calls the device "XC7007S". | The device is the XC7Z007S (schematic Rev D; the XSA says `xc7z007s`, `clg400`, speed grade `-1`). | Documentation only. |
| 7 | The HDMI lines in the master XDC use `LVCMOS33`, which is not a TMDS I/O standard. | Kept as RealDigital wrote them, commented out; Chapter 13 sets the TMDS I/O standards. | To be settled in Chapter 13. |

## Facts used by the early chapters

| Item | Value | Source |
|---|---|---|
| PL clock | 100 MHz oscillator on package pin H16 | master XDC |
| Discrete LEDs `led[0]`..`led[9]` | N20, P20, R19, T20, T19, U13, V20, W20, W19, Y19 | master XDC, schematic |
| Slide switches `sw[0]`..`sw[11]` | R17, U20, R16, N16, R14, P14, L15, M15, T10, T12, T11, T14 | master XDC, schematic |
| I/O standard of those pins | LVCMOS33 (banks 34 and 35) | master XDC |
| Jumpers | JP3 power source (PROG UART USB or EXTP), JP2 boot/programming mode (SD, QSPI or JTAG), JP1 servo supply | RealDigital, "Setting up and Using the Blackboard" |
