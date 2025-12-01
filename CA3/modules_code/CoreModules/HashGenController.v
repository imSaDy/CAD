module HashGenController (
    input clk,
    input rst,
    input start,
    input done_rnd,
    input co,
    output start_rnd,
    output countEn,
    output loadABCD, 
    output loadM,
    output loadF,
    output selF,
    output selA,
    output selB,
    output selC,
    output selD,
    output loadAcc,
    output [1:0] selAdd1,
    output [1:0] selAdd2,
    output done
);

    wire [7:0] ps; 
    
    // --- Phase Toggle Logic ---
    wire phase, phase_next;
    NOT not_phase(phase, phase_next);
    s2 phase_ff (
        .D00(phase), .D01(phase_next), .D10(1'b0), .D11(1'b0),
        .A1(1'b0), .B1(1'b0), .A0(1'b1), .B0(1'b1), 
        .clr(rst), .clk(clk), .out(phase)
    );

    // --- Optimization: Shared Logic Terms ---
    
    // Term 1: Active in INIT(2) OR UPDATE(6)
    // Used for: selAdd1[1], selAdd2[1]
    wire state_2_or_6;
    OR u_opt1 (.A(ps[2]), .B(ps[6]), .C(state_2_or_6));

    // Term 2: Active in INIT(2) OR UPDATE_ACC(4)
    // Used for: loadAcc, auto_shift
    wire state_2_or_4;
    OR u_opt2 (.A(ps[2]), .B(ps[4]), .C(state_2_or_4));

    // --- Shift Logic ---
    wire wait_start, wait_pulse, wait_rnd, check_co;
    wire auto_shift;

    c1 c1_start (.A0(1'b0), .A1(ps[0]), .SA(start), .B0(1'b0), .B1(1'b0), .SB(1'b0), .S0(1'b0), .S1(1'b0), .f(wait_start));
    c1 c1_pulse (.A0(ps[1]), .A1(1'b0), .SA(start), .B0(1'b0), .B1(1'b0), .SB(1'b0), .S0(1'b0), .S1(1'b0), .f(wait_pulse));
    c1 c1_rnd   (.A0(1'b0), .A1(ps[3]), .SA(done_rnd), .B0(1'b0), .B1(1'b0), .SB(1'b0), .S0(1'b0), .S1(1'b0), .f(wait_rnd));

    wire co_ph;
    AND3 u_co_ph (.A(co), .B(phase), .C(1'b1), .Y(co_ph));
    c1 c1_co    (.A0(1'b0), .A1(ps[6]), .SA(co_ph), .B0(1'b0), .B1(1'b0), .SB(1'b0), .S0(1'b0), .S1(1'b0), .f(check_co));

    // OPTIMIZATION: Reused state_2_or_4 here
    OR u_auto_final (.A(state_2_or_4), .B(ps[5]), .C(auto_shift));

    wire shift_1, shift_2, shift_3, shift_trigger;
    OR u_sh1 (.A(wait_start), .B(wait_pulse), .C(shift_1));
    OR u_sh2 (.A(wait_rnd), .B(check_co), .C(shift_2));
    OR u_sh3 (.A(shift_1), .B(shift_2), .C(shift_3));
    OR u_sh_final (.A(shift_3), .B(auto_shift), .C(shift_trigger));

    // --- Load Trigger & Reset ---
    
    // Jump Back (UPDATE -> INIT)
    wire not_co, jump_cond;
    NOT u_not_co(co, not_co);
    AND3 u_jump_cond(.A(ps[6]), .B(not_co), .C(phase), .Y(jump_cond));

    // Reset Detect (00000000 -> IDLE)
    wire nor_low, nor_up, reset_detect;
    NOR4 u_nor_l (.A(ps[0]), .B(ps[1]), .C(ps[2]), .D(ps[3]), .Y(nor_low));
    NOR4 u_nor_u (.A(ps[4]), .B(ps[5]), .C(ps[6]), .D(ps[7]), .Y(nor_up));
    AND3 u_rst_det (.A(nor_low), .B(nor_up), .C(1'b1), .Y(reset_detect));

    // OPTIMIZATION: Combine Reset and Done first (Next State = IDLE conditions)
    wire next_idle;
    OR u_next_idle (.A(reset_detect), .B(ps[7]), .C(next_idle));

    // Load Trigger: Jump OR Next_Idle
    wire load_trigger;
    OR u_ld_final (.A(jump_cond), .B(next_idle), .C(load_trigger));

    // --- State Register ---
    wire [7:0] PI;
    assign PI = {5'b0, jump_cond, 1'b0, next_idle};

    ShiftRegister #(.WIDTH(8)) state_reg (
        .clk(clk), .rst(rst), .load(load_trigger), .shiftEn(shift_trigger),
        .ser_in(1'b0), .PI(PI), .twoMSB(), .Q(ps)
    );

    // --- Output Assignments ---

    // Shared signals (Optimization Applied)
    assign selAdd1[1] = state_2_or_6;
    assign selAdd2[1] = state_2_or_6;
    assign loadAcc    = state_2_or_4;
    
    // Remaining Outputs
    assign loadM = ps[2];
    assign start_rnd = ps[2];
    assign selF = ps[5];
    
    wire update_phase1;
    AND3 u_upd_ph1 (.A(ps[6]), .B(phase), .C(1'b1), .Y(update_phase1));
    OR u_loadABCD (.A(ps[1]), .B(update_phase1), .C(loadABCD));

    OR u_loadF (.A(ps[3]), .B(ps[5]), .C(loadF));
    
    assign selA = ps[6];
    assign selB = ps[6];
    assign selC = ps[6];
    assign selD = ps[6];
    assign countEn = update_phase1; 

    OR u_sa1_0 (.A(ps[5]), .B(ps[6]), .C(selAdd1[0]));
    OR u_sa2_0 (.A(ps[4]), .B(ps[6]), .C(selAdd2[0]));

    assign done = ps[7];

endmodule