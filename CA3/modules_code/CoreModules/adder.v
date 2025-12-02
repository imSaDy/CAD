module Adder2 #(parameter N = 8)(
    input  [N-1:0] A, B,
    input          cin,
    output [N-1:0] Sum,
    output         cout 
);
    wire [N:0] C;
    assign C[0] = cin;
    assign cout = 1'b0;

    HA u_ha_0 (
        .A(A[0]), .B(B[0]), .S(Sum[0]), .C(C[1])
    );

    genvar i;
    generate
        for(i=1; i<N-1; i=i+1) begin : RIPPLE
            FA u_fa(
                .A(A[i]), 
                .B(B[i]), 
                .Cin(C[i]), 
                .S(Sum[i]), 
                .C(C[i+1])
            );
        end
    endgenerate

    wire t_last;
    XOR u_last_1 (.A(A[N-1]), .B(B[N-1]), .C(t_last));
    XOR u_last_2 (.A(t_last), .B(C[N-1]), .C(Sum[N-1]));

endmodule

module FA (input A, B, Cin, output S, C);
    wire t;
    XOR u_x1 (.A(A), .B(B), .C(t));
    XOR u_x2 (.A(t), .B(Cin), .C(S));
    MAJ u_c  (.A(A), .B(B), .C(Cin), .Y(C));
endmodule


module HA (input A, B, output S, C);
    XOR u_sum (.A(A), .B(B), .C(S));
    AND3 u_cy  (.A(A), .B(B), .C(1'b1), .Y(C));
endmodule

// module Adder4 #(parameter N = 8)(
//     input  [N-1:0] A, B, C, D,
//     input          cin,
//     output [N-1:0] Sum,
//     output         cout
// );
//     wire [N-1:0] S1, S2;
//     wire [N-1:0] C1, C2, C3;

//     genvar i;

//     generate
//         for(i=0;i<N;i=i+1) begin : ADD1
//             FA FA1(
//                 .A(A[i]), .B(B[i]),
//                 .Cin(i==0 ? cin : C1[i-1]),
//                 .S(S1[i]), .C(C1[i])
//             );
//         end
//     endgenerate

//     generate
//         for(i=0;i<N;i=i+1) begin : ADD2
//             FA FA2(
//                 .A(S1[i]), .B(C[i]),
//                 .Cin(i==0 ? 1'b0 : C2[i-1]),
//                 .S(S2[i]), .C(C2[i])
//             );
//         end
//     endgenerate

//     generate
//         for(i=0;i<N;i=i+1) begin : ADD3
//             FA FA3(
//                 .A(S2[i]), .B(D[i]),
//                 .Cin(i==0 ? 1'b0 : C3[i-1]),
//                 .S(Sum[i]), .C(C3[i])
//             );
//         end
//     endgenerate

//     assign cout = C3[N-1];
// endmodule

