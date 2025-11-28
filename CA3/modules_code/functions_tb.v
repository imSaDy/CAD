`timescale 1ns / 1ns

module Functions_TestBench;

    reg  [7:0] X, Y, Z, P;
    wire [7:0] F1_Res, F2_Res, F3_Res;

    // ----------------------------
    // Instantiate 8-bit functions
    // ----------------------------
    Function1 #(.WIDTH(8)) F1 (
        .X(X), .Y(Y), .Z(Z), .P(P), .Res(F1_Res)
    );

    Function2 #(.WIDTH(8)) F2 (
        .X(X), .Y(Y), .Z(Z), .Res(F2_Res)
    );

    Function3 #(.WIDTH(8)) F3 (
        .X(X), .Y(Y), .Z(Z), .Res(F3_Res)
    );

    integer i;

    initial begin
        $display("=== 8-bit Functions Testbench ===");

        // ----------------------------
        // Test 1: Zero Inputs
        // ----------------------------
        X = 0; Y = 0; Z = 0; P = 0; #10;
        $display("T1: X=%h Y=%h Z=%h P=%h | F1=%h F2=%h F3=%h",
                  X, Y, Z, P, F1_Res, F2_Res, F3_Res);

        // ----------------------------
        // Test 2: All Ones
        // ----------------------------
        X = 8'hFF; Y = 8'hFF; Z = 8'hFF; P = 8'hFF; #10;
        $display("T2: X=%h Y=%h Z=%h P=%h | F1=%h F2=%h F3=%h",
                  X, Y, Z, P, F1_Res, F2_Res, F3_Res);

        // ----------------------------
        // Test 3: Pattern Inputs
        // ----------------------------
        X = 8'hAA; Y = 8'h55; Z = 8'h0F; P = 8'hF0; #10;
        $display("T3: X=%h Y=%h Z=%h P=%h | F1=%h F2=%h F3=%h",
                  X, Y, Z, P, F1_Res, F2_Res, F3_Res);

        // ----------------------------
        // Test 4: Sweep X, Y, Z, P
        // ----------------------------
        for (i = 0; i < 16; i = i + 1) begin
            X = i;
            Y = 15 - i;
            Z = i ^ 8'h3C;
            P = i + 8'h10;
            #10;
            $display("T4[%0d]: X=%h Y=%h Z=%h P=%h | F1=%h F2=%h F3=%h",
                      i, X, Y, Z, P, F1_Res, F2_Res, F3_Res);
        end

        // ----------------------------
        // Test 5: Random Tests
        // ----------------------------
        for (i = 0; i < 10; i = i + 1) begin
            X = $random;
            Y = $random;
            Z = $random;
            P = $random;
            #10;
            $display("Rand[%0d]: X=%h Y=%h Z=%h P=%h | F1=%h F2=%h F3=%h",
                      i, X, Y, Z, P, F1_Res, F2_Res, F3_Res);
        end

        $display("=== Testbench Finished ===");
        $stop;
    end

endmodule
