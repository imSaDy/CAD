`timescale 1ns / 1ns

module Multiplier4x4_tb;

    reg [3:0] A;
    reg [3:0] B;
    wire [7:0] P;

    Multiplier4x4 uut (
        .A(A), 
        .B(B), 
        .P(P)
    );

    integer i, j;

    initial begin
        A = 0; B = 0;
        #10;

        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                A = i;
                B = j;
                #10;
            end
        end

        $stop;
    end
      
endmodule