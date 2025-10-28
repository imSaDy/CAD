module shiftRegFile #(
    parameter WIDTH = 16,
    parameter INPUT_ADDRESS_WIDTH = 3,
    parameter NUM_SR = 8   // you can change this but keep INPUT_ADDRESS_WIDTH wide enough
)(
    input  wire                     clk,
    input  wire                     rst,       // synchronous active-high reset
    input  wire                     load,      // when high, parallel-load PI into SR[addr]
    input  wire                     shiftEn,   // when high, all SRs shift one position
    input  wire [INPUT_ADDRESS_WIDTH-1:0] addr,// address of SR to parallel-load
    input  wire [WIDTH-1:0]         PI,        // parallel input for load into addressed SR
    output wire [3:0]               A3to0,     // {A3,A2,A1,A0} = serout[3:0]
    output wire [3:0]               A7to4      // {A7,A6,A5,A4} = serout[7:4]
);

    // internal storage: NUM_SR shift registers, each WIDTH bits
    reg [WIDTH-1:0] sr [0:NUM_SR-1];

    // serial outputs (one bit per SR)addr
    wire serout [0:NUM_SR-1];
    // serial inputs computed from the circular chain
    wire serin  [0:NUM_SR-1];
    
    genvar i;
    // compute serouts (MSB is serial-out)
    generate
        for (i = 0; i < NUM_SR; i = i + 1) begin : GEN_SEROUT
            assign serout[i] = sr[i][WIDTH-1];
        end
    endgenerate

    // circular chain: serin[0] = serout[NUM_SR-1]; serin[i] = serout[i-1]
    generate
        for (i = 0; i < NUM_SR; i = i + 1) begin : GEN_SERIN
            assign serin[i] = serout[i];
            // if (i == 0) begin
            //     assign serin[0] = serout[NUM_SR-1];
            // end else begin
            //     assign serin[i] = serout[i-1];
            // end
        end
    endgenerate

    // synchronous logic: load or shift (load takes priority)
    integer j;
    always @(posedge clk) begin
        if (rst) begin
            // clear all shift registers
            for (j = 0; j < NUM_SR; j = j + 1)
                sr[j] <= {WIDTH{1'b0}};
        end else begin
            if (load) begin
                // parallel-load PI into addressed shift register only
                // other SRs unchanged
                sr[addr] <= PI;
            end
            if (shiftEn) begin
                // perform circular serial shift for all SRs
                // new LSB (bit 0) receives serin for that SR; bits shift up toward MSB
                for (j = 0; j < NUM_SR; j = j + 1) begin
                    sr[j] <= { sr[j][WIDTH-2:0], serin[j] };
                end
            end
        end
    end

    // Pack outputs (A3to0 = serout[3..0], A7to4 = serout[7..4])
    // If NUM_SR < 8, missing bits will be tied to 0 (but recommended NUM_SR = 8)
    assign A3to0 = { serout[3], serout[2], serout[1], serout[0] };
    assign A7to4 = { serout[7], serout[6], serout[5], serout[4] };

endmodule
