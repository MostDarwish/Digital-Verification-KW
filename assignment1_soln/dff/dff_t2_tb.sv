module dff_t2_tb ();
  //? local parameters
  localparam USE_EN = 0;
  localparam CLK_CYCLE = 2;
  //? Interface signals
  logic clk, rst, d, en, q;
  //? temp signals
  logic q_temp;
  //? Variables
  int error_count, correct_count;
  //? DUT instantiation
  dff #(
      .USE_EN(USE_EN)
  ) DUT_dff2 (
      .clk(clk),
      .rst(rst),
      .d  (d),
      .en (en),
      .q  (q)
  );
  //? CLK generation
  always #(CLK_CYCLE / 2) clk = ~clk;
  //? Driver block
  initial begin
    clk = 0;
    rst = 0;
    d   = 1;
    en  = 0;
    #CLK_CYCLE;
    assert_reset();
    if (USE_EN == 1) begin
      en = 0;
      q_temp = q;
      for (int i = 0; i < 10; i++) begin
        d = $random;
        check_result(q_temp);
      end
      en = 1;
      for (int i = 0; i < 10; i++) begin
        d = $random;
        check_result(d);
      end
      en = 0;
      q_temp = q;
      for (int i = 0; i < 10; i++) begin
        d = $random;
        check_result(q_temp);
      end
    end else begin
      for (int i = 0; i < 10; i++) begin
        d = $random;
        check_result(d);
      end
    end
    $display("error_counts = %0d, correct_counts = %0d", error_count, correct_count);
    $stop;
  end

  //? TASKS
  task assert_reset();
    rst = 1;
    check_result(0);
    #(5 * CLK_CYCLE);
    rst = 0;
  endtask

  task check_result(input q_exp);
    #CLK_CYCLE;
    if (q_exp == q) correct_count++;
    else begin
      error_count++;
      $display("xxxx ERROR: the actual output result is not matching the expected result xxxx");
      $display("q=%0b ,q_exp=%0b, rst=%0b, en=%0b", q, q_exp, rst, en);
    end
  endtask

endmodule
