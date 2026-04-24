import uvm_pkg::*;
`include "uvm_macros.svh"

import alsu_test_pkg::*;
module top();
    //? clk generation
    bit clk;
    always #1 clk = ~clk;
    //? DUT & interface instantiation
    ALSU_if alsuif (clk);
    ALSU DUT (
        .clk(alsuif.clk),
        .cin(alsuif.cin),
        .rst(alsuif.rst),
        .red_op_A(alsuif.red_op_A),
        .red_op_B(alsuif.red_op_B),
        .bypass_A(alsuif.bypass_A),
        .bypass_B(alsuif.bypass_B),
        .direction(alsuif.direction),
        .serial_in(alsuif.serial_in),
        .opcode(alsuif.opcode),
        .A(alsuif.A),
        .B(alsuif.B),
        .leds(alsuif.leds),
        .out(alsuif.out)
    );
    //? UVM run_test task
    initial begin
        uvm_config_db #(virtual ALSU_if)::set(null, "uvm_test_top", "ALSU_IF", alsuif);
        run_test("alsu_test");
    end

endmodule