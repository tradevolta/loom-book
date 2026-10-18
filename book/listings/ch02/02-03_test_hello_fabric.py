# SPDX-License-Identifier: Apache-2.0
"""test_hello_fabric.py -- cocotb smoke test for Project 1: for all
1,024 switch settings, every LED shows its own switch.

  make -C projects/ch01_hello_fabric test
"""

import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def test_leds_follow_switches(dut):
    """Drive every switch setting and compare led with sw."""
    errors = 0
    for value in range(2**10):
        dut.sw.value = value
        await Timer(1, unit="ns")
        led = int(dut.led.value)
        if led != value:
            errors += 1
            if errors <= 3:
                cocotb.log.error(
                    f"mismatch: sw={value:010b} led={led:010b}")
    assert errors == 0, f"{errors} of 1024 switch settings wrong"
