module RegisterFileB #(
    parameter DATA_WIDTH = 16,
    parameter SIZE = 8,
    parameter HALF_SIZE = 4,
    parameter OUTPUT_WIDTH = 64
) (
    input clk,
    input load,
    input [DATA_WIDTH-1:0] data_in,
    input [$clog2(SIZE) - 1 : 0] address, 
    output [OUTPUT_WIDTH-1:0] B1,
    output [OUTPUT_WIDTH-1:0] B2
);

    reg [DATA_WIDTH-1:0] register [0:SIZE-1];

    always @(posedge clk) begin
        if (load)
            register[address] <= data_in; 
    end

    assign B1 = {register[3], register[2], register[1], register[0]};
    assign B2 = {register[7], register[6], register[5], register[4]};

endmodule
