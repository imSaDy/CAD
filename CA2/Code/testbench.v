module TestBenchMVM();
    reg clk;   
    reg rst;
    reg start;
    wire done;

    initial clk = 1'b0;
    always #5 clk = ~clk;

    Matrix_Multiplier #(
        .DATA_WIDTH(34),
        .ADDR_WIDTH(7),
        .DIMENSION(8),
        .MEMORY_NAME("input_memory (3).txt"),
        .MEMORY_SIZE(128),
        .WRITE_ADDR_START(72),
        .A_WIDTH(16),
        .B_WIDTH(16),
        .A_VEC_SIZE(8), 
        .B_VEC_SIZE(8),
        .B_HALF_SIZE(4),
        .B_CONCAT_WIDTH(64)
    )UUT(
        .clk(clk),
        .rst(rst),
        .start(start),
        .done(done)
    ); 

    initial begin
        rst = 1'b1; 
        #10; 
        rst = 1'b0; start = 1'b1; 
        #10;
        start = 1'b0; 
        #10000;
        $stop;
    end

endmodule