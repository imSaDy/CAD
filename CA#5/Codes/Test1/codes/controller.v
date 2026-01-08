module controller(
  input clk, rst, start,
  output reg op_ready,
  output reg [3:0] alu1_sel1, alu1_sel2,
  output reg alu1_op,
  output reg [3:0] alu2_sel1, alu2_sel2,
  output reg alu2_op,
  output reg [3:0] mul1_sel1, mul1_sel2,
  output reg mul1_op,
  output reg done_next, result_en,
  output reg reg_alu2_en,
  output reg reg_alu4_en,
  output reg reg_alu5_en,
  output reg reg_mul6_en,
  output reg reg_mul7_en
);
  reg [3:0] state, next_state;
  localparam S_IDLE = 0;
  localparam S_DONE = 4;
  localparam S_CYCLE_1 = 1;
  localparam S_CYCLE_2 = 2;
  localparam S_CYCLE_3 = 3;

  always @(posedge clk or posedge rst) begin
    if (rst) state <= S_IDLE;
    else state <= next_state;
  end

  always @(*) begin
    op_ready = 0; next_state = state;
    done_next = 0; result_en = 0;
    reg_alu2_en = 0;
    reg_alu4_en = 0;
    reg_alu5_en = 0;
    reg_mul6_en = 0;
    reg_mul7_en = 0;
    alu1_sel1 = 0; alu1_sel2 = 0; alu1_op = 0;
    alu2_sel1 = 0; alu2_sel2 = 0; alu2_op = 0;
    mul1_sel1 = 0; mul1_sel2 = 0; mul1_op = 0;

    case (state)
      S_IDLE: begin
        op_ready = 1;
        if (start) next_state = S_CYCLE_1;
      end
      S_CYCLE_1: begin
        alu1_sel1 = 4'd4;
        alu1_sel2 = 4'd4;
        alu1_op = 1'b0;
        reg_alu4_en = 1;
        alu2_sel1 = 4'd5;
        alu2_sel2 = 4'd5;
        alu2_op = 1'b0;
        reg_alu5_en = 1;
        next_state = S_CYCLE_2;
      end
      S_CYCLE_2: begin
        alu1_sel1 = 4'd2;
        alu1_sel2 = 4'd2;
        alu1_op = 1'b0;
        reg_alu2_en = 1;
        mul1_sel1 = 4'd6;
        mul1_sel2 = 4'd6;
        mul1_op = 1'b0;
        reg_mul6_en = 1;
        next_state = S_CYCLE_3;
      end
      S_CYCLE_3: begin
        mul1_sel1 = 4'd7;
        mul1_sel2 = 4'd7;
        mul1_op = 1'b0;
        reg_mul7_en = 1;
        result_en = 1;
        next_state = S_DONE;
      end
      S_DONE: begin
        done_next = 1;
        next_state = S_IDLE;
      end
    endcase
  end
endmodule