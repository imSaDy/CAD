module PE(
    input clk,
    input rst,
    input i_is_msb,
    input [3:0] a,
    input [63:0] b,
    input is_valid,
    input i_is_lsb,
    input [33:0] initial_sum,
    output [33:0] o_dot_product
);

    wire [33:0] outTwosComp1, outTwosComp2, outTwosComp3, outTwosComp4,
                outMux1, outMux2, outMux3, outMux4, outMux5, outMux6,
                outMux7, outMux8;
    
    wire [33:0] inputAccumulator, outAccumulator;

    wire [33:0] b0, b1, b2, b3;
    wire [33:0] outAdder1;
    wire a0, a1, a2, a3;
    wire selMux2, selMux4, selMux6, selMux8; 
    wire coutAdder2;
    wire [1:0] coutAdder1;

    assign b0 = {{18{b[15]}}, b[15:0]};
    assign b1 = {{18{b[31]}}, b[31:16]};
    assign b2 = {{18{b[47]}}, b[47:32]};
    assign b3 = {{18{b[63]}}, b[63:48]};

    assign a0 = a[0];
    assign a1 = a[1];
    assign a2 = a[2];
    assign a3 = a[3];

    assign selMux2 =  i_is_msb & a0;
    Mux2 #(34) mux1(
        .in0(34'b0),
        .in1(b0),
        .sel(a0),
        .out(outMux1)
    );
    TwosComplement #(34) twos_complement1(.in(b0), .out(outTwosComp1));
    Mux2 #(34) mux2(
        .in0(outMux1),
        .in1(outTwosComp1),
        .sel(selMux2),
        .out(outMux2)
    );


    assign selMux4 =  i_is_msb & a1;
    Mux2 #(34) mux3(
        .in0(34'b0),
        .in1(b1),
        .sel(a1),
        .out(outMux3)
    );
    TwosComplement #(34) twos_complement2(.in(b1), .out(outTwosComp2));
    Mux2 #(34) mux4(
        .in0(outMux3),
        .in1(outTwosComp2),
        .sel(selMux4),
        .out(outMux4)
    );


    assign selMux6 =  i_is_msb & a2;
    Mux2 #(34) mux5(
        .in0(34'b0),
        .in1(b2),
        .sel(a2),
        .out(outMux5)
    );
    TwosComplement #(34) twos_complement3(.in(b2), .out(outTwosComp3));
    Mux2 #(34) mux6(
        .in0(outMux5),
        .in1(outTwosComp3),
        .sel(selMux6),
        .out(outMux6)
    );

    assign selMux8 =  i_is_msb & a3;
    Mux2 #(34) mux7(
        .in0(34'b0),
        .in1(b3),
        .sel(a3),
        .out(outMux7)
    );
    TwosComplement #(34) twos_complement4(.in(b3), .out(outTwosComp4));
    Mux2 #(34) mux8(
        .in0(outMux7),
        .in1(outTwosComp4),
        .sel(selMux8),
        .out(outMux8)
    );


    Adder_fourOpr #(34) adder1(
        .cin(1'b0),
        .A(outMux2),
        .B(outMux4),
        .C(outMux6),
        .D(outMux8),
        .cout(coutAdder1),
        .S(outAdder1)
    );

    assign inputAccumulator = outAdder1;

    Accumulator #(34) accumulator(
        .clk(clk),
        .rst(i_is_lsb),
        .en(is_valid),
        .addData(inputAccumulator),
        .register(outAccumulator)
    );

    Adder_twoOpr #(34) adder2(
        .cin(1'b0),
        .A(outAccumulator),
        .B(initial_sum),
        .cout(coutAdder2),
        .S(o_dot_product)
    );


endmodule