module top_module(
  input clk, rst, start,
  input [31:0] i1,
  input [31:0] i2,
  input [31:0] i3,
  input [31:0] i4,
  output [31:0] result,
  output done
);

  // Interconnect Wires
  wire op_ready;
  wire done_next, result_en;
  wire [3:0] log1_sel1, log1_sel2;
  wire [1:0] log1_op;
  wire [3:0] mul1_sel1, mul1_sel2;
  wire mul1_op;
  wire [3:0] alu1_sel1, alu1_sel2;
  wire alu1_op;
  wire [3:0] alu2_sel1, alu2_sel2;
  wire alu2_op;
  wire reg_log3_en;
  wire reg_mul5_en;
  wire reg_mul6_en;
  wire reg_alu7_en;
  wire reg_alu8_en;
  wire reg_log9_en;
  wire reg_alu10_en;
  wire reg_mul11_en;

  controller ctrl_inst (
    .clk(clk),
    .rst(rst),
    .start(start),
    .op_ready(op_ready),
    .done_next(done_next),
    .result_en(result_en),
    .log1_sel1(log1_sel1),
    .log1_sel2(log1_sel2),
    .log1_op(log1_op),
    .mul1_sel1(mul1_sel1),
    .mul1_sel2(mul1_sel2),
    .mul1_op(mul1_op),
    .alu1_sel1(alu1_sel1),
    .alu1_sel2(alu1_sel2),
    .alu1_op(alu1_op),
    .alu2_sel1(alu2_sel1),
    .alu2_sel2(alu2_sel2),
    .alu2_op(alu2_op),
    .reg_log3_en(reg_log3_en),
    .reg_mul5_en(reg_mul5_en),
    .reg_mul6_en(reg_mul6_en),
    .reg_alu7_en(reg_alu7_en),
    .reg_alu8_en(reg_alu8_en),
    .reg_log9_en(reg_log9_en),
    .reg_alu10_en(reg_alu10_en),
    .reg_mul11_en(reg_mul11_en)
  );

  datapath dp_inst (
    .clk(clk),
    .rst(rst),
    .done_next(done_next),
    .result_en(result_en),
    .result(result),
    .done(done),
    .i1(i1),
    .i2(i2),
    .i3(i3),
    .i4(i4),
    .log1_sel1(log1_sel1),
    .log1_sel2(log1_sel2),
    .log1_op(log1_op),
    .mul1_sel1(mul1_sel1),
    .mul1_sel2(mul1_sel2),
    .mul1_op(mul1_op),
    .alu1_sel1(alu1_sel1),
    .alu1_sel2(alu1_sel2),
    .alu1_op(alu1_op),
    .alu2_sel1(alu2_sel1),
    .alu2_sel2(alu2_sel2),
    .alu2_op(alu2_op),
    .reg_log3_en(reg_log3_en),
    .reg_mul5_en(reg_mul5_en),
    .reg_mul6_en(reg_mul6_en),
    .reg_alu7_en(reg_alu7_en),
    .reg_alu8_en(reg_alu8_en),
    .reg_log9_en(reg_log9_en),
    .reg_alu10_en(reg_alu10_en),
    .reg_mul11_en(reg_mul11_en)
  );
endmodule