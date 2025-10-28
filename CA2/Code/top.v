module Matrix_Multiplier(
    input clk,
    input rst,
    input start,
    input done
); 
    wire write;
    wire [33:0] w_data, r_data;
    wire [6:0] address;

    Martrix_Vector_multiplication #(
        .DATA_WIDTH(34),
        .ADDR_WIDTH(7),
        .DIMENSION(8)
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
        .DATA_WIDTH(34),
        .INPUT_ADDRESS_WIDTH(7),
        .MEMORY_SIZE(128),
        .MEM_FILE("input_memory (1).txt")
    ) memory (
        .clk(clk),
        .rst(rst),
        .write(write),
        .data_in(w_data), 
        .address(address),
        .data_out(r_data)
    );


endmodule