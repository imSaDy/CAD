`timescale 1ns / 1ns

module NOR4_tb;

    reg A;
    reg B;
    reg C;
    reg D;
    wire Y;

    NOR4 uut (
        .A(A), 
        .B(B), 
        .C(C), 
        .D(D), 
        .Y(Y)
    );

    integer i;

    initial begin
        for (i = 0; i < 16; i = i + 1) begin
            {A, B, C, D} = i[3:0];
            #10;
        end
        $stop;
    end
      
endmodule