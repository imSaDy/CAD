`timescale 1ns / 1ns

module testbench7;

    reg clk;
    reg rst;
    reg start;

    reg [31:0] i1;
    reg [31:0] i2;
    reg [31:0] i3;
    reg [31:0] i4;
    reg [31:0] i5;
    reg [31:0] i6;
    reg [31:0] i7;
    reg [31:0] i8;

    wire [31:0] result;
    wire done;

    top_module uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .i1(i1), .i2(i2), .i3(i3), .i4(i4),
        .i5(i5), .i6(i6), .i7(i7), .i8(i8),
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

        i1 = 32'd2;
        i2 = 32'd3;
        i3 = 32'd1;
        i4 = 32'd4;
        i5 = 32'd12;
        i6 = 32'd10;
        i7 = 32'd9;
        i8 = 32'd5;

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
        $display("Inputs: %d %d %d %d %d %d %d %d",
                  i1,i2,i3,i4,i5,i6,i7,i8);
        $display("Expected Result: 25");
        $display("Actual Result:   %d", result);

        if (result == 32'd25)
            $display("TEST PASSED");
        else
            $display("TEST FAILED");

        $display("--------------------------------------------------");

        $stop;
    end

endmodule
