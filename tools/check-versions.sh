#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# check-versions.sh -- compare the tools on PATH with the pins in
# tools/versions.lock. One line per tool, `<tool> <pinned>: ok`, or
# DIFF (a different version) or missing. A DIFF is a warning; with --strict it is an
# error (CI uses --strict). A missing tool is never an error here:
# CI has no Vivado, and a laptop may have no cocotb yet.
#
#   tools/check-versions.sh [--strict]
set -uo pipefail
cd "$(dirname "$0")/.."
strict=0
[ "${1:-}" = --strict ] && strict=1
pin() { sed -n "s/^$1 *= *\"\([^\"]*\)\".*/\1/p" tools/versions.lock; }

# found TOOL COMMAND: the installed version, or nothing if COMMAND
# is not on PATH
found() {
  command -v "$2" >/dev/null || return 0
  case $1 in
    vivado) vivado -version 2>/dev/null \
      | sed -n 's/.* v\([0-9][0-9.]*\).*/\1/p' | head -1 ;;
    verilator) verilator --version | awk '{print $2}' ;;
    iverilog) { iverilog -V 2>&1 || true; } \
      | sed -n 's/.* version \([0-9.]*\) .*/\1/p' | head -1 ;;
    verible) verible-verilog-lint --version | awk 'NR==1 {print $2}' ;;
    cocotb) cocotb-config --version ;;
  esac
}

diffs=0
for t in vivado:vivado verilator:verilator iverilog:iverilog \
         verible:verible-verilog-lint cocotb:cocotb-config; do
  tool=${t%%:*}
  want=$(pin "$tool")
  have=$(found "$tool" "${t#*:}")
  if [ -z "$have" ]; then
    echo "$tool $want: missing"
  elif [ "$have" = "$want" ]; then
    echo "$tool $want: ok"
  else
    echo "$tool $want: DIFF, found $have"
    diffs=$((diffs + 1))
  fi
done
if [ "$diffs" -gt 0 ]; then
  echo "WARNING: $diffs tool(s) differ from tools/versions.lock"
  [ "$strict" = 1 ] && exit 1
fi
exit 0
