`timescale 1ns / 1ns

module Adder_8bit_TestBench;

    reg  [7:0] A;
    reg  [7:0] B;
    reg        cin;
    wire [7:0] Sum;
    wire       cout;

    Adder_8bit uut (
        .A(A),
        .B(B),
        .cin(cin),
        .Sum(Sum),
        .cout(cout)
    );

    integer i;

    initial begin
        A   = 0;
        B   = 0;
        cin = 0;
        #10;

        $display("---- Sweeping Inputs ----");
        for (i = 0; i < 16; i = i + 1) begin
            {A, B} = {i, 16 - i};
            cin = i % 2;
            #10;
        end

        $display("---- Corner Cases ----");
        A = 8'h00; B = 8'h00; cin = 0; #10;
        A = 8'hFF; B = 8'h01; cin = 0; #10;
        A = 8'hAA; B = 8'h55; cin = 1; #10;

        $display("---- Random ----");
        for (i = 0; i < 10; i = i + 1) begin
            A   = $random;
            B   = $random;
            cin = $random % 2;
            #10;
        end

        $stop;
    end

endmodule
