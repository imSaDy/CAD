module HashGenerator (
    input clk, 
    input rst,
    input start,
    input [7:0] const_i,
    input [31:0] message,
    output done,
    output [31:0] digest,
    output [5:0] i
);
    wire selA, selB, selC, selD, selF;
    wire loadA, loadB, loadC, loadD, loadM, loadF;
    wire start_rnd, done_rnd;
    wire co, countEn;
    HashGenDataPath #(
        .COUNTER_WIDTH(6),
        .RND_WIDTH(2),
        .MESSAGE_WIDTH(32),
        .WORD_WIDTH(8)
    ) hashGenDataPath(
        .A0(8'h01),
        .B0(8'h89),
        .C0(8'hfe),
        .D0(8'h76),
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
        .digest(digest),
        .const_i(const_i),
        .i(i)
    );
    HashGenController hashGenController(
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