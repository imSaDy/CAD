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
    output co
);

    wire serin; 
    wire [INPUT_WIDTH-1:0] shift_q; 
    wire [2:0] count;

    ShiftRegister #(
        .WIDTH(INPUT_WIDTH)
    ) shiftreg (
        .clk(clk),
        .rst(rst),
        .load(shiftRegLoad),
        .shiftEn(shiftEn),
        .ser_in(serin),
        .PI(shiftRegPI),
        .twoMSB(rnd),
        .Q(shift_q)
    );

    wire xor_temp;

    XOR u_xor1 (
        .A(shift_q[5]),
        .B(shift_q[3]),
        .C(xor_temp)
    );

    XOR u_xor2 (
        .A(xor_temp),
        .B(shift_q[1]),
        .C(serin)
    );

    Counter #(
        .WIDTH(3)
    ) counter (
        .clk(clk),
        .rst(rst),
        .load(counterLoad),
        .en(countEn),
        .PI(3'd2),
        .count(count)
    );
    
    AND3 u_co_logic (
        .A(count[0]),
        .B(count[1]),
        .C(count[2]),
        .Y(co)
    );

endmodule