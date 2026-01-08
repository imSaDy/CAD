module MAJ (input A, B, C, output Y);
    c1 u (.A0(1'b0), .A1(C), .SA(B), .B0(C), .B1(1'b1), .SB(B), .S0(A), .S1(1'b0), .f(Y));
endmodule