`timescale 1ns/1ns

module Counter_TestBench;

    // ----------------------------------
    // Clock Generation
    // ----------------------------------
    reg clk;
    initial clk = 0;
    always #5 clk = ~clk;   // 10ns period

    // ----------------------------------
    // 3-bit Counter Signals
    // -----------------------------------
    reg rst3, load3, en3;
    reg [2:0] PI3;
    wire [2:0] count3;

    Counter_3Bit U3 (
        .clk(clk),
        .rst(rst3),
        .load(load3),
        .en(en3),
        .PI(PI3),
        .count(count3)
    );

    // ----------------------------------
    // 6-bit Counter Signals
    //-----------------------------------
    reg rst6, load6, en6;
    reg [5:0] PI6;
    wire [5:0] count6;

    Counter_6Bit U6 (
        .clk(clk),
        .rst(rst6),
        .load(load6),
        .en(en6),
        .PI(PI6),
        .count(count6)
    );

    // ----------------------------------
    // TEST SEQUENCE
    // ----------------------------------
    initial begin
        $display("====== START COUNTER TEST ======");

        // ---------------------------
        // INITIAL VALUES
        // ---------------------------
        rst3 = 1; load3 = 0; en3 = 0; PI3 = 3'b000;
        rst6 = 1; load6 = 0; en6 = 0; PI6 = 6'b000000;

        #20;
        rst3 = 0;
        rst6 = 0;

        // ---------------------------
        // COUNT UP FOR A FEW CYCLES
        // ---------------------------
        en3 = 1;
        en6 = 1;

        #100;

        // ---------------------------
        // LOAD VALUES
        // ---------------------------
        load3 = 1; PI3 = 3'b101;   // load decimal 5
        load6 = 1; PI6 = 6'd42;    // load decimal 42

        #10;
        load3 = 0;
        load6 = 0;

        // Continue counting
        #80;

        // ---------------------------
        // DISABLE COUNTING
        // ---------------------------
        en3 = 0;
        en6 = 0;

        #50;

        // ---------------------------
        // ENABLE AGAIN
        // ---------------------------
        en3 = 1;
        en6 = 1;

        #80;

        // ---------------------------
        // APPLY RESET AGAIN
        // ---------------------------
        rst3 = 1;
        rst6 = 1;
        #15;
        rst3 = 0;
        rst6 = 0;

        #50;

        $display("====== END TEST ======");
        $stop;
    end

endmodule
