`timescale 1ns/1ns

module tb_top;

  // ------------------------------------------------------------
  // REQUIRED signals 
  // ------------------------------------------------------------
  reg clk, rst, start;
  reg [31:0] i1, i2, i3;
  wire [31:0] result;
  wire done;

  top_module uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .i1(i1),
        .i2(i2),
        .i3(i3),
        .result(result),
        .done(done)
    );
  

  // ------------------------------------------------------------
  // Students: Uncomment/edit these parts based on YOUR top module,
  // datapath/controller ports, and signal names.
  // ------------------------------------------------------------

  /*
  // Example interconnect signals (edit as needed)
  wire op_ready;
  wire [3:0] alu1_sel1, alu1_sel2, alu2_sel1, alu2_sel2, mul1_sel1, mul1_sel2;
  wire alu1_op, alu2_op, mul1_op;
  wire done_next, result_en;
  wire reg_alu0_en, reg_alu1_en, reg_alu2_en, reg_mul3_en, reg_mul4_en;

  // Example outputs (edit as needed)
  wire [31:0] result;
  wire done;

  // Example DUT instantiation: datapath
  datapath DP (
    .clk(clk),
    .rst(rst),
    .i1(i1),
    .i2(i2),
    .i3(i3),
    .alu1_sel1(alu1_sel1),
    .alu1_sel2(alu1_sel2),
    .alu2_sel1(alu2_sel1),
    .alu2_sel2(alu2_sel2),
    .mul1_sel1(mul1_sel1),
    .mul1_sel2(mul1_sel2),
    .alu1_op(alu1_op),
    .alu2_op(alu2_op),
    .mul1_op(mul1_op),
    .done_next(done_next),
    .result_en(result_en),
    .reg_alu0_en(reg_alu0_en),
    .reg_alu1_en(reg_alu1_en),
    .reg_alu2_en(reg_alu2_en),
    .reg_mul3_en(reg_mul3_en),
    .reg_mul4_en(reg_mul4_en),
    .result(result),
    .done(done)
  );

  // Example DUT instantiation: controller
  controller CTRL (
    .clk(clk),
    .rst(rst),
    .start(start),
    .op_ready(op_ready),
    .alu1_sel1(alu1_sel1), .alu1_sel2(alu1_sel2),
    .alu2_sel1(alu2_sel1), .alu2_sel2(alu2_sel2),
    .mul1_sel1(mul1_sel1), .mul1_sel2(mul1_sel2),
    .alu1_op(alu1_op), .alu2_op(alu2_op),
    .mul1_op(mul1_op),
    .done_next(done_next),
    .result_en(result_en),
    .reg_alu0_en(reg_alu0_en),
    .reg_alu1_en(reg_alu1_en),
    .reg_alu2_en(reg_alu2_en),
    .reg_mul3_en(reg_mul3_en),
    .reg_mul4_en(reg_mul4_en)
  );
  */

  // ------------------------------------------------------------
  // Clock generation (10ns period)
  // ------------------------------------------------------------
  always #5 clk = ~clk;

  initial begin
    // Initialize
    clk = 0;
    rst = 1;
    start = 0;

    // Fixed test values
    i1 = 32'd1;
    i2 = 32'd2;
    i3 = 32'd3;

    // Release reset
    #12 rst = 0;

    // Start pulse
    #10 start = 1;
    #10 start = 0;

    // Let it run a bit (students can add $display checks for their outputs)
    #200;

    $display("TB finished at time %0t", $time);
    $stop;
  end

endmodule
