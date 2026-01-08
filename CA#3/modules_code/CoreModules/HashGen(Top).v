module HashGenerator#(
    parameter MESSAGE_WIDTH = 32,
    parameter [MESSAGE_WIDTH/4 - 1: 0] C0 = 8'hFE,
    parameter [MESSAGE_WIDTH/4 - 1: 0] D0 = 8'h76,
    parameter [MESSAGE_WIDTH/4 - 1: 0] B0 = 8'h89,
    parameter [MESSAGE_WIDTH/4 - 1: 0] A0 = 8'h01,
    parameter MEMORY_FILE = "constant.mem"
)(
    input clk, 
    input rst,
    input start,
    input [MESSAGE_WIDTH - 1: 0] message,
    output done,
    output [MESSAGE_WIDTH - 1: 0] digest
);

    wire selA, selB, selC, selD, selF;
    wire loadABCD, loadM, loadF;
    wire start_rnd, done_rnd;
    wire co, countEn;
    
    wire loadAcc;
    wire [1:0] selAdd1;
    wire [1:0] selAdd2;

    HashGenDataPath #(
        .COUNTER_WIDTH(6),
        .RND_WIDTH(2),
        .MESSAGE_WIDTH(MESSAGE_WIDTH),
        .WORD_WIDTH(MESSAGE_WIDTH / 4),
        .MEMORY_FILE(MEMORY_FILE)
    ) hash_gen_dataPath(
        .clk(clk),
        .rst(rst),
        .A0(A0),
        .B0(B0),
        .C0(C0),
        .D0(D0),
        .countEn(countEn),
        .start_rnd(start_rnd),
        .loadM(loadM),
        .message(message),
        .selA(selA),
        .selB(selB),
        .selC(selC),
        .selD(selD),
        .selF(selF),
        .loadABCD(loadABCD),
        .loadF(loadF),
        .selAdd1(selAdd1),
        .selAdd2(selAdd2),
        .loadAcc(loadAcc),
        .co(co),
        .done_rnd(done_rnd),
        .digest(digest)
    );

    HashGenController hash_gen_controller(
        .clk(clk),
        .rst(rst),
        .start(start),
        .done_rnd(done_rnd),
        .co(co),
        .start_rnd(start_rnd),
        .countEn(countEn),
        .loadABCD(loadABCD),
        .loadM(loadM),
        .loadF(loadF),
        .selF(selF),
        .selA(selA),
        .selB(selB),
        .selC(selC),
        .selD(selD),
        .loadAcc(loadAcc),
        .selAdd1(selAdd1),
        .selAdd2(selAdd2),
        .done(done)
    );
    
endmodule