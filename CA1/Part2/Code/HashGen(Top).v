module HashGenerator#(
    parameter [31:0] A0 = 32'h67452301,
    parameter [31:0] B0 = 32'hefcdab89,
    parameter [31:0] C0 = 32'h98badcfe,
    parameter [31:0] D0 = 32'h10325476
)(
    input clk, 
    input rst,
    input start,
    input [127:0] message,
    output done,
    output [127:0] digest
);
    wire selA, selB, selC, selD, selF;
    wire loadA, loadB, loadC, loadD, loadM, loadF;
    wire start_rnd, done_rnd;
    wire co, countEn;
    HashGenDataPath #(
        .COUNTER_WIDTH(6),
        .RND_WIDTH(2),
        .MESSAGE_WIDTH(128),
        .WORD_WIDTH(32)
    ) hashGenDataPath(
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
        .loadA(loadA),
        .loadB(loadB),
        .loadC(loadC), 
        .loadD(loadD),
        .loadF(loadF),
        .co(co),
        .done_rnd(done_rnd),
        .digest(digest)
    );
    HashGenController (
        .clk(clk),
        .rst(rst),
        .start(start),
        .done_rnd(done_rnd),
        .co(co),
        .start_rnd(start_rnd),
        .countEn(countEn),
        .loadA(loadA),
        .loadB(loadB),
        .loadC(loadC),
        .loadD(loadD),
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