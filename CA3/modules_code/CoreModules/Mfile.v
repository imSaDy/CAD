module MFile #(
    parameter MESSAGE_WIDTH = 32
)(  
    input clk,
    input rst,
    input [MESSAGE_WIDTH-1: 0] message,
    input load,
    input [1:0] index,
    output [MESSAGE_WIDTH/4 -1: 0] out
);

    wire [MESSAGE_WIDTH-1: 0] outReg;

    Register #(MESSAGE_WIDTH) reg1(
        .clk(clk),
        .rst(rst),
        .load(load),
        .D(message),
        .Q(outReg)
    );

    MUX41 #(MESSAGE_WIDTH/4) mux(
        .I0(outReg[MESSAGE_WIDTH/4 - 1:0]),
        .I1(outReg[(2*MESSAGE_WIDTH)/4 - 1: MESSAGE_WIDTH/4]),
        .I2(outReg[(3*MESSAGE_WIDTH)/4 - 1: (2*MESSAGE_WIDTH)/4]),
        .I3(outReg[MESSAGE_WIDTH - 1: (3*MESSAGE_WIDTH)/4]),
        .S(index),
        .Y(out)
    );

endmodule