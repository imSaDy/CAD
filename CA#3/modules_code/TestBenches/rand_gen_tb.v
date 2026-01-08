`timescale 1ns/1ns

module RndGen_TB();
    reg clk;
    reg rst;
    reg [5:0] seed; 
    reg start_rnd;
    wire done_rnd; 
    wire [1:0] twoMSB; 

    initial clk = 0;
    always #5 clk = ~clk; 

    rndGenerator rndGen(
        .clk(clk),
        .rst(rst),
        .shiftRegPI(seed),
        .start_rnd(start_rnd),
        .rnd(twoMSB),
        .done_rnd(done_rnd)
    );

    initial begin
        seed = 6'b0; 
        rst = 1; 
        start_rnd = 1'b0;
        
        #10 rst = 0;
        
        #10 start_rnd = 1; seed = 6'b000111; 
        #10 start_rnd = 0; 
        #150;
        
        #10 start_rnd = 1; seed = 6'b000000; 
        #10 start_rnd = 0; 
        #150;
        
        #10 start_rnd = 1; seed = 6'b000001; 
        #10 start_rnd = 0; 
        #150;
        
        #10 start_rnd = 1; seed = 6'b111111;
        #10 start_rnd = 0; 
        #150;
        
        #10 start_rnd = 1; seed = 6'b100101; 
        #10 start_rnd = 0; 
        #150;
        
        $stop;
    end
endmodule