module TOP ();
  logic reset;
  logic signed [3:0] A, B;
  logic signed [4:0] C;
  logic [1:0] opcode;
  bit clk;
  always #1 clk = ~clk;

  ALU_4_bit DUT (.reset(reset), .A(A), .B(B), .C(C), .opcode(opcode), .clk(clk));
  ALU_tb TB (.reset(reset), .A(A), .B(B), .C(C), .opcode(opcode), .clk(clk));
  bind ALU_4_bit ALU_sva ALU_sva_inst (.reset(reset), .A(A), .B(B), .C(C), .opcode(opcode), .clk(clk));
endmodule
