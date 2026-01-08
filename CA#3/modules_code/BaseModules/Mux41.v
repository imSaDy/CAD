module MUX41 #(
    parameter WIDTH = 1
)(
    input [WIDTH-1:0] I0,
    input [WIDTH-1:0] I1,
    input [WIDTH-1:0] I2,
    input [WIDTH-1:0] I3,
    input [1:0] S,
    output [WIDTH-1:0] Y
);

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_slice
            c1 c1_inst (
                .A0(I0[i]),
                .A1(I1[i]),
                .SA(S[0]),
                .B0(I2[i]),
                .B1(I3[i]),
                .SB(S[0]),
                .S0(S[1]),
                .S1(1'b0),
                .f(Y[i])
            );
        end
    endgenerate

endmodule