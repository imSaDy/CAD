module Adder_twoOpr #(
    parameter WIDTH = 34
)(
    input cin,
    input [WIDTH - 1:0] A, B,
    output cout,
    output [WIDTH - 1:0] S
);

    assign {cout,S} = $unsigned(A) + $unsigned(B) + $unsigned(cin);

endmodule

module Adder_fourOpr #(
    parameter WIDTH = 34
)(
    input cin,
    input [WIDTH - 1:0] A, B, C, D, 
    output cout,
    output [WIDTH - 1:0] S
);

    assign {cout,S} = $unsigned(A) + $unsigned(B) + $unsigned(C) + $unsigned(D) + $unsigned(cin);

endmodule