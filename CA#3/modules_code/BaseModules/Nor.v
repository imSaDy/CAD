module NOR4 (
    input A,
    input B,
    input C,
    input D,
    output Y
);

    wire abc_or;

    c1 u_or3 (
        .A0(C),
        .A1(1'b0),
        .SA(1'b0),
        .B0(1'b1),
        .B1(1'b1),
        .SB(1'b0),
        .S0(A),
        .S1(B),
        .f(abc_or)
    );

    c1 u_nor2 (
        .A0(1'b1),
        .A1(1'b0),
        .SA(1'b0),
        .B0(1'b0),
        .B1(1'b0),
        .SB(1'b0),
        .S0(abc_or),
        .S1(D),
        .f(Y)
    );

endmodule