`timescale 1ns / 1ns

module NOT_TestBench;
    reg A;
    wire Y;
    NOT uut (
        .A(A), 
        .Y(Y)
    );

    integer i;
    initial begin
        A = 0;
        #10;
        for (i = 0; i < 8; i = i + 1) begin
            {A} = i;
            #10;
        end
        $stop;
    end
      
endmodule

