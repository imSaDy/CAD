module ShiftRegister (
    input clk, 
    input rst,
    input load,
    input shiftEn,
    input ser_in,
    input [5:0] PI,
    output [1:0] twoMSB
);

    wire [5:0] Q;

    // Logic Mapping for s2 module:
    // s2 selects based on {s1, s0} where s1 = A1|B1 and s0 = A0&B0.
    // We want:
    // Load=1 -> Select PI (Indices 2 or 3). Set A1=load, B1=0 -> s1=load.
    // Load=0, Shift=1 -> Select Shift Source (Index 1). Set A0=shiftEn, B0=1 -> s0=shiftEn.
    // Load=0, Shift=0 -> Select Hold (Index 0).
    
    // Instance 0 (LSB) - Shifts in ser_in
    s2 bit0 (
        .D00(Q[0]),     // Hold
        .D01(ser_in),   // Shift in serial input
        .D10(PI[0]),    // Load
        .D11(PI[0]),    // Load (don't care about s0 if s1 is high)
        .A1(load), 
        .B1(1'b0), 
        .A0(shiftEn), 
        .B0(1'b1), 
        .clr(rst), 
        .clk(clk), 
        .out(Q[0])
    );

    s2 bit1 (
        .D00(Q[1]), 
        .D01(Q[0]), 
        .D10(PI[1]), 
        .D11(PI[1]), 
        .A1(load), 
        .B1(1'b0), 
        .A0(shiftEn), 
        .B0(1'b1), 
        .clr(rst), 
        .clk(clk), 
        .out(Q[1])
    );

    s2 bit2 (
        .D00(Q[2]), 
        .D01(Q[1]), 
        .D10(PI[2]), 
        .D11(PI[2]), 
        .A1(load), 
        .B1(1'b0), 
        .A0(shiftEn), 
        .B0(1'b1), 
        .clr(rst), 
        .clk(clk), 
        .out(Q[2])
    );

    s2 bit3 (
        .D00(Q[3]), 
        .D01(Q[2]), 
        .D10(PI[3]), 
        .D11(PI[3]), 
        .A1(load), 
        .B1(1'b0), 
        .A0(shiftEn), 
        .B0(1'b1), 
        .clr(rst), 
        .clk(clk), 
        .out(Q[3])
    );

    s2 bit4 (
        .D00(Q[4]), 
        .D01(Q[3]), 
        .D10(PI[4]), 
        .D11(PI[4]), 
        .A1(load), 
        .B1(1'b0), 
        .A0(shiftEn), 
        .B0(1'b1), 
        .clr(rst), 
        .clk(clk), 
        .out(Q[4])
    );

    s2 bit5 (
        .D00(Q[5]), 
        .D01(Q[4]), 
        .D10(PI[5]), 
        .D11(PI[5]), 
        .A1(load), 
        .B1(1'b0), 
        .A0(shiftEn), 
        .B0(1'b1), 
        .clr(rst), 
        .clk(clk), 
        .out(Q[5])
    );

    assign twoMSB = Q[5:4];

endmodule