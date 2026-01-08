`timescale 1ns / 1ns

module testbench;

    reg clk;
    reg rst;
    reg start;
    reg [31:0] i1;
    reg [31:0] i2;
    reg [31:0] i3;

    wire [31:0] result;
    wire done;

    top_module uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .i1(i1),
        .i2(i2),
        .i3(i3),
        .result(result),
        .done(done)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        start = 0;
        i1 = 32'd10;
        i2 = 32'd20;
        i3 = 32'd5;

        #20;
        rst = 0;
        
        #10;
        start = 1;
        #10;
        start = 0;

        wait(done);
        #10;
        
        $display("--------------------------------------------------");
        $display("Simulation Finished");
        $display("Inputs: i1=%d, i2=%d, i3=%d", i1, i2, i3);
        $display("Expected Result: 100");
        $display("Actual Result:   %d", result);
        
        if (result == 32'd100)
            $display("TEST PASSED");
        else
            $display("TEST FAILED");
        $display("--------------------------------------------------");
        
        $stop;
    end
      
endmodule