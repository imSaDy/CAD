`timescale 1ns/1ps

module MuxReg_TestBench();

    localparam WIDTH = 8;

    reg clk;
    reg rst;
    reg init;
    reg update;
    reg [WIDTH-1:0] val_init;
    reg [WIDTH-1:0] val_update;
    wire [WIDTH-1:0] Q;

    MuxReg #(WIDTH) dut (
        .clk(clk),
        .rst(rst),
        .init(init),
        .update(update),
        .val_init(val_init),
        .val_update(val_update),
        .Q(Q)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        init = 0;
        update = 0;
        val_init = 8'h00;
        val_update = 8'h00;

        #20;
        rst = 0;

        val_init = 8'hA5;
        init = 1;
        #10;
        init = 0;

        #20;

        val_update = 8'h3C;
        update = 1;
        #10;
        update = 0;

        #20;

        val_update = 8'hF0;
        update = 1;
        #10;
        update = 0;

        #20;

        $stop;
    end

endmodule
