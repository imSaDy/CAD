module MUX41 (
    input I0,
    input I1,
    input I2,
    input I3,
    input [1:0] S,
    output Y
);

    c1 c1_inst (
        .A0(I0),
        .A1(I1),
        .SA(S[0]),
        .B0(I2),
        .B1(I3),
        .SB(S[0]),
        .S0(S[1]),
        .S1(1'b0),
        .f(Y)
    );

endmodule