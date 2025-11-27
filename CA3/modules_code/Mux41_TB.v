`timescale 1ns / 1ns

module MUX41_tb;

    reg I0;
    reg I1;
    reg I2;
    reg I3;
    reg [1:0] S;
    wire Y;

    MUX41 uut (
        .I0(I0), 
        .I1(I1), 
        .I2(I2), 
        .I3(I3), 
        .S(S), 
        .Y(Y)
    );

    initial begin
        I0 = 0; I1 = 0; I2 = 0; I3 = 0; S = 0;
        #10;

        I0 = 0; I1 = 1; I2 = 0; I3 = 1;
        
        S = 2'b00; #10; 
        S = 2'b01; #10; 
        S = 2'b10; #10; 
        S = 2'b11; #10; 

        I0 = 1; I1 = 0; I2 = 1; I3 = 0;

        S = 2'b00; #10; 
        S = 2'b01; #10; 
        S = 2'b10; #10; 
        S = 2'b11; #10; 

        $stop;
    end
      
endmodule