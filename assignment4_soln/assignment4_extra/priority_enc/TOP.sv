module TOP ();
  logic rst, valid;
  logic [3:0] D;
  logic [1:0] Y;
  bit clk;
  always #1 clk = ~clk;

  priority_enc PE_DUT (.D(D), .clk(clk), .rst(rst), .Y(Y), .valid(valid));
  priority_enc_tb TB (.D(D), .clk(clk), .rst(rst), .Y(Y), .valid(valid));
  bind priority_enc pencoder_sva pencoder_sva_inst (.D(D), .clk(clk), .rst(rst), .Y(Y), .valid(valid));
endmodule
