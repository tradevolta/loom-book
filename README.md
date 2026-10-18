# Loom book companion repository

Code for the book *Logic to Cloud with SystemVerilog: Building Verified
FPGA Hardware, IP Cores and IoT Systems on the Zynq-7000 Blackboard*
(Vincent Donkor, Xilos LLC). It holds **Loom**, the SystemVerilog IP
library the book grows chapter by chapter, and every chapter project.
The book's prose is not in this repository.

Board: RealDigital Blackboard Rev D, AMD Zynq-7000S XC7Z007S-1CLG400C.

**Status: Chapter 1 (`ch01-done`).** One project, no Loom blocks yet:
the first Loom IP (`loom_sync`, `loom_debounce`, `loom_tick`,
`loom_sevenseg_mux`) arrives with Chapter 4.

## Layout

| Path | What lives there |
|---|---|
| `board/` | `blackboard.xdc`, the corrected master constraints, and `README.md` with the board-file errata |
| `projects/chNN_<name>/` | One project per chapter: `rtl/`, `tb/`, `constr/`; the top module is `<name>` |
| `tools/` | `versions.lock` (pinned tools), `vivado/` (non-project Tcl flow), `install-oss.sh`, `check.sh` |
| `book/listings/chNN/` | The exact files the book prints, exported by the book build, with `INDEX.csv` |
| `.github/workflows/` | CI: `tools/check.sh` on every push, pull request and weekly |
| `LICENSES/` | Licence texts other than `LICENSE` (see `LICENSING.md`) |

Later chapters add `loom/` (the IP library), `capstone/sentinel/`,
`board/ps7/`, a Dockerfile and Makefiles, as the book introduces them.

## Tools (pinned in `tools/versions.lock`)

| Tool | Version | Used for |
|---|---|---|
| AMD Vivado ML Standard | 2025.2, frozen for the whole book | synthesis, implementation, bitstream, JTAG programming |
| Verilator | 5.052 | lint and primary simulator |
| Icarus Verilog | 13.0 | second simulator |
| Verible | v0.0-4296-g0f262651 | lint and format |

Vivado ML Standard 2025.2 needs no licence file. It is installed from
AMD's download site and is never redistributed here. If you run a
newer Vivado, `tools/vivado/build.tcl` warns; see "Upgrading to newer
Vivado versions" in Chapter 2 and Appendix B.

## Quick start: Chapter 1, "Hello, fabric"

Set jumper JP2 to JTAG, connect the PROG UART micro-USB port and
switch the board on. Then build and program:

```
git clone https://github.com/tradevolta/loom-book.git
cd loom-book
git checkout ch01-done
vivado -mode batch -source tools/vivado/build.tcl \
  -tclargs projects/ch01_hello_fabric hello_fabric
vivado -mode batch -source tools/vivado/prog.tcl \
  -tclargs projects/ch01_hello_fabric/build/hello_fabric.bit
```

Each LED LD0..LD9 should now follow the slide switch with the same
number; the hardware checklist is in
`projects/ch01_hello_fabric/README.md`.

Without Vivado you can still lint and simulate everything:

```
tools/install-oss.sh "$HOME/.local/loom-oss"
export PATH="$HOME/.local/loom-oss/bin:$PATH"
tools/check.sh
```

## Tags

* `chNN-start`, `chNN-done`: the repository at the start and the end
  of Chapter NN. The book's listing captions link to `chNN-done`.
* `vX.Y.Z`: Loom releases (from Chapter 4).

## Licence

Code: Apache License 2.0 (`LICENSE`). Documentation: CC BY 4.0. See
`LICENSING.md`.
