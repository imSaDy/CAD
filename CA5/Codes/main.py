import ast
import sys
import json
import os
from pathlib import Path
from src.dfg_creator import GraphBuilder
from src.graph_visualizer import expression_to_graph, visualize_graph, visualize_scheduled_graph
from src.scheduler import MinLatencyScheduler, MinResourceScheduler, ScheduledNodeInfo
from src.verilog_generator import VerilogGenerator

MinResourceAlgorithm = "MinResourceLatencyConstrained"
MinlatencyAlgorithm = "MinLatencyResourceContrained"

def load_input(filename: str) -> dict:
    with open(filename, "r") as file:
        return json.load(file)

def build_dfg(expression: str, folder_path : str):
    ast_root = expression_to_graph(expression)

    dot = visualize_graph(ast_root)
    dot.attr(label="", labelloc='t', fontsize='17')  
    dot.render(folder_path + "/pics/DFG", format='png', view=False, cleanup=True)

    builder = GraphBuilder()
    return builder.build(ast_root)


def schedule_dfg(dfg_root, algorithm : str, config : dict, folder_path : str) -> list:
    if (algorithm == MinResourceAlgorithm):
        scheduler = MinResourceScheduler(dfg_root=dfg_root, numof_resources=config["Resources"], max_time=config["MaxTime"])
    else:
        scheduler = MinLatencyScheduler(dfg_root=dfg_root, numof_resources=config["Resources"])    
    scheduler.schedule()
    schedule_info = scheduler.get_scheduling_info()

    dot = visualize_scheduled_graph(root_id=dfg_root.id, schedule_info=schedule_info)
    dot.attr(label="", labelloc='t', fontsize='17')  
    dot.render(folder_path + "/pics/ScheduledDFG", format='png', view=False, cleanup=True)

    return schedule_info

'''
    Call your VerilogGenerator class here.
    Save the reuslting code files to:
        - "{folder_path}/codes/datapath.v"
        - "{folder_path}/codes/controller.v"
'''
# TODO
def generate_verilog(folder_path : str, schedule_info : list[ScheduledNodeInfo]):
    # Pass ONLY schedule_info. The generator class now deduces the root internally.
    generator = VerilogGenerator(schedule_info)
    
    datapath_code = generator.generate_datapath()
    controller_code = generator.generate_controller()
    # NEW: Generate top module
    top_module_code = generator.generate_top_module()
    
    # Ensure directory exists
    os.makedirs(folder_path + "/codes", exist_ok=True)
    
    with open(folder_path + "/codes/datapath.v", "w") as f:
        f.write(datapath_code)
        
    with open(folder_path + "/codes/controller.v", "w") as f:
        f.write(controller_code)

    # NEW: Save top module
    with open(folder_path + "/codes/top_module.v", "w") as f:
        f.write(top_module_code)

def save_result(folder_path : str, schedule_info : list[ScheduledNodeInfo]):
    json_output = {}
    with open(folder_path + "/output.json", "w") as file:
        for node_info in schedule_info:
            json_output[node_info.node.id] = {
                "clk": node_info.scheduled_time,
                "resource_type": node_info.node.op_type,
                "resource_num": node_info.resource_num
            }
        json.dump(json_output, file, indent=4)


def run_test(folder_path : str):
    input_file_path = folder_path + "/input.json"
    data = load_input(input_file_path)

    dfg_root = build_dfg(expression=data["Expression"], folder_path=folder_path)

    schedule_info = schedule_dfg(dfg_root, algorithm=data["Algorithm"], config=data["Config"], folder_path=folder_path)

    save_result(folder_path=folder_path, schedule_info=schedule_info)

    generate_verilog(folder_path=folder_path, schedule_info=schedule_info)

def main():
    if len(sys.argv) > 1:
        run_test(folder_path=sys.argv[1])
    else:
        print("Please provide the input folder path.")

if __name__ == "__main__":
    main()
