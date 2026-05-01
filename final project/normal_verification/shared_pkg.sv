package shared_pkg;
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    bit test_finished;
    int error_count = 0;
    int correct_count = 0;
    event TRIG, ACK;
endpackage