module HashGenerator#(
    parameter MESSAGE_WIDTH = 32,
    parameter [MESSAGE_WIDTH/4 - 1: 0] C0 = 8'hFE,
    parameter [MESSAGE_WIDTH/4 - 1: 0] D0 = 8'h76,
    parameter [MESSAGE_WIDTH/4 - 1: 0] B0 = 8'h89,
    parameter [MESSAGE_WIDTH/4 - 1: 0] A0 = 8'h01,
    parameter MEMORY_FILE = "constant.mem"
)(
    input clk, 
    input rst,
    input start,
    input [MESSAGE_WIDTH - 1: 0] message,
    output done,
    output [MESSAGE_WIDTH - 1: 0] digest
);

    // --- Interconnecting Wires ---
    wire selA, selB, selC, selD, selF;
    wire loadABCD, loadM, loadF;
    wire start_rnd, done_rnd;
    wire co, countEn;
    
    // New Wires for Single-Adder Architecture
    wire loadAcc;
    wire [1:0] selAdd1;
    wire [1:0] selAdd2;

    // --- Datapath Instantiation ---
    HashGenDataPath #(
        .COUNTER_WIDTH(6),
        .RND_WIDTH(2),
        .MESSAGE_WIDTH(MESSAGE_WIDTH),
        .WORD_WIDTH(MESSAGE_WIDTH / 4),
        .MEMORY_FILE(MEMORY_FILE)
    ) hash_gen_dataPath(
        // Inputs
        .clk(clk),
        .rst(rst),
        .A0(A0),
        .B0(B0),
        .C0(C0),
        .D0(D0),
        .countEn(countEn),
        .start_rnd(start_rnd),
        .loadM(loadM),
        .message(message),
        
        // Control Signals
        .selA(selA),
        .selB(selB),
        .selC(selC),
        .selD(selD),
        .selF(selF),
        .loadABCD(loadABCD), // Single load signal
        .loadF(loadF),
        
        // Single Adder Controls
        .selAdd1(selAdd1),
        .selAdd2(selAdd2),
        .loadAcc(loadAcc),
        
        // Outputs
        .co(co),
        .done_rnd(done_rnd),
        .digest(digest)
    );

    // --- Controller Instantiation ---
    HashGenController hash_gen_controller(
        // Inputs
        .clk(clk),
        .rst(rst),
        .start(start),
        .done_rnd(done_rnd),
        .co(co),
        
        // Outputs
        .start_rnd(start_rnd),
        .countEn(countEn),
        .loadABCD(loadABCD), // Single load signal
        .loadM(loadM),
        .loadF(loadF),
        .selF(selF),
        .selA(selA),
        .selB(selB),
        .selC(selC),
        .selD(selD),
        
        // Single Adder Controls
        .loadAcc(loadAcc),
        .selAdd1(selAdd1),
        .selAdd2(selAdd2),
        
        .done(done)
    );
    
endmodule