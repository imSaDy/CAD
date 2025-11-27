`timescale 1ns / 1ns

module MUX41_tb;

    parameter WIDTH = 4;

    reg [WIDTH-1:0] I0;
    reg [WIDTH-1:0] I1;
    reg [WIDTH-1:0] I2;
    reg [WIDTH-1:0] I3;
    reg [1:0] S;
    wire [WIDTH-1:0] Y;

    MUX41 #(.WIDTH(WIDTH)) uut (
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

        I0 = 4'h1; 
        I1 = 4'h2; 
        I2 = 4'h4; 
        I3 = 4'h8;
        
        S = 2'b00; #10; 
        S = 2'b01; #10; 
        S = 2'b10; #10; 
        S = 2'b11; #10; 

        I0 = 4'hA; 
        I1 = 4'hB; 
        I2 = 4'hC; 
        I3 = 4'hD;

        S = 2'b00; #10; 
        S = 2'b01; #10; 
        S = 2'b10; #10; 
        S = 2'b11; #10; 

        $stop;
    end
      
endmodule