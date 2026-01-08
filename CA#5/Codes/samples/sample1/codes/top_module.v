module top_module(
  input clk, rst, start,
  input [31:0] i1,
  input [31:0] i2,
  input [31:0] i3,
  output [31:0] result,
  output done
);

  // Interconnect Wires
  wire op_ready;
  wire done_next, result_en;
  wire [3:0] alu1_sel1, alu1_sel2;
  wire alu1_op;
  wire [3:0] mul1_sel1, mul1_sel2;
  wire mul1_op;
  wire [3:0] log1_sel1, log1_sel2;
  wire [1:0] log1_op;
  wire reg_alu2_en;
  wire reg_mul4_en;
  wire reg_mul5_en;
  wire reg_log6_en;
  wire reg_mul7_en;
  wire reg_alu8_en;

  controller ctrl_inst (
    .clk(clk),
    .rst(rst),
    .start(start),
    .op_ready(op_ready),
    .done_next(done_next),
    .result_en(result_en),
    .alu1_sel1(alu1_sel1),
    .alu1_sel2(alu1_sel2),
    .alu1_op(alu1_op),
    .mul1_sel1(mul1_sel1),
    .mul1_sel2(mul1_sel2),
    .mul1_op(mul1_op),
    .log1_sel1(log1_sel1),
    .log1_sel2(log1_sel2),
    .log1_op(log1_op),
    .reg_alu2_en(reg_alu2_en),
    .reg_mul4_en(reg_mul4_en),
    .reg_mul5_en(reg_mul5_en),
    .reg_log6_en(reg_log6_en),
    .reg_mul7_en(reg_mul7_en),
    .reg_alu8_en(reg_alu8_en)
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
    .alu1_sel1(alu1_sel1),
    .alu1_sel2(alu1_sel2),
    .alu1_op(alu1_op),
    .mul1_sel1(mul1_sel1),
    .mul1_sel2(mul1_sel2),
    .mul1_op(mul1_op),
    .log1_sel1(log1_sel1),
    .log1_sel2(log1_sel2),
    .log1_op(log1_op),
    .reg_alu2_en(reg_alu2_en),
    .reg_mul4_en(reg_mul4_en),
    .reg_mul5_en(reg_mul5_en),
    .reg_log6_en(reg_log6_en),
    .reg_mul7_en(reg_mul7_en),
    .reg_alu8_en(reg_alu8_en)
  );
endmodule