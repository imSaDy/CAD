module Mux2 #(
    parameter WIDTH = 8
)(
    input [WIDTH-1:0] in0,    
    input [WIDTH-1:0] in1,
    input sel,
    output [WIDTH-1:0] out
);
    assign out = (sel == 2'b10 ? in0 :
                 (sel == 2'b11 ? in1 : {WIDTH{1'bx}}));
endmodule