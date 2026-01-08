module MFile #(
    parameter MESSAGE_WIDTH = 32
)(  
    input clk,
    input rst,
    input [MESSAGE_WIDTH-1: 0] message,
    input load,
    input [1:0] index,
    output reg [MESSAGE_WIDTH/4 -1: 0] out
);


    wire [MESSAGE_WIDTH - 1:0] outReg;

    Register #(MESSAGE_WIDTH) reg1(
        .clk(clk),
        .rst(rst),
        .load(load),
        .data(message),
        .register(outReg)
    );
    
    always @(*) begin
        case (index)
            2'b00: out = outReg[MESSAGE_WIDTH - 1: (3*MESSAGE_WIDTH)/4];
            2'b01: out = outReg[(3*MESSAGE_WIDTH)/4 - 1: (2*MESSAGE_WIDTH)/4];
            2'b10: out = outReg[(2*MESSAGE_WIDTH)/4 - 1: MESSAGE_WIDTH/4];
            2'b11: out = outReg[MESSAGE_WIDTH/4 - 1:0];
            default: out = 8'b0;
        endcase
    end

endmodule