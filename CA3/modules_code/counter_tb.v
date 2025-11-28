`timescale 1ns / 1ns

module Counter_Par_tb;

    parameter WIDTH = 5;

    reg clk;
    reg rst;
    reg load;
    reg en;
    reg [WIDTH-1:0] PI;

    wire [WIDTH-1:0] count;

    Counter #(.WIDTH(WIDTH)) uut (
        .clk(clk), 
        .rst(rst), 
        .load(load), 
        .en(en), 
        .PI(PI), 
        .count(count)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        load = 0;
        en = 0;
        PI = 0;

        #20;
        rst = 0;
        #10;

        en = 1;
        #100;

        en = 0;
        #40;

        PI = 5'b11100;
        load = 1;
        #10;
        
        load = 0;
        #10; 

        en = 1;
        #60; 

        rst = 1;
        #10;
        rst = 0;
        #20;

        $stop;
    end
      
endmodule