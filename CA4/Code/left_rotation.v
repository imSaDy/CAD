module LeftRotation #(
    parameter INPUT_WIDTH = 32,
    parameter INDEX_WIDTH = 6
)(
    input [INPUT_WIDTH-1:0] data_in,
    input [INDEX_WIDTH-1:0] index,
    output [INPUT_WIDTH-1:0] data_out
);
    reg [4:0] step [0:63];

    initial begin
        step[0] = 7;  step[ 1] = 12; step[ 2] = 17; step[ 3] = 22;
        step[4] = 7;  step[ 5] = 12; step[ 6] = 17; step[ 7] = 22;
        step[8] = 7;  step[ 9] = 12; step[10] = 17; step[11] = 22;
        step[12] = 7;  step[13] = 12; step[14] = 17; step[15] = 22;

        step[16] = 5;  step[17] = 9;  step[18] = 14; step[19] = 20;
        step[20] = 5;  step[21] = 9;  step[22] = 14; step[23] = 20;
        step[24] = 5;  step[25] = 9;  step[26] = 14; step[27] = 20;
        step[28] = 5;  step[29] = 9;  step[30] = 14; step[31] = 20;

        step[32] = 4;  step[33] = 11; step[34] = 16; step[35] = 23;
        step[36] = 4;  step[37] = 11; step[38] = 16; step[39] = 23;
        step[40] = 4;  step[41] = 11; step[42] = 16; step[43] = 23;
        step[44] = 4;  step[45] = 11; step[46] = 16; step[47] = 23;

        step[48] = 6;  step[49] = 10; step[50] = 15; step[51] = 21;
        step[52] = 6;  step[53] = 10; step[54] = 15; step[55] = 21;
        step[56] = 6;  step[57] = 10; step[58] = 15; step[59] = 21;
        step[60] = 6;  step[61] = 10; step[62] = 15; step[63] = 21;
    end


    assign data_out = (data_in << step[index]) | (data_in >> (INPUT_WIDTH - step[index]));


endmodule
