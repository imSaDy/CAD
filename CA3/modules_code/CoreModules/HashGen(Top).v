module HashGenerator#(
    parameter [7:0] A0 = 8'h01,
    parameter [7:0] B0 = 8'h89,
    parameter [7:0] C0 = 8'hfe,
    parameter [7:0] D0 = 8'h76,
    parameter MEMORY_FILE = "constant.mem"
)(
    input clk, 
    input rst,
    input start,
    input [31:0] message,
    output done,
    output [31:0] digest
);
    wire selA, selB, selC, selD, selF;
    wire loadABCD, loadM, loadF;
    wire start_rnd, done_rnd;
    wire co, countEn;
    HashGenDataPath #(
        .COUNTER_WIDTH(6),
        .RND_WIDTH(2),
        .MESSAGE_WIDTH(32),
        .WORD_WIDTH(8),
        .MEMORY_FILE(MEMORY_FILE)
    ) hash_gen_dataPath(
        .A0(A0),
        .B0(B0),
        .C0(C0),
        .D0(D0),
        .clk(clk),
        .rst(rst),
        .countEn(countEn),
        .start_rnd(start_rnd),
        .loadM(loadM),
        .message(message),
        .selA(selA),
        .selB(selB),
        .selC(selC),
        .selD(selD),
        .selF(selF),
        .loadA(loadABCD),
        .loadB(loadABCD),
        .loadC(loadABCD), 
        .loadD(loadABCD),
        .loadF(loadF),
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
        .done(done)
    );
endmodule