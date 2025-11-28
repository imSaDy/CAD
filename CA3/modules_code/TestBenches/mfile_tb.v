`timescale 1ns/1ps

module MFile_TestBench;

    localparam MESSAGE_WIDTH = 32;

    reg clk;
    reg rst;
    reg load;
    reg [1:0] index;
    reg [MESSAGE_WIDTH-1:0] message;
    wire [7:0] out;

    MFile #(MESSAGE_WIDTH) dut (
        .clk(clk),
        .rst(rst),
        .message(message),
        .load(load),
        .index(index),
        .out(out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    initial begin
        rst = 1;
        load = 0;
        index = 0;
        message = 0;

        #20;
        rst = 0;

        message = 32'hA1_B2_C3_D4;
        load = 1;
        #10;
        load = 0;

        #10;

        index = 0; #10;
        index = 1; #10;
        index = 2; #10;
        index = 3; #10;

        #20;
        $stop;
    end

endmodule
