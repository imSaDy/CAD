module rndGenerator(
    input clk,
    input rst,
    input shiftRegPI,
    input start_rnd,
    output rnd,
    output done_rnd
);

    wire cout;

    RandGenController controller(
        .clk(clk),
        .rst(rst),
        .start_rnd(start_rnd),
        .co(cout)
    );

    RandGenDataPath #(
        .INPUT_WIDTH(6),
        .RND_WIDTH(2)
    ) datapath(
        .clk(clk), 
        .rst(rst),
        .shiftRegLoad(),
        .shiftEn(), 
        .shiftRegPI(),
        .counterLoad(),
        .countEn(),
        .rnd(),
        .co() 
    );

endmodule