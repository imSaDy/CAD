module MUX21 #(
    parameter WIDTH = 1
)(
    input [WIDTH-1:0] I0,
    input [WIDTH-1:0] I1,
    input S,
    output [WIDTH-1:0] Y
);

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_slice
            c1 c1_inst (
                .A0(I0[i]),
                .A1(1'b0),
                .SA(1'b0),
                .B0(I1[i]),
                .B1(1'b0),
                .SB(1'b0),
                .S0(S),
                .S1(1'b0),
                .f(Y[i])
            );
        end
    endgenerate

endmodule