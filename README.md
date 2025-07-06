# Arithmetic Unit in VHDL

This project implements a fully structural **Arithmetic Unit** in VHDL that computes the following formula:
```
    P = (A × B) / 2^C + D
```

Where:
- `A` and `B` are signed n-bit integers
- `C` is a natural number (32-bit)
- `D` is a signed 2n-bit integer
- `P` is a signed integer of size 2n + 1

The design includes a **signed n-bit adder**, a **Booth's multiplier**, and an **arithmetic right shift**. A first version provides a synchronous RTL top-level, which wraps **purely combinational components** with registers for input/output control; though the internal logic remains asynchronous. Additionally, a **sequential version** is implemented for both the arithmetic right shift and the entire arithmetic unit, enabling true clock-driven operation.

---

## Features

- Fully structural VHDL design and sequential version
- Synchronous operation with clocked DFF registers
- Booth’s multiplier
- Configurable operand bit-width through generics
- Simulation testbenches for all components
- ModelSim project-compatible structure

---

## Project Tree
```
arithmetic-unit
├── LIB
│   ├── LIB_BENCH          # Compiled library for testbenches
│   └── LIB_RTL            # Compiled library for RTL modules
├── SRC
│   ├── BENCH              # Testbenches for all modules
│   └── RTL                # RTL source files for the arithmetic unit
├── init_to_compile.txt    # Bash script to initialize libraries
├── compile_src.txt        # Bash script to compile all SRC files
├── Report (academic).pdf  # Upcoming report
└── README.md              # This file
```


---

## Components Overview

- **Signed n-bit Adder**: Ripple-carry architecture; versions with and without overflow support.
- **Booth's Multiplier**: Chosen for its efficiency in area and power; implemented structurally using adders, a multiplexer, and arithmetic shift.
- **Arithmetic Shift Right**:
  - Structural version: Instantiates multiple single-bit shifters.
  - Sequential version: Uses registers and clocked logic for area and delay-efficient design.
- **Top-Level RTL Design**:
  - Synchronous, used for the structural version only.

---

## How to Compile

### Compile all RTL and BENCH files:

```bash
source compile_src.txt
```

### Compile a single file:

1. Initialize libraries:
```bash
source init_to_compile.txt
```

2. Compile the file:
```bash
vcom -work LIB_BENCH ./SRC/BENCH/your_testbench.vhd
vcom -work LIB_RTL   ./SRC/RTL/your_component.vhd
```

---

## How to Simulate

Once the desired files are compiled:
```bash
vsim
```
Load the appropriate testbench and run the simulation in ModelSim.

---

# Authors
- Benjamin Vauchel
- Di Wang

This project was developed at Concordia University for COEN 6501 – Digital Design and Synthesis (Fall 2023).

---

# License

This project is provided for academic purposes. Feel free to explore, modify, or build upon it.

---

# Notes
- The *arithmetic_unit* entity strictly follows the requirement to model the arithmetic unit structurally using only component instantiation (no process blocks).
- An enhanced sequential version, *arithmetic_unit_seq*, is also included for both the arithmetic right shift and the full arithmetic unit, providing a more optimized and FPGA-friendly alternative.
- For synthesis or FPGA deployment, further timing analysis and optimization may be required.
