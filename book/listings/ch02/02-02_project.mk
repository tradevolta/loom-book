# SPDX-License-Identifier: Apache-2.0
# project.mk -- the make targets every book project shares. A project
# Makefile sets TOP and includes this file:
#
#   TOP := hello_fabric
#   include ../../tools/make/project.mk
#
#   make lint   Verible lint and format check, Verilator lint
#   make sim    tb/*_tb.sv on Verilator and on Icarus Verilog
#   make test   tb/test_*.py (cocotb) on Verilator and on Icarus
#   make bit    Vivado build: build/<TOP>.bit and build/reports/
#   make prog   load build/<TOP>.bit over JTAG
#   make clean  remove build/
#
# `make` alone runs lint, sim and test: everything without Vivado.

.RECIPEPREFIX = >
SHELL := /bin/bash
.SHELLFLAGS := -euo pipefail -c
.DELETE_ON_ERROR:
.PHONY: all lint sim test bit prog clean

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../..)
RTL := $(sort $(wildcard rtl/*.sv))
TBS := $(sort $(wildcard tb/*_tb.sv))
XDC := $(sort $(wildcard constr/*.xdc))
OUT := build
VIVADO ?= vivado
PYTHON ?= python3
VFLAGS := -Wall --quiet --timescale 1ns/1ps
VMODE := -mode batch -nojournal -notrace

all: lint sim test

lint:
> verible-verilog-lint $(RTL) $(TBS)
> @for f in $(RTL) $(TBS); do verible-verilog-format --verify \
>   --flagfile=$(ROOT)/tools/verible-format.flags $$f >/dev/null; done
> verilator --lint-only $(VFLAGS) --top-module $(TOP) $(RTL)

sim: $(TBS:tb/%.sv=$(OUT)/%.v.log) $(TBS:tb/%.sv=$(OUT)/%.i.log)

# One log per testbench and simulator; a log exists only if it ends
# in a PASS line, so make re-runs a failed simulation next time.
$(OUT)/%.v.log: tb/%.sv $(RTL) | $(OUT)
> verilator --binary $(VFLAGS) --Mdir $(OUT)/$* \
>   --top-module $* $(RTL) $< >$(OUT)/$*.v.build 2>&1 \
>   || { cat $(OUT)/$*.v.build; exit 1; }
> $(OUT)/$*/V$* +verilator+quiet | tee $@.tmp
> @grep -q '^PASS ' $@.tmp && mv $@.tmp $@

$(OUT)/%.i.log: tb/%.sv $(RTL) | $(OUT)
> iverilog -g2012 -Wall -Wno-timescale -o $(OUT)/$*.vvp $(RTL) $<
> vvp -n $(OUT)/$*.vvp | tee $@.tmp
> @grep -q '^PASS ' $@.tmp && mv $@.tmp $@

test: | $(OUT)
> $(PYTHON) $(ROOT)/tools/run_cocotb.py verilator . $(TOP)
> $(PYTHON) $(ROOT)/tools/run_cocotb.py icarus . $(TOP)

bit: $(OUT)/$(TOP).bit

$(OUT)/$(TOP).bit: $(RTL) $(XDC) $(ROOT)/tools/vivado/build.tcl | $(OUT)
> $(VIVADO) $(VMODE) -log $(OUT)/build.log \
>   -source $(ROOT)/tools/vivado/build.tcl -tclargs . $(TOP)

prog: $(OUT)/$(TOP).bit
> $(VIVADO) $(VMODE) -log $(OUT)/prog.log \
>   -source $(ROOT)/tools/vivado/prog.tcl -tclargs $<

$(OUT):
> mkdir -p $@

clean:
> rm -rf $(OUT)
