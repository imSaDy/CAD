module Martrix_Vector_multiplication #(
    parameter  DATA_WIDTH = 34,
    parameter ADDR_WIDTH = 7,
    parameter DIMENSION = 8
)(
    input clk,
    input rst,
    input start,
    input [DATA_WIDTH-1: 0] r_data,
    output [ADDR_WIDTH-1: 0] address,
    output [DATA_WIDTH-1: 0] w_data,
    output write,
    output done
);

    wire countEnAddr, countEnWriteAddr, countEnWrite,
            countEnPE, countEnBRead, countEnARead;

    wire loadCounterWriteAddr, selAddr, loadAreg, shiftEnA,
            loadBreg, i_is_msb, i_is_lsb, i_valid;

    wire coutWrite, coutPE, coutBread, coutARead;
    wire rstDataPath;

    Martrix_Vector_multiplication #(
        .DATA_WIDTH(34),
        .ADDR_WIDTH(7),
        .DIMENSION(8),
        .Write_ADDR_LOAD_VALUE(72)
    ) mvp (
        .clk(clk),
        .rst(rstDataPath),
        .countEnAddr(countEnAddr),
        .countEnWriteAddr(countEnWriteAddr),
        .countEnWrite(countEnWrite),
        .countEnPE(countEnPE),
        .countEnBRead(countEnBRead),
        .countEnARead(countEnARead),
        .loadCounterWriteAddr(loadCounterWriteAddr),
        .selAddr(selAddr),
        .loadAreg(loadAreg),
        .shiftEnA(shiftEnA),
        .loadBreg(loadBreg),
        .i_is_lsb(i_is_lsb),
        .i_is_msb(i_is_msb),
        .i_valid(i_valid),
        .r_data(r_data),
        .coutWrite(coutWrite),
        .coutPE(coutPE),
        .coutBread(coutBread),
        .coutARead(coutARead),
        .address(address),
        .w_data(w_data)
    );

    Controller  controller(
        .clk(clk),
        .rst(rst),
        .start(start),
        .coutARead(coutARead),
        .coutBRead(coutBread),
        .coutPE(coutPE),
        .coutWrite(coutWrite),
        .rstOut(rstDataPath),
        .countEnAddr(countEnAddr),
        .loadAReg(loadAReg),
        .loadCounterWriteAddr(loadCounterWriteAddr),
        .countEnARead(countEnARead),
        .loadBReg(loadBReg),
        .i_is_lsb(i_is_lsb),
        .i_is_msb(i_is_msb),
        .countEnBRead(countEnBRead), 
        .countEnPE(countEnPE), 
        .i_valid(i_valid), 
        .shiftEnA(shiftEnA), 
        .write(write), 
        .countEnWrite(countEnWrite), 
        .countEnWriteAddr(countEnWriteAddr), 
        .selAddr(selAddr),
        .done(done)
    );
        


endmodule