module MuxReg #(
    parameter WIDTH = 8
)(
    input clk,
    input rst,
    input init,       // Control signal for Initialization (ps[1])
    input update,     // Control signal for Update (ps[6])
    input [WIDTH-1:0] val_init,   // A0, B0, etc.
    input [WIDTH-1:0] val_update, // D, outAdder, etc.
    output [WIDTH-1:0] Q
);
    wire [WIDTH-1:0] q_wire;
    assign Q = q_wire;

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_slice
            // Logic Mapping:
            // init=0, update=0 -> s1=0, s0=0 -> Select D00 (Hold Q)
            // init=0, update=1 -> s1=0, s0=1 -> Select D01 (Update Value)
            // init=1, update=0 -> s1=1, s0=0 -> Select D10 (Init Value)
            
            s2 bit_inst (
                .D00(q_wire[i]),      // Hold
                .D01(val_update[i]),  // Update
                .D10(val_init[i]),    // Init
                .D11(val_init[i]),    // (Unused case)
                
                // s1 = A1 | B1. We want s1 = init. Set A1=init, B1=0.
                .A1(init), .B1(1'b0),
                
                // s0 = A0 & B0. We want s0 = update. Set A0=update, B0=1.
                .A0(update), .B0(1'b1),
                
                .clr(rst),
                .clk(clk),
                .out(q_wire[i])
            );
        end
    endgenerate
endmodule