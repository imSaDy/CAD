module datapath(
  input clk, rst,
  input [31:0] i1,
  input [31:0] i2,
  input [31:0] i3,
  input [31:0] i4,
  input [31:0] i5,
  input [31:0] i6,
  input [31:0] i7,
  input [31:0] i8,
  input [3:0] alu1_sel1,
  input [3:0] alu1_sel2,
  input alu1_op,
  input [3:0] alu2_sel1,
  input [3:0] alu2_sel2,
  input alu2_op,
  input [3:0] alu3_sel1,
  input [3:0] alu3_sel2,
  input alu3_op,
  input [3:0] alu4_sel1,
  input [3:0] alu4_sel2,
  input alu4_op,
  input done_next,
  input result_en,
  input reg_alu2_en,
  input reg_alu5_en,
  input reg_alu6_en,
  input reg_alu9_en,
  input reg_alu12_en,
  input reg_alu13_en,
  input reg_alu14_en,
  output reg [31:0] result,
  output reg done
);

  // Wires for FU outputs
  wire [31:0] alu1_out;
  wire [31:0] alu1_op1, alu1_op2;
  wire [31:0] alu2_out;
  wire [31:0] alu2_op1, alu2_op2;
  wire [31:0] alu3_out;
  wire [31:0] alu3_op1, alu3_op2;
  wire [31:0] alu4_out;
  wire [31:0] alu4_op1, alu4_op2;

  // Registers for intermediate values
  reg [31:0] reg_alu2;
  reg [31:0] reg_alu5;
  reg [31:0] reg_alu6;
  reg [31:0] reg_alu9;
  reg [31:0] reg_alu12;
  reg [31:0] reg_alu13;
  reg [31:0] reg_alu14;

  // Muxing logic for FU inputs
  reg [31:0] alu1_op1_reg;
  always @(*) begin
    case (alu1_sel1)
      4'd2: alu1_op1_reg = i1;
      4'd6: alu1_op1_reg = reg_alu2;
      4'd14: alu1_op1_reg = reg_alu6;
      default: alu1_op1_reg = 0;
    endcase
  end
  assign alu1_op1 = alu1_op1_reg;
  reg [31:0] alu1_op2_reg;
  always @(*) begin
    case (alu1_sel2)
      4'd2: alu1_op2_reg = i2;
      4'd6: alu1_op2_reg = reg_alu5;
      4'd14: alu1_op2_reg = reg_alu13;
      default: alu1_op2_reg = 0;
    endcase
  end
  assign alu1_op2 = alu1_op2_reg;
  reg [31:0] alu2_op1_reg;
  always @(*) begin
    case (alu2_sel1)
      4'd5: alu2_op1_reg = i3;
      4'd13: alu2_op1_reg = reg_alu9;
      default: alu2_op1_reg = 0;
    endcase
  end
  assign alu2_op1 = alu2_op1_reg;
  reg [31:0] alu2_op2_reg;
  always @(*) begin
    case (alu2_sel2)
      4'd5: alu2_op2_reg = i4;
      4'd13: alu2_op2_reg = reg_alu12;
      default: alu2_op2_reg = 0;
    endcase
  end
  assign alu2_op2 = alu2_op2_reg;
  reg [31:0] alu3_op1_reg;
  always @(*) begin
    case (alu3_sel1)
      4'd9: alu3_op1_reg = i5;
      default: alu3_op1_reg = 0;
    endcase
  end
  assign alu3_op1 = alu3_op1_reg;
  reg [31:0] alu3_op2_reg;
  always @(*) begin
    case (alu3_sel2)
      4'd9: alu3_op2_reg = i6;
      default: alu3_op2_reg = 0;
    endcase
  end
  assign alu3_op2 = alu3_op2_reg;
  reg [31:0] alu4_op1_reg;
  always @(*) begin
    case (alu4_sel1)
      4'd12: alu4_op1_reg = i7;
      default: alu4_op1_reg = 0;
    endcase
  end
  assign alu4_op1 = alu4_op1_reg;
  reg [31:0] alu4_op2_reg;
  always @(*) begin
    case (alu4_sel2)
      4'd12: alu4_op2_reg = i8;
      default: alu4_op2_reg = 0;
    endcase
  end
  assign alu4_op2 = alu4_op2_reg;

  // Functional Units
  // ALU Unit 1
  reg [31:0] alu1_out_reg;
  always @(*) begin
    case (alu1_op)
      1'b0: alu1_out_reg = alu1_op1 + alu1_op2;
      1'b1: alu1_out_reg = alu1_op1 - alu1_op2;
    endcase
  end
  assign alu1_out = alu1_out_reg;
  // ALU Unit 2
  reg [31:0] alu2_out_reg;
  always @(*) begin
    case (alu2_op)
      1'b0: alu2_out_reg = alu2_op1 + alu2_op2;
      1'b1: alu2_out_reg = alu2_op1 - alu2_op2;
    endcase
  end
  assign alu2_out = alu2_out_reg;
  // ALU Unit 3
  reg [31:0] alu3_out_reg;
  always @(*) begin
    case (alu3_op)
      1'b0: alu3_out_reg = alu3_op1 + alu3_op2;
      1'b1: alu3_out_reg = alu3_op1 - alu3_op2;
    endcase
  end
  assign alu3_out = alu3_out_reg;
  // ALU Unit 4
  reg [31:0] alu4_out_reg;
  always @(*) begin
    case (alu4_op)
      1'b0: alu4_out_reg = alu4_op1 + alu4_op2;
      1'b1: alu4_out_reg = alu4_op1 - alu4_op2;
    endcase
  end
  assign alu4_out = alu4_out_reg;

  // Register update logic
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      reg_alu2 <= 0;
      reg_alu5 <= 0;
      reg_alu6 <= 0;
      reg_alu9 <= 0;
      reg_alu12 <= 0;
      reg_alu13 <= 0;
      reg_alu14 <= 0;
      result <= 0;
      done <= 0;
    end else begin
      done <= done_next;
      if (reg_alu2_en) reg_alu2 <= alu1_out;
      if (reg_alu5_en) reg_alu5 <= alu2_out;
      if (reg_alu6_en) reg_alu6 <= alu1_out;
      if (reg_alu9_en) reg_alu9 <= alu3_out;
      if (reg_alu12_en) reg_alu12 <= alu4_out;
      if (reg_alu13_en) reg_alu13 <= alu2_out;
      if (reg_alu14_en) reg_alu14 <= alu1_out;
      if (result_en) result <= alu1_out;
    end
  end
endmodule