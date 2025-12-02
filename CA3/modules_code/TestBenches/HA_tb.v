`timescale 1ns/1ps

module HA_TB;
    reg A, B;
    wire S, C;

    HA dut (.A(A), .B(B), .S(S), .C(C));

    integer i;

    initial begin
        for (i = 0; i < 4; i = i + 1) begin
            {A, B} = i[1:0];
            #5;
        end
        #10;
        $stop;
    end
endmodule
