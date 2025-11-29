module HashGenerator_TB();
    reg clk;   
    reg rst;
    reg start;
    wire done;
    reg [31:0] message;
    wire [31:0] digest;

    initial clk = 1'b0;
    always #5 clk = ~clk;

    HashGenerator #(
        .A0(8'h01),
        .B0(8'h89),
        .C0(8'hfe),
        .D0(8'h76),
        .MESSAGE_WIDTH(32),
        .MEMORY_FILE("constant.mem")
    ) hash_generator(
        .clk(clk),
        .rst(rst),
        .start(start),
        .message(message),
        .done(done),
        .digest(digest)
    );

    initial begin
        message = 32'b0; start=0; rst = 1'b1;
        #10 rst = 1'b0;
        #10 start = 1'b1 ; message = 32'hdf01f0b7; 
        #10 start = 1'b0;
        #10000;
        $stop;
    end

endmodule