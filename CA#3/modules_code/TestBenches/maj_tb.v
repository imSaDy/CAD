`timescale 1ns/1ps

module MAJ_TB;

    reg A, B, C;
    wire Y;

    MAJ dut (
        .A(A),
        .B(B),
        .C(C),
        .Y(Y)
    );

    integer i;

    initial begin
        for (i = 0; i < 8; i = i + 1) begin
            {A, B, C} = i[2:0];
            #5;
        end
        $stop;
    end

endmodule


