module RandGenDataPath #(
    parameter INPUT_WIDTH = 6,
    parameter RND_WIDTH = 2
)(
    input clk, 
    input rst,
    input shiftRegLoad,
    input shiftEn, 
    input [INPUT_WIDTH-1:0] shiftRegPI,
    input counterLoad,
    input countEn,
    output [RND_WIDTH-1:0] rnd,
    output co; 
);
    wire serin; 
    wire [RND_WIDTH-1:0] rnd; 
    wire [2:0] count;

    ShiftRegister #(INPUT_WIDTH) shiftreg(
        .clk(clk),
        .rst(rst),
        .load(shiftRegLoad),
        .shiftEn(shiftEn),
        .PI(shiftRegPI),
        .twoMSB(rnd)
    );
    Counter #(3) counter(
        .clk(clk),
        .rst(rst),
        .load(counterLoad),
        .en(countEn),
        .PI(3'd2),
        .count(count)
    );
    
    assign co = &{count};
endmodule