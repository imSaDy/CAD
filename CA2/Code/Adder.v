module Adder_twoOpr #(
    parameter WIDTH = 34
)(
    input cin,
    input [WIDTH - 1:0] A, B,
    output cout,
    output [WIDTH - 1:0] S
);

    assign {cout,S} = A + B + cin;

endmodule

module Adder_fourOpr #(
    parameter WIDTH = 34
)(
    input cin,
    input [WIDTH - 1:0] A, B, C, D, 
    output [1:0] cout,
    output [WIDTH - 1:0] S
);

    assign {cout, S} = A + B + C + D + cin;

endmodule