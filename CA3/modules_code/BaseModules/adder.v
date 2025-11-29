module Adder2 #(parameter N = 8)(
    input  [N-1:0] A, B,
    input          cin,
    output [N-1:0] Sum,
    output         cout
);
    wire [N-1:0] P, G;
    wire [N:0]   C;
    assign C[0] = cin;

    genvar i;

    // Propagate / Generate
    generate
        for (i = 0; i < N; i=i+1) begin : PG
            XOR  u_xor(A[i], B[i], P[i]);
            AND3 u_and(A[i], B[i], 1'b1, G[i]);
        end
    endgenerate

    // Prefix chain
    generate
        for (i = 0; i < N; i=i+1) begin : PREFIX
            GrayCell gc(G[i], P[i], C[i], C[i+1]);
        end
    endgenerate

    // Sum bits
    generate
        for (i = 0; i < N; i=i+1) begin : SUMS
            XOR u_sum(P[i], C[i], Sum[i]);
        end
    endgenerate

    assign cout = C[N];
endmodule

module Adder4 #(parameter N = 8)(
    input  [N-1:0] A, B, C, D,
    input          cin,
    output [N-1:0] Sum,
    output         cout
);
    wire [N-1:0] S1, S2;
    wire [N-1:0] C1, C2, C3;

    genvar i;

    // Stage 1: A + B
    generate
        for(i=0;i<N;i=i+1) begin : ADD1
            FullAdder FA1(
                .a(A[i]), .b(B[i]),
                .cin(i==0 ? cin : C1[i-1]),
                .sum(S1[i]), .cout(C1[i])
            );
        end
    endgenerate

    // Stage 2: (A+B) + C
    generate
        for(i=0;i<N;i=i+1) begin : ADD2
            FullAdder FA2(
                .a(S1[i]), .b(C[i]),
                .cin(i==0 ? 1'b0 : C2[i-1]),
                .sum(S2[i]), .cout(C2[i])
            );
        end
    endgenerate

    // Stage 3: (A+B+C) + D
    generate
        for(i=0;i<N;i=i+1) begin : ADD3
            FullAdder FA3(
                .a(S2[i]), .b(D[i]),
                .cin(i==0 ? 1'b0 : C3[i-1]),
                .sum(Sum[i]), .cout(C3[i])
            );
        end
    endgenerate

    assign cout = C3[N-1];
endmodule

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

module FullAdder(
    input  a, b, cin,
    output sum, cout
);
    wire axb, t1, t2;

    XOR x1(a, b, axb);
    XOR x2(axb, cin, sum);

    AND3 g1(a, b, 1'b1, t1);
    AND3 g2(cin, axb, 1'b1, t2);
    OR   o1(t1, t2, cout);
endmodule