import quiz_4::*;
module test();
    quiz obj;
    initial begin
        obj = new();
        for(int i=0; i<10; i++) begin
            assert(obj.randomize());
            $display("queue = %p", obj.q);
        end
        $stop;
    end
endmodule