`define Idle 2'b00
`define Pulse 2'b01
`define CountAndShift 2'b10

module RandGenController(clk, rst, start_rnd, co, done_rnd, enBuffer, loadC, loadR, countEn, shiftEn);

    input clk, rst, start_rnd, co;
    output reg done_rnd, enBuffer, loadC, loadR, countEn, shiftEn;

    reg [1:0] ps, ns;
    always @(posedge clk or posedge rst) begin
        if(rst) 
            ps <= `Idle;
        else
            ps <= ns;
    end

    always @(ps, start_rnd, co) begin
        case(ps)
            `Idle: ns = (start_rnd) ? `Pulse: `Idle;
            `Pulse: ns = (start_rnd) ? `Pulse: `CountAndShift;
            `CountAndShift: ns = (co) ? `Idle: `CountAndShift;
            default ns = `Idle;
        endcase
    end

    always @(ps, start_rnd, co) begin
        {done_rnd, enBuffer, loadC, loadR, shiftEn, countEn} = 6'b0;
        case(ps)
            `Idle: begin done_rnd = 1'b1; enBuffer = 1'b1; end
            `Pulse: begin loadC = 1'b1; loadR = 1'b1; end 
            `CountAndShift: begin shiftEn = 1'b1; countEn = 1'b1; end 
        endcase
    end

endmodule