module tb_hashGeneratopr();
    reg clk;   
    reg rst;
    reg start;
    wire done;
    reg [127:0] message;
    wire [127:0] digest;

    initial clk = 1'b0;
    always #5 clk = ~clk;

    HashGenerator #(
        .A0(32'h67452301),
        .B0(32'hefcdab89),
        .C0(32'h98badcfe),
        .D0(32'h10325476)
    ) hash_generator(
        .clk(clk),
        .rst(rst),
        .start(start),
        .message(message),
        .done(done),
        .digest(digest)
    );

    initial begin
        message = 128'b0; start=0; rst = 1'b1;
        #10 rst = 1'b0;
        #10 start = 1'b1 ; message = 128'h41a801a8e81df62b14a661b85c97bf45; 
        #10 start = 1'b0;
        #10000;
        $stop;
    end

endmodule