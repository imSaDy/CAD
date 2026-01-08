module Martrix_Vector_multiplication #(
    parameter  DATA_WIDTH = 34,
    parameter ADDR_WIDTH = 7,
    parameter DIMENSION = 8,
    parameter [ADDR_WIDTH-1:0] Write_ADDR_LOAD_VALUE = 72,
    parameter A_WIDTH = 16,
    parameter B_WIDTH = 16,
    parameter A_VEC_SIZE = 8, 
    parameter B_VEC_SIZE = 8,
    parameter B_HALF_SIZE = 4,
    parameter B_CONCAT_WIDTH = 64
)(
    input clk,
    input rst,
    input countEnAddr, countEnWriteAddr, countEnWrite,
            countEnPE, countEnBRead, countEnARead,
    input loadCounterWriteAddr,
    input selAddr,
    input loadAreg, shiftEnA,
    input loadBreg,
    input i_is_lsb, i_is_msb, i_valid,
    input [DATA_WIDTH-1:0] r_data,
    output coutWrite, coutPE, coutBread, coutARead,
    output [ADDR_WIDTH-1:0] address,
    output [DATA_WIDTH-1:0] w_data
);
    wire [ADDR_WIDTH-1:0] countAddr, countWriteAddr;
    wire [$clog2(A_VEC_SIZE)-1:0] countWrite; 
    wire [$clog2(A_VEC_SIZE)-1:0] countAread;
    wire [$clog2(B_VEC_SIZE)-1:0] countBread;
    wire [$clog2(A_WIDTH)-1:0] countPE;
    wire [(A_VEC_SIZE/2)-1:0] A7to4, A3to0;
    wire [B_CONCAT_WIDTH-1:0] B7to4, B3to0;
    wire [DATA_WIDTH-1:0] outPeLSB;

    Counter #(ADDR_WIDTH) counter_addr(
        .clk(clk),
        .rst(rst),
        .load(1'b0),
        .en(countEnAddr),
        .PI({ADDR_WIDTH{1'b0}}),
        .count(countAddr)
    );

    Counter #(ADDR_WIDTH) counter_write_addr(
        .clk(clk),
        .rst(rst),
        .load(loadCounterWriteAddr),
        .en(countEnWriteAddr),
        .PI(Write_ADDR_LOAD_VALUE),
        .count(countWriteAddr)
    );

    Counter #($clog2(DIMENSION)) counter_write(
        .clk(clk),
        .rst(rst),
        .load(1'b0),
        .en(countEnWrite),
        .PI({($clog2(DIMENSION)){1'b0}}),
        .count(countWrite)
    );
    assign coutWrite = &{countWrite};

    Counter #($clog2(A_WIDTH)) counter_pe(
        .clk(clk),
        .rst(rst),
        .load(1'b0),
        .en(countEnPE),
        .PI({($clog2(A_WIDTH)){1'b0}}),
        .count(countPE)
    );
    assign coutPE = &{countPE};

    Counter #($clog2(B_VEC_SIZE)) counter_BRead(
        .clk(clk),
        .rst(rst),
        .load(1'b0),
        .en(countEnBRead),
        .PI({($clog2(B_VEC_SIZE)){1'b0}}),
        .count(countBread)
    );
    assign coutBread = &{countBread};

    Counter #($clog2(A_VEC_SIZE)) counter_ARead(
        .clk(clk),
        .rst(rst),
        .load(1'b0),
        .en(countEnARead),
        .PI({($clog2(A_VEC_SIZE)){1'b0}}),
        .count(countAread)
    );
    assign coutARead = &{countAread};

    Mux2 #(ADDR_WIDTH) mux1(
        .in0(countAddr),
        .in1(countWriteAddr),
        .sel(selAddr),
        .out(address)
    );

    shiftRegFile #(
        .WIDTH(A_WIDTH),
        .INPUT_ADDRESS_WIDTH($clog2(A_VEC_SIZE)),
        .NUM_SR(A_VEC_SIZE)
    ) A_shift_reg_file(
        .clk(clk),
        .rst(rst),
        .load(loadAreg),
        .shiftEn(shiftEnA),
        .addr(countAread),
        .PI(r_data[A_WIDTH-1:0]),
        .A3to0(A3to0),
        .A7to4(A7to4)
    );

    RegisterFileB #(
        .DATA_WIDTH(B_WIDTH),
        .SIZE(B_VEC_SIZE),
        .HALF_SIZE(B_HALF_SIZE),
        .OUTPUT_WIDTH(B_CONCAT_WIDTH)
    ) B_reg_file(
        .clk(clk),
        .load(loadBreg),
        .data_in(r_data[B_WIDTH-1:0]),
        .address(countBread),
        .B1(B3to0),
        .B2(B7to4)
    );

    PE #(
        .B_CONCAT_WIDTH(B_CONCAT_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .A_VEC_SIZE(A_VEC_SIZE),
        .B_WIDTH(B_WIDTH)
    ) pe_lsb(
        .clk(clk),
        .rst(rst),
        .i_is_msb(i_is_msb),
        .a(A3to0),
        .b(B3to0),
        .is_valid(i_valid),
        .i_is_lsb(i_is_lsb),
        .initial_sum({DATA_WIDTH{1'b0}}),
        .o_dot_product(outPeLSB)
    );

    PE #(
        .B_CONCAT_WIDTH(B_CONCAT_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .A_VEC_SIZE(A_VEC_SIZE),
        .B_WIDTH(B_WIDTH)
    ) pe_msb(
        .clk(clk),
        .rst(rst),
        .i_is_msb(i_is_msb),
        .a(A7to4),
        .b(B7to4),
        .is_valid(i_valid),
        .i_is_lsb(i_is_lsb),
        .initial_sum(outPeLSB),
        .o_dot_product(w_data)
    );
endmodule