#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0
"""run_cocotb.py -- build a project's RTL and run its cocotb tests
(tb/test_*.py) on one simulator; exit 1 if any test fails.

  python3 tools/run_cocotb.py verilator projects/ch01_hello_fabric \\
      hello_fabric
"""

import sys
from pathlib import Path

from cocotb_tools.check_results import get_results
from cocotb_tools.runner import get_runner


def main(sim: str, project: str, top: str) -> int:
    proj = Path(project).resolve()
    rtl = sorted((proj / "rtl").glob("*.sv"))
    tests = sorted(p.stem for p in (proj / "tb").glob("test_*.py"))
    if not tests:
        print(f"no cocotb tests in {proj / 'tb'}")
        return 0
    out = proj / "build" / f"cocotb-{sim}"
    runner = get_runner(sim)
    runner.build(
        sources=rtl,
        hdl_toplevel=top,
        build_dir=out,
        timescale=("1ns", "1ps"),
        always=True,
    )
    xml = runner.test(
        test_module=tests,
        hdl_toplevel=top,
        test_dir=proj / "tb",
        build_dir=out,
        results_xml=str(out / "results.xml"),
    )
    total, failed = get_results(xml)
    print(f"{'FAIL' if failed else 'PASS'} cocotb on {sim}: "
          f"{total - failed} of {total} tests passed")
    return 1 if failed else 0


if __name__ == "__main__":
    if len(sys.argv) != 4:
        sys.exit(__doc__)
    sys.exit(main(*sys.argv[1:]))
