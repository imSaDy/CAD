module ConstMem #(
    parameter INPUT_WIDTH = 6,
    parameter OUTPUT_WIDTH = 32,
    parameter MEM_FILE = "constant.mem"
)(
    input [INPUT_WIDTH-1:0] index,
    output reg [OUTPUT_WIDTH-1:0] data_out
);

    reg [OUTPUT_WIDTH-1:0]  rom [0:(1<<INPUT_WIDTH)-1];

    initial begin 
        $readmemh(MEM_FILE, rom);
    end

    always @(*) begin
        data_out = rom[index];
    end

endmodule