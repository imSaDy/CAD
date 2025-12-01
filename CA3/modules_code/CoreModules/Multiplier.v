module Multiplier4x4 (
    input [3:0] A,
    input [3:0] B,
    output [7:0] P
);

    wire [3:0] pp0, pp1, pp2, pp3;

    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : g_pp0
            m_AND u_and (.A(A[i]), .B(B[0]), .Y(pp0[i]));
        end
        for (i=0; i<4; i=i+1) begin : g_pp1
            m_AND u_and (.A(A[i]), .B(B[1]), .Y(pp1[i]));
        end
        for (i=0; i<4; i=i+1) begin : g_pp2
            m_AND u_and (.A(A[i]), .B(B[2]), .Y(pp2[i]));
        end
        for (i=0; i<4; i=i+1) begin : g_pp3
            m_AND u_and (.A(A[i]), .B(B[3]), .Y(pp3[i]));
        end
    endgenerate

    assign P[0] = pp0[0];

    wire [3:0] s1;
    wire [3:0] c1;
    
    // Stage 1
    m_HA ha1_0 (.A(pp0[1]), .B(pp1[0]), .S(P[1]), .C(c1[0]));
    m_FA fa1_1 (.A(pp0[2]), .B(pp1[1]), .Cin(c1[0]), .S(s1[1]), .C(c1[1]));
    m_FA fa1_2 (.A(pp0[3]), .B(pp1[2]), .Cin(c1[1]), .S(s1[2]), .C(c1[2]));
    
    // OPTIMIZATION: Replaced FA with HA because input A was 0
    m_HA fa1_3 (.A(pp1[3]), .B(c1[2]), .S(s1[3]), .C(c1[3])); 

    wire [3:0] s2;
    wire [3:0] c2;

    // Stage 2
    m_HA ha2_0 (.A(s1[1]), .B(pp2[0]), .S(P[2]), .C(c2[0]));
    m_FA fa2_1 (.A(s1[2]), .B(pp2[1]), .Cin(c2[0]), .S(s2[1]), .C(c2[1]));
    m_FA fa2_2 (.A(s1[3]), .B(pp2[2]), .Cin(c2[1]), .S(s2[2]), .C(c2[2]));
    m_FA fa2_3 (.A(c1[3]), .B(pp2[3]), .Cin(c2[2]), .S(s2[3]), .C(c2[3]));

    wire [3:0] c3;
    
    // Stage 3
    m_HA ha3_0 (.A(s2[1]), .B(pp3[0]), .S(P[3]), .C(c3[0]));
    m_FA fa3_1 (.A(s2[2]), .B(pp3[1]), .Cin(c3[0]), .S(P[4]), .C(c3[1]));
    m_FA fa3_2 (.A(s2[3]), .B(pp3[2]), .Cin(c3[1]), .S(P[5]), .C(c3[2]));
    m_FA fa3_3 (.A(c2[3]), .B(pp3[3]), .Cin(c3[2]), .S(P[6]), .C(P[7]));

endmodule

module m_AND (input A, B, output Y);
    c1 u (.A0(1'b0), .A1(1'b0), .SA(1'b0), .B0(1'b0), .B1(1'b1), .SB(B), .S0(A), .S1(1'b0), .f(Y));
endmodule

module m_XOR (input A, B, output Y);
    c1 u (.A0(1'b0), .A1(1'b1), .SA(B), .B0(1'b1), .B1(1'b0), .SB(B), .S0(A), .S1(1'b0), .f(Y));
endmodule

module m_MAJ (input A, B, C, output Y);
    c1 u (.A0(1'b0), .A1(C), .SA(B), .B0(C), .B1(1'b1), .SB(B), .S0(A), .S1(1'b0), .f(Y));
endmodule

module m_HA (input A, B, output S, C);
    m_XOR u_sum (.A(A), .B(B), .Y(S));
    m_AND u_cy  (.A(A), .B(B), .Y(C));
endmodule

module m_FA (input A, B, Cin, output S, C);
    wire t;
    m_XOR u_x1 (.A(A), .B(B), .Y(t));
    m_XOR u_x2 (.A(t), .B(Cin), .Y(S));
    m_MAJ u_c  (.A(A), .B(B), .C(Cin), .Y(C));
endmodule