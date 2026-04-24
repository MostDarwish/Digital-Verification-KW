import COUNTER_PACKAGE::*;
module counter_tb ();
  //? local parameters
  localparam CLK_CYCLE = 2;
  //? Variables
  int error_count, correct_count;
  //? interface signals
  logic clk;
  logic rst_n;
  logic load_n;
  logic up_down;
  logic ce;
  logic [WIDTH-1:0] data_load;
  logic [WIDTH-1:0] count_out;
  logic max_count;
  logic zero;
  //? debug signals
  logic [WIDTH-1:0] count_out_g;
  logic max_count_g, zero_g;
  //? class object
  counter_var count_rand;
  //? DUT instantiation
  counter #(
      .WIDTH(WIDTH)
  ) COUNTER_DUT (
      .clk(clk),
      .rst_n(rst_n),
      .load_n(load_n),
      .up_down(up_down),
      .ce(ce),
      .data_load(data_load),
      .count_out(count_out),
      .max_count(max_count),
      .zero(zero)
  );
  //? CLK generation
  always #(CLK_CYCLE / 2) clk = ~clk;
  //? Driver block
  initial begin
    //*initialization
    count_rand = new();
    clk = 0;
    rst_n = 1;
    load_n = 1;
    up_down = 0;
    ce = 0;
    data_load = $random;
    #CLK_CYCLE;
    //! COUNTER_1 TEST
    assert_reset();
    $display("COUNTER_1 TEST time = %0t",$time);
    //! COUNTER_2 TEST
    load_n = 0;
    for(int i=0; i<10; i++) begin
        data_load = $random;
        golden_model();
        check_result(count_out_g, zero_g, max_count_g);
    end
    $display("COUNTER_2 TEST time = %0t",$time);
    //! COUNTER_3 & COUNTER_4 TESTS
    ce = 1;
    load_n = 1;
    up_down = 1;
    for (int i = 0; i<10 ;i++) begin
        golden_model();
        check_result(count_out_g, zero_g, max_count_g);
    end
    up_down = 0;
    for (int i = 0;i<10 ;i++) begin
        golden_model();
        check_result(count_out_g, zero_g, max_count_g);
    end
    ce = 0;
    for (int i = 0;i<5 ;i++ ) begin
        golden_model();
        check_result(count_out_g, zero_g, max_count_g);
    end
    $display("COUNTER_3&4 TEST time = %0t",$time);
    //! COUNTER_5 TEST
    for (int i = 0; i<100; i++) begin
        assert(count_rand.randomize());
        data_load = count_rand.data_load;
        ce = count_rand.ce;
        up_down = count_rand.up_down;
        rst_n = count_rand.rst_n;
        load_n = count_rand.load_n;
        golden_model();
        check_result(count_out_g, zero_g, max_count_g);
    end 
    $display("COUNTER_5 TEST time = %0t",$time);
    $display("error_counts = %0d, correct_counts = %0d", error_count, correct_count);
    $stop;
  end
  //? TASKS
  task assert_reset();
    rst_n = 0;
    count_out_g = 0;
    zero_g = 1;
    max_count_g = 0;
    check_result(count_out_g, zero_g, max_count_g);
    rst_n = 1;
  endtask

  task check_result(input [WIDTH-1:0] count_out_exp, input zero_exp, max_count_exp);
    #CLK_CYCLE;
    if (count_out_exp == count_out && zero_exp == zero && max_count_exp == max_count) correct_count++;
    else begin
      error_count++;
      $display("xxxx ERROR at time %0t: the actual output result is not matching the expected result xxxx", $time);
      $display("count_out=%0b ,count_out_exp=%0b\nmax_count=%0b, max_count_exp=%0b\nzero=%0b, zero_exp=%0b\ndata_load = %0b, ce = %0b, up_down = %0b \n",
               count_out, count_out_exp, max_count, max_count_exp, zero, zero_exp, data_load, ce, up_down);
    end
  endtask

  task golden_model();
    if(rst_n == 0)begin
        max_count_g = 0;
        zero_g = 1;
        count_out_g = 0;
    end else if(load_n == 0) begin
        count_out_g = data_load;
        if(count_out_g == 0) begin
            max_count_g = 0;
            zero_g = 1;
        end else if(count_out_g == {WIDTH{1'b1}})begin
            max_count_g = 1;
            zero_g = 0;
        end else begin
            max_count_g = 0;
            zero_g = 0;
        end
    end else if(ce == 1) begin
        if(up_down == 1) count_out_g++;
        else count_out_g--;
        if(count_out_g == {WIDTH{1'b1}}) begin
                max_count_g = 1;
                zero_g = 0;
        end else if (count_out_g == 0) begin
            max_count_g = 0;
            zero_g = 1;
        end else begin
            max_count_g = 0;
            zero_g = 0;
        end
    end
  endtask
endmodule