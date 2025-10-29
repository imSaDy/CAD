module shiftRegFile #(
    parameter WIDTH = 16,
    parameter INPUT_ADDRESS_WIDTH = 3,
    parameter NUM_SR = 8
)(
    input  wire                     clk,
    input  wire                     rst,
    input  wire                     load,
    input  wire                     shiftEn,
    input  wire [INPUT_ADDRESS_WIDTH-1:0] addr,
    input  wire [WIDTH-1:0]         PI,
    output wire [3:0]               A3to0,
    output wire [3:0]               A7to4
);
    reg [WIDTH-1:0] sr [0:NUM_SR-1];
    wire serout [0:NUM_SR-1];
    wire serin  [0:NUM_SR-1];
    
    genvar i;
    generate
        for (i = 0; i < NUM_SR; i = i + 1) begin : GEN_SEROUT
            assign serout[i] = sr[i][WIDTH-1];
        end
    endgenerate

    generate
        for (i = 0; i < NUM_SR; i = i + 1) begin : GEN_SERIN
            assign serin[i] = serout[i];
        end
    endgenerate

    integer j;
    always @(posedge clk) begin
        if (rst) begin
            for (j = 0; j < NUM_SR; j = j + 1)
                sr[j] <= {WIDTH{1'b0}};
        end else begin
            if (load) begin
                sr[addr] <= PI;
            end
            if (shiftEn) begin
                for (j = 0; j < NUM_SR; j = j + 1) begin
                    sr[j] <= {sr[j][WIDTH-2:0], serin[j]};
                end
            end
        end
    end

    assign A3to0 = {serout[3], serout[2], serout[1], serout[0]};
    assign A7to4 = {serout[7], serout[6], serout[5], serout[4]};
endmodule
