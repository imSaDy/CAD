module LeftRotation #(
    parameter INPUT_WIDTH = 32,
    parameter INDEX_WIDTH = 6
)(
    input [INPUT_WIDTH-1:0] data_in,
    input [INDEX_WIDTH-1:0] index,
    output [INPUT_WIDTH-1:0] data_out
);
    reg [4:0] step; 

    assign step = (0 <= index && index <= 15) ? (
            (index % 4 == 0) ? 5'd7  :
            (index % 4 == 1) ? 5'd12 :
            (index % 4 == 2) ? 5'd17 : 5'd22) :
       (16 <= index && index <= 31) ? (
            (index % 4 == 0) ? 5'd5  :
            (index % 4 == 1) ? 5'd9  :
            (index % 4 == 2) ? 5'd14 : 5'd20) :
       (32 <= index && index <= 47) ? (
            (index % 4 == 0) ? 5'd4  :
            (index % 4 == 1) ? 5'd11 :
            (index % 4 == 2) ? 5'd16 : 5'd23) :
       (index % 4 == 0) ? 5'd6  :
       (index % 4 == 1) ? 5'd10 :
       (index % 4 == 2) ? 5'd15 : 5'd21;
    
    assign data_out = (data_in << step) | (data_in >> (INPUT_WIDTH - step));

endmodule
