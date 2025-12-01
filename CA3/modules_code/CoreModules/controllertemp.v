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
    output reg loadAcc,
    output reg [1:0] selAdd1,
    output reg [1:0] selAdd2,
    output reg done
);
    reg [2:0] ps, ns;
    parameter [2:0] IDLE = 0,
                    PULSE = 1,
                    INIT = 2, 
                    GENRAND = 3, 
                    UPDATE_ACC = 4,
                    CALCULATEF = 5, 
                    UPDATE = 6,
                    DONE = 7;
    
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
            GENRAND: ns = (done_rnd ? UPDATE_ACC : GENRAND);
            UPDATE_ACC: ns = CALCULATEF;
            CALCULATEF: ns = UPDATE;
            UPDATE: ns = (co ? DONE : INIT);
            DONE: ns = IDLE; 
        endcase
    end
    always @(ps, start, done_rnd, co) begin
        {countEn, loadA, loadB, loadC, loadD, loadM, loadF, selF, selA, selB, selC, selD, done, start_rnd, selAdd1, selAdd2, loadAcc} = 19'b0;
        case (ps)
            PULSE: begin loadA = 1'b1; loadB = 1'b1; loadC = 1'b1; loadD = 1'b1; end 
            INIT: begin loadM = 1'b1; start_rnd = 1'b1; loadAcc = 1'b1; selAdd1[1] = 1'b1; selAdd2[1] = 1'b1; end
            GENRAND: loadF = 1'b1; 
            UPDATE_ACC: begin loadAcc = 1'b1; selAdd2[0] = 1'b1; end
            CALCULATEF: begin loadF = 1'b1; selF = 1'b1; selAdd1[0] = 1'b1;end
            UPDATE: begin countEn = 1'b1; loadA = 1'b1; loadB = 1'b1; loadC = 1'b1; loadD = 1'b1; selA = 1'b1; selB = 1'b1; selC = 1'b1; selD = 1'b1; selAdd1 = 2'b11; selAdd2 = 2'b11;end
            DONE: done = 1'b1;
        endcase
    end
endmodule