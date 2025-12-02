module mul2x2_opt(
    input A0, A1, B0, B1,
    output [3:0] P
);

    wire m_term;
    wire notB0;

    NOT not_b0(
        .A(B0),
        .Y(notB0)
    );

    c1 m_p0 (
        .A0(1'b0), .A1(B0), .SA(A0), 
        .B0(1'b0), .B1(1'b0), .SB(1'b0), 
        .S0(1'b0), .S1(1'b0), 
        .f(P[0])
    );

    c1 m_mid (
        .A0(1'b0), .A1(B1), .SA(A0), 
        .B0(1'b0), .B1(1'b0), .SB(1'b0), 
        .S0(1'b0), .S1(1'b0), 
        .f(m_term)
    );

    c1 m_p1 (
        .A0(1'b0), .A1(B0), .SA(A1), 
        .B0(1'b1), .B1(notB0), .SB(A1), 
        .S0(m_term), .S1(1'b0), 
        .f(P[1])
    );

    c1 m_p3 (
        .A0(1'b0), .A1(1'b0), .SA(1'b0), 
        .B0(1'b0), .B1(B1), .SB(A1), 
        .S0(P[0]), .S1(1'b0), 
        .f(P[3])
    );

    c1 m_p2 (
        .A0(1'b0), .A1(B1), .SA(A1), 
        .B0(1'b0), .B1(1'b0), .SB(1'b0), 
        .S0(P[0]), .S1(1'b0), 
        .f(P[2])
    );

endmodule


module Multiplier4x4 (
    input [3:0] A,
    input [3:0] B,
    output [7:0] P
);
    wire [3:0] m0, m1, m2, m3;
    
    mul2x2_opt u_m0 (.A0(A[0]), .A1(A[1]), .B0(B[0]), .B1(B[1]), .P(m0));

    mul2x2_opt u_m1 (.A0(A[2]), .A1(A[3]), .B0(B[0]), .B1(B[1]), .P(m1));

    mul2x2_opt u_m2 (.A0(A[0]), .A1(A[1]), .B0(B[2]), .B1(B[3]), .P(m2));

    mul2x2_opt u_m3 (.A0(A[2]), .A1(A[3]), .B0(B[2]), .B1(B[3]), .P(m3));

    wire [4:0] mid_sum;
    wire c1_0, c1_1, c1_2, c1_3;
    
    HA ha_mid_0 (.A(m1[0]), .B(m2[0]), .S(mid_sum[0]), .C(c1_0));
    FA fa_mid_1 (.A(m1[1]), .B(m2[1]), .Cin(c1_0), .S(mid_sum[1]), .C(c1_1));
    FA fa_mid_2 (.A(m1[2]), .B(m2[2]), .Cin(c1_1), .S(mid_sum[2]), .C(c1_2));
    FA fa_mid_3 (.A(m1[3]), .B(m2[3]), .Cin(c1_2), .S(mid_sum[3]), .C(mid_sum[4]));

    assign P[0] = m0[0];
    assign P[1] = m0[1];

    wire c2_0, c2_1;
    HA ha_p2 (.A(m0[2]), .B(mid_sum[0]), .S(P[2]), .C(c2_0));
    FA fa_p3 (.A(m0[3]), .B(mid_sum[1]), .Cin(c2_0), .S(P[3]), .C(c2_1));

    wire c3_0, c3_1;
    FA fa_p4 (.A(mid_sum[2]), .B(m3[0]), .Cin(c2_1), .S(P[4]), .C(c3_0));
    FA fa_p5 (.A(mid_sum[3]), .B(m3[1]), .Cin(c3_0), .S(P[5]), .C(c3_1));

    wire c4_0;
    FA fa_p6 (.A(mid_sum[4]), .B(m3[2]), .Cin(c3_1), .S(P[6]), .C(c4_0));
    
    wire t_final;
    XOR x_p7_1 (.A(1'b0), .B(m3[3]), .C(t_final));
    XOR x_p7_2 (.A(t_final), .B(c4_0), .C(P[7]));

endmodule

