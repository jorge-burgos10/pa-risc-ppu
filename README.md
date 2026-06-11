# PA-RISC 2025 — PPU Simulator

Verilog implementation of a **PA-RISC**-style processor (`PPU` module) with a 5-stage pipeline: **IF → ID → EX → MEM → WB**. Includes a control unit, hazard detection, register file, ALU, instruction memory, and data memory.

## Requirements

- [Icarus Verilog](https://steveicarus.github.io/iverilog/) (`iverilog` + `vvp`)

Verify installation:

```bash
iverilog -V
```

## Project structure

```
PA_RISC_2025/
├── PF4_PA_Risc.v              # PPU processor (modular design with `include`)
├── PF4_Test_Bench.v           # Full PPU test bench (self-contained)
├── PF3_CU.v                   # Phase III test bench and control unit
├── PF1_Lopez_Valentin_Manuel_rf.v  # Register file
├── General_Modules.v          # PC, pipeline registers, hazard detection, TAG
├── Miscellaneous.v            # Multiplexers and adders
├── ALU_SOH_CH_PSW.v           # ALU, operand handler, PSW, and condition handler
├── DataMemory.v               # Data memory (standalone module)
├── InstructionMemory.v        # Instruction memory (standalone module)
├── Tb_CH_ALU_SOH_PSW.v        # ALU / SOH / PSW / CH test bench
├── SIM_Code/                  # Binary programs (256 bytes, $readmemb format)
│   ├── file_precarga_fase_I.txt
│   ├── Test_1_PA_risc.txt
│   ├── Test_2_PA_risc.txt
│   ├── Validation_PA_risc.txt
│   └── Fase_III_code.txt
└── Diagrama PPU.pdf           # Processor block diagram
```

## Build and simulation

Always run commands from the **repository root**, since `$readmemb` paths are relative to that directory.

### Main test bench (full PPU)

```bash
iverilog -o PF4_Test_Bench.vvp PF4_Test_Bench.v
vvp PF4_Test_Bench.vvp
```

The simulation prints the pipeline state on every clock cycle. When it finishes, it dumps data memory contents and writes `DM_changes.txt` with differences from the loaded program.

### Modular design (no integrated test bench)

```bash
iverilog -o PPU.vvp PF4_PA_Risc.v
```

### Other test benches

```bash
# Phase III — control unit
iverilog -o Fase3.vvp PF3_CU.v && vvp Fase3.vvp

# ALU, operand handler, PSW, and condition handler
iverilog -o ALU_TB.vvp Tb_CH_ALU_SOH_PSW.v && vvp ALU_TB.vvp
```

## Test programs (`SIM_Code/`)

Files are **binary byte** sequences (8 bits per line, 4 bytes per 32-bit instruction, big-endian). Each file holds up to 256 bytes of memory.

| File | Description |
|------|-------------|
| `file_precarga_fase_I.txt` | Initial preload (phase I) |
| `Test_1_PA_risc.txt` | Test program 1 |
| `Test_2_PA_risc.txt` | Test program 2 (loaded by default in `PF4_Test_Bench.v`) |
| `Validation_PA_risc.txt` | Validation program |
| `Fase_III_code.txt` | Code for the phase III test bench |

### Changing the simulated program

In `PF4_Test_Bench.v`, update the `$readmemb` calls that point to `SIM_Code/Test_2_PA_risc.txt` (in the test bench and embedded `InstructionMemory` / `DataMemory` modules). The standalone `DataMemory.v` and `InstructionMemory.v` use `SIM_Code/file_precarga_fase_I.txt`.

## Supported instructions

| Opcode (bits 31:26) | Instruction |
|---------------------|-------------|
| `101101` | ADDI |
| `100101` | SUBI |
| `000010` | ADD, ADDC, ADDL, SUB, SUBB, OR, XOR, AND |
| `010010` / `010001` / `010000` | LDW / LDH / LDB |
| `001101` | LDO |
| `001000` | LDIL |
| `011010` / `011001` / `011000` | STW / STH / STB |
| `100000` / `100010` | COMBT / COMBF |
| `111010` | BL |
| `110100` | EXTRS / EXTRU |
| `110101` | ZDEP |
| `000000` | NOP |

## Generated output

| File | Contents |
|------|----------|
| `PF4_Test_Bench.vvp` | Compiled binary (regenerable) |
| `DM_changes.txt` | Data memory differences after simulation |
