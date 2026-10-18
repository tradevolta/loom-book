# Project 1: Hello, fabric (Chapter 1)

Each discrete LED LD0..LD9 shows the slide switch SW0..SW9 with the
same number, through one continuous assignment and no clock.

| File | Purpose |
|---|---|
| `rtl/hello_fabric.sv` | The design (top module `hello_fabric`) |
| `constr/hello_fabric.xdc` | Package pins and I/O standards for `sw[9:0]` and `led[9:0]` |
| `tb/hello_fabric_tb.sv` | Exhaustive self-checking testbench (all 1,024 switch patterns) |

## Build and program (Vivado 2025.2)

From the repository root, with jumper JP2 on JTAG and the board
connected through its PROG UART micro-USB port:

```
vivado -mode batch -source tools/vivado/build.tcl \
  -tclargs projects/ch01_hello_fabric hello_fabric
vivado -mode batch -source tools/vivado/prog.tcl \
  -tclargs projects/ch01_hello_fabric/build/hello_fabric.bit
```

The build writes `build/hello_fabric.bit` and the reports in
`build/reports/` (`summary.txt` has WNS, WHS, the critical-warning
count and the LUT and flip-flop counts).

## Simulate (no Vivado needed)

```
cd projects/ch01_hello_fabric
verilator --binary -Wall --timescale 1ns/1ps \
  --top-module hello_fabric_tb rtl/hello_fabric.sv tb/hello_fabric_tb.sv
obj_dir/Vhello_fabric_tb
```

## Hardware checklist

Status: **not yet run on a board.** Tick each item on a Blackboard
Rev D with Vivado 2025.2 and record the results in the book.

1. Jumpers: JP3 on the PROG UART (USB) supply, JP2 on JTAG, JP1 on the
   board supply. Note the silkscreen labels and photograph them.
2. Power on with the power switch. Note which LEDs light before any
   design is loaded (factory configuration in QSPI, if any).
3. In Vivado's Hardware Manager (or `prog.tcl`), the JTAG chain shows
   one target and an `xc7z007s` device. Record the names it prints.
4. `build.tcl` completes with no errors; Vivado reads the multi-line
   `set_property -dict {...}` form in `hello_fabric.xdc` without a
   warning. Keep `build/reports/summary.txt`, `utilization.rpt`,
   `timing_summary.rpt` and the log.
5. `prog.tcl` programs the device; note any DONE indicator.
6. Each switch SW0..SW9, moved alone, lights only the LED with the same
   number. Record which switch position is 1 (LED on).
7. All ten switches on: all ten LEDs on. All off: all off.
8. SW10 and SW11 change nothing.
9. Power-cycle: the design is gone (JTAG configuration is volatile).
