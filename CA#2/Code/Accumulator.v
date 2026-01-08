module Accumulator #(
    parameter WIDTH = 34
)(
    input clk,
    input rst,
    input en,
    input [WIDTH-1:0] addData,
    output reg [WIDTH-1:0] register
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            register <= {WIDTH{1'b0}};
        else if(en)
            register <= ((register << 1) + addData);
    end
    
endmodule