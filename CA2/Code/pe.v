module PE#(
    parameter B_CONCAT_WIDTH, 
    parameter DATA_WIDTH,
    parameter A_VEC_SIZE,
    parameter B_WIDTH
)(
    input clk,
    input rst,
    input i_is_msb,
    input [(A_VEC_SIZE/2)-1:0] a,
    input [B_CONCAT_WIDTH-1:0] b,
    input is_valid,
    input i_is_lsb,
    input [DATA_WIDTH-1:0] initial_sum,
    output [DATA_WIDTH-1:0] o_dot_product
);
    wire [DATA_WIDTH-1:0] outTwosComp1, outTwosComp2, outTwosComp3, outTwosComp4,
                outMux1, outMux2, outMux3, outMux4, outMux5, outMux6,
                outMux7, outMux8;
    
    wire [DATA_WIDTH-1:0] inputAccumulator, outAccumulator;

    wire [DATA_WIDTH-1:0] b0, b1, b2, b3;
    wire [DATA_WIDTH-1:0] outAdder1;
    wire selMux2, selMux4, selMux6, selMux8; 
    wire coutAdder2;
    wire [1:0] coutAdder1;

    assign b0 = {{(DATA_WIDTH-B_WIDTH){b[B_WIDTH-1]}}, b[B_WIDTH-1:0]};
    assign b1 = {{(DATA_WIDTH-B_WIDTH){b[B_WIDTH*2-1]}}, b[B_WIDTH*2-1:B_WIDTH]};
    assign b2 = {{(DATA_WIDTH-B_WIDTH){b[B_WIDTH*3-1]}}, b[B_WIDTH*3-1:B_WIDTH*2]};
    assign b3 = {{(DATA_WIDTH-B_WIDTH){b[B_WIDTH*4-1]}}, b[B_WIDTH*4-1:B_WIDTH*3]};

    assign selMux2 =  i_is_msb & a[0];
    Mux2 #(DATA_WIDTH) mux1(
        .in0({DATA_WIDTH{1'b0}}),
        .in1(b0),
        .sel(a[0]),
        .out(outMux1)
    );
    TwosComplement #(DATA_WIDTH) twos_complement1(.in(b0), .out(outTwosComp1));
    Mux2 #(DATA_WIDTH) mux2(
        .in0(outMux1),
        .in1(outTwosComp1),
        .sel(selMux2),
        .out(outMux2)
    );

    assign selMux4 =  i_is_msb & a[1];
    Mux2 #(DATA_WIDTH) mux3(
        .in0({DATA_WIDTH{1'b0}}),
        .in1(b1),
        .sel(a[1]),
        .out(outMux3)
    );
    TwosComplement #(DATA_WIDTH) twos_complement2(.in(b1), .out(outTwosComp2));
    Mux2 #(DATA_WIDTH) mux4(
        .in0(outMux3),
        .in1(outTwosComp2),
        .sel(selMux4),
        .out(outMux4)
    );

    assign selMux6 =  i_is_msb & a[2];
    Mux2 #(DATA_WIDTH) mux5(
        .in0({DATA_WIDTH{1'b0}}),
        .in1(b2),
        .sel(a[2]),
        .out(outMux5)
    );
    TwosComplement #(DATA_WIDTH) twos_complement3(.in(b2), .out(outTwosComp3));
    Mux2 #(DATA_WIDTH) mux6(
        .in0(outMux5),
        .in1(outTwosComp3),
        .sel(selMux6),
        .out(outMux6)
    );

    assign selMux8 =  i_is_msb & a[3];
    Mux2 #(DATA_WIDTH) mux7(
        .in0({DATA_WIDTH{1'b0}}),
        .in1(b3),
        .sel(a[3]),
        .out(outMux7)
    );
    TwosComplement #(DATA_WIDTH) twos_complement4(.in(b3), .out(outTwosComp4));
    Mux2 #(DATA_WIDTH) mux8(
        .in0(outMux7),
        .in1(outTwosComp4),
        .sel(selMux8),
        .out(outMux8)
    );

    Adder_fourOpr #(DATA_WIDTH) adder1(
        .cin(1'b0),
        .A(outMux2),
        .B(outMux4),
        .C(outMux6),
        .D(outMux8),
        .cout(coutAdder1),
        .S(outAdder1)
    );

    assign inputAccumulator = outAdder1;

    Accumulator #(DATA_WIDTH) accumulator(
        .clk(clk),
        .rst(i_is_lsb),
        .en(is_valid),
        .addData(inputAccumulator),
        .register(outAccumulator)
    );

    Adder_twoOpr #(DATA_WIDTH) adder2(
        .cin(1'b0),
        .A(outAccumulator),
        .B(initial_sum),
        .cout(coutAdder2),
        .S(o_dot_product)
    );
endmodule