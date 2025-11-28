module NOT(
    input A,
    output Y
);
    c1 c1_inst (
        .A0(1'b1), 
        .A1(1'b0), 
        .SA(1'b0), 
        .B0(1'b0), 
        .B1(1'b0), 
        .SB(1'b0), 
        .S0(A), 
        .S1(1'b0), 
        .f(Y)
    );
endmodule