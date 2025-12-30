`timescale 1ns / 1ns

module testbench2;

    // Inputs
    reg clk;
    reg rst;
    reg start;
    reg [31:0] i1;
    reg [31:0] i2;
    reg [31:0] i3;

    // Outputs
    wire [31:0] result;
    wire done;

    // Instantiate the Top Module
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

    // Clock Generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test Sequence
    initial begin
        // 1. Initialize Inputs
        rst = 1;
        start = 0;
        i1 = 0;
        i2 = 0;
        i3 = 0;

        // 2. Reset the system
        #20;
        rst = 0;
        
        // 3. Apply Test Vectors
        // Expression: ((i1 - i2) / ((i2 + i3) - (i3 | i1))) + ((i3 / i2) + (i1 - (i2 & i3)))
        // Inputs selected to ensure positive integers and no div-by-zero
        i1 = 32'd20;
        i2 = 32'd5;
        i3 = 32'd30;

        // 4. Start the operation
        #10;
        start = 1;
        #10;
        start = 0;

        // 5. Wait for completion
        wait(done);
        #10;
        
        // 6. Check Results
        $display("--------------------------------------------------");
        $display("Simulation Finished");
        $display("Inputs: i1=%d, i2=%d, i3=%d", i1, i2, i3);
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