# Project 1: Hello, fabric (Chapter 1)

Each discrete LED LD0..LD9 shows the slide switch SW0..SW9 with the
same number, through one continuous assignment and no clock.

| File | Purpose |
|---|---|
| `rtl/hello_fabric.sv` | The design (top module `hello_fabric`) |
| `constr/hello_fabric.xdc` | Package pins and I/O standards for `sw[9:0]` and `led[9:0]` |
| `tb/hello_fabric_tb.sv` | Exhaustive self-checking testbench (all 1,024 switch patterns) |
| `tb/test_hello_fabric.py` | cocotb smoke test, also exhaustive (Chapter 2) |
| `Makefile` | `make lint`, `sim`, `test`, `bit`, `prog`, `clean` (`tools/make/project.mk`) |

## Lint, simulate, build and program

From this directory:

```
make            # lint, sim and test: no Vivado needed
make bit        # Vivado 2025.2: build/hello_fabric.bit, build/reports/
make prog       # program over JTAG (jumper JP2 on JTAG, PROG UART port)
```

`make bit` runs `tools/vivado/build.tcl` in batch mode and `make prog`
runs `tools/vivado/prog.tcl`; Chapter 1 shows the same scripts run by
hand from the repository root. The build writes
`build/reports/summary.txt` with WNS, WHS, the critical-warning count
and the LUT and flip-flop counts.

## Hardware checklist

Status: **not yet run on a board.** Tick each item on a Blackboard
Rev D with Vivado 2025.2 and record the results in the book.

1. Jumpers: JP3 on the PROG UART (USB) supply, JP2 on JTAG, JP1 on the
   board supply. Note the silkscreen labels and photograph them.
2. Power on with the power switch. Note which LEDs light before any
   design is loaded (factory configuration in QSPI, if any).
3. In Vivado's Hardware Manager (or `prog.tcl`), the JTAG chain shows
   one target and an `xc7z007s` device. Record the names it prints.
4. `build.tcl` completes with no errors; Vivado applies the group
   `IOSTANDARD` line (`[get_ports {sw[*] led[*]}]`) to all twenty
   ports with no warning (check `io.rpt`: every `sw` and `led` port
   LVCMOS33 at its package pin). Keep `build/reports/summary.txt`,
   `utilization.rpt`, `timing_summary.rpt` and the log.
5. `prog.tcl` programs the device; note any DONE indicator.
6. Each switch SW0..SW9, moved alone, lights only the LED with the same
   number. Record which switch position is 1 (LED on).
7. All ten switches on: all ten LEDs on. All off: all off.
8. SW10 and SW11 change nothing.
9. Power-cycle: the design is gone (JTAG configuration is volatile).
10. Chapter 2: `make bit` and `make prog` from this directory do the
    same as items 4 and 5, and `make prog` after a source change
    rebuilds first. Record `build/build.log`'s last lines.
11. Chapter 2: `tools/check-versions.sh` reports `vivado 2025.2 ok`;
    record the exact output of `vivado -version` it parses.
12. Chapter 2: record the installation paths of `settings64.sh` and of
    the cable-driver script (`install_drivers`) for Vivado 2025.2.
