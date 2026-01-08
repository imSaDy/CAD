module datapath(
  input clk, rst,
  input [31:0] i1,
  input [31:0] i2,
  input [31:0] i3,
  input [3:0] alu1_sel1,
  input [3:0] alu1_sel2,
  input alu1_op,
  input [3:0] mul1_sel1,
  input [3:0] mul1_sel2,
  input mul1_op,
  input [3:0] log1_sel1,
  input [3:0] log1_sel2,
  input [1:0] log1_op,
  input done_next,
  input result_en,
  input reg_alu2_en,
  input reg_mul4_en,
  input reg_mul5_en,
  input reg_log6_en,
  input reg_mul7_en,
  input reg_alu8_en,
  output reg [31:0] result,
  output reg done
);

  // Wires for FU outputs
  wire [31:0] alu1_out;
  wire [31:0] alu1_op1, alu1_op2;
  wire [31:0] mul1_out;
  wire [31:0] mul1_op1, mul1_op2;
  wire [31:0] log1_out;
  wire [31:0] log1_op1, log1_op2;

  // Registers for intermediate values
  reg [31:0] reg_alu2;
  reg [31:0] reg_mul4;
  reg [31:0] reg_mul5;
  reg [31:0] reg_log6;
  reg [31:0] reg_mul7;
  reg [31:0] reg_alu8;

  // Muxing logic for FU inputs
  reg [31:0] alu1_op1_reg;
  always @(*) begin
    case (alu1_sel1)
      4'd2: alu1_op1_reg = i1;
      4'd8: alu1_op1_reg = reg_mul5;
      default: alu1_op1_reg = 0;
    endcase
  end
  assign alu1_op1 = alu1_op1_reg;
  reg [31:0] alu1_op2_reg;
  always @(*) begin
    case (alu1_sel2)
      4'd2: alu1_op2_reg = i2;
      4'd8: alu1_op2_reg = reg_mul7;
      default: alu1_op2_reg = 0;
    endcase
  end
  assign alu1_op2 = alu1_op2_reg;
  reg [31:0] mul1_op1_reg;
  always @(*) begin
    case (mul1_sel1)
      4'd4: mul1_op1_reg = i1;
      4'd5: mul1_op1_reg = reg_alu2;
      4'd7: mul1_op1_reg = reg_log6;
      default: mul1_op1_reg = 0;
    endcase
  end
  assign mul1_op1 = mul1_op1_reg;
  reg [31:0] mul1_op2_reg;
  always @(*) begin
    case (mul1_sel2)
      4'd4: mul1_op2_reg = i3;
      4'd5: mul1_op2_reg = reg_mul4;
      4'd7: mul1_op2_reg = i1;
      default: mul1_op2_reg = 0;
    endcase
  end
  assign mul1_op2 = mul1_op2_reg;
  reg [31:0] log1_op1_reg;
  always @(*) begin
    case (log1_sel1)
      4'd6: log1_op1_reg = i2;
      default: log1_op1_reg = 0;
    endcase
  end
  assign log1_op1 = log1_op1_reg;
  reg [31:0] log1_op2_reg;
  always @(*) begin
    case (log1_sel2)
      4'd6: log1_op2_reg = i3;
      default: log1_op2_reg = 0;
    endcase
  end
  assign log1_op2 = log1_op2_reg;

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

  // Register update logic
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      reg_alu2 <= 0;
      reg_mul4 <= 0;
      reg_mul5 <= 0;
      reg_log6 <= 0;
      reg_mul7 <= 0;
      reg_alu8 <= 0;
      result <= 0;
      done <= 0;
    end else begin
      done <= done_next;
      if (reg_alu2_en) reg_alu2 <= alu1_out;
      if (reg_mul4_en) reg_mul4 <= mul1_out;
      if (reg_mul5_en) reg_mul5 <= mul1_out;
      if (reg_log6_en) reg_log6 <= log1_out;
      if (reg_mul7_en) reg_mul7 <= mul1_out;
      if (reg_alu8_en) reg_alu8 <= alu1_out;
      if (result_en) result <= alu1_out;
    end
  end
endmodule