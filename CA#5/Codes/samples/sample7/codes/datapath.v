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
  input [3:0] mul1_sel1,
  input [3:0] mul1_sel2,
  input mul1_op,
  input [3:0] log1_sel1,
  input [3:0] log1_sel2,
  input [1:0] log1_op,
  input [3:0] log2_sel1,
  input [3:0] log2_sel2,
  input [1:0] log2_op,
  input done_next,
  input result_en,
  input reg_mul2_en,
  input reg_mul4_en,
  input reg_mul6_en,
  input reg_log9_en,
  input reg_log10_en,
  input reg_log13_en,
  input reg_log14_en,
  output reg [31:0] result,
  output reg done
);

  // Wires for FU outputs
  wire [31:0] mul1_out;
  wire [31:0] mul1_op1, mul1_op2;
  wire [31:0] log1_out;
  wire [31:0] log1_op1, log1_op2;
  wire [31:0] log2_out;
  wire [31:0] log2_op1, log2_op2;

  // Registers for intermediate values
  reg [31:0] reg_mul2;
  reg [31:0] reg_mul4;
  reg [31:0] reg_mul6;
  reg [31:0] reg_log9;
  reg [31:0] reg_log10;
  reg [31:0] reg_log13;
  reg [31:0] reg_log14;

  // Muxing logic for FU inputs
  reg [31:0] mul1_op1_reg;
  always @(*) begin
    case (mul1_sel1)
      4'd2: mul1_op1_reg = i1;
      4'd4: mul1_op1_reg = reg_mul2;
      4'd6: mul1_op1_reg = reg_mul4;
      default: mul1_op1_reg = 0;
    endcase
  end
  assign mul1_op1 = mul1_op1_reg;
  reg [31:0] mul1_op2_reg;
  always @(*) begin
    case (mul1_sel2)
      4'd2: mul1_op2_reg = i2;
      4'd4: mul1_op2_reg = i3;
      4'd6: mul1_op2_reg = i4;
      default: mul1_op2_reg = 0;
    endcase
  end
  assign mul1_op2 = mul1_op2_reg;
  reg [31:0] log1_op1_reg;
  always @(*) begin
    case (log1_sel1)
      4'd9: log1_op1_reg = i5;
      4'd10: log1_op1_reg = reg_mul6;
      4'd14: log1_op1_reg = reg_log10;
      default: log1_op1_reg = 0;
    endcase
  end
  assign log1_op1 = log1_op1_reg;
  reg [31:0] log1_op2_reg;
  always @(*) begin
    case (log1_sel2)
      4'd9: log1_op2_reg = i6;
      4'd10: log1_op2_reg = reg_log9;
      4'd14: log1_op2_reg = reg_log13;
      default: log1_op2_reg = 0;
    endcase
  end
  assign log1_op2 = log1_op2_reg;
  reg [31:0] log2_op1_reg;
  always @(*) begin
    case (log2_sel1)
      4'd13: log2_op1_reg = i7;
      default: log2_op1_reg = 0;
    endcase
  end
  assign log2_op1 = log2_op1_reg;
  reg [31:0] log2_op2_reg;
  always @(*) begin
    case (log2_sel2)
      4'd13: log2_op2_reg = i8;
      default: log2_op2_reg = 0;
    endcase
  end
  assign log2_op2 = log2_op2_reg;

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
  // LOG Unit 1
  reg [31:0] log1_out_reg;
  always @(*) begin
    case (log1_op)
      2'b00: log1_out_reg = log1_op1 & log1_op2;
      2'b01: log1_out_reg = log1_op1 | log1_op2;
    endcase
  end
  assign log1_out = log1_out_reg;
  // LOG Unit 2
  reg [31:0] log2_out_reg;
  always @(*) begin
    case (log2_op)
      2'b00: log2_out_reg = log2_op1 & log2_op2;
      2'b01: log2_out_reg = log2_op1 | log2_op2;
    endcase
  end
  assign log2_out = log2_out_reg;

  // Register update logic
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      reg_mul2 <= 0;
      reg_mul4 <= 0;
      reg_mul6 <= 0;
      reg_log9 <= 0;
      reg_log10 <= 0;
      reg_log13 <= 0;
      reg_log14 <= 0;
      result <= 0;
      done <= 0;
    end else begin
      done <= done_next;
      if (reg_mul2_en) reg_mul2 <= mul1_out;
      if (reg_mul4_en) reg_mul4 <= mul1_out;
      if (reg_mul6_en) reg_mul6 <= mul1_out;
      if (reg_log9_en) reg_log9 <= log1_out;
      if (reg_log10_en) reg_log10 <= log1_out;
      if (reg_log13_en) reg_log13 <= log2_out;
      if (reg_log14_en) reg_log14 <= log1_out;
      if (result_en) result <= log1_out;
    end
  end
endmodule