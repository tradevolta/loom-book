// SPDX-License-Identifier: Apache-2.0
// hello_fabric_tb.sv -- exhaustive, self-checking testbench for
// Project 1. Drives all 1,024 switch patterns and checks that every
// LED copies its switch. Shows the first few mismatches, then prints
// one PASS or FAIL line.
module hello_fabric_tb;
  timeunit 1ns; timeprecision 1ps;

  logic [9:0] sw;
  logic [9:0] led;
  int unsigned errors = 0;

  hello_fabric u_dut (
    .sw (sw),
    .led(led)
  );

  initial begin
    for (int i = 0; i < 1024; i++) begin
      sw = 10'(i);
      #1;
      if (led !== sw) begin
        errors++;
        if (errors <= 3) $display("mismatch: sw=%b led=%b", sw, led);
      end
    end
    if (errors != 0) begin
      $fatal(1, "FAIL hello_fabric_tb: %0d mismatches", errors);
    end
    $display("PASS hello_fabric_tb: 1024 patterns checked");
    $finish;
  end

endmodule : hello_fabric_tb
