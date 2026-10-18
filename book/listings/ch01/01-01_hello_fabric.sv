// SPDX-License-Identifier: Apache-2.0
// hello_fabric.sv -- Project 1, "Hello, fabric".
// Each of the ten LEDs shows the slide switch with the same number.
// No clock and no state: one continuous assignment.
module hello_fabric (
  input  logic [9:0] sw,  // slide switches SW0..SW9
  output logic [9:0] led  // discrete LEDs LD0..LD9
);

  assign led = sw;

endmodule : hello_fabric
