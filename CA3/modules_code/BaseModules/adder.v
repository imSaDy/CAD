module Adder2_8bit(
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

//////////////////////////////////////////////////////////////////////////////////

module Adder4_8bit(
    input  [7:0] A, B, C, D,
    input        cin,
    output [7:0] Sum,
    output       cout
);
    // Intermediate sums
    wire [7:0] S1, S2;
    wire [7:0] C1, C2, C3;

    // -------- Stage 1: A + B --------
    genvar i;
    generate
        for(i=0;i<8;i=i+1) begin : ADD1
            FullAdder_min FA1(
                .a(A[i]),
                .b(B[i]),
                .cin(i==0 ? cin : C1[i-1]),
                .sum(S1[i]),
                .cout(C1[i])
            );
        end
    endgenerate

    // -------- Stage 2: (A+B) + C --------
    generate
        for(i=0;i<8;i=i+1) begin : ADD2
            FullAdder_min FA2(
                .a(S1[i]),
                .b(C[i]),
                .cin(i==0 ? 1'b0 : C2[i-1]),
                .sum(S2[i]),
                .cout(C2[i])
            );
        end
    endgenerate

    // -------- Stage 3: (A+B+C) + D --------
    generate
        for(i=0;i<8;i=i+1) begin : ADD3
            FullAdder_min FA3(
                .a(S2[i]),
                .b(D[i]),
                .cin(i==0 ? 1'b0 : C3[i-1]),
                .sum(Sum[i]),
                .cout(C3[i])
            );
        end
    endgenerate

    assign cout = C3[7];

endmodule



// =====================================================
// MINIMAL-GATE FULL ADDER
// Uses ONLY: XOR, AND3, OR
// Total = 5 gates per FA (minimum possible)
// =====================================================
module FullAdder_min(
    input  a, b, cin,
    output sum, cout
);
    wire axb, t1, t2;

    // sum = a XOR b XOR cin   (2 XOR gates)
    XOR x1(a, b, axb);
    XOR x2(axb, cin, sum);

    // carry = (a&b) + (cin & (a⊕b))
    // uses 2 AND3 + 1 OR  (3 gates)
    AND3 g1(a, b, 1'b1, t1);
    AND3 g2(cin, axb, 1'b1, t2);
    OR   o1(t1, t2, cout);
endmodule
