module Controller (
    input clk,
    input rst,
    input start,
    input coutARead,
    input coutBRead,
    input coutPE,
    input coutWrite,
    output reg rstOut,
    output reg countEnAddr,
    output reg loadAReg,
    output reg loadCounterWriteAddr,
    output reg countEnARead,
    output reg loadBReg,
    output reg i_is_lsb,
    output reg i_is_msb,
    output reg countEnBRead, 
    output reg countEnPE, 
    output reg i_valid, 
    output reg shiftEnA, 
    output reg write, 
    output reg countEnWrite, 
    output reg countEnWriteAddr, 
    output reg done
);
    reg [2:0] ps, ns;
    parameter [2:0] IDLE = 0,
                    PULSE = 1,
                    READ_A = 2, 
                    READ_B = 3, 
                    SEND_MSB = 4,
                    MULTIPLY = 5, 
                    WRITE = 6,
                    DONE = 7; 
    
    always @(posedge clk, posedge rst) begin
        if (rst == 1'b1)
            ps <= IDLE;
        else 
            ps <= ns; 
    end
    always @(*) begin
        ns = IDLE; 
        case (ps) 
            IDLE: ns = (start ? PULSE : IDLE);
            PULSE: ns = (start ? PULSE : READ_A);
            READ_A: ns = (coutARead ? READ_B : READ_A);
            READ_B: ns = (coutBRead ? SEND_MSB : READ_B);
            SEND_MSB: ns = MULTIPLY;
            MULTIPLY: ns = (coutPE ? WRITE : MULTIPLY);
            WRITE: ns = (coutWrite ? DONE : READ_B);
            DONE: ns = IDLE; 
            default: ns = IDLE;
        endcase
    end
    always @(*) begin
        {rstOut, countEnAddr, loadAReg, loadCounterWriteAddr, countEnARead, loadBReg, i_is_lsb, i_is_msb, countEnBRead, countEnPE, i_valid, shiftEnA, write, countEnWrite, countEnWriteAddr, selAddr, done} = 17'b0;
        case (ps)
            PULSE: begin rstOut = 1'b1; end 
            READ_A: begin countEnAddr = 1'b1; loadAReg = 1'b1; loadCounterWriteAddr = 1'b1; countEnARead = 1'b1; end
            READ_B: begin countEnAddr = 1'b1; loadBReg = 1'b1; i_is_lsb = 1'b1; countEnBRead = 1'b1; end
            SEND_MSB: begin i_is_msb = 1'b1; countEnPE = 1'b1; i_valid = 1'b1; shiftEnA = 1'b1; end
            MULTIPLY: begin countEnPE = 1'b1; i_valid = 1'b1; shiftEnA = 1'b1; end
            WRITE: begin write = 1'b1; countEnWrite = 1'b1; countEnWriteAddr = 1'b1; selAddr = 1'b1; end
            DONE: done = 1'b1; 
        endcase
    end
endmodule