`timescale 1ns / 1ns

module XOR_TestBench;
    reg A;
    reg B;
    wire C;
    XOR uut (
        .A(A), 
        .B(B), 
        .C(C)
    );

    integer i;
    initial begin
        A = 0;
        B = 0;
        #10;
        for (i = 0; i < 8; i = i + 1) begin
            {A, B} = i;
            #10;
        end
        $stop;
    end
      
endmodule

