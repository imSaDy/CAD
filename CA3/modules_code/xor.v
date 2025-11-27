module XOR(
    input A, B,
    output C
)

    c1 c1_1(
        .A0(1'b0),
        .A1(1'b1),
        .SA(B),
        .B0(1'b1), 
        .B1(1'b0),
        .SB(B),
        .S0(A),
        .S1(1'b0),
        .f(C)
    );

endmodule