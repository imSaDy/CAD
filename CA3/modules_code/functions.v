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
        for (i = 0; i < WIDTH; i = i + 1) begin : F1
            wire XY, nZ, nZP;

            AND3 u0 (X[i], Y[i], 1'b1, XY);
            NOT u1 (Z[i], nZ);
            AND3 u2 (nZ, P[i], 1'b1, nZP);
            OR  u3 (XY, nZP, Res[i]);
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
        for (i = 0; i < WIDTH; i = i + 1) begin : F3
            wire nZ, Y_or_nZ;

            NOT u0 (Z[i], nZ);
            OR  u1 (Y[i], nZ, Y_or_nZ);
            XOR u2 (X[i], Y_or_nZ, Res[i]);
        end
    endgenerate
endmodule
