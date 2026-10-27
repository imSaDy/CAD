# Computer-Aided Design of Digital Systems

Assignments for the Computer-Aided Design of Digital Systems course at the University of Tehran, Fall 2025, done with [Erfan Falahati](https://github.com/erfan-f). The work goes from RTL design in Verilog down to gate-level mapping, then to automated synthesis and scheduling. Each folder has the assignment statement (in Persian), our code and design diagrams, and from CA2 on, a report.

| Folder | Assignment | What we did |
| --- | --- | --- |
| [CA#1](CA%231) | Hash generator RTL | A 128-bit hash generator in Verilog, built as a datapath and controller. A message of four 32-bit words goes through 64 rounds. Part 1 is the shift-register random number generator it uses; the two modules synchronize through a start/done handshake. |
| [CA#2](CA%232) | Bit-serial arithmetic | A bit-serial unit for the dot product of two vectors, based on the Stripes accelerator, then reused to build a matrix-vector multiplier. Test inputs and expected outputs are included. |
| [CA#3](CA%233) | Manual synthesis | A simplified version of the CA1 hash generator built only from the four basic cells the course provides (C1, C2, S1 and S2), without Verilog operators. The goal was to stay under 3,800 gates in total. |
| [CA#4](CA%234) | Synthesis with Yosys | The same simplified design synthesized with Yosys. A Python script (`lut2mapper_fixed.py`) maps the generic LUTs that Yosys produces onto the course's basic cells, so the result can be compared with the hand-made design from CA3. |
| [CA#5](CA%235) | Scheduling and code generation | A Python tool that reads an arithmetic expression, builds its data-flow graph, schedules it with either resource-constrained minimum-latency or latency-constrained minimum-resource list scheduling, and generates the matching Verilog datapath and controller. |

## Running

The Verilog designs were simulated in ModelSim; each folder has a testbench. CA4 needs [Yosys](https://github.com/YosysHQ/yosys) (the script is `CA#4/Code/lut2synthesis.ys`). CA5 needs Python 3 and the `graphviz` package, and runs on one of the sample folders:

```sh
cd "CA#5/Codes"
python main.py ./samples/sample1/
```
