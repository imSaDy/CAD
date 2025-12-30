import os
import ast
from .scheduler import ScheduledNodeInfo
from .dfg_creator import OperatorNode, IdentifierNode

class VerilogGenerator:
    def __init__(self, schedule_info: list[ScheduledNodeInfo]):
        self.schedule_info = schedule_info
        self.max_time = max((node.scheduled_time for node in schedule_info), default=0)
        self.resources = {} 
        self.node_map = {info.node.id: info for info in schedule_info}
        
        # 1. Deduce Root Node (The node that is not an operand of any other node)
        producer_ids = {info.node.id for info in schedule_info}
        consumer_ids = set()
        for info in schedule_info:
            for op in info.node.operands:
                if isinstance(op, OperatorNode):
                    consumer_ids.add(op.id)
        
        possible_roots = producer_ids - consumer_ids
        if possible_roots:
            root_id = max(possible_roots)
            self.root = self.node_map[root_id].node
        else:
            # Fallback: use the last scheduled node
            self.root = schedule_info[-1].node

        # 2. Find all Inputs (Identifiers) by scanning operands
        self.identifiers = set()
        for info in schedule_info:
            for op in info.node.operands:
                if isinstance(op, IdentifierNode):
                    self.identifiers.add(op.name)
        
        # 3. Populate resource usage map
        for info in schedule_info:
            key = (info.node.op_type, info.resource_num)
            if key not in self.resources:
                self.resources[key] = []
            self.resources[key].append((info.scheduled_time, info.node))

    def get_operand_wire(self, operand):
        """Returns the Verilog wire name for a given operand node."""
        if isinstance(operand, IdentifierNode):
            return operand.name
        elif isinstance(operand, OperatorNode):
            return f"reg_{operand.op_type.lower()}{operand.id}"
        return "0"

    def generate_datapath(self):
        lines = []
        lines.append(f"module datapath(")
        lines.append(f"  input clk, rst,")
        
        # Inputs
        for ident in sorted(list(self.identifiers)):
            lines.append(f"  input [31:0] {ident},")
            
        # Control Signals
        for (rtype, rnum) in self.resources.keys():
            res_name = f"{rtype.lower()}{rnum}"
            lines.append(f"  input [3:0] {res_name}_sel1,")
            lines.append(f"  input [3:0] {res_name}_sel2,")
            if rtype in ["ALU", "MUL"]:
                lines.append(f"  input {res_name}_op,")
            elif rtype == "LOG":
                lines.append(f"  input [1:0] {res_name}_op,")
                
        lines.append(f"  input done_next,")
        lines.append(f"  input result_en,")
        for info in self.schedule_info:
            lines.append(f"  input reg_{info.node.op_type.lower()}{info.node.id}_en,")
            
        lines.append(f"  output reg [31:0] result,")
        lines.append(f"  output reg done")
        lines.append(f");")
        
        # Wires & Registers
        lines.append("\n  // Wires for FU outputs")
        for (rtype, rnum) in self.resources:
             lines.append(f"  wire [31:0] {rtype.lower()}{rnum}_out;")
             lines.append(f"  wire [31:0] {rtype.lower()}{rnum}_op1, {rtype.lower()}{rnum}_op2;")

        lines.append("\n  // Registers for intermediate values")
        for info in self.schedule_info:
            lines.append(f"  reg [31:0] reg_{info.node.op_type.lower()}{info.node.id};")
            
        # Mux Logic
        lines.append("\n  // Muxing logic for FU inputs")
        for (rtype, rnum), ops in self.resources.items():
            res_name = f"{rtype.lower()}{rnum}"
            
            # Op1 Mux
            lines.append(f"  reg [31:0] {res_name}_op1_reg;")
            lines.append(f"  always @(*) begin")
            lines.append(f"    case ({res_name}_sel1)")
            for time, node in ops:
                src = self.get_operand_wire(node.operands[0])
                lines.append(f"      4'd{node.id}: {res_name}_op1_reg = {src};")
            lines.append(f"      default: {res_name}_op1_reg = 0;")
            lines.append(f"    endcase")
            lines.append(f"  end")
            lines.append(f"  assign {res_name}_op1 = {res_name}_op1_reg;")

            # Op2 Mux
            lines.append(f"  reg [31:0] {res_name}_op2_reg;")
            lines.append(f"  always @(*) begin")
            lines.append(f"    case ({res_name}_sel2)")
            for time, node in ops:
                src = self.get_operand_wire(node.operands[1])
                lines.append(f"      4'd{node.id}: {res_name}_op2_reg = {src};")
            lines.append(f"      default: {res_name}_op2_reg = 0;")
            lines.append(f"    endcase")
            lines.append(f"  end")
            lines.append(f"  assign {res_name}_op2 = {res_name}_op2_reg;")

        # Functional Units
        lines.append("\n  // Functional Units")
        # FIXED LOOP HERE: Iterate over keys, or unpack correctly
        for (rtype, rnum) in self.resources: 
            res_name_str = f"{rtype.lower()}{rnum}"
            lines.append(f"  // {rtype} Unit {rnum}")
            lines.append(f"  reg [31:0] {res_name_str}_out_reg;")
            lines.append(f"  always @(*) begin")
            if rtype == "ALU":
                lines.append(f"    case ({res_name_str}_op)")
                lines.append(f"      1'b0: {res_name_str}_out_reg = {res_name_str}_op1 + {res_name_str}_op2;")
                lines.append(f"      1'b1: {res_name_str}_out_reg = {res_name_str}_op1 - {res_name_str}_op2;")
                lines.append(f"    endcase")
            elif rtype == "MUL":
                lines.append(f"    case ({res_name_str}_op)")
                lines.append(f"      1'b0: {res_name_str}_out_reg = {res_name_str}_op1 * {res_name_str}_op2;")
                lines.append(f"      1'b1: {res_name_str}_out_reg = {res_name_str}_op1 / {res_name_str}_op2;")
                lines.append(f"    endcase")
            elif rtype == "LOG":
                lines.append(f"    case ({res_name_str}_op)")
                lines.append(f"      2'b00: {res_name_str}_out_reg = {res_name_str}_op1 & {res_name_str}_op2;")
                lines.append(f"      2'b01: {res_name_str}_out_reg = {res_name_str}_op1 | {res_name_str}_op2;")
                lines.append(f"    endcase")
            lines.append(f"  end")
            lines.append(f"  assign {res_name_str}_out = {res_name_str}_out_reg;")

        # Register Updates
        lines.append("\n  // Register update logic")
        lines.append("  always @(posedge clk or posedge rst) begin")
        lines.append("    if (rst) begin")
        for info in self.schedule_info:
            lines.append(f"      reg_{info.node.op_type.lower()}{info.node.id} <= 0;")
        lines.append("      result <= 0;")
        lines.append("      done <= 0;")
        lines.append("    end else begin")
        lines.append("      done <= done_next;")
        for info in self.schedule_info:
            reg_name = f"reg_{info.node.op_type.lower()}{info.node.id}"
            res_source = f"{info.node.op_type.lower()}{info.resource_num}_out"
            lines.append(f"      if ({reg_name}_en) {reg_name} <= {res_source};")
            if info.node.id == self.root.id:
                lines.append(f"      if (result_en) result <= {res_source};")
        lines.append("    end")
        lines.append("  end")
        lines.append("endmodule")
        return "\n".join(lines)

    def generate_controller(self):
        lines = []
        lines.append(f"module controller(")
        lines.append(f"  input clk, rst, start,")
        lines.append(f"  output reg op_ready,")
        
        for (rtype, rnum) in self.resources.keys():
            res_name = f"{rtype.lower()}{rnum}"
            lines.append(f"  output reg [3:0] {res_name}_sel1, {res_name}_sel2,")
            if rtype in ["ALU", "MUL"]:
                lines.append(f"  output reg {res_name}_op,")
            elif rtype == "LOG":
                lines.append(f"  output reg [1:0] {res_name}_op,")
                
        lines.append(f"  output reg done_next, result_en,")
        for info in self.schedule_info:
            lines.append(f"  output reg reg_{info.node.op_type.lower()}{info.node.id}_en,")
        lines.append(");")

        lines.append("  reg [3:0] state, next_state;")
        lines.append("  localparam S_IDLE = 0;")
        lines.append(f"  localparam S_DONE = {self.max_time + 1};")
        for t in range(1, self.max_time + 1):
            lines.append(f"  localparam S_CYCLE_{t} = {t};")
            
        lines.append("\n  always @(posedge clk or posedge rst) begin")
        lines.append("    if (rst) state <= S_IDLE;")
        lines.append("    else state <= next_state;")
        lines.append("  end")
        
        lines.append("\n  always @(*) begin")
        lines.append("    op_ready = 0; next_state = state;")
        lines.append("    done_next = 0; result_en = 0;")
        for info in self.schedule_info:
             lines.append(f"    reg_{info.node.op_type.lower()}{info.node.id}_en = 0;")
        for (rtype, rnum) in self.resources.keys():
            res_name = f"{rtype.lower()}{rnum}"
            lines.append(f"    {res_name}_sel1 = 0; {res_name}_sel2 = 0; {res_name}_op = 0;")

        lines.append("\n    case (state)")
        lines.append("      S_IDLE: begin")
        lines.append("        op_ready = 1;")
        lines.append("        if (start) next_state = S_CYCLE_1;")
        lines.append("      end")
        
        op_code_map = {
            ast.Add: "1'b0", ast.Sub: "1'b1",
            ast.Mult: "1'b0", ast.Div: "1'b1", ast.Mod: "1'b1", 
            ast.BitAnd: "2'b00", ast.BitOr: "2'b01"
        }
        
        for t in range(1, self.max_time + 1):
            lines.append(f"      S_CYCLE_{t}: begin")
            nodes_at_t = [info for info in self.schedule_info if info.scheduled_time == t]
            for info in nodes_at_t:
                res_name = f"{info.node.op_type.lower()}{info.resource_num}"
                
                # Mux Selects
                lines.append(f"        {res_name}_sel1 = 4'd{info.node.id};")
                lines.append(f"        {res_name}_sel2 = 4'd{info.node.id};")
                
                op_val = op_code_map.get(type(info.node.op), "0")
                lines.append(f"        {res_name}_op = {op_val};")
                lines.append(f"        reg_{info.node.op_type.lower()}{info.node.id}_en = 1;")
                if info.node.id == self.root.id:
                    lines.append(f"        result_en = 1;")
            if t < self.max_time:
                lines.append(f"        next_state = S_CYCLE_{t+1};")
            else:
                lines.append(f"        next_state = S_DONE;")
            lines.append("      end")
            
        lines.append("      S_DONE: begin")
        lines.append("        done_next = 1;")
        lines.append("        next_state = S_IDLE;")
        lines.append("      end")
        lines.append("    endcase")
        lines.append("  end")
        lines.append("endmodule")
        return "\n".join(lines)