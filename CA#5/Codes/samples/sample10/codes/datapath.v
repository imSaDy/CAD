module datapath(
  input clk, rst,
  input [31:0] i1,
  input [31:0] i2,
  input [31:0] i3,
  input [31:0] i4,
  input [31:0] i5,
  input [31:0] i6,
  input [3:0] mul1_sel1,
  input [3:0] mul1_sel2,
  input mul1_op,
  input [3:0] mul2_sel1,
  input [3:0] mul2_sel2,
  input mul2_op,
  input [3:0] alu1_sel1,
  input [3:0] alu1_sel2,
  input alu1_op,
  input [3:0] mul3_sel1,
  input [3:0] mul3_sel2,
  input mul3_op,
  input [3:0] mul4_sel1,
  input [3:0] mul4_sel2,
  input mul4_op,
  input [3:0] log1_sel1,
  input [3:0] log1_sel2,
  input [1:0] log1_op,
  input done_next,
  input result_en,
  input reg_mul2_en,
  input reg_mul5_en,
  input reg_alu6_en,
  input reg_mul7_en,
  input reg_mul10_en,
  input reg_log11_en,
  input reg_alu12_en,
  output reg [31:0] result,
  output reg done
);

  // Wires for FU outputs
  wire [31:0] mul1_out;
  wire [31:0] mul1_op1, mul1_op2;
  wire [31:0] mul2_out;
  wire [31:0] mul2_op1, mul2_op2;
  wire [31:0] alu1_out;
  wire [31:0] alu1_op1, alu1_op2;
  wire [31:0] mul3_out;
  wire [31:0] mul3_op1, mul3_op2;
  wire [31:0] mul4_out;
  wire [31:0] mul4_op1, mul4_op2;
  wire [31:0] log1_out;
  wire [31:0] log1_op1, log1_op2;

  // Registers for intermediate values
  reg [31:0] reg_mul2;
  reg [31:0] reg_mul5;
  reg [31:0] reg_alu6;
  reg [31:0] reg_mul7;
  reg [31:0] reg_mul10;
  reg [31:0] reg_log11;
  reg [31:0] reg_alu12;

  // Muxing logic for FU inputs
  reg [31:0] mul1_op1_reg;
  always @(*) begin
    case (mul1_sel1)
      4'd2: mul1_op1_reg = i1;
      default: mul1_op1_reg = 0;
    endcase
  end
  assign mul1_op1 = mul1_op1_reg;
  reg [31:0] mul1_op2_reg;
  always @(*) begin
    case (mul1_sel2)
      4'd2: mul1_op2_reg = i2;
      default: mul1_op2_reg = 0;
    endcase
  end
  assign mul1_op2 = mul1_op2_reg;
  reg [31:0] mul2_op1_reg;
  always @(*) begin
    case (mul2_sel1)
      4'd5: mul2_op1_reg = i3;
      default: mul2_op1_reg = 0;
    endcase
  end
  assign mul2_op1 = mul2_op1_reg;
  reg [31:0] mul2_op2_reg;
  always @(*) begin
    case (mul2_sel2)
      4'd5: mul2_op2_reg = i4;
      default: mul2_op2_reg = 0;
    endcase
  end
  assign mul2_op2 = mul2_op2_reg;
  reg [31:0] alu1_op1_reg;
  always @(*) begin
    case (alu1_sel1)
      4'd6: alu1_op1_reg = reg_mul2;
      4'd12: alu1_op1_reg = reg_alu6;
      default: alu1_op1_reg = 0;
    endcase
  end
  assign alu1_op1 = alu1_op1_reg;
  reg [31:0] alu1_op2_reg;
  always @(*) begin
    case (alu1_sel2)
      4'd6: alu1_op2_reg = reg_mul5;
      4'd12: alu1_op2_reg = reg_log11;
      default: alu1_op2_reg = 0;
    endcase
  end
  assign alu1_op2 = alu1_op2_reg;
  reg [31:0] mul3_op1_reg;
  always @(*) begin
    case (mul3_sel1)
      4'd7: mul3_op1_reg = i1;
      default: mul3_op1_reg = 0;
    endcase
  end
  assign mul3_op1 = mul3_op1_reg;
  reg [31:0] mul3_op2_reg;
  always @(*) begin
    case (mul3_sel2)
      4'd7: mul3_op2_reg = i2;
      default: mul3_op2_reg = 0;
    endcase
  end
  assign mul3_op2 = mul3_op2_reg;
  reg [31:0] mul4_op1_reg;
  always @(*) begin
    case (mul4_sel1)
      4'd10: mul4_op1_reg = i5;
      default: mul4_op1_reg = 0;
    endcase
  end
  assign mul4_op1 = mul4_op1_reg;
  reg [31:0] mul4_op2_reg;
  always @(*) begin
    case (mul4_sel2)
      4'd10: mul4_op2_reg = i6;
      default: mul4_op2_reg = 0;
    endcase
  end
  assign mul4_op2 = mul4_op2_reg;
  reg [31:0] log1_op1_reg;
  always @(*) begin
    case (log1_sel1)
      4'd11: log1_op1_reg = reg_mul7;
      default: log1_op1_reg = 0;
    endcase
  end
  assign log1_op1 = log1_op1_reg;
  reg [31:0] log1_op2_reg;
  always @(*) begin
    case (log1_sel2)
      4'd11: log1_op2_reg = reg_mul10;
      default: log1_op2_reg = 0;
    endcase
  end
  assign log1_op2 = log1_op2_reg;

  // Functional Units
  // MUL Unit 1
  reg [31:0] mul1_out_reg;
  always @(*) begin
    case (mul1_op)
      1'b0: mul1_out_reg = mul1_op1 * mul1_op2;
      1'b1: mul1_out_reg = mul1_op1 / mul1_op2;
    endcase
  end
  assign mul1_out = mul1_out_reg;
  // MUL Unit 2
  reg [31:0] mul2_out_reg;
  always @(*) begin
    case (mul2_op)
      1'b0: mul2_out_reg = mul2_op1 * mul2_op2;
      1'b1: mul2_out_reg = mul2_op1 / mul2_op2;
    endcase
  end
  assign mul2_out = mul2_out_reg;
  // ALU Unit 1
  reg [31:0] alu1_out_reg;
  always @(*) begin
    case (alu1_op)
      1'b0: alu1_out_reg = alu1_op1 + alu1_op2;
      1'b1: alu1_out_reg = alu1_op1 - alu1_op2;
    endcase
  end
  assign alu1_out = alu1_out_reg;
  // MUL Unit 3
  reg [31:0] mul3_out_reg;
  always @(*) begin
    case (mul3_op)
      1'b0: mul3_out_reg = mul3_op1 * mul3_op2;
      1'b1: mul3_out_reg = mul3_op1 / mul3_op2;
    endcase
  end
  assign mul3_out = mul3_out_reg;
  // MUL Unit 4
  reg [31:0] mul4_out_reg;
  always @(*) begin
    case (mul4_op)
      1'b0: mul4_out_reg = mul4_op1 * mul4_op2;
      1'b1: mul4_out_reg = mul4_op1 / mul4_op2;
    endcase
  end
  assign mul4_out = mul4_out_reg;
  // LOG Unit 1
  reg [31:0] log1_out_reg;
  always @(*) begin
    case (log1_op)
      2'b00: log1_out_reg = log1_op1 & log1_op2;
      2'b01: log1_out_reg = log1_op1 | log1_op2;
    endcase
  end
  assign log1_out = log1_out_reg;

  // Register update logic
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      reg_mul2 <= 0;
      reg_mul5 <= 0;
      reg_alu6 <= 0;
      reg_mul7 <= 0;
      reg_mul10 <= 0;
      reg_log11 <= 0;
      reg_alu12 <= 0;
      result <= 0;
      done <= 0;
    end else begin
      done <= done_next;
      if (reg_mul2_en) reg_mul2 <= mul1_out;
      if (reg_mul5_en) reg_mul5 <= mul2_out;
      if (reg_alu6_en) reg_alu6 <= alu1_out;
      if (reg_mul7_en) reg_mul7 <= mul3_out;
      if (reg_mul10_en) reg_mul10 <= mul4_out;
      if (reg_log11_en) reg_log11 <= log1_out;
      if (reg_alu12_en) reg_alu12 <= alu1_out;
      if (result_en) result <= alu1_out;
    end
  end
endmodule