`define Idle 2'b00
`define Pulse 2'b01
`define CountAndShift 2'b10
`define Done 2'b11

module RandGenController(clk, rst, start_rnd, co, done_rnd, loadC, loadR, countEn, shiftEn);

    input clk, rst, start_rnd, co;
    output reg done_rnd, loadC, loadR, countEn, shiftEn;

    reg [1:0] ps, ns;
    always @(posedge clk or posedge rst) begin
        if(rst) 
            ps <= `Idle;
        else
            ps <= ns;
    end

    always @(ps, start_rnd, co) begin
        ns = `Idle;
        case(ps)
            `Idle: ns = (start_rnd) ? `Pulse: `Idle;
            `Pulse: ns = (start_rnd) ? `Pulse: `CountAndShift;
            `CountAndShift: ns = (co) ? `Done: `CountAndShift;
            `Done: ns = `Idle; 
            default ns = `Idle;
        endcase
    end

    always @(ps, start_rnd, co) begin
        {done_rnd, loadC, loadR, shiftEn, countEn} = 5'b0;
        case(ps)
            `Pulse: begin loadC = 1'b1; loadR = 1'b1; end 
            `CountAndShift: begin shiftEn = 1'b1; countEn = 1'b1; end 
            `Done: done_rnd = 1'b1;
        endcase
    end

endmodule