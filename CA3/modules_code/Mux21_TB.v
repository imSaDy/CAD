`timescale 1ns / 1ns

module MUX21_tb;

    parameter WIDTH = 4;

    reg [WIDTH-1:0] I0;
    reg [WIDTH-1:0] I1;
    reg S;
    wire [WIDTH-1:0] Y;

    MUX21 #(.WIDTH(WIDTH)) uut (
        .I0(I0), 
        .I1(I1), 
        .S(S), 
        .Y(Y)
    );

    initial begin
        I0 = 0; I1 = 0; S = 0;
        #10;

        I0 = 4'hA;
        I1 = 4'h5;
        S = 0;
        #10;

        S = 1;
        #10;

        I0 = 4'hF;
        I1 = 4'h0;
        S = 0;
        #10;

        S = 1;
        #10;

        $stop;
    end
      
endmodule