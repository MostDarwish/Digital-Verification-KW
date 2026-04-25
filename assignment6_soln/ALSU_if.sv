import shared_pkg::*;
interface ALSU_if (clk);
  input clk;
  logic cin, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
  opcode_e opcode;
  logic signed [2:0] A, B;
  logic [15:0] leds;
  logic signed [5:0] out;

  modport MONITOR(
      input clk,
            cin,
            rst,
            red_op_A,
            red_op_B,
            bypass_A,
            bypass_B,
            direction,
            serial_in,
            opcode,
            A,
            B,
            leds,
            out
  );
endinterface
