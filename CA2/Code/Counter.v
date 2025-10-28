module Counter #(
    parameter WIDTH = 3
)(
    input clk,
    input rst, 
    input load,
    input en,
    input [WIDTH-1:0] PI,
    output reg [WIDTH-1:0] count
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= {WIDTH{1'b0}};
        else if (load)
            count <= PI;
        else if (en)
            count <= count + 1'b1;
    end
endmodule