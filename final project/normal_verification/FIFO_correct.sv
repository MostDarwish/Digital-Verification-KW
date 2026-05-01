import shared_pkg::*;
module FIFO (
    FIFO_if.DUT intf
);
  localparam max_fifo_addr = $clog2(FIFO_DEPTH);

  logic [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

  logic [max_fifo_addr-1:0] wr_ptr, rd_ptr;
  logic [max_fifo_addr:0] count;

  always @(posedge intf.clk or negedge intf.rst_n) begin
    if (!intf.rst_n) begin
      wr_ptr <= 0;
	  intf.overflow <= 0;
	  intf.wr_ack <= 0;
    end else if (intf.wr_en && count < FIFO_DEPTH) begin
      mem[wr_ptr] <= intf.data_in;
      intf.wr_ack <= 1;
      wr_ptr <= wr_ptr + 1;
    end else begin
      intf.wr_ack <= 0;
      if (intf.full & intf.wr_en) intf.overflow <= 1;
      else intf.overflow <= 0;
    end
  end

  always @(posedge intf.clk or negedge intf.rst_n) begin
    if (!intf.rst_n) begin
      rd_ptr <= 0;
	  intf.data_out <= 0;
	  intf.underflow <= 0;
    end else if (intf.rd_en && count != 0) begin
      intf.data_out <= mem[rd_ptr];
      rd_ptr <= rd_ptr + 1;
	end else begin
		if(intf.rd_en && intf.empty) intf.underflow <= 1;
		else intf.underflow <= 0;
	end
  end

  always @(posedge intf.clk or negedge intf.rst_n) begin
    if (!intf.rst_n) begin
      count <= 0;
    end else begin
      if (({intf.wr_en, intf.rd_en} == 2'b10) && !intf.full) count <= count + 1;
      else if (({intf.wr_en, intf.rd_en} == 2'b01) && !intf.empty) count <= count - 1;
      else if (({intf.wr_en, intf.rd_en} == 2'b11) && intf.empty) count <= count + 1;
	  else if (({intf.wr_en, intf.rd_en} == 2'b11) && intf.full) count <= count - 1;
    end
  end

  assign intf.full = (count == FIFO_DEPTH) ? 1 : 0;
  assign intf.empty = (count == 0) ? 1 : 0;
  assign intf.almostfull = (count == FIFO_DEPTH - 1) ? 1 : 0;
  assign intf.almostempty = (count == 1) ? 1 : 0;

  //ASSERTIONS
	`ifdef SIM
		//asynchronous reset assertion 
		always_comb begin 
			if(!intf.rst_n) 
				arst_sva: assert final(wr_ptr == 0 && rd_ptr == 0 && count == 0);  
		end
		//direct assertions
		always_ff @(posedge intf.clk) begin
			assert (wr_ptr < FIFO_DEPTH);
			assert (rd_ptr < FIFO_DEPTH);
			assert (count <= FIFO_DEPTH);
		end
		//assertions properties
		property wr_ack_sva_check;
			@(posedge intf.clk) disable iff(!intf.rst_n) intf.wr_en && count < FIFO_DEPTH |=> intf.wr_ack;
		endproperty
		property overflow_sva_check;
			@(posedge intf.clk) disable iff(!intf.rst_n) intf.wr_en && count == FIFO_DEPTH |=> intf.overflow;
		endproperty
		property underflow_sva_check;
			@(posedge intf.clk) disable iff(!intf.rst_n) intf.rd_en && count == 0 |=> intf.underflow;
		endproperty
		property empty_sva_check;
			@(posedge intf.clk) disable iff(!intf.rst_n) count == 0 |-> intf.empty;
		endproperty
		property full_sva_check;
			@(posedge intf.clk) disable iff(!intf.rst_n) count == FIFO_DEPTH |-> intf.full;
		endproperty
		property almfull_sva_check;
			@(posedge intf.clk) disable iff(!intf.rst_n) count == FIFO_DEPTH - 1 |-> intf.almostfull;
		endproperty
		property almemp_sva_check;
			@(posedge intf.clk) disable iff(!intf.rst_n) count == 1 |-> intf.almostempty;
		endproperty
		property wr_ptr_wrap_sva_check;
			@(posedge intf.clk) disable iff(!intf.rst_n) wr_ptr == 7 && intf.wr_en && count < FIFO_DEPTH |=> wr_ptr == 0;
		endproperty
		property rd_ptr_wrap_sva_check;
			@(posedge intf.clk) disable iff(!intf.rst_n) rd_ptr == 7 && intf.rd_en && count > 0 |=> rd_ptr == 0;
		endproperty

		//? ASSERTIONS
		wr_ack_sva:               assert property (wr_ack_sva_check); 
		overflow_sva:             assert property (overflow_sva_check);      
		underflow_sva:            assert property (underflow_sva_check);      
		empty_sva:                assert property (empty_sva_check);  
		full_sva:                 assert property (full_sva_check);      
		almfull_sva:              assert property (almfull_sva_check);      
		almemp_sva:               assert property (almemp_sva_check);       
		wr_ptr_wrap_sva:          assert property (wr_ptr_wrap_sva_check);     
		rd_ptr_wrap_sva:          assert property (rd_ptr_wrap_sva_check);     
		//? COVER PROPERTIES
		wr_ack_sva_cp:               cover property (wr_ack_sva_check); 
		overflow_sva_cp:             cover property (overflow_sva_check);      
		underflow_sva_cp:            cover property (underflow_sva_check);      
		empty_sva_cp:                cover property (empty_sva_check);  
		full_sva_cp:                 cover property (full_sva_check);      
		almfull_sva_cp:              cover property (almfull_sva_check);      
		almemp_sva_cp:               cover property (almemp_sva_check);       
		wr_ptr_wrap_sva_cp:          cover property (wr_ptr_wrap_sva_check);     
		rd_ptr_wrap_sva_cp:          cover property (rd_ptr_wrap_sva_check);   

	`endif
endmodule
