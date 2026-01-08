`timescale 1ns/1ns

module tb_top;

  // ------------------------------------------------------------
  // REQUIRED signals 
  // ------------------------------------------------------------
  reg clk, rst, start;

  // Fixed inputs
  reg [31:0] i1, i2, i3, i4;
  wire [31:0] result;
  wire done;

  top_module uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .i1(i1),
        .i2(i2),
        .i3(i3),
        .i4(i4),
        .result(result),
        .done(done)
    );

  // ------------------------------------------------------------
  // Students: Uncomment/edit these parts based on YOUR modules,
  // ports, and signal names. (Left commented for flexibility.)
  // ------------------------------------------------------------
  /*
  // Example interconnect wires (edit as needed)
  wire op_ready;
  wire [3:0] alu1_sel1, alu1_sel2, alu2_sel1, alu2_sel2;
  wire [3:0] log1_sel1, log1_sel2, mul1_sel1, mul1_sel2;
  wire alu1_op, alu2_op, mul1_op;
  wire [1:0] log1_op;
  wire done_next, result_en;
  wire reg_alu3_en, reg_alu4_en, reg_alu6_en, reg_log0_en, reg_log5_en;
  wire reg_mul1_en, reg_mul2_en, reg_mul7_en;

  // Example outputs (edit as needed)
  wire [31:0] result;
  wire done;

  // Example DUT instantiation: datapath
  datapath DP (
    .clk(clk), .rst(rst),
    .i1(i1), .i2(i2), .i3(i3), .i4(i4),
    .alu1_sel1(alu1_sel1), .alu1_sel2(alu1_sel2),
    .alu2_sel1(alu2_sel1), .alu2_sel2(alu2_sel2),
    .log1_sel1(log1_sel1), .log1_sel2(log1_sel2),
    .mul1_sel1(mul1_sel1), .mul1_sel2(mul1_sel2),
    .alu1_op(alu1_op), .alu2_op(alu2_op),
    .log1_op(log1_op),
    .mul1_op(mul1_op),
    .done_next(done_next), .result_en(result_en),
    .reg_alu3_en(reg_alu3_en), .reg_alu4_en(reg_alu4_en), .reg_alu6_en(reg_alu6_en),
    .reg_log0_en(reg_log0_en), .reg_log5_en(reg_log5_en),
    .reg_mul1_en(reg_mul1_en), .reg_mul2_en(reg_mul2_en), .reg_mul7_en(reg_mul7_en),
    .result(result), .done(done)
  );

  // Example DUT instantiation: controller
  controller CTRL (
    .clk(clk), .rst(rst), .start(start),
    .op_ready(op_ready),
    .alu1_sel1(alu1_sel1), .alu1_sel2(alu1_sel2),
    .alu2_sel1(alu2_sel1), .alu2_sel2(alu2_sel2),
    .log1_sel1(log1_sel1), .log1_sel2(log1_sel2),
    .mul1_sel1(mul1_sel1), .mul1_sel2(mul1_sel2),
    .alu1_op(alu1_op), .alu2_op(alu2_op),
    .log1_op(log1_op),
    .mul1_op(mul1_op),
    .done_next(done_next), .result_en(result_en),
    .reg_alu3_en(reg_alu3_en), .reg_alu4_en(reg_alu4_en), .reg_alu6_en(reg_alu6_en),
    .reg_log0_en(reg_log0_en), .reg_log5_en(reg_log5_en),
    .reg_mul1_en(reg_mul1_en), .reg_mul2_en(reg_mul2_en), .reg_mul7_en(reg_mul7_en)
  );
  */

  // ------------------------------------------------------------
  // Clock generation (10ns period)
  // ------------------------------------------------------------
  always #5 clk = ~clk;

  initial begin
    // Initialize
    clk   = 0;
    rst   = 1;
    start = 0;

    // Set fixed test values
    i1 = 32'd1;
    i2 = 32'd2;
    i3 = 32'd3;
    i4 = 32'd4;

    // Release reset
    #12 rst = 0;

    // Start pulse
    #10 start = 1;
    #10 start = 0;

    // Run for enough cycles (students can add checks/displays)
    #300;

    $display("TB finished at time %0t", $time);
    $stop;
  end

endmodule
