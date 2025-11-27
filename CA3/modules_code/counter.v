module Counter_3Bit (
    input clk,
    input rst,
    input load,
    input en,
    input [2:0] PI,
    output [2:0] count
);

    wire Q_0, Q_1, Q_2; 
    assign count[0] = Q_0;
    assign count[1] = Q_1;
    assign count[2] = Q_2;
    
    wire C_0, C_1; 
    wire XOR_0, XOR_1, XOR_2;
    
    AND3 and0(
        .A(Q_0),
        .B(en),
        .C(1'b1),
        .Y(C_0)
    );

    AND3 and1(
        .A(Q_1),
        .B(C_0),
        .C(1'b1),
        .Y(C_1)
    );
    

    XOR xor0(
        .A(Q_0),
        .B(en),
        .C(XOR_0)
    );
    
    XOR xor1(
        .A(Q_1),
        .B(C_0),
        .C(XOR_1)
    );

    XOR xor2(
        .A(Q_2),
        .B(C_1),
        .C(XOR_2)
    );
        
    s2 S2_0 (
        .D00(Q_0),   
        .D01(XOR_0),  
        .D10(PI[0]),
        .D11(PI[0]),     
        .A1(load),
        .B1(1'b0),
        .A0(en),
        .B0(1'b1),
        .clr(rst), 
        .clk(clk), 
        .out(Q_0)
    );

    s2 S2_1 (
        .D00(Q_1),   
        .D01(XOR_1),  
        .D10(PI[1]),
        .D11(PI[1]),     
        .A1(load),
        .B1(1'b0),
        .A0(en),
        .B0(1'b1),
        .clr(rst), 
        .clk(clk), 
        .out(Q_1)
    );

    s2 S2_2 (
        .D00(Q_2),   
        .D01(XOR_2),  
        .D10(PI[2]),
        .D11(PI[2]),     
        .A1(load),
        .B1(1'b0),
        .A0(en),
        .B0(1'b1),
        .clr(rst), 
        .clk(clk), 
        .out(Q_2)
    );

endmodule