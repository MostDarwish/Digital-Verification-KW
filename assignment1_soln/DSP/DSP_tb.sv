module DSP_tb ();
  //? local parameters
  localparam  CLK_CYCLE = 2;
  //? Interface signals
  logic signed [17:0] A,B,D;
  logic [47:0] C,P;
  logic clk,rst_n;
  //? Temp signals
  logic [17:0] adder_out_exp;
  logic [47:0] mulout_exp, P_exp;
  //? Variables
  int error_count, correct_count;
  //? DUT instantiation
  DSP DUT_DSP (
    .clk(clk),
    .rst_n(rst_n),
    .A(A),
    .B(B),
    .C(C),
    .D(D),
    .P(P)
  );
  //? CLK generation
  always #(CLK_CYCLE / 2) clk = ~clk;
  //? Driver block
  initial begin
    A = 0;
    B = 0;
    C = 0;
    D = 0;
    rst_n = 1;
    clk = 0;
    #CLK_CYCLE;
    //! DSP_1 test
    assert_reset();
    //! DSP_2 test
    for(int i=0; i<100; i++)begin
      A = $urandom;
      B = $urandom;
      C = {$urandom, $urandom};
      D = $urandom;
      adder_out_exp = (B+D);
      mulout_exp = adder_out_exp * A;
      P_exp = mulout_exp + C;
      check_result(P_exp);
    end
    $display("error_counts = %0d, correct_counts = %0d", error_count, correct_count);
    $stop;
  end
  //? TASKS
  task assert_reset();
    rst_n = 0;
    check_result(0);
    rst_n = 1;
  endtask

  task check_result(input [47:0] expected_P);
    if(rst_n == 0) #CLK_CYCLE;
    else #(4*CLK_CYCLE);

    if (expected_P == P) correct_count++;
    else begin
      error_count++;
      $display("xxxx ERROR: the actual output result is not matching the expected result xxxx");
      $display("A=%0h ,B=%0h, C=%0h, D=%0h, P_exp=%0h, P_result=%0h", A, B, C, D, expected_P, P);
    end
  endtask

endmodule
