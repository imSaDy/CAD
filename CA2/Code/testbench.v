module tb_hashGeneratopr();
    reg clk;   
    reg rst;
    reg start;
    wire done;

    initial clk = 1'b0;
    always #5 clk = ~clk;

    Matrix_Multiplier #(
        .MEMORY_NAME("input_memory (3).txt")
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