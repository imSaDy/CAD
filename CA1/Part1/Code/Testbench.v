`timescale 1ns/1ns
module tb_rndGenerator
    reg clk;
    reg rst;
    reg [5:0] seed; 
    reg start_rnd
    wire done_rnd; 
    wire [1:0] twoMSB; 
    
    initial clk = 0;
    always #5 clk = ~clk; 
    
    initial begin
        shift_en = 0; par_load = 0; seed = 80'b0; rst = 1;
        #10 rst = 0;
        #10 start_rnd = 1; seed = 000111; 
        #10 start_rnd = 0; 
        #150;
        #10 start_rnd = 1; seed = 000000; 
        #10 start_rnd = 0; 
        #150;
        #10 start_rnd = 1; seed = 000001; // 000010 000101 001010 010100 101000 010000  
        #10 start_rnd = 0; 
        #150;
        #10 start_rnd = 1; seed = 111111;
        #10 start_rnd = 0; 
        #150;
        #10 start_rnd = 1; seed = 100101;
        #10 start_rnd = 0; 
        #150;
    end
endmodule