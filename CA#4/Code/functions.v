module Function1 #(
    parameter WIDTH = 32
)(
    input [WIDTH-1:0] X,
    input [WIDTH-1:0] Y,
    input [WIDTH-1:0] Z,
    input [WIDTH-1:0] P,
    output [WIDTH-1:0] Res
);

    assign Res = (X & Y) | ((~Z) & P);

endmodule

module Function2 #(
    parameter WIDTH = 32
)(
    input [WIDTH-1:0] X,
    input [WIDTH-1:0] Y,
    input [WIDTH-1:0] Z,
    output [WIDTH-1:0] Res
);

    assign Res = X ^ Y ^ Z;

endmodule

module Function3 #(
    parameter WIDTH = 32
)(
    input [WIDTH-1:0] X,
    input [WIDTH-1:0] Y,
    input [WIDTH-1:0] Z,
    output [WIDTH-1:0] Res
);

    assign Res = X ^ (Y | (~Z));

endmodule