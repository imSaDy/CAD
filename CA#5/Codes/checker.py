import json
import sys
import os


def get_max_clk(data):
    return max(item['clk'] for item in data.values())

def get_max_resources(data):
    res_counts = {}
    for item in data.values():
        rtype = item['resource_type']
        rnum = item['resource_num']
        res_counts[rtype] = max(res_counts.get(rtype, 0), rnum)
    return res_counts



def test_common(expected, actual):

    # check if all node IDs exist
    if set(expected.keys()) != set(actual.keys()):
        print(f"  FAILED: ID mismatch. Expected {list(expected.keys())}, got {list(actual.keys())}")
        return False

    # check if there's any mismatch in allocated resource type and what the node actually wanted
    for op_id in expected:
        if expected[op_id]['resource_type'] != actual[op_id]['resource_type']:
            print(f"  FAILED: ID {op_id} has wrong resource type.")
            return False

    # check if any resource is allocated by two or more nodes at the same time
    usage_map = set()    
    for _, details in actual.items():
        state = (details['clk'], details['resource_type'], details['resource_num'])
        if state in usage_map:
            print(f"  FAILED: Resource Collision at Clk {details['clk']}!")
            print(f"  Multiple nodes assigned to {details['resource_type']} #{details['resource_num']}")
            return False
        usage_map.add(state)

    # check if dependency between nodes is violated
    for op_id in expected:
        dependencies = expected[op_id]['dependency']
        for dependant_node_id in dependencies:
            if actual[dependant_node_id]['clk'] > actual[op_id]['clk']:
                print(f"  FAILED: node {op_id} is scheduled before node {dependant_node_id}")
                return False


    return True

def test_min_resource_latency_constrained(expected, actual, config):

    # check if scheduler exceeded the time constraint
    max_clk_actual = get_max_clk(actual)
    max_time_allowed = config.get("MaxTime", float('inf'))
    if max_clk_actual > max_time_allowed:
        print(f"  FAILED: Latency {max_clk_actual} exceeds MaxTime {max_time_allowed}")
        return False

    max_res_actual = get_max_resources(actual)
    max_res_expected = get_max_resources(expected)
    
    # check if any resource type is allocated more than it is necessary 
    for rtype, count in max_res_actual.items():
        if count > max_res_expected.get(rtype, 0):
            print(f"  FAILED: Used {count} {rtype}s, but correct output only used {max_res_expected.get(rtype, 0)}")
            return False
    return True

def test_min_latency_resource_constrained(expected, actual, config):

    #check if number of clocks is more than expected
    if get_max_clk(actual) > get_max_clk(expected):
        print(f"  FAILED: Latency {get_max_clk(actual)} does not match expected {get_max_clk(expected)}")
        return False

    # check if any scheduler exceeded the resource constraint
    max_res_actual = get_max_resources(actual)
    allowed_res = config.get("Resources", {})
    for rtype, count in max_res_actual.items():
        if count > allowed_res.get(rtype, 0):
            print(f"  FAILED: Used {count} {rtype}s, which exceeds constraint of {allowed_res.get(rtype, 0)}")
            return False
    return True



def main():
    if len(sys.argv) < 2:
        return
    
    test_folder = sys.argv[1]
    input_path = os.path.join(test_folder, "input.json")
    out_path = os.path.join(test_folder, "output.json")
    ref_path = os.path.join(test_folder, "correct_output.json")

    try:
        with open(input_path) as f_in, open(out_path) as f_out, open(ref_path) as f_ref:
            input_data = json.load(f_in)
            actual = json.load(f_out)
            expected = json.load(f_ref)

        algo = input_data.get("Algorithm")
        config = input_data.get("Config", {})

        if not test_common(expected, actual):
            sys.exit(1)

        success = False
        if algo == "MinResourceLatencyConstrained":
            success = test_min_resource_latency_constrained(expected, actual, config)
        elif algo == "MinLatencyResourceConstrained":
            success = test_min_latency_resource_constrained(expected, actual, config)
        else:
            print(f"  ERROR: Unknown algorithm {algo}")
            sys.exit(1)

        sys.exit(0 if success else 1)

    except Exception as e:
        print(f"  ERROR processing folder {test_folder}: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()