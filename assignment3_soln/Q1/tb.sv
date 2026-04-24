import testing_pkg::*;

module tb ();
  Transaction tr = new;
  byte operand1, operand2, out, expected_out;
  opcode_e opcode;
  bit clk, rst;
  int correct_count, error_count = 0;
  //CLK generation
  initial begin
    clk = 0;
    forever begin
      #1 clk = ~clk;
      tr.clk = clk;
    end
  end
  //<DUT Instantiation>
  alu_seq DUT (
      operand1,
      operand2,
      clk,
      rst,
      opcode,
      out
  );

  initial begin
    // initialization
    operand1 = 0;
    operand2 = 0;
    opcode   = ADD;
    assert_reset();

    repeat (32) begin  // Run a few cycles
      assert (tr.randomize());  // Create a transaction
      operand1 = tr.operand1;
      operand2 = tr.operand2;
      opcode   = tr.opcode;
      @(negedge clk);
      out_exp();
      check_result();
    end
    $display("correct_count = %d, error_count = %d", correct_count, error_count);
    $stop();
  end
  //TASKS
  task assert_reset();
    rst = 0;
    @(negedge clk);
    rst = 1;
    @(negedge clk);
    rst = 0;
  endtask

  task out_exp();
    case (opcode)
      ADD:  expected_out = operand1 + operand2;
      SUB:  expected_out = operand1 - operand2;
      MULT: expected_out = operand1 * operand2;
      DIV:  expected_out = operand1 / operand2;
    endcase
  endtask

  task check_result();
    if (expected_out == out) correct_count++;
    else begin
      error_count++;
      $display("xxxx ERROR at time %0t: the actual output result is not matching the expected result xxxx", $time);
      $display("out=%0b ,expected=%0b", out, expected_out);
    end
  endtask

endmodule
