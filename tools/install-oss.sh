#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# install-oss.sh -- build and install the open-source simulators and
# linter pinned in tools/versions.lock into PREFIX (bin/ under it).
# Needs a C++ toolchain, autoconf, bison, flex, gperf, help2man and
# make; on Ubuntu 24.04:
#   sudo apt-get install -y autoconf bison flex gperf help2man g++ \
#     libfl-dev make perl python3 zlib1g-dev
#
#   tools/install-oss.sh "$HOME/.local/loom-oss"
#   export PATH="$HOME/.local/loom-oss/bin:$PATH"
set -euo pipefail
prefix=${1:?usage: install-oss.sh PREFIX}
mkdir -p "$prefix"
prefix=$(cd "$prefix" && pwd)
here=$(cd "$(dirname "$0")" && pwd)
pin() {
  sed -n "s/^$1 *= *\"\([^\"]*\)\".*/\1/p" "$here/versions.lock"
}
verilator=$(pin verilator)
iverilog=$(pin iverilog)
verible=$(pin verible)
gh=https://github.com
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
jobs=$(nproc 2>/dev/null || echo 2)

fetch() {
  curl -fsSL --retry 5 --retry-all-errors -o "$work/dl.tar.gz" "$1"
  tar xzf "$work/dl.tar.gz" -C "$work"
  rm -f "$work/dl.tar.gz"
}

have() {
  [ -x "$prefix/bin/$1" ] || return 1
  # iverilog -V exits non-zero without input files; only the text counts
  { "$prefix/bin/$1" $2 2>&1 || true; } | grep -q -- "$3"
}

if have verilator --version "Verilator $verilator "; then
  echo "verilator $verilator: already installed"
else
  fetch "$gh/verilator/verilator/archive/refs/tags/v$verilator.tar.gz"
  (cd "$work/verilator-$verilator" && autoconf \
    && ./configure --prefix="$prefix" >/dev/null \
    && make -j"$jobs" >/dev/null && make install >/dev/null)
  echo "verilator $verilator: installed"
fi

if have iverilog -V "version $iverilog "; then
  echo "iverilog $iverilog: already installed"
else
  tag="v${iverilog//./_}"
  fetch "$gh/steveicarus/iverilog/archive/refs/tags/$tag.tar.gz"
  (cd "$work/iverilog-${tag#v}" && sh autoconf.sh >/dev/null \
    && ./configure --prefix="$prefix" >/dev/null \
    && make -j"$jobs" >/dev/null && make install >/dev/null)
  echo "iverilog $iverilog: installed"
fi

if have verible-verilog-lint --version "$verible"; then
  echo "verible $verible: already installed"
else
  f="verible-$verible-linux-static-x86_64.tar.gz"
  fetch "$gh/chipsalliance/verible/releases/download/$verible/$f"
  cp "$work/verible-$verible"/bin/* "$prefix/bin/"
  echo "verible $verible: installed"
fi
