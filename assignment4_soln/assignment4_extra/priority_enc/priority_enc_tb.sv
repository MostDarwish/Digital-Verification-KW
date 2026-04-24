module priority_enc_tb (
  //?interface ports
  output logic [3:0] D,
  output logic rst,
  input logic clk,
  input logic [1:0] Y,
  input logic valid
);
  localparam CLK_CYCLE = 2;
  //?test block
  initial begin
    D   = 0;
    rst = 0;
    #(CLK_CYCLE / 2);
    assert_reset();
    assert_data();
    assert_reset();
    $stop;
  end
  //?tasks
  task assert_reset();
    rst = 1;
    #(5*CLK_CYCLE);
    rst = 0;
  endtask
  task assert_data();
    for (int i = 0; i < 17; i++) begin
      D++;
      #CLK_CYCLE;
    end
  endtask

endmodule
