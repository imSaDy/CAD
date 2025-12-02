module Adder2 #(parameter N = 8)(
    input  [N-1:0] A, B,
    input          cin,
    output [N-1:0] Sum,
    output         cout 
);
    wire [N:0] C;
    assign C[0] = cin;
    assign cout = 1'b0;

    m_HA u_ha_0 (
        .A(A[0]), .B(B[0]), .S(Sum[0]), .C(C[1])
    );

    genvar i;
    generate
        for(i=1; i<N-1; i=i+1) begin : RIPPLE
            m_FA u_fa(
                .A(A[i]), 
                .B(B[i]), 
                .Cin(C[i]), 
                .S(Sum[i]), 
                .C(C[i+1])
            );
        end
    endgenerate

    wire t_last;
    m_XOR u_last_1 (.A(A[N-1]), .B(B[N-1]), .Y(t_last));
    m_XOR u_last_2 (.A(t_last), .B(C[N-1]), .Y(Sum[N-1]));

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

    generate
        for(i=0;i<N;i=i+1) begin : ADD1
            FullAdder FA1(
                .a(A[i]), .b(B[i]),
                .cin(i==0 ? cin : C1[i-1]),
                .sum(S1[i]), .cout(C1[i])
            );
        end
    endgenerate

    generate
        for(i=0;i<N;i=i+1) begin : ADD2
            FullAdder FA2(
                .a(S1[i]), .b(C[i]),
                .cin(i==0 ? 1'b0 : C2[i-1]),
                .sum(S2[i]), .cout(C2[i])
            );
        end
    endgenerate

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