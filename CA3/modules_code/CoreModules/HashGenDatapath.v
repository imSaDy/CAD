module HashGenDataPath #(
    parameter COUNTER_WIDTH = 6,
    parameter RND_WIDTH = 2,
    parameter MESSAGE_WIDTH = 32,
    parameter WORD_WIDTH = 8,
    parameter MEMORY_FILE = "constant.mem"
)(
    input [WORD_WIDTH-1:0] A0,
    input [WORD_WIDTH-1:0] B0,
    input [WORD_WIDTH-1:0] C0,
    input [WORD_WIDTH-1:0] D0,
    input clk,
    input rst,
    input countEn,
    input start_rnd,
    input loadM,
    input [MESSAGE_WIDTH - 1:0] message,
    input selA, selB, selC, selD, selF,
    input loadABCD, 
    input loadF,
    input [1:0] selAdd1, 
    input [1:0] selAdd2,
    input loadAcc,
    output co,
    output done_rnd,
    output [MESSAGE_WIDTH-1:0] digest
);

    wire [COUNTER_WIDTH-1:0] i;
    wire [RND_WIDTH-1: 0] rnd;
    wire [WORD_WIDTH-1:0] M_rand, const_i;
    wire [WORD_WIDTH-1:0] A, B, C, D, F, acc;
    wire [WORD_WIDTH-1:0] outMuxAdd1, outMuxAdd2;
    wire [WORD_WIDTH-1:0] f1, f2, f3, f4;
    wire [WORD_WIDTH-1:0] outMux5; // mux6 removed (merged)
    wire [WORD_WIDTH-1:0] outMult, outAdder;
    wire coutAdder, outAnd31, outAnd32;
    wire is_init;

    // --- Optimized Multiplier ---
    Multiplier4x4 multiplier(
        .A(F[WORD_WIDTH/2 - 1: 0]),
        .B(F[WORD_WIDTH - 1: WORD_WIDTH/2]),
        .P(outMult)
    );

    // --- Init Logic ---
    c1 u_is_init (
        .A0(1'b0), .A1(1'b1), .SA(loadABCD),
        .B0(1'b0), .B1(1'b0), .SB(1'b0),
        .S0(selA), .S1(1'b0), .f(is_init)
    );

    // --- MuxRegs (A, B, C, D) ---
    MuxReg #(WORD_WIDTH) A_muxreg(
        .clk(clk), .rst(rst), 
        .init(is_init), .update(loadABCD), 
        .val_init(A0), .val_update(D),
        .Q(A)
    );

    MuxReg #(WORD_WIDTH) B_muxreg(
        .clk(clk), .rst(rst), 
        .init(is_init), .update(loadABCD), 
        .val_init(B0), .val_update(outAdder),
        .Q(B)
    );

    MuxReg #(WORD_WIDTH) C_muxreg(
        .clk(clk), .rst(rst), 
        .init(is_init), .update(loadABCD), 
        .val_init(C0), .val_update(B),
        .Q(C)
    );

    MuxReg #(WORD_WIDTH) D_muxreg(
        .clk(clk), .rst(rst), 
        .init(is_init), .update(loadABCD), 
        .val_init(D0), .val_update(C),
        .Q(D)
    );

    assign digest = {A, B, C, D};

    // --- Counter Logic ---
    Counter #(6) counter_6bit(
        .clk(clk), .rst(rst), .load(1'b0), .en(countEn), 
        .PI({COUNTER_WIDTH{1'b0}}), .count(i)
    );

    AND3 and3_1(.A(i[0]), .B(i[1]), .C(i[2]), .Y(outAnd31));
    AND3 and3_2(.A(i[3]), .B(i[4]), .C(i[5]), .Y(outAnd32));
    AND3 and3_3(.A(outAnd31), .B(outAnd32), .C(1'b1), .Y(co));
    
    rndGenerator rnd_generator(
        .clk(clk), .rst(rst), .shiftRegPI(i), .start_rnd(start_rnd), 
        .rnd(rnd), .done_rnd(done_rnd)
    );

    MFile #(MESSAGE_WIDTH) mfile(
        .clk(clk), .rst(rst), .message(message), .load(loadM), 
        .index(rnd), .out(M_rand)
    );

    // --- Function Logic ---
    Function1 #(WORD_WIDTH) func1(.X(B), .Y(C), .Z(B), .P(D), .Res(f1));
    Function1 #(WORD_WIDTH) func2(.X(D), .Y(B), .Z(D), .P(C), .Res(f2));
    Function2 #(WORD_WIDTH) func3(.X(B), .Y(C), .Z(D), .Res(f3));
    Function3 #(WORD_WIDTH) func4(.X(C), .Y(B), .Z(D), .Res(f4));

    MUX41 #(WORD_WIDTH) mux5(
        .I0(f1), .I1(f2), .I2(f3), .I3(f4),
        .S({i[5], i[4]}), .Y(outMux5)
    );

    ConstMem #(.INPUT_WIDTH(6), .OUTPUT_WIDTH(WORD_WIDTH), .MEMORY_FILE(MEMORY_FILE)) const_mem (
        .index(i), .data_out(const_i)
    );

    // --- SHARED ADDER LOGIC ---
    Adder2 #(WORD_WIDTH) adder2opr(
        .cin(1'b0),
        .A(outMuxAdd1),
        .B(outMuxAdd2),
        .cout(coutAdder),
        .Sum(outAdder)
    );

    Register #(WORD_WIDTH) accReg(
        .clk(clk), .rst(rst), .load(loadAcc), .D(outAdder), .Q(acc)
    );

    MUX41 #(WORD_WIDTH) muxadd1(
        .I0(acc), .I1(M_rand), .I2(A), .I3(outMult),
        .S(selAdd1), .Y(outMuxAdd1)
    );

    MUX41 #(WORD_WIDTH) muxadd2(
        .I0(acc), .I1(F), .I2(const_i), .I3(B),
        .S(selAdd2), .Y(outMuxAdd2)
    );
    
    // --- OPTIMIZATION: Merged MUX21 (mux6) and Register (Freg) ---
    // Eliminates 80 gates by using MuxReg logic
    MuxReg #(WORD_WIDTH) F_muxreg(
        .clk(clk), .rst(rst), 
        .init(selF),          // If selF=1 (and loadF=1), Select D11 (val_init) -> outAdder
        .update(loadF),       // If loadF=1 (and selF=0), Select D01 (val_update) -> outMux5
        .val_init(outAdder),  // Source when selF=1 (State 5)
        .val_update(outMux5), // Source when selF=0 (State 3)
        .Q(F)
    );

endmodule