module MuxReg #(
    parameter WIDTH = 8
)(
    input clk,
    input rst,
    input init,
    input update,
    input [WIDTH-1:0] val_init,
    input [WIDTH-1:0] val_update,
    output [WIDTH-1:0] Q
);
    wire [WIDTH-1:0] q_wire;
    assign Q = q_wire;

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_slice            
            s2 bit_inst (
                .D00(q_wire[i]),
                .D01(val_update[i]),
                .D10(val_init[i]),
                .D11(val_init[i]),
                
                .A1(init), .B1(1'b0),
                
                .A0(update), .B0(1'b1),
                
                .clr(rst),
                .clk(clk),
                .out(q_wire[i])
            );
        end
    endgenerate
endmodule