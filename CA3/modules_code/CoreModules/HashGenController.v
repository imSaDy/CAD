module HashGenController (
    input clk,
    input rst,
    input start,
    input done_rnd,
    input co,
    output reg start_rnd,
    output reg countEn,
    output reg loadABCD,
    output reg loadM,
    output reg loadF,
    output reg selF,
    output reg selA,
    output reg selB,
    output reg selC,
    output reg selD,
    output reg done
);
    wire [6:0] ps;
    wire inter_connection;  
    wire shift_trigger; 
    wire load_trigger;
    wire PI_2, PI_0;

    assign PI_0 = rst;

    c1 c1_1(
        .A0(ps[1]),       
        .A1(ps[0]),       
        .SA(start),  
        .B0(done_rnd),         
        .B1(co),       
        .SB(ps[5]),       
        .S0(ps[3]),       
        .S1(ps[5]),       
        .f(inter_connection)
    );

    c1 c1_2(
        .A0(inter_connection),       
        .A1(1'b1),       
        .SA(p[6]),  
        .B0(1'b1),         
        .B1(1'b0),       
        .SB(1'b0),       
        .S0(ps[2]),       
        .S1(ps[4]),       
        .f(shift_trigger)
    );

    c1 c1_3(
        .A0(1'b0),       
        .A1(1'b1),       
        .SA(rst),  
        .B0(1'b1),         
        .B1(1'b0),       
        .SB(co),       
        .S0(1'b0),       
        .S1(ps[5]),       
        .f(load_trigger)
    );


    c1 c1_4(
        .A0(1'b0),       
        .A1(1'b1),       
        .SA(ps[5]),  
        .B0(1'b0),         
        .B1(1'b1),       
        .SB(1'b0),       
        .S0(rst),       
        .S1(0),       
        .f(PI_2)
    );

    ShiftRegister #(.WIDTH(7)) state_reg (
        .clk(clk),
        .rst(rst),          
        .load(load_trigger),          
        .shiftEn(shift_trigger),
        .ser_in(ps[6]),
        .PI({4'b0, PI_2, 1'b0, PI_0}),        
        .twoMSB(),           
        .Q(ps)
    );

    // NOR4 nor1 (
    //     .A(ps[0]), 
    //     .B(ps[1]), 
    //     .C(ps[2]), 
    //     .D(ps[3]), 
    //     .Y(load_trigger)
    // );

    OR or_1(
        .A(ps[1]),
        .B(ps[5]),
        .C(loadABCD)
    );

    OR or_1(
        .A(ps[3]),
        .B(ps[4]),
        .C(loadF)
    );

    assign loadM = ps[2]; 
    assign start_rnd = ps[2]; 
    assign selF = ps[4];
    assign countEn = ps[5];
    assign selA = ps[5];
    assign selB = ps[5];
    assign selC = ps[5];
    assign selD = ps[5];  
    assign done = ps[6]; 

endmodule