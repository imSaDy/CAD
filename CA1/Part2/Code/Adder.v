module Adder_twoOpr #(
    parameter WIDTH = 32
)(
    input cin,
    input [WIDTH - 1:0] A,B,
    output cout,
    output [WIDTH - 1:0] S
);

    assign {cout,S} = A + B + cin;

endmodule

module Adder_fourOpr #(
    parameter WIDTH = 32
)(
    input cin,
    input [WIDTH - 1:0] A, B, C, D, 
    output cout,
    output [WIDTH - 1:0] S
);
    wire [31:0] AplusB; 
    wire coutAB;
    Adder_twoOpr #(32) adder1
    (
        .cin(1'b0),
        .A(A),
        .B(B),
        .cout(coutAB),
        .S(AplusB)
    );
    wire [31:0] ABplusC; 
    wire coutABC;
    Adder_twoOpr #(32) adder2
    (
        .cin(1'b0),
        .A(AplusB),
        .B(C),
        .cout(coutABC),
        .S(ABplusC)
    );
    wire [31:0] ABCplusD; 
    wire coutABCD;
    Adder_twoOpr #(32) adder3
    (
        .cin(1'b0),
        .A(ABplusC),
        .B(D),
        .cout(coutABCD),
        .S(ABCplusD)
    );
    assign S = ABCplusD; 
    //assign {cout,S} = A + B + C + D + cin;

endmodule
