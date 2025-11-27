`timescale 1ns / 1ns

module MUX21_tb;

    reg I0;
    reg I1;
    reg S;
    wire Y;

    MUX21 uut (
        .I0(I0), 
        .I1(I1), 
        .S(S), 
        .Y(Y)
    );

    initial begin
        I0 = 0;
        I1 = 0;
        S = 0;
        #10;

        I0 = 1;
        I1 = 0;
        S = 0;
        #10;

        I0 = 0;
        I1 = 1;
        S = 0;
        #10;

        I0 = 1;
        I1 = 1;
        S = 0;
        #10;

        I0 = 0;
        I1 = 0;
        S = 1;
        #10;

        I0 = 1;
        I1 = 0;
        S = 1;
        #10;

        I0 = 0;
        I1 = 1;
        S = 1;
        #10;

        I0 = 1;
        I1 = 1;
        S = 1;
        #10;

        $stop;
    end
      
endmodule