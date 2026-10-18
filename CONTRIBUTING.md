# Contributing

Thank you for helping. This repository is the code of a printed book,
so a few rules are stricter than usual: what the book prints must stay
byte-identical to what is here.

## Reporting a problem

Open an issue with:

* the chapter and project (for example `projects/ch01_hello_fabric`)
  and the tag you checked out (`git describe --tags`);
* your board revision (the book targets Blackboard Rev D);
* your Vivado version (`vivado -version`), and for a newer release
  than 2025.2 the output of `report_ip_status` and a diff of the
  reports in `<project>/build/reports/` against your 2025.2 build if
  you have one;
* the exact command and its full output.

Board-file errata and tool differences that are confirmed are listed
in `board/README.md` and on the book's errata page.

## Code rules

The book's coding standard (lowRISC-based, simplified for FPGA and
print) applies to every file:

* ASCII only, LF line ends, spaces only (no TABs), no trailing spaces.
* At most 100 columns in the repository; files that the book prints
  are kept to 72 (`book/listings/` is checked at 72).
* SystemVerilog: 2-space indent; one module per file, named after the
  file; `logic`, `always_ff` with `<=` and `always_comb` with `=`;
  synchronous active-high resets in the PL; `_i`/`_o` port suffixes
  (top-level board ports keep the XDC names, such as `sw` and `led`);
  `endmodule : name` end labels. Format with
  `verible-verilog-format --flagfile=tools/verible-format.flags`.
* Every testbench is self-checking, ends with one `PASS ...` or
  `FAIL ...` line and exits non-zero on failure.
* Tcl and XDC: 2-space indent, one command per line; one
  `set_property -dict` per pin, broken after `-dict {` where a line
  would pass 72 columns.
* Every source file starts with `SPDX-License-Identifier: Apache-2.0`.

Run the checks before you open a pull request:

```
tools/check.sh
```

## Book listings

`book/listings/chNN/` is written by the book build, not by hand. Each
row of its `INDEX.csv` names the repository file a listing was taken
from; `tools/check_repo.py` fails if the two differ by a single byte.
If you change a file that a chapter prints, say so in the pull request:
the change lands in the next chapter tag, and the printed chapter keeps
pointing at its own tag.

## History

Tags are never moved and published history is never rewritten (no
force-pushes, no rebases of `main`). Fixes to an earlier chapter's
code are new commits, listed on the errata page.

## Licence

By contributing you agree that your contribution is licensed under
Apache-2.0 (code) or CC BY 4.0 (documentation), as in `LICENSING.md`.
