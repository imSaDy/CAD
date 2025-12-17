module HashGenDataPath #(
    parameter COUNTER_WIDTH = 6,
    parameter RND_WIDTH = 2,
    parameter WORD_WIDTH = 8,
    parameter MESSAGE_WIDTH = WORD_WIDTH
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
    input [WORD_WIDTH-1:0] const_i,
    output co,
    output done_rnd,
    output [MESSAGE_WIDTH-1:0] digest,
    output [COUNTER_WIDTH-1:0] i
);

    wire [RND_WIDTH-1: 0] rnd;
    wire [WORD_WIDTH-1:0] M_rand;
    wire [WORD_WIDTH-1:0] A, B, C, D, F;
    wire [WORD_WIDTH-1:0] f1, f2, f3, f4;
    wire [WORD_WIDTH-1:0] outMux1, outMux2, outMux3, outMux4, outMux5, outMux6,
                             outMult, outAdder, outAdder2;
    wire coutAdder, coutAdder2;

    // LeftRotation #(
    //     .INPUT_WIDTH(WORD_WIDTH),
    //     .INDEX_WIDTH(6)
    // ) leftR (
    //     .data_in(F),
    //     .index(i),
    //     .data_out(outLeftR)
    // );
    
    assign outMult = F[WORD_WIDTH-1: WORD_WIDTH/2] * F[WORD_WIDTH/2 -1: 0];

    Adder_twoOpr #(WORD_WIDTH) adder(
        .cin(1'b0),
        .A(outMult),
        .B(B),
        .cout(coutAdder),
        .S(outAdder)
    );

    Mux2  #(WORD_WIDTH) mux1(
        .in0(A0),
        .in1(D),
        .sel(selA),
        .out(outMux1)
    );


    Mux2  #(WORD_WIDTH) mux2(
        .in0(B0),
        .in1(outAdder),
        .sel(selB),
        .out(outMux2)
    );

    Mux2  #(WORD_WIDTH) mux3(
        .in0(C0),
        .in1(B),
        .sel(selC),
        .out(outMux3)
    );

    Mux2  #(WORD_WIDTH) mux4(
        .in0(D0),
        .in1(C),
        .sel(selD),
        .out(outMux4)
    );


    Register #(WORD_WIDTH) Areg(
        .clk(clk),
        .rst(rst),
        .load(loadA),
        .data(outMux1),
        .register(A)
    );

    Register #(WORD_WIDTH) Breg(
        .clk(clk),
        .rst(rst),
        .load(loadB),
        .data(outMux2),
        .register(B)
    );


    Register #(WORD_WIDTH) Creg(
        .clk(clk),
        .rst(rst),
        .load(loadC),
        .data(outMux3),
        .register(C)
    );

    Register #(WORD_WIDTH) Dreg(
        .clk(clk),
        .rst(rst),
        .load(loadD),
        .data(outMux4),
        .register(D)
    );

    assign digest = {A, B, C, D};

////////////////////////////////////////////////
    Counter #(COUNTER_WIDTH) counter_6bit(
        .clk(clk),
        .rst(rst),
        .load(1'b0),
        .en(countEn),
        .PI({COUNTER_WIDTH{1'b0}}),
        .count(i)
    );

    assign co = &{i};

    
    rndGenerator rnd_generator(
        .clk(clk),
        .rst(rst),
        .shiftRegPI(i),
        .start_rnd(start_rnd),
        .rnd(rnd),
        .done_rnd(done_rnd)
    );

    MFile mfile(
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

    Mux4 #(WORD_WIDTH) mux5(
        .in0(f1),
        .in1(f2),
        .in2(f3),
        .in3(f4),
        .sel({i[5], i[4]}),
        .out(outMux5)
    );



    // ConstMem #(
    //     .INPUT_WIDTH(6),
    //     .OUTPUT_WIDTH(WORD_WIDTH),
    //     .MEM_FILE("constant.mem")
    // ) const_mem (
    //     .index(i),
    //     .data_out(const_i)
    // );


    Adder_fourOpr #(WORD_WIDTH) adder2(
        .cin(1'b0),
        .A(F),
        .B(A),
        .C(const_i),
        .D(M_rand),
        .cout(coutAdder2),
        .S(outAdder2)
    );


    Mux2 #(WORD_WIDTH) mux6(
        .in0(outMux5),
        .in1(outAdder2),
        .sel(selF),
        .out(outMux6)
    );

    Register #(WORD_WIDTH) Freg(
        .clk(clk),
        .rst(rst),
        .load(loadF),
        .data(outMux6),
        .register(F)
    );
    

endmodule