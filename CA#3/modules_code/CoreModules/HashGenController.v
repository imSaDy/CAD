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

    wire [6:0] ps; 
    
    wire phase, phase_next;
    NOT not_phase(phase, phase_next);
    s2 phase_ff (
        .D00(phase), .D01(phase_next), .D10(1'b0), .D11(1'b0),
        .A1(1'b0), .B1(1'b0), .A0(1'b1), .B0(1'b1), 
        .clr(rst), .clk(clk), .out(phase)
    );

    wire state_2_or_6;
    OR u_opt1 (.A(ps[2]), .B(ps[6]), .C(state_2_or_6));

    wire state_2_or_4;
    OR u_opt2 (.A(ps[2]), .B(ps[4]), .C(state_2_or_4));

    wire wait_start, wait_pulse, wait_rnd, check_co;
    wire auto_shift;
    
    c1 c1_start (.A0(1'b0), .A1(ps[0]), .SA(start), .B0(1'b0), .B1(1'b0), .SB(1'b0), .S0(1'b0), .S1(1'b0), .f(wait_start));
    c1 c1_pulse (.A0(ps[1]), .A1(1'b0), .SA(start), .B0(1'b0), .B1(1'b0), .SB(1'b0), .S0(1'b0), .S1(1'b0), .f(wait_pulse));
    c1 c1_rnd   (.A0(1'b0), .A1(ps[3]), .SA(done_rnd), .B0(1'b0), .B1(1'b0), .SB(1'b0), .S0(1'b0), .S1(1'b0), .f(wait_rnd));

    wire co_ph;
    AND3 u_co_ph (.A(co), .B(phase), .C(1'b1), .Y(co_ph));
    c1 c1_co    (.A0(1'b0), .A1(ps[6]), .SA(co_ph), .B0(1'b0), .B1(1'b0), .SB(1'b0), .S0(1'b0), .S1(1'b0), .f(check_co));

    c1 u_auto_opt (
        .A0(ps[5]), .A1(1'b0), .SA(1'b0),
        .B0(1'b1), .B1(1'b1), .SB(1'b0), 
        .S0(ps[2]), .S1(ps[4]),
        .f(auto_shift)
    );

    wire shift_trigger;
    wire shift_grp1;
    
    c1 u_sh_grp1 (
        .A0(check_co), .A1(1'b1), .SA(wait_rnd),
        .B0(1'b1), .B1(1'b1), .SB(1'b0),        
        .S0(wait_start), .S1(wait_pulse),       
        .f(shift_grp1)
    );

    OR u_sh_final (.A(shift_grp1), .B(auto_shift), .C(shift_trigger));

    wire not_co, jump_cond;
    NOT u_not_co(co, not_co);
    AND3 u_jump_cond(.A(ps[6]), .B(not_co), .C(phase), .Y(jump_cond));

    wire any_low, any_high, has_any_1;
    wire reset_detect;

    wire done_cond_mealy; 
    AND3 u_done_mealy (.A(ps[6]), .B(shift_trigger), .C(1'b1), .Y(done_cond_mealy)); 
    assign done = done_cond_mealy;

    c1 u_any_low (
        .A0(ps[3]), .A1(1'b1), .SA(ps[2]), 
        .B0(1'b1), .B1(1'b1), .SB(1'b0), 
        .S0(ps[0]), .S1(ps[1]), 
        .f(any_low)
    );

    c1 u_any_high (
        .A0(ps[6]), .A1(1'b1), .SA(ps[5]), 
        .B0(1'b1), .B1(1'b1), .SB(1'b0), 
        .S0(ps[4]), .S1(1'b0), 
        .f(any_high)
    );

    c1 u_nor_final (
        .A0(1'b1), .A1(1'b0), .SA(any_high),
        .B0(1'b0), .B1(1'b0), .SB(1'b0),     
        .S0(any_low), .S1(1'b0),
        .f(reset_detect)
    );

    wire next_idle;
    OR u_next_idle (.A(reset_detect), .B(done_cond_mealy), .C(next_idle));

    wire load_trigger;
    OR u_ld_final (.A(jump_cond), .B(next_idle), .C(load_trigger));

    wire [6:0] PI;
    assign PI = {4'b0, jump_cond, 1'b0, next_idle};

    ShiftRegister #(.WIDTH(7)) state_reg (
        .clk(clk), .rst(rst), .load(load_trigger), .shiftEn(shift_trigger),
        .ser_in(1'b0), .PI(PI), .twoMSB(), .Q(ps)
    );

    assign selAdd1[1] = state_2_or_6;
    assign selAdd2[1] = state_2_or_6;
    assign loadAcc    = state_2_or_4;

    assign loadM = ps[2];
    assign start_rnd = ps[2];
    assign selF = ps[5];
    
    c1 u_opt_loadABCD (
        .A0(1'b0), .A1(phase), .SA(ps[6]),
        .B0(1'b1), .B1(1'b1), .SB(1'b0),
        .S0(ps[1]), .S1(1'b0),
        .f(loadABCD)
    );

    OR u_loadF (.A(ps[3]), .B(ps[5]), .C(loadF));
    
    assign selA = ps[6];
    assign selB = ps[6];
    assign selC = ps[6];
    assign selD = ps[6];
    
    AND3 u_upd_ph1 (.A(ps[6]), .B(phase), .C(1'b1), .Y(countEn));

    OR u_sa1_0 (.A(ps[5]), .B(ps[6]), .C(selAdd1[0]));
    OR u_sa2_0 (.A(ps[4]), .B(ps[6]), .C(selAdd2[0]));

endmodule