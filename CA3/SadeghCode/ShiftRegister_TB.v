`timescale 1ns / 1ns

module ShiftRegister_tb;
    reg clk;
    reg rst;
    reg load;
    reg shiftEn;
    reg ser_in;
    reg [5:0] PI;
    wire [1:0] twoMSB;

    ShiftRegister uut (
        .clk(clk), 
        .rst(rst), 
        .load(load), 
        .shiftEn(shiftEn), 
        .ser_in(ser_in), 
        .PI(PI), 
        .twoMSB(twoMSB)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        load = 0;
        shiftEn = 0;
        ser_in = 0;
        PI = 0;
        #20;
        rst = 0;
        #10;
        PI = 6'b101010;
        load = 1;
        shiftEn = 0; 
        #10; 
        load = 0;
        #20;
        shiftEn = 1;
        ser_in = 1;
        #60; 
        ser_in = 0;
        #10; 
        rst = 1;
        shiftEn = 0;
        #10;

        $stop;
    end
      
endmodule