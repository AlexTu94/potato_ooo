# Potato Out-of-Order (OoO) RISC-V Processor

This project is an evolution of the Potato processor, originally a 5-stage in-order RISC-V processor. It has been extended with a Reorder Buffer (ROB) to support Out-of-Order (OoO) execution while maintaining precise exceptions and handling RAW hazards.

## Architecture

- **ISA**: RV32I-Zicsr
- **Pipeline**: Originally 5 stages, now extended with a **Reorder Buffer (ROB)** stage.
- **Execution Model**: Out-of-Order execution enabled by the ROB.
- **Hazard Management**: RAW (Read-After-Write) hazards are managed through the ROB and renaming/forwarding mechanisms.

## Project Structure

- `src/`: VHDL source files for the processor core and components.
  - `pp_rob.vhd`: Implementation of the Reorder Buffer.
  - `pp_core.vhd`: Top-level core integration.
- `soc/`: System-on-Chip components (memory, UART, timer, GPIO).
- `sim/`: Simulation scripts and test programs.
- `tests/`: Assembly and C programs for functional verification.
- `software/`: Bootloader and sample applications.
- `testbenches/`: VHDL testbenches for individual components and the full SoC.

## Simulation & Development

### Vivado Simulation
The project is designed to be simulated using Xilinx Vivado. 
- Top-level simulation usually targets `tb_soc` or `tb_processor`.
- Use the provided testbenches in the `testbenches/` directory.

### Functional Verification
The `tests/` directory contains specific programs to verify the processor's functionality, including hazard handling and OoO execution logic.

## Conventions

- **Language**: VHDL is used for RTL design.
- **Tooling**: Xilinx Vivado for synthesis and simulation.
- **ISA Compliance**: Must maintain compatibility with RV32I and Zicsr extension.
