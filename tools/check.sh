#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# check.sh -- everything CI runs without Vivado: text hygiene and
# book-listing identity, Verible lint and format, Verilator lint, and
# every project testbench on Verilator and Icarus Verilog. Chapter 2
# wraps these steps in `make lint` and `make sim`.
#
#   tools/check.sh
set -euo pipefail
cd "$(dirname "$0")/.."
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
flags=tools/verible-format.flags

echo "== text hygiene and book listings"
python3 tools/check_repo.py

mapfile -t sv < <(git ls-files '*.sv')
echo "== verible lint and format (${#sv[@]} files)"
verible-verilog-lint "${sv[@]}"
for f in "${sv[@]}"; do
  verible-verilog-format --flagfile="$flags" --verify "$f" >/dev/null \
    || { echo "FAIL format: $f (run verible-verilog-format" \
           "--flagfile=$flags --inplace $f)"; exit 1; }
done

for proj in projects/ch*_*/; do
  proj=${proj%/}
  top=${proj#projects/ch[0-9][0-9]_}
  mapfile -t rtl < <(ls "$proj"/rtl/*.sv)
  echo "== $proj: verilator lint (top $top)"
  verilator --lint-only -Wall --quiet --top-module "$top" "${rtl[@]}"
  for tb in "$proj"/tb/*_tb.sv; do
    [ -e "$tb" ] || continue
    name=$(basename "$tb" .sv)
    echo "== $proj: $name on Verilator"
    verilator --binary -Wall --timescale 1ns/1ps --quiet \
      --Mdir "$work/$name" --top-module "$name" "${rtl[@]}" "$tb" \
      >"$work/$name.build.log" 2>&1 \
      || { cat "$work/$name.build.log"; exit 1; }
    "$work/$name/V$name" | tee "$work/$name.v.log"
    grep -q '^PASS ' "$work/$name.v.log"
    echo "== $proj: $name on Icarus Verilog"
    # -Wno-timescale: RTL carries no timeunit; the testbench does.
    iverilog -g2012 -Wall -Wno-timescale -o "$work/$name.vvp" \
      "${rtl[@]}" "$tb"
    vvp -n "$work/$name.vvp" | tee "$work/$name.i.log"
    grep -q '^PASS ' "$work/$name.i.log"
  done
done
echo "check.sh: all checks passed"
