module my_mem_tb ();
  //? local parameters
  localparam TESTS = 100;
  //? Variables
  int error_count, correct_count;
  //? interface signals
  logic clk; 
  logic write;
  logic read; 
  logic [7:0] data_in; 
  logic [15:0] address; 
  logic [7:0] data_out;
  //? DEBUG signals
  logic [15:0] address_array [];
  logic [7:0] data_to_write_array [];
  logic [7:0] data_read_expect_assoc [int];
  logic [7:0] data_read_queue[$];
  //? DUT instantiation
  my_mem DUT (
      .clk(clk),
      .write(write),
      .read(read),
      .data_in(data_in),
      .address(address),
      .data_out(data_out)
  );
  //? CLK generation
  initial begin
    clk = 0;
    forever
      #1 clk = ~clk;
  end
  //? Driver block
  initial begin
    //*initialization
    write = 0;
    read = 0;
    data_in = 0;
    address = 0;
    address_array = new[TESTS];
    data_to_write_array = new[TESTS];
    //*Data preparation
    stimulus_gen();
    golden_model();
    @(negedge clk);
    //*Write operations
    write = 1;
    for (int i = 0; i<TESTS; i++) begin
        address = address_array[i];
        data_in = data_to_write_array[i];
        @(negedge clk);
    end
    //*Read and self-checking
    write = 0;
    read = 1;
    for (int i = 0; i< TESTS; i++) begin
        address = address_array[i];
        @(negedge clk);
        check9Bits();
    end   
    $display("data_read_queue values:");
    while (data_read_queue.size())
        $display("%h",data_read_queue.pop_front());
    $display("Error counts = %d, Correct_counts = %d", error_count, correct_count); 
    $stop;
  end
  //? TASKS

  task stimulus_gen();
    for (int i = 0; i<TESTS ; i++) begin
        address_array[i] = $random;
        data_to_write_array[i] = $random;
    end
  endtask

  task golden_model();
    for (int i = 0; i< TESTS; i++) begin
        data_read_expect_assoc[address_array[i]] = data_to_write_array[i];
    end
  endtask

  task check9Bits();
    if(data_out == data_read_expect_assoc[address]) correct_count++;
    else error_count++;
    data_read_queue.push_back(data_out);
  endtask
endmodule