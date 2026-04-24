import adder_pkg::*;
module adder_tb ();
  //? Interface signals
  logic clk, reset;
  logic signed [3:0] A, B;
  logic signed [4:0] C;
  //? Variables
  int error_count, correct_count;
  rand_adder addr_obj;
  //? DUT Instantiation
  adder DUT (
      .clk(clk),
      .reset(reset),
      .A(A),
      .B(B),
      .C(C)
  );
  //? CLK generator
    initial begin
    clk = 0;
    forever begin
      #1 clk = ~clk;
      addr_obj.clk = clk;
    end
  end
  //? Sampling logic
  always @(posedge reset) begin
    addr_obj.Covgrp_A.stop();
    addr_obj.Covgrp_B.stop();
  end

  always @(negedge reset) begin
    addr_obj.Covgrp_A.start();
    addr_obj.Covgrp_B.start();
  end

  always @(posedge clk) begin
    addr_obj.Covgrp_A.sample();
    addr_obj.Covgrp_B.sample();
  end
  initial begin
    //? Initialization part
    addr_obj = new();
    clk = 0;
    reset = 0;
    A = 0;
    B = 0;
    error_count = 0;
    correct_count = 0;
    @(negedge clk);
    assert_reset();
    //? Randomization test
    for(int i=0; i<100; i++) begin
      assert (addr_obj.randomize());
      A = addr_obj.A;
      B = addr_obj.B;
      reset = addr_obj.reset;
      if (!reset) check_result(A+B);
      else check_result(0);
      
    end
    $display("error_counter=%d, correct_counter=%d", error_count, correct_count);
    $stop;
  end
  //? TASKS
  task assert_reset();
    reset = 1;
    check_result(0);
    reset = 0;
  endtask

  task check_result(input [4:0] expected_sum);
    @(negedge clk);
    if (expected_sum == C) correct_count++;
    else begin
      error_count++;
      $display("xxxx ERROR: the actual output result is not matching the expected result xxxx");
      $display("A=%b ,B=%b, C_exp=%b, C_actual=%b", A, B, expected_sum, C);
    end
  endtask
endmodule
