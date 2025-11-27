module OR(
    input A,
    input B,
    output C
);
    c1 c1_inst (
        .A0(B), 
        .A1(1'b0), 
        .SA(1'b0), 
        .B0(1'b1), 
        .B1(1'b0), 
        .SB(1'b0), 
        .S0(A), 
        .S1(1'b0), 
        .f(C)
    );
endmodule