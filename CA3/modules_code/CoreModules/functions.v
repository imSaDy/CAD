module Function1 #(
    parameter WIDTH = 8
)(
    input  [WIDTH-1:0] X,
    input  [WIDTH-1:0] Y,
    input  [WIDTH-1:0] Z,
    input  [WIDTH-1:0] P,
    output [WIDTH-1:0] Res
);

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_slice
            MUX21 #(1) u_mux (
                .I0(P[i]),
                .I1(Y[i]),
                .S(X[i]),
                .Y(Res[i])
            );
        end
    endgenerate

endmodule

module Function2 #(
    parameter WIDTH = 8
)(
    input  [WIDTH-1:0] X,
    input  [WIDTH-1:0] Y,
    input  [WIDTH-1:0] Z,
    output [WIDTH-1:0] Res
);

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : F2
            wire t;
            XOR u0 (X[i], Y[i], t);
            XOR u1 (t, Z[i], Res[i]);
        end
    endgenerate
endmodule

module Function3 #(
    parameter WIDTH = 8
)(
    input  [WIDTH-1:0] X,
    input  [WIDTH-1:0] Y,
    input  [WIDTH-1:0] Z,
    output [WIDTH-1:0] Res
);

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_slice
            wire term;
            c1 u_or_not (
                .A0(1'b1),
                .A1(1'b0),
                .SA(1'b0),
                .B0(Y[i]),
                .B1(1'b0),
                .SB(1'b0),
                .S0(Z[i]),
                .S1(1'b0),
                .f(term)
            );
            XOR u_xor_final (
                .A(X[i]), 
                .B(term), 
                .C(Res[i])
            );
        end
    endgenerate

endmodule