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
    input loadA, loadB, loadC, loadD, loadF,
    output co,
    output done_rnd,
    output [MESSAGE_WIDTH-1:0] digest
);

    wire [COUNTER_WIDTH-1:0] i;
    wire [RND_WIDTH-1: 0] rnd;
    wire [WORD_WIDTH-1:0] M_rand, const_i;
    wire [WORD_WIDTH-1:0] A, B, C, D, F;
    wire [WORD_WIDTH-1:0] f1, f2, f3, f4;
    wire [WORD_WIDTH-1:0] outMux1, outMux2, outMux3, outMux4, outMux5, outMux6,
                             outMult, outAdder, outAdder2;
    wire coutAdder, coutAdder2, outAnd31, outAnd32;

    Multiplier4x4 multiplier(
        .A(F[WORD_WIDTH/2 - 1: 0]),
        .B(F[WORD_WIDTH - 1: WORD_WIDTH/2]),
        .P(outMult)
    );

    Adder2 #(WORD_WIDTH) adder1(
        .cin(1'b0),
        .A(outMult),
        .B(B),
        .cout(coutAdder),
        .Sum(outAdder)
    );

    MUX21  #(WORD_WIDTH) mux1(
        .I0(A0),
        .I1(D),
        .S(selA),
        .Y(outMux1)
    );

    MUX21  #(WORD_WIDTH) mux2(
        .I0(B0),
        .I1(outAdder),
        .S(selB),
        .Y(outMux2)
    );

    MUX21  #(WORD_WIDTH) mux3(
        .I0(C0),
        .I1(B),
        .S(selC),
        .Y(outMux3)
    );

    MUX21  #(WORD_WIDTH) mux4(
        .I0(D0),
        .I1(C),
        .S(selD),
        .Y(outMux4)
    );


    Register #(WORD_WIDTH) Areg(
        .clk(clk),
        .rst(rst),
        .load(loadA),
        .D(outMux1),
        .Q(A)
    );

    Register #(WORD_WIDTH) Breg(
        .clk(clk),
        .rst(rst),
        .load(loadB),
        .D(outMux2),
        .Q(B)
    );


    Register #(WORD_WIDTH) Creg(
        .clk(clk),
        .rst(rst),
        .load(loadC),
        .D(outMux3),
        .Q(C)
    );

    Register #(WORD_WIDTH) Dreg(
        .clk(clk),
        .rst(rst),
        .load(loadD),
        .D(outMux4),
        .Q(D)
    );

    assign digest = {A, B, C, D};

////////////////////////////////////////////////

    Counter #(6) counter_6bit(
        .clk(clk),
        .rst(rst),
        .load(1'b0),
        .en(countEn),
        .PI({COUNTER_WIDTH{1'b0}}),
        .count(i)
    );

    AND3 and3_1(
        .A(i[0]),
        .B(i[1]),
        .C(i[2]),
        .Y(outAnd31)
    );

    AND3 and3_2(
        .A(i[3]),
        .B(i[4]),
        .C(i[5]),
        .Y(outAnd32)
    );

    AND3 and3_3(
        .A(outAnd31),
        .B(outAnd32),
        .C(1'b1),
        .Y(co)
    );
    
    rndGenerator rnd_generator(
        .clk(clk),
        .rst(rst),
        .shiftRegPI(i),
        .start_rnd(start_rnd),
        .rnd(rnd),
        .done_rnd(done_rnd)
    );

    MFile #(MESSAGE_WIDTH) mfile(
        .clk(clk),
        .rst(rst),
        .message(message),
        .load(loadM),
        .index(rnd),
        .out(M_rand)
    );

    Function1 #(WORD_WIDTH) func1(
        .X(B),
        .Y(C),
        .Z(B),
        .P(D),
        .Res(f1)
    );

    Function1 #(WORD_WIDTH) func2(
        .X(D),
        .Y(B),
        .Z(D),
        .P(C),
        .Res(f2)
    );

    Function2 #(WORD_WIDTH) func3(
        .X(B),
        .Y(C),
        .Z(D),
        .Res(f3)
    );

    Function3 #(WORD_WIDTH) func4(
        .X(C),
        .Y(B),
        .Z(D),
        .Res(f4)
    );


    MUX41 #(WORD_WIDTH) mux5(
        .I0(f1),
        .I1(f2),
        .I2(f3),
        .I3(f4),
        .S({i[5], i[4]}),
        .Y(outMux5)
    );


    ConstMem #(
        .INPUT_WIDTH(6),
        .OUTPUT_WIDTH(WORD_WIDTH),
        .MEMORY_FILE(MEMORY_FILE)
    ) const_mem (
        .index(i),
        .data_out(const_i)
    );


    Adder4 #(WORD_WIDTH) adder2(
        .cin(1'b0),
        .A(F),
        .B(A),
        .C(const_i),
        .D(M_rand),
        .cout(coutAdder2),
        .Sum(outAdder2)
    );

    MUX21 #(WORD_WIDTH) mux6(
        .I0(outMux5),
        .I1(outAdder2),
        .S(selF),
        .Y(outMux6)
    );

    Register #(WORD_WIDTH) Freg(
        .clk(clk),
        .rst(rst),
        .load(loadF),
        .D(outMux6),
        .Q(F)
    );


endmodule