`timescale 1ns / 1ns

module testbench3;

    reg clk;
    reg rst;
    reg start;
    reg [31:0] i1;
    reg [31:0] i2;

    wire [31:0] result;
    wire done;

    top_module uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .i1(i1),
        .i2(i2),
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
        i2 = 32'd6;

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
        $display("Inputs: i1=%d, i2=%d", i1, i2);
        $display("Expected Result: 80");
        $display("Actual Result:   %d", result);

        if (result == 32'd80)
            $display("TEST PASSED");
        else
            $display("TEST FAILED");

        $display("--------------------------------------------------");

        $stop;
    end

endmodule
