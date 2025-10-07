module MFile (  
    input clk,
    input rst,
    input [127:0] message,
    input load,
    input [1:0] index,
    output reg [31:0] out
);

    wire [127:0] outReg;

    Register #(128) reg1(
        .clk(clk),
        .rst(rst),
        .load(load),
        .data(message),
        .register(outReg)
    );
    
    always @(*) begin
        case (index)
            2'b00: out = outReg[31:0];
            2'b01: out = outReg[63:32];
            2'b10: out = outReg[95:64];
            2'b11: out = outReg[127:96];
            default: out = 32'b0;
        endcase
    end

endmodule