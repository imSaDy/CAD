module Martrix_Vector_multiplication #(
    parameter  DATA_WIDTH = 34,
    parameter ADDR_WIDTH = 7,
    parameter DIMENSION = 8,
    parameter [ADDR_WIDTH-1:0] Write_ADDR_LOAD_VALUE = 72
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
    input [DATA_WIDTH-1: 0] r_data,
    output coutWrite, coutPE, coutBread, coutARead,
    output [ADDR_WIDTH-1: 0] address,
    output [DATA_WIDTH-1: 0] w_data
);
    wire [ADDR_WIDTH-1: 0] countAddr, countWriteAddr;
    wire [2:0] countWrite, countAread, countBread;
    wire [3:0] countPE;
    wire [3:0] A7to4, A3to0;
    wire [63:0] B7to4, B3to0;
    wire [33:0] outPeLSB;

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

    Counter #(4) counter_pe(
        .clk(clk),
        .rst(rst),
        .load(1'b0),
        .en(countEnPE),
        .PI(4'b0),
        .count(countPE)
    );
    assign coutPE = &{countPE};

    Counter #(3) counter_BRead(
        .clk(clk),
        .rst(rst),
        .load(1'b0),
        .en(countEnBRead),
        .PI(3'b0),
        .count(countBread)
    );
    assign coutBread = &{countBread};

    Counter #(3) counter_ARead(
        .clk(clk),
        .rst(rst),
        .load(1'b0),
        .en(countEnARead),
        .PI(3'b0),
        .count(countAread)
    );
    assign coutARead = &{countAread};

    Mux2 #(7) mux1(
        .in0(countAddr),
        .in1(countWriteAddr),
        .sel(selAddr),
        .out(address)
    );

    shiftRegFile #(
        .WIDTH(16),
        .INPUT_ADDRESS_WIDTH(3),
        .NUM_SR(8)
    ) A_shift_reg_file(
        .clk(clk),
        .rst(rst),
        .load(loadAreg),
        .shiftEn(shiftEnA),
        .addr(countAread),
        .PI(r_data[15:0]),
        .A3to0(A3to0),
        .A7to4(A7to4)
    );

    RegisterFileB #(
        .DATA_WIDTH(16),
        .SIZE(8),
        .HALF_SIZE(4),
        .OUTPUT_WIDTH(64)
    ) B_reg_file(
        .clk(clk),
        .load(loadBreg),
        .data_in(r_data[15:0]),
        .address(countBread),
        .B1(B3to0),
        .B2(B7to4)
    );

    PE pe_lsb(
        .clk(clk),
        .rst(rst),
        .i_is_msb(i_is_msb),
        .a(A3to0),
        .b(B3to0),
        .is_valid(i_valid),
        .i_is_lsb(i_is_lsb),
        .initial_sum(34'b0),
        .o_dot_product(outPeLSB)
    );

    PE pe_msb(
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