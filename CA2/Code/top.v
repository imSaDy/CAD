module Matrix_Multiplier #(
    parameter DATA_WIDTH,
    parameter ADDR_WIDTH,
    parameter DIMENSION,
    parameter MEMORY_NAME,
    parameter MEMORY_SIZE,
    parameter WRITE_ADDR_START,
    parameter A_WIDTH = 16,
    parameter B_WIDTH = 16,
    parameter A_VEC_SIZE = 8, 
    parameter B_VEC_SIZE = 8,
    parameter B_HALF_SIZE = 4,
    parameter B_CONCAT_WIDTH = 64
)(
    input clk,
    input rst,
    input start,
    input done
); 
    wire write;
    wire [33:0] w_data, r_data;
    wire [6:0] address;

    MVM #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .DIMENSION(DIMENSION),
        .WRITE_ADDR_START(WRITE_ADDR_START),
        .A_WIDTH(A_WIDTH),
        .B_WIDTH(B_WIDTH),
        .A_VEC_SIZE(A_VEC_SIZE), 
        .B_VEC_SIZE(B_VEC_SIZE),
        .B_HALF_SIZE(B_HALF_SIZE),
        .B_CONCAT_WIDTH(B_CONCAT_WIDTH)
    ) mvm (
        .clk(clk),
        .rst(rst),
        .start(start),
        .r_data(r_data),
        .address(address),
        .w_data(w_data),
        .write(write),
        .done(done)
    );

    Memory #(
        .DATA_WIDTH(DATA_WIDTH),
        .INPUT_ADDRESS_WIDTH(ADDR_WIDTH),
        .MEMORY_SIZE(MEMORY_SIZE),
        .MEM_FILE(MEMORY_NAME)
    ) memory (
        .clk(clk),
        .rst(rst),
        .write(write),
        .data_in(w_data), 
        .address(address),
        .data_out(r_data)
    );


endmodule