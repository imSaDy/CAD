module HashGenController (
    input clk,
    input rst,
    input start,
    input done_rnd,
    input co,
    output reg start_rnd,
    output reg countEn,
    output reg loadA,
    output reg loadB,
    output reg loadC,
    output reg loadD,
    output reg loadM,
    output reg loadF,
    output reg selF,
    output reg selA,
    output reg selB,
    output reg selC,
    output reg selD,
    output reg done
);
    reg [2:0] ps, ns;
    parameter [3:0] IDLE = 0,
                    PULSE = 1,
                    INIT = 2, 
                    GENRAND = 3, 
                    CALCULATEF = 4, 
                    UPDATE = 5;
    
    always @(posedge clk, posedge rst) begin
        if (rst == 1'b1)
            ps <= IDLE;
        else 
            ps <= ns; 
    end
    always @(ps, start, done_rnd, co) begin
        ns = IDLE; 
        case (ps) 
            IDLE: ns = (start ? PULSE : IDLE);
            PULSE: ns = (start ? PULSE : INIT);
            INIT: ns = GENRAND;
            GENRAND: ns = (done_rnd ? CALCULATEF : GENRAND);
            CALCULATEF: ns = UPDATE;
            UPDATE: ns = (co ? IDLE : INIT);
        endcase
    end
    always @(ps, start) begin
        {countEn, loadA, loadB, loadC, loadD, loadM, loadF, selF, selA, selB, selC, selD, done} = 13'b0;
        case (ps) 
            IDLE: done = 1'b1;
            INIT: begin loadA = 1'b1; loadB = 1'b1; loadC = 1'b1; loadD = 1'b1; loadM = 1'b1; start_rnd = 1'b1; end
            GENRAND: loadF = 1'b1; 
            CALCULATEF: begin loadF = 1'b1; selF = 1'b1; end
            UPDATE: begin countEn = 1'b1; loadA = 1'b1; loadB = 1'b1; loadC = 1'b1; loadD = 1'b1; selA = 1'b1; selB = 1'b1; selC = 1'b1; selD = 1'b1; end
        endcase
    end
endmodule