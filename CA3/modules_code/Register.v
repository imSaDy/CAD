module Register #(
    parameter WIDTH = 4
)(
    input clk,
    input rst,
    input load,
    input [WIDTH-1:0] D,
    output [WIDTH-1:0] Q
);

    wire [WIDTH-1:0] q;
    assign Q = q;

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_slice
            s2 bit_inst (
                .D00(q[i]),
                .D01(D[i]),
                .D10(1'b0),
                .D11(1'b0),
                .A1(1'b0),
                .B1(1'b0),
                .A0(load),
                .B0(1'b1),
                .clr(rst),
                .clk(clk),
                .out(q[i])
            );
        end
    endgenerate

endmodule