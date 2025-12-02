`timescale 1ns / 1ns

module AND3_tb;
    reg A;
    reg B;
    reg C;
    wire Y;
    AND3 uut (
        .A(A), 
        .B(B), 
        .C(C), 
        .Y(Y)
    );

    integer i;
    initial begin
        A = 0;
        B = 0;
        C = 0;
        #10;
        for (i = 0; i < 8; i = i + 1) begin
            {A, B, C} = i;
            #10;
        end
        $stop;
    end
      
endmodule

