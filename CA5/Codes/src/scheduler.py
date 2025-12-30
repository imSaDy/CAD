from abc import ABC, abstractmethod
from .dfg_creator import BaseNode, OperatorNode, IdentifierNode, OP_TYPES
from typing import List, Dict

class ScheduledNodeInfo:
    def __init__(self, node : OperatorNode, scheduled_time : int, resource_num : int):
        self.node = node
        self.scheduled_time = scheduled_time
        self.resource_num = resource_num
        
    def __repr__(self):
        return f"Node {self.node.id}: Time {self.scheduled_time}, Res {self.node.op_type}_{self.resource_num}"


class ListScheduler(ABC):
    def __init__(self, dfg_root : BaseNode, numof_reources : dict):
        self.root = dfg_root
        if numof_reources is None:
            self.numof_resources = {op: 1 for op in OP_TYPES}
        else:
            self.numof_resources = numof_reources

        self.scheduled_nodes_info : List[ScheduledNodeInfo] = []
        self.scheduled_ids = set()
        
        # Build a map of all operator nodes to easily find parents/children
        self.all_ops = []
        self._collect_ops(self.root)

    def _collect_ops(self, node):
        """Helper to recursively collect all OperatorNodes in the graph."""
        if isinstance(node, OperatorNode):
            if node not in self.all_ops:
                self.all_ops.append(node)
                for op in node.operands:
                    self._collect_ops(op)

    def record_scheduled_node(self, node : OperatorNode, scheduled_time : int, resource_num : int):
        """Records that a node has been scheduled at a specific time and resource."""
        recorded_info = ScheduledNodeInfo(node=node, scheduled_time=scheduled_time, resource_num=resource_num)
        self.scheduled_nodes_info.append(recorded_info)
        self.scheduled_ids.add(node.id)

    def get_scheduling_info(self) -> List[ScheduledNodeInfo]:
        """Returns the list of all ScheduledNodeInfos sorted by their node id."""
        return sorted(self.scheduled_nodes_info, key = lambda node_info: node_info.node.id)

    def check_dependencies(self, node: OperatorNode) -> bool:
        """Check if all operands of the node are scheduled or are identifiers."""
        for operand in node.operands:
            if isinstance(operand, OperatorNode):
                if operand.id not in self.scheduled_ids:
                    return False
        return True

    @abstractmethod
    def find_candidate_nodes(self) -> List[OperatorNode]:
        pass

    @abstractmethod
    def select_from_frontier(self, frontier : List[OperatorNode]) -> List[OperatorNode]:
        pass

    @abstractmethod
    def schedule(self) -> None:
        pass


class MinLatencyScheduler(ListScheduler):
    def __init__(self, dfg_root : BaseNode, numof_resources : dict):
        super().__init__(dfg_root=dfg_root, numof_reources=numof_resources)
        self.current_time = 1

    def find_candidate_nodes(self) -> List[OperatorNode]:
        candidates = []
        for node in self.all_ops:
            if node.id not in self.scheduled_ids:
                if self.check_dependencies(node):
                    candidates.append(node)
        return candidates

    def select_from_frontier(self, frontier : List[OperatorNode]) -> List[OperatorNode]:
        # Priority: Greedy (Just schedule as many as possible)
        selected = []
        resources_avail = self.numof_resources.copy()
        
        # Sort by depth as a heuristic (deeper nodes first)
        sorted_frontier = sorted(frontier, key=lambda x: x.depth) 
        
        for node in sorted_frontier:
            op_type = node.op_type
            if resources_avail[op_type] > 0:
                selected.append(node)
                resources_avail[op_type] -= 1
                
        return selected

    def schedule(self) -> None:
        while len(self.scheduled_ids) < len(self.all_ops):
            frontier = self.find_candidate_nodes()
            selected_nodes = self.select_from_frontier(frontier)
            
            type_counters = {k: 1 for k in OP_TYPES}
            
            for node in selected_nodes:
                res_num = type_counters[node.op_type]
                type_counters[node.op_type] += 1
                self.record_scheduled_node(node, self.current_time, res_num)
                
            self.current_time += 1


class MinResourceScheduler(ListScheduler):
    def __init__(self, dfg_root : BaseNode, numof_resources : dict, max_time : int):
        super().__init__(dfg_root=dfg_root, numof_reources=numof_resources)
        self.max_time = max_time
        self.current_time = 1
        self.latest_time = self.find_latest_times()

    def find_latest_times(self) -> dict:
        """
        Calculates ALAP (As Late As Possible) time for each node recursively.
        """
        # Initialize all nodes to max_time
        alap = {node.id: self.max_time for node in self.all_ops}
        
        # Recursive helper to propagate deadlines backwards from Root -> Children
        def set_alap(curr_node, time_limit):
            # Update the node's deadline if the new limit is tighter
            if curr_node.id in alap:
                alap[curr_node.id] = min(alap[curr_node.id], time_limit)
            
            # Propagate to children: If I must end by T, my children must end by T-1
            for child in curr_node.operands:
                if isinstance(child, OperatorNode):
                    set_alap(child, alap[curr_node.id] - 1)
        
        # Start recursion from the root (sink) of the DFG
        if self.root:
            set_alap(self.root, self.max_time)
            
        return alap

    def find_candidate_nodes(self) -> List[OperatorNode]:
        candidates = []
        for node in self.all_ops:
            if node.id not in self.scheduled_ids:
                if self.check_dependencies(node):
                    candidates.append(node)
        return candidates

    def select_from_frontier(self, frontier : List[OperatorNode]) -> List[OperatorNode]:
        # 1. Calculate Slack for every candidate
        # Slack = ALAP (Latest Start Time) - Current Time
        frontier_with_slack = []
        for node in frontier:
            slack = self.latest_time[node.id] - self.current_time
            frontier_with_slack.append((slack, node))
            
        # 2. Sort by Slack (Ascending) -> Most urgent nodes first
        frontier_with_slack.sort(key=lambda x: x[0])
        
        selected = []
        # Create a local copy of the resource limits to track usage in THIS cycle
        resources_avail = self.numof_resources.copy()
        
        for slack, node in frontier_with_slack:
            op_type = node.op_type
            
            # CASE A: Critical Node (Slack == 0)
            # We MUST schedule this now, or we violate the MaxTime constraint.
            # We ignore the resource limit here (effectively "adding" a resource if needed).
            if slack == 0:
                selected.append(node)
                # Decrement available count (it can go negative, which implies we added a resource)
                resources_avail[op_type] -= 1
                
            # CASE B: Non-Critical Node (Slack > 0)
            # We only schedule this if we have "spare" resources within the limit.
            # If not, we wait (pass) to save resources, because we have slack to spare.
            else:
                if resources_avail[op_type] > 0:
                    selected.append(node)
                    resources_avail[op_type] -= 1
                else:
                    # We have slack and no free resources, so we defer this node.
                    pass
                
        return selected

    def schedule(self) -> None:
        while len(self.scheduled_ids) < len(self.all_ops):
            frontier = self.find_candidate_nodes()
            selected_nodes = self.select_from_frontier(frontier)
            
            type_counters = {k: 1 for k in OP_TYPES}
            
            for node in selected_nodes:
                res_num = type_counters[node.op_type]
                type_counters[node.op_type] += 1
                self.record_scheduled_node(node, self.current_time, res_num)
                
            self.current_time += 1