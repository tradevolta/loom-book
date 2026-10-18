#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# check.sh -- everything CI runs without Vivado: tool versions
# against tools/versions.lock, text hygiene and book-listing
# identity, then `make lint sim test` in every project (Verible lint
# and format, Verilator lint, each SystemVerilog testbench and each
# cocotb test on Verilator and on Icarus Verilog).
#
#   tools/check.sh
set -euo pipefail
cd "$(dirname "$0")/.."

echo "== tool versions (tools/versions.lock)"
tools/check-versions.sh --strict

echo "== text hygiene and book listings"
python3 tools/check_repo.py

for proj in projects/ch*_*/; do
  echo "== ${proj%/}: make lint sim test"
  # -B: run every step again, even if an earlier run left results
  make -B --no-print-directory -C "$proj" lint sim test
done
echo "check.sh: all checks passed"
