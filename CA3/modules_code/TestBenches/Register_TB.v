`timescale 1ns / 1ns

module Register_tb;

    parameter WIDTH = 8;

    reg clk;
    reg rst;
    reg load;
    reg [WIDTH-1:0] D;
    wire [WIDTH-1:0] Q;

    Register #(.WIDTH(WIDTH)) uut (
        .clk(clk), 
        .rst(rst), 
        .load(load), 
        .D(D), 
        .Q(Q)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        load = 0;
        D = 0;
        #20;

        rst = 0;
        #10;

        D = 8'hAA;
        load = 1;
        #10; 
        
        load = 0; 
        D = 8'h00; 
        #10;
        
        D = 8'h55;
        load = 1;
        #10;
        
        load = 0;
        #10;

        rst = 1;
        #10;
        
        $stop;
    end
      
endmodule