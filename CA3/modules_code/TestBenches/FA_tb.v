`timescale 1ns/1ps

module FA_TB;
    reg A, B, Cin;
    wire S, C;

    FA dut (.A(A), .B(B), .Cin(Cin), .S(S), .C(C));

    integer i;

    initial begin
        for (i = 0; i < 8; i = i + 1) begin
            {A, B, Cin} = i[2:0];
            #5;
        end
        #10;
        $stop;
    end
endmodule
