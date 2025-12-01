module Extend(
    input [3:0] in,
    input [1:0] fsel,
    output [7:0] out
);
    MUX41 #(8) mux(
        .I0({4'b0000, in}),
        .I1({2'b00, in, 2'b00}), 
        .I2({2'b00, in, 2'b00}), 
        .I3({in, 4'b0000}),
        .S(fsel),
        .Y(out)
    );
endmodule