module Memory #(
    parameter DATA_WIDTH = 34,
    parameter INPUT_ADDRESS_WIDTH = 7,
    parameter MEMORY_SIZE = 128,
    parameter MEM_FILE = "input_memory (1).txt"
)(
    input clk,
    input rst,
    input write,
    input [DATA_WIDTH-1:0] data_in, 
    input [INPUT_ADDRESS_WIDTH-1:0] address,
    output reg [DATA_WIDTH-1:0] data_out
);
    reg [DATA_WIDTH-1:0] rom [0:MEMORY_SIZE-1];

    initial begin 
        $readmemh(MEM_FILE, rom);
    end
    always @(posedge clk) begin
        if (rst)
            $readmemh(MEM_FILE, rom);
        else if (write) 
            rom[address] <= data_in; 
    end

    assign data_out = rom[address];

endmodule