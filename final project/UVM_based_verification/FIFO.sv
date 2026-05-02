import shared_pkg::*;
module FIFO ( FIFO_if.DUT intf);

  logic [FIFO_WIDTH-1:0] mem[FIFO_DEPTH-1:0];
  logic [max_fifo_addr-1:0] wr_ptr, rd_ptr;
  logic [max_fifo_addr:0] count;

  always @(posedge intf.clk or negedge intf.rst_n) begin
    if (!intf.rst_n) begin
      wr_ptr <= 0;
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
    end else if (intf.rd_en && count != 0) begin
      intf.data_out <= mem[rd_ptr];
      rd_ptr <= rd_ptr + 1;
    end
  end

  always @(posedge intf.clk or negedge intf.rst_n) begin
    if (!intf.rst_n) begin
      count <= 0;
    end else begin
      if (({intf.wr_en, intf.rd_en} == 2'b10) && !intf.full) count <= count + 1;
      else if (({intf.wr_en, intf.rd_en} == 2'b01) && !intf.empty) count <= count - 1;
    end
  end

  assign intf.full = (count == FIFO_DEPTH) ? 1 : 0;
  assign intf.empty = (count == 0) ? 1 : 0;
  assign intf.underflow = (intf.empty && intf.rd_en) ? 1 : 0;
  assign intf.almostfull = (count == FIFO_DEPTH - 2) ? 1 : 0;
  assign intf.almostempty = (count == 1) ? 1 : 0;

endmodule
