module Function1 #(
    parameter WIDTH = 32
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

            AND3 u0 (.A(X[i]), .B(Y[i]), .C(1'b1), .Y(XY));
            
            NOT u1 (.A(Z[i]), .Y(nZ));
            
            AND3 u2 (.A(nZ), .B(P[i]), .C(1'b1), .Y(nZP));
            
            OR  u3 (.A(XY), .B(nZP), .C(Res[i]));
        end
    endgenerate
endmodule

module Function2 #(
    parameter WIDTH = 32
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
            XOR u0 (.A(X[i]), .B(Y[i]), .C(t));
            XOR u1 (.A(t),    .B(Z[i]), .C(Res[i]));
        end
    endgenerate
endmodule

module Function3 #(
    parameter WIDTH = 32
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

            NOT u0 (.A(Z[i]), .Y(nZ));
            
            OR  u1 (.A(Y[i]), .B(nZ), .C(Y_or_nZ));
            
            XOR u2 (.A(X[i]), .B(Y_or_nZ), .C(Res[i]));
        end
    endgenerate
endmodule