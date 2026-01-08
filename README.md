# Computer-Aided Design (CAD) of Digital Systems - Fall 1404

This repository contains the complete set of projects and laboratory assignments for the **Computer-Aided Design of Digital Systems** course at the **University of Tehran**, Department of Electrical and Computer Engineering.
  
**Term:** Fall 1404 (Autumn 2025)

## 📂 Project Overview

### 1. Hash Generator RTL Design
* **Focus:** Datapath & Controller design using the Huffman model.
* **Key Features:** Implemented a 128-bit Hash Generator in Verilog with modular PRNG and Hash cores.
* **Concepts:** Moore State Machines, Handshaking protocols (`start_rnd`, `done_rnd`), and RTL verification.

### 2. Bit-Serial Arithmetic & Stripes Accelerator
* **Focus:** Hardware resource optimization and serial processing.
* **Key Features:** Designed a **Bit-Serial Dot Product** module and scaled it into a **Matrix-Vector Multiplier**.
* **Concepts:** Bit-serial architectures, sign-extension, and memory integration for hardware accelerators.

### 3. Structural Synthesis on FPGA Logic Cells
* **Focus:** Manual synthesis and mapping to Actel basic cells.
* **Key Features:** Re-implemented the Hash Generator using structural Verilog, mapping logic to specific FPGA primitives (`C1`, `C2`, `S1`, `S2`).
* **Constraints:** Optimized the design to stay under a strict gate-count limit (< 3800 gates).

### 4. Automated Synthesis Flow with Yosys
* **Focus:** Logic mapping automation and CAD tool chains.
* **Key Features:** Integrated **Yosys** to synthesize RTL into netlists and developed a Python mapper (`lut2mapper.py`) to convert generic LUTs to Actel cells.
* **Analysis:** Comparison between manual structural design and automated synthesis results.

### 5. HLS & Automated Scheduling Algorithms
* **Focus:** High-Level Synthesis (HLS) and DFG scheduling.
* **Key Features:** Developed Python tools to implement:
    1.  **Resource-Constrained Scheduling** (Minimum Latency)
    2.  **Latency-Constrained Scheduling** (Minimum Resource)
* **Automation:** Generated full RTL Verilog (Datapath + Controller) directly from mathematical expressions and scheduled Data Flow Graphs (DFG).


## 👥 Contributors
* **[Sadegh Samadi](https://github.com/imSaDy)**
* **[Erfan Falahati](https://github.com/erfan-f)**
