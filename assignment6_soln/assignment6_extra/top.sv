import uvm_pkg::*;
`include "uvm_macros.svh"

import alsu_test_pkg::*;
import shared_pkg::*;
module top();
    //? clk generation
    bit clk;
    always #1 clk = ~clk;
    //? DUT & interface instantiation
    ALSU_if alsuif (clk);
    shift_reg_if shift_regif ();
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
    //? internal shift reg interface assignment
    assign shift_regif.serial_in = DUT.serial_in_reg;
    assign shift_regif.direction = direction_e'(DUT.direction_reg);
    assign shift_regif.mode = mode_e'(DUT.opcode_reg[0]);
    assign shift_regif.datain = DUT.out;
    assign shift_regif.dataout = DUT.out_shift;
    //? UVM run_test task
    initial begin
        uvm_config_db #(virtual ALSU_if)::set(null, "uvm_test_top", "ALSU_IF", alsuif);
        uvm_config_db #(virtual shift_reg_if)::set(null, "uvm_test_top", "SHIFT_REG_IF", shift_regif);
        run_test("alsu_test");
    end

    bind ALSU alsu_sva alsu_sva_inst(alsuif.MONITOR);

endmodule