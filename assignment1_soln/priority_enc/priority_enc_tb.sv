module priority_enc_tb ();
  //?parameters
  parameter CLK_CYCLE = 2;
  //?interface ports
  logic [3:0] D;
  logic clk;
  logic rst;
  logic [1:0] Y;
  logic valid;
  //?variables
  int correct_count, error_count = 0;
  //?instantiation part
  priority_enc PE_DUT (
      .D(D),
      .clk(clk),
      .rst(rst),
      .Y(Y),
      .valid(valid)
  );
  //?CLK generator
  always #(CLK_CYCLE / 2) clk = ~clk;
  //?test block
  initial begin
    clk = 0;
    D   = 0;
    rst = 0;
    #(CLK_CYCLE / 2);
    assert_reset();
    assert_data();
    assert_reset();
    $display("error_counter=%0d, correct_counter=%0d", error_count, correct_count);
    $stop;
  end
  //?tasks
  task assert_reset();
    rst = 1;
    #(5*CLK_CYCLE);
    test_result();
    rst = 0;
  endtask

  task assert_data();
    for (int i = 0; i < 17; i++) begin
      test_result();
      D++;
      #CLK_CYCLE;
    end
  endtask

  task test_result();
    //*check for reset
    if (rst == 1) begin
      check_result(0, 0, 0);
    end  //* check for the valid signal when all inputs are set to 0
    else if (D == 0) begin
      check_result(0, 0, 0);
    end  //* check for outputs at different input stimulus
    else if (D[0] == 1) begin
      check_result(1, 3, 0);
    end else if (D[1] == 1) begin
      check_result(1, 2, 1);
    end else if (D[2] == 1) begin
      check_result(1, 1, 2);
    end else if (D[3] == 1) begin
      check_result(1, 0, 3);
    end
  endtask

  task check_result(valid_exp, logic [1:0] Y_exp, int D_num);
    if (rst == 1) begin
      if (valid == valid_exp && Y == Y_exp) begin
        $display("Reset test passed");
        correct_count++;
      end else begin
        $display("Reset test fails");
        $display(
            "valid_exp=%0b, Y0_exp=%0b, Y1_exp=%0b ... valid_result=%0b, Y0_result=%0b, Y1_result=%0b",
            valid_exp, Y[0], Y[1], valid, Y[0], Y[1]);
        error_count++;
      end
    end else if (D_num == 0) begin
      if (valid == valid_exp) begin
        correct_count++;
        $display("valid = 0 when all inputs are set to 0 passed");
      end else begin
        error_count++;
        $display("valid = 0 when all inputs are 0 fails");
        $display("valid_exp=%0d ... valid_result=%0b", valid_exp, valid);
      end
    end else if (valid == valid_exp && Y == Y_exp) begin
      correct_count++;
      $display("outputs when D%0d is set to one are true (test passed)", D_num);
    end else begin
      error_count++;
      $display("outputs when D%0d is set to one are false (test fails)", D_num);
      $display(
          "valid_exp=%0b, Y0_exp=%0b, Y1_exp=%0b ... valid_result=%0b, Y0_result=%0b, Y1_result=%0b",
          valid_exp, Y_exp[0], Y_exp[1], valid, Y[0], Y[1]);
    end
  endtask
endmodule
