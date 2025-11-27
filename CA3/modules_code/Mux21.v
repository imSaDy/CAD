module MUX21 (
    input I0,
    input I1,
    input S,
    output Y
);

    c1 c1_inst (
        .A0(I0),
        .A1(1'b0),
        .SA(1'b0),
        .B0(I1),
        .B1(1'b0),
        .SB(1'b0),
        .S0(S),
        .S1(1'b0),
        .f(Y)
    );

endmodule