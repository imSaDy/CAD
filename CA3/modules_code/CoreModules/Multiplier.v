module mul2x2_opt(
    input A0, A1, B0, B1,
    output [3:0] P
);

    wire m_term; // Intermediate term (A0 & B1)

    // 1. Calculate P0 = A0 & B0
    c1 m_p0 (
        .A0(1'b0), .A1(B0), .SA(A0), 
        .B0(1'b0), .B1(1'b0), .SB(1'b0), 
        .S0(1'b0), .S1(1'b0), 
        .f(P[0])
    );

    // 2. Calculate Intermediate M = A0 & B1
    c1 m_mid (
        .A0(1'b0), .A1(B1), .SA(A0), 
        .B0(1'b0), .B1(1'b0), .SB(1'b0), 
        .S0(1'b0), .S1(1'b0), 
        .f(m_term)
    );

    // 3. Calculate P1 = (A1 & B0) XOR M
    c1 m_p1 (
        .A0(1'b0), .A1(B0), .SA(A1), 
        .B0(1'b1), .B1(~B0), .SB(A1), 
        .S0(m_term), .S1(1'b0), 
        .f(P[1])
    );

    // 4. Calculate P3 = P0 & (A1 & B1)
    c1 m_p3 (
        .A0(1'b0), .A1(1'b0), .SA(1'b0), 
        .B0(1'b0), .B1(B1), .SB(A1), 
        .S0(P[0]), .S1(1'b0), 
        .f(P[3])
    );

    // 5. Calculate P2 = ~P0 & (A1 & B1)
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
    // Split inputs into 2-bit chunks
    wire [3:0] m0, m1, m2, m3;
    
    // M0 = A[1:0] * B[1:0] (Aligned at 0)
    mul2x2_opt u_m0 (.A0(A[0]), .A1(A[1]), .B0(B[0]), .B1(B[1]), .P(m0));

    // M1 = A[3:2] * B[1:0] (Aligned at 2)
    mul2x2_opt u_m1 (.A0(A[2]), .A1(A[3]), .B0(B[0]), .B1(B[1]), .P(m1));

    // M2 = A[1:0] * B[3:2] (Aligned at 2)
    mul2x2_opt u_m2 (.A0(A[0]), .A1(A[1]), .B0(B[2]), .B1(B[3]), .P(m2));

    // M3 = A[3:2] * B[3:2] (Aligned at 4)
    mul2x2_opt u_m3 (.A0(A[2]), .A1(A[3]), .B0(B[2]), .B1(B[3]), .P(m3));

    // --- Summation Logic ---
    // P = M0 + (M1 + M2)<<2 + M3<<4
    
    // Step 1: Add M1 + M2 (4 bits + 4 bits -> 5 bits)
    wire [4:0] mid_sum;
    wire c1_0, c1_1, c1_2, c1_3;
    
    // Adder for M1 + M2
    m_HA ha_mid_0 (.A(m1[0]), .B(m2[0]), .S(mid_sum[0]), .C(c1_0));
    m_FA fa_mid_1 (.A(m1[1]), .B(m2[1]), .Cin(c1_0), .S(mid_sum[1]), .C(c1_1));
    m_FA fa_mid_2 (.A(m1[2]), .B(m2[2]), .Cin(c1_1), .S(mid_sum[2]), .C(c1_2));
    m_FA fa_mid_3 (.A(m1[3]), .B(m2[3]), .Cin(c1_2), .S(mid_sum[3]), .C(mid_sum[4]));

    // Step 2: Combine Results
    // P[1:0] comes directly from M0
    assign P[0] = m0[0];
    assign P[1] = m0[1];

    // P[3:2] = M0[3:2] + mid_sum[1:0]
    wire c2_0, c2_1;
    m_HA ha_p2 (.A(m0[2]), .B(mid_sum[0]), .S(P[2]), .C(c2_0));
    m_FA fa_p3 (.A(m0[3]), .B(mid_sum[1]), .Cin(c2_0), .S(P[3]), .C(c2_1));

    // P[5:4] = mid_sum[3:2] + M3[1:0] + carry from previous
    wire c3_0, c3_1;
    m_FA fa_p4 (.A(mid_sum[2]), .B(m3[0]), .Cin(c2_1), .S(P[4]), .C(c3_0));
    m_FA fa_p5 (.A(mid_sum[3]), .B(m3[1]), .Cin(c3_0), .S(P[5]), .C(c3_1));

    // P[7:6] = mid_sum[4] + M3[3:2] + carry from previous
    // Note: We don't need final carry out for P[7] as result is 8-bit max
    wire c4_0;
    m_FA fa_p6 (.A(mid_sum[4]), .B(m3[2]), .Cin(c3_1), .S(P[6]), .C(c4_0));
    
    // Final bit: Just XOR sum, no carry needed
    // logic: A xor B xor Cin
    wire t_final;
    m_XOR x_p7_1 (.A(1'b0), .B(m3[3]), .Y(t_final)); // mid_sum has no bit 5, input 0
    m_XOR x_p7_2 (.A(t_final), .B(c4_0), .Y(P[7]));

endmodule

// Helper Primitive Wrappers for Multiplier
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