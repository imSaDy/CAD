module ShiftRegister #(
    parameter WIDTH = 6
)(
    input clk, 
    input rst,
    input load,
    input shiftEn,
    input [WIDTH-1:0] PI,
    output [1:0] twoMSB;
);
    reg [WIDTH-1:0] shiftReg;
    always @(posedge clk or posedge rst) begin
        if (rst)
            shiftReg <= {WIDTH{1'b0}};
        else if (load)
            shiftReg <= PI;
        else if (shiftEn)
            shiftReg <= {shiftReg[WIDTH-2:0], shiftReg[5] ^ shiftReg[3] ^ shiftReg[1]}; 
    end
    assign twoMSB = shiftReg[WIDTH-1:WIDTH-2]; 
endmodule