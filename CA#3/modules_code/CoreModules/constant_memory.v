module ConstMem #(
    parameter INPUT_WIDTH = 6,
    parameter OUTPUT_WIDTH = 8,
    parameter MEMORY_FILE = "constant.mem"
)(
    input [INPUT_WIDTH-1:0] index,
    output reg [OUTPUT_WIDTH-1:0] data_out
);

    reg [OUTPUT_WIDTH-1:0]  rom [0:(1<<INPUT_WIDTH)-1];

    initial begin 
        $readmemh(MEMORY_FILE, rom);
    end

    
    assign data_out = rom[index];
    

endmodule