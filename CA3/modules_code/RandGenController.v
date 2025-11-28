module RandGenController(
    input clk, 
    input rst, 
    input start_rnd, 
    input co, 
    output done_rnd, 
    output loadC, 
    output loadR, 
    output countEn, 
    output shiftEn
);

    wire [3:0] ps;       
    wire shift_trigger; 

    ShiftRegister #(.WIDTH(4)) state_reg (
        .clk(clk),
        .rst(1'b0),          
        .load(rst),          
        .shiftEn(shift_trigger),
        .ser_in(ps[3]),
        .PI(4'b0001),        
        .twoMSB(),           
        .Q(ps)
    );

    c1 logic_inst (
        .A0(ps[1]),       
        .A1(ps[0]),       
        .SA(start_rnd),  
        .B0(co),         
        .B1(1'b1),       
        .SB(ps[3]),       
        .S0(ps[3]),       
        .S1(ps[2]),       
        .f(shift_trigger)
    );

    assign loadC = ps[1]; 
    assign loadR = ps[1]; 
    assign countEn = ps[2]; 
    assign shiftEn = ps[2]; 
    assign done_rnd = ps[3]; 

endmodule