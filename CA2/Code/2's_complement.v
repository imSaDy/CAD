
module TwosComplement #(parameter WIDTH = 16) (
    input  wire [WIDTH-1:0] in,
    output wire [WIDTH-1:0] out
);

    assign out = (~in) + 1'b1;

endmodule
