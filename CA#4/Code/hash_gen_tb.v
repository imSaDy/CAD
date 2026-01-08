`timescale 1ns/1ns
module HashGenerator_TB();
    reg clk;   
    reg rst;
    reg start;
    wire done;
    reg [31:0] message;
    wire [31:0] digest;

    initial clk = 1'b0;
    always #5 clk = ~clk;

    wire [5:0] i;
    wire [7:0] const_i;

    ConstMem #(
        .INPUT_WIDTH(6),
        .OUTPUT_WIDTH(8),
        .MEM_FILE("constant.mem")
    ) const_mem (
        .index(i),
        .data_out(const_i)
    );

    HashGenerator  hash_generator(
        .clk(clk),
        .rst(rst),
        .start(start),
        .message(message),
        .const_i(const_i),
        .done(done),
        .digest(digest),
        .i(i)
    );

    initial begin
        message = 32'b0; start=0; rst = 1'b1;
        #10 rst = 1'b0;
        #10 start = 1'b1 ; message = 32'hac390aa7; 
        #10 start = 1'b0;
        #10000;
        $stop;
    end

endmodule