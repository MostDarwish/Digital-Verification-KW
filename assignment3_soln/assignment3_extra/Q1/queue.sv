module queue();
    int j = 1;
    int q [$] = {0,2,5};
    int temp;
    initial begin
        q.insert(1, j);
        $display("q after inserting j at index 1 = %p", q);
        q.delete(1);
        $display("q after deleting index 1 = %p", q);
        q.push_front(7);
        $display("q after pushing front value 7= %p", q);
        q.push_back(9);
        $display("q after pushing back value 9= %p", q);
        j = q.pop_back();
        $display("q after poping back = %p", q);
        $display("poped value j = %0d", j);
        j = q.pop_front();
        $display("q after poping front = %p", q);
        $display("poped value j = %0d", j);
        for (int i = 0; i < q.size()/2; i++) begin
            temp = q[i];
            q[i] = q[q.size()-1-i];
            q[q.size()-1-i] = temp;
        end
        $display("q after reversing = %p", q);
        q.sort();
        $display("q after sorting = %p", q);
        q.rsort();
        $display("q after reverse sorting = %p", q);
        q.shuffle();
        $display("q after shuffling = %p", q);
    end

endmodule