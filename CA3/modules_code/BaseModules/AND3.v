module AND3(
    input A,
    input B,
    input C,
    output Y
);
    c1 c1_inst (
        .A0(1'b0), 
        .A1(1'b0), 
        .SA(1'b0), 
        .B0(1'b0), 
        .B1(C), 
        .SB(B), 
        .S0(A), 
        .S1(1'b0), 
        .f(Y)
    );
endmodule