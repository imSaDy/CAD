module Counter #(
    parameter WIDTH = 4
)(
    input clk,
    input rst,
    input load,
    input en,
    input [WIDTH-1:0] PI,
    output [WIDTH-1:0] count
);

    wire [WIDTH-1:0] Q;
    wire [WIDTH-2:0] C_chain; 
    wire [WIDTH-1:0] next_state_logic; 

    assign count = Q;

    AND3 u_carry_0 (
        .A(Q[0]), 
        .B(en), 
        .C(1'b1), 
        .Y(C_chain[0])
    );

    XOR u_logic_0 (
        .A(Q[0]),
        .B(en),
        .C(next_state_logic[0])
    );

    s2 u_ff_0 (
        .D00(Q[0]),
        .D01(next_state_logic[0]),
        .D10(PI[0]),
        .D11(PI[0]),
        .A1(load), 
        .B1(1'b0), 
        .A0(en), 
        .B0(1'b1), 
        .clr(rst), 
        .clk(clk), 
        .out(Q[0])
    );

    genvar i;
    generate
        for (i = 1; i < WIDTH - 1; i = i + 1) begin : stage
            
            AND3 u_carry (
                .A(Q[i]), 
                .B(C_chain[i-1]), 
                .C(1'b1), 
                .Y(C_chain[i])
            );

            XOR u_logic (
                .A(Q[i]),
                .B(C_chain[i-1]),
                .C(next_state_logic[i])
            );
            
            s2 u_ff (
                .D00(Q[i]),               
                .D01(next_state_logic[i]),
                .D10(PI[i]),              
                .D11(PI[i]),              
                .A1(load), 
                .B1(1'b0), 
                .A0(en), 
                .B0(1'b1), 
                .clr(rst), 
                .clk(clk), 
                .out(Q[i])
            );
        end
    endgenerate

    XOR u_logic_last (
        .A(Q[WIDTH-1]),
        .B(C_chain[WIDTH-2]),
        .C(next_state_logic[WIDTH-1])
    );

    s2 u_ff_last (
        .D00(Q[WIDTH-1]),
        .D01(next_state_logic[WIDTH-1]),
        .D10(PI[WIDTH-1]),
        .D11(PI[WIDTH-1]),
        .A1(load), 
        .B1(1'b0), 
        .A0(en), 
        .B0(1'b1), 
        .clr(rst), 
        .clk(clk), 
        .out(Q[WIDTH-1])
    );

endmodule