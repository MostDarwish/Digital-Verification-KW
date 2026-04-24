module packet_struct;

    typedef logic [6:0] seven_t;

    typedef struct {
        seven_t CRC;     
        seven_t DATA;    
        seven_t CMD;     
        seven_t HEADER;  
    } packet;

    packet my_packet;

    initial begin
        my_packet.HEADER = 7'h5A;
        $display("HEADER = %0h", my_packet.HEADER);
    end

endmodule