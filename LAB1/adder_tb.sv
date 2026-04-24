module adder_tb ();
  //? local parameters
  localparam MAXPOS = 7;
  localparam MAXNEG = -8;
  localparam CLK_CYCLE = 2;
  //? Interface signals
  logic clk, reset;
  logic signed [3:0] A, B;
  logic signed [4:0] C;
  //? Variables
  int error_count, correct_count;
  //? DUT Instantiation
  adder DUT (
      .clk(clk),
      .reset(reset),
      .A(A),
      .B(B),
      .C(C)
  );
  //? CLK generator
  always begin
    #(CLK_CYCLE / 2) clk = ~clk;
  end
  //? Initialization part
  initial begin
    clk = 0;
    reset = 0;
    A = 0;
    B = 0;
    error_count = 0;
    correct_count = 0;
    #CLK_CYCLE;
    assert_reset();
    //* directed test cases
    //* test-1
    A = 0;
    B = 0;
    check_result(5'b0);
    //* test-2
    A = MAXNEG;
    B = 0;
    check_result(MAXNEG);
    //* test-3
    A = MAXPOS;
    B = 0;
    check_result(MAXPOS);
    //* test-4
    A = 0;
    B = MAXNEG;
    check_result(MAXNEG);
    //* test-5
    A = MAXNEG;
    B = MAXNEG;
    check_result(5'b10000);
    //* test-6
    A = MAXPOS;
    B = MAXNEG;
    check_result(5'b11111);
    //* test-7
    A = 0;
    B = MAXPOS;
    check_result(MAXPOS);
    //* test-8
    A = MAXNEG;
    B = MAXPOS;
    check_result(5'b11111);
    //* test-9
    A = MAXPOS;
    B = MAXPOS;
    check_result(5'b01110);
    //* test-10
    A = 0;
    B = 0;
    check_result(0);
    $display("error_counter=%d, correct_counter=%d", error_count, correct_count);
    $stop;
  end
  //? TASKS
  task assert_reset();
    reset = 1;
    check_result(5'b0);
    reset = 0;
  endtask

  task check_result(input [4:0] expected_sum);
    #(CLK_CYCLE);
    if (expected_sum == C) correct_count++;
    else begin
      error_count++;
      $display("xxxx ERROR: the actual output result is not matching the expected result xxxx");
      $display("A=%b ,B=%b, C_exp=%b, C_actual=%b", A, B, expected_sum, C);
    end
  endtask


endmodule
