module Register #(
    parameter WIDTH
) (
    input clk,
    input rst,
    input load,
    input [WIDTH-1:0] data,
    output [WIDTH-1:0] register
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            register <= {WIDTH{1'b0}};
        else if (load)
            register <= data;
    end
    
endmodule