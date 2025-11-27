module ShiftRegister #(
    parameter WIDTH = 6
)(
    input clk, 
    input rst,
    input load,
    input shiftEn,
    input ser_in,
    input [WIDTH-1:0] PI,
    output [1:0] twoMSB,
    output [WIDTH-1:0] Q 
);

    wire [WIDTH-1:0] q;
    
    assign Q = q;
    assign twoMSB = q[WIDTH-1:WIDTH-2];

    s2 bit_0 (
        .D00(q[0]), 
        .D01(ser_in),
        .D10(PI[0]), 
        .D11(PI[0]), 
        .A1(load), 
        .B1(1'b0), 
        .A0(shiftEn), 
        .B0(1'b1), 
        .clr(rst), 
        .clk(clk), 
        .out(q[0])
    );

    genvar i;
    generate
        for (i = 1; i < WIDTH; i = i + 1) begin : bit_slice
            s2 bit_inst (
                .D00(q[i]), 
                .D01(q[i-1]),
                .D10(PI[i]), 
                .D11(PI[i]), 
                .A1(load), 
                .B1(1'b0), 
                .A0(shiftEn), 
                .B0(1'b1), 
                .clr(rst), 
                .clk(clk), 
                .out(q[i])
            );
        end
    endgenerate

endmodule