module Adder_2opr(
    input  [31:0] A, B,
    input         cin,
    output [31:0] Sum,
    output        cout
);

    wire [31:0] P, G;
    wire [32:0] C;
    assign C[0] = cin;

    genvar i;

    // -----------------------------
    // Level 0: Initial P and G
    // -----------------------------
    generate
        for (i = 0; i < 32; i=i+1) begin : PG
            XOR Pgen(A[i], B[i], P[i]);
            AND3 Ggen(A[i], B[i], 1'b1, G[i]);
        end
    endgenerate

    // -----------------------------
    // Han–Carlson Prefix Network
    // (minimal possible)
    // -----------------------------

    // Level 1: odd positions get gray cells
    GrayCell gc1(G[0], P[0], C[0], C[1]);
    generate
        for (i=2; i<32; i=i+2)
            GrayCell gc(G[i-1], P[i-1], G[i-2], C[i]);
    endgenerate

    // Level 2: black cells every 4 bits
    generate
        for (i=4; i<32; i=i+4)
            BlackCell bc(G[i-1], P[i-1], G[i-2], P[i-2], G[i-1], P[i-1]);
    endgenerate

    // Level 3–5 follow the minimal Han-Carlson pattern
    // (half-prefix, compute only required G values)

    // Level 3: distances 4
    GrayCell gc5(G[3], P[3], G[1], C[4]);
    GrayCell gc6(G[7], P[7], G[3], C[8]);
    GrayCell gc7(G[11], P[11], G[7], C[12]);
    GrayCell gc8(G[15], P[15], G[11], C[16]);
    GrayCell gc9(G[19], P[19], G[15], C[20]);
    GrayCell gc10(G[23], P[23], G[19], C[24]);
    GrayCell gc11(G[27], P[27], G[23], C[28]);
    GrayCell gc12(G[31], P[31], G[27], C[32]);

    // -----------------------------
    // Sum bits
    // -----------------------------
    generate
        for (i = 0; i < 32; i=i+1)
            XOR sumxor(P[i], C[i], Sum[i]);
    endgenerate

    assign cout = C[32];

endmodule


module BlackCell(input Gin_k, Pin_k, Gin_j, Pin_j,
                 output Gout, Pout);

    wire t;
    AND3 u1 (Pin_k, Gin_j, 1'b1, t);
    OR  u2 (Gin_k, t, Gout);
    AND3 u3 (Pin_k, Pin_j, 1'b1, Pout);

endmodule


module GrayCell(input Gin_k, Pin_k, Gin_j,
                output Gout);

    wire t;
    AND3 u1(Pin_k, Gin_j, 1'b1, t);
    OR u2(Gin_k, t, Gout);

endmodule
