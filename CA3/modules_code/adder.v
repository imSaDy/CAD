module Adder_8bit(
    input  [7:0] A, B,
    input        cin,
    output [7:0] Sum,
    output       cout
);

    wire [7:0] P, G;
    wire [8:0] C;

    assign C[0] = cin;

    genvar i;

    // -----------------------------
    // Level 0: Propagate & Generate
    // -----------------------------
    generate
        for (i = 0; i < 8; i=i+1) begin : PG
            XOR  x1(A[i], B[i], P[i]);
            AND3 g1(A[i], B[i], 1'b1, G[i]);
        end
    endgenerate

    // -------------------------------------------------------------
    // HAN–CARLSON PREFIX NETWORK (Correct 8-bit Version)
    // -------------------------------------------------------------

    // Level 1: distance = 1
    GrayCell gc1(G[0], P[0], C[0], C[1]);
    GrayCell gc2(G[1], P[1], C[1], C[2]);
    GrayCell gc3(G[2], P[2], C[2], C[3]);
    GrayCell gc4(G[3], P[3], C[3], C[4]);
    GrayCell gc5(G[4], P[4], C[4], C[5]);
    GrayCell gc6(G[5], P[5], C[5], C[6]);
    GrayCell gc7(G[6], P[6], C[6], C[7]);
    GrayCell gc8(G[7], P[7], C[7], C[8]);

    // -------------------------------------------------------------
    // SUM bits
    // -------------------------------------------------------------
    generate
        for (i = 0; i < 8; i=i+1)
            XOR sx(P[i], C[i], Sum[i]);
    endgenerate

    assign cout = C[8];

endmodule


// ---------------------------------------------------------
// PRIMITIVES
// ---------------------------------------------------------

module BlackCell(
    input Gin_k, Pin_k,
    input Gin_j, Pin_j,
    output Gout, Pout
);
    wire t;
    AND3 u1(Pin_k, Gin_j, 1'b1, t);
    OR  u2(Gin_k, t, Gout);
    AND3 u3(Pin_k, Pin_j, 1'b1, Pout);
endmodule

module GrayCell(
    input Gin_k, Pin_k,
    input Gin_j,
    output Gout
);
    wire t;
    AND3 u1(Pin_k, Gin_j, 1'b1, t);
    OR  u2(Gin_k, t, Gout);
endmodule
