`timescale 1ns / 1ns

module Adder2_8bit_TestBench;

    reg  [7:0] A;
    reg  [7:0] B;
    reg        cin;
    wire [7:0] Sum;
    wire       cout;

    Adder2 uut (
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

        for (i = 0; i < 16; i = i + 1) begin
            {A, B} = {i, 16 - i};
            cin = i % 2;
            #10;
        end

        A = 8'h00; B = 8'h00; cin = 0; #10;
        A = 8'hFF; B = 8'h01; cin = 0; #10;
        A = 8'hAA; B = 8'h55; cin = 1; #10;

        for (i = 0; i < 10; i = i + 1) begin
            A   = $random;
            B   = $random;
            cin = $random % 2;
            #10;
        end

        $stop;
    end

endmodule


module Adder4_8bit_TestBench;

    reg  [7:0] A;
    reg  [7:0] B;
    reg  [7:0] C;
    reg  [7:0] D;
    reg        cin;

    wire [7:0] Sum;
    wire       cout;

    Adder4 uut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .cin(cin),
        .Sum(Sum),
        .cout(cout)
    );

    integer i;

    initial begin
        A   = 0;
        B   = 0;
        C   = 0;
        D   = 0;
        cin = 0;
        #10;

        for (i = 0; i < 16; i = i + 1) begin
            A   = i;
            B   = 16 - i;
            C   = i + 1;
            D   = 8  - i;
            cin = i % 2;
            #10;
        end

        A = 8'h00; B = 8'h00; C = 8'h00; D = 8'h00; cin = 0; #10;
        A = 8'hFF; B = 8'h01; C = 8'h00; D = 8'h00; cin = 0; #10;
        A = 8'hAA; B = 8'h55; C = 8'h0F; D = 8'hF0; cin = 1; #10;
        A = 8'hFF; B = 8'hFF; C = 8'hFF; D = 8'hFF; cin = 1; #10;

        for (i = 0; i < 10; i = i + 1) begin
            A   = $random;
            B   = $random;
            C   = $random;
            D   = $random;
            cin = $random % 2;
            #10;

        end

        $stop;
    end

endmodule