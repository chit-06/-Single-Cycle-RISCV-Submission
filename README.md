# RISC-V Single-Cycle RV32I Processor

## 1. Overview

This project implements a single-cycle RISC-V RV32I processor using SystemVerilog. It uses a modular architecture consisting of instruction fetch, decode, execute, and writeback stages.

## 2. Architecture

The processor consists of four stages:

1. **IF:** Program counter and instruction fetching.
2. **ID:** Instruction decoding, immediate generation, register-file access, and control signals.
3. **EX:** ALU operations, branch and jump calculations.
4. **WB:** Selection of data to write back into registers.

Instruction and data memories are external to the processor core.

## 3. Repository Structure

```text
├── ALU/
├── ALU_Control/
├── Decoder/
├── EX_Stage/
├── ID_Stage/
├── IF_Stage/
├── Immediate_Generator/
├── Main_Control/
├── Register_File/
├── Single_Cycle_RISCV/
│   ├── single_cycle_riscv.sv
│   └── tb_single_cycle_riscv.sv
├── WB_Stage/
├── README.md
└── rnr-stage.yaml
```

## 4. Tools Used

- SystemVerilog
- Xilinx Vivado
- Yosys 0.33
- Git and GitHub

## 5. Verification

The processor was simulated and its testbench verified using Vivado Behavioral Simulation.

The testbench checks:
- Instruction decoding and immediate generation.
- Register-file operations.
- ALU operations.
- Branch and jump handling.
- Memory interface and writeback.
- Processor integration.

## 6. Running the Simulation

1. Open the project in Vivado.
2. Add all `.sv` design files.
3. Add `tb_single_cycle_riscv.sv` as a simulation source.
4. Set the testbench as the simulation top.
5. Run Behavioral Simulation.

## 7. Conclusion

The project implements a modular single-cycle RV32I processor and demonstrates practical experience with processor architecture, SystemVerilog RTL design, simulation, and verification.

## 8. Repository

[GitHub Repository](https://github.com/chit-06/-Single-Cycle-RISCV-Submission)
