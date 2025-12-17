module rndGenerator(
    input clk,
    input rst,
    input [5:0] shiftRegPI,
    input start_rnd,
    output [1:0] rnd,
    output done_rnd
);

    wire cout, loadC, loadR, countEn, shiftEn, enBuffer;

    RandGenController controller(
        .clk(clk),
        .rst(rst),
        .start_rnd(start_rnd),
        .co(cout),
        .done_rnd(done_rnd),
        .loadC(loadC),
        .loadR(loadR),
        .countEn(countEn),
        .shiftEn(shiftEn)
    );

    RandGenDataPath #(
        .INPUT_WIDTH(6),
        .RND_WIDTH(2)
    ) datapath(
        .clk(clk), 
        .rst(rst),
        .shiftRegLoad(loadR),
        .shiftEn(shiftEn), 
        .shiftRegPI(shiftRegPI),
        .counterLoad(loadC),
        .countEn(countEn),
        .rnd(rnd),
        .co(cout)
    );

endmodule