# FPGA Digital Systems & FSM (VHDL / Xilinx Artix-7)

![Language](https://img.shields.io/badge/Language-VHDL-blue.svg)
![Tool](https://img.shields.io/badge/EDA-Xilinx%20Vivado-red.svg)
![Platform](https://img.shields.io/badge/Hardware-Artix--7%20FPGA-orange.svg)

A repository of modular, synthesizable RTL digital designs implemented in VHDL for Xilinx Artix-7 FPGAs using Vivado. This project covers digital arithmetic circuits, hierarchical finite state machines (FSMs), functional simulation testbenches, timing analysis, and physical pin constraint mapping.

---

## Repository Structure

```text
fpga-digital-systems-vhdl/
├── cla-adder-subtractor/
│   ├── src/
│   │   └── cla_adder_subtractor_4bit.vhd     # Synthesizable 4-bit CLA RTL
│   └── sim/
│       └── tb_cla_adder_subtractor_4bit.vhd  # Functional verification testbench
├── traffic-light-fsm/
│   ├── src/
│   │   └── traffic_light_fsm.vhd             # Multi-state traffic controller & clock divider
│   ├── sim/
│   │   └── tb_traffic_light_fsm.vhd          # Accelerated clock testbench
│   └── constraints/
│       └── Basys3_Master.xdc                 # Vivado pin mappings and 100 MHz timing constraint
└── README.md