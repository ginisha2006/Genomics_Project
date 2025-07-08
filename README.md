# Genomics Project

> **Introduction**  
> This project provides a unified platform for DNA sequence analysis, combining both software (Python) and hardware (Verilog) solutions. It covers classic alignment algorithms, advanced seeding techniques, and efficient hardware implementations, making it suitable for research, education, and FPGA-based genomics acceleration.

This repository contains a comprehensive suite of algorithms and hardware modules for efficient DNA sequence analysis, including both Python and Verilog implementations.

---

## Project Structure

```
Genomics_Project-main/
│
├── Needleman_Wunsch.ipynb
├── Smith_Waterman.ipynb
├── Seeding_Techniques.ipynb
├── Project Report.pdf
├── README.md
│
├── Needleman_Wunsch_Verilog/
│   ├── needleman_wunsch.v
│   ├── tb_needleman_wunsch.v
│   └── Results/
│       ├── Power_Report.jpg
│       ├── Simulation.jpg
│       └── Utilisation_Report.jpg
│
├── Smith_Waterman_Verilog/
│   ├── smith_waterman.v
│   ├── tb_smith_waterman.v
│   └── Results/
│
├── Rolling_Hash_Verilog/
│   ├── dna_base4_hash.v
│   ├── rolling_hash.v
│   ├── tb.v
│   └── Results/
│
└── Project_Poster/
    ├── Poster_Part1.pdf
    └── Poster_Part2.pdf
```

---

## Key Components

### 1. Python Notebooks

- **[Needleman_Wunsch.ipynb](Needleman_Wunsch.ipynb)**  
  Implements global alignment (Needleman-Wunsch), seeding, and consensus genome reconstruction from reads.

- **[Smith_Waterman.ipynb](Smith_Waterman.ipynb)**  
  Implements local alignment (Smith-Waterman), rolling hash seeding, and consensus genome reconstruction.

- **[Seeding_Techniques.ipynb](Seeding_Techniques.ipynb)**  
  Demonstrates various hash-based seeding strategies: k-mers, minimisers, spaced seeds, strobemers, and fuzzy seeds.

### 2. Verilog Hardware Modules

- **Needleman_Wunsch_Verilog/**  
  - [`needleman_wunsch.v`](Needleman_Wunsch_Verilog/needleman_wunsch.v): Needleman-Wunsch global alignment hardware implementation  
  - [`tb_needleman_wunsch.v`](Needleman_Wunsch_Verilog/tb_needleman_wunsch.v): Testbench  
  - Results: Power, simulation, and utilisation reports

- **Smith_Waterman_Verilog/**  
  - [`smith_waterman.v`](Smith_Waterman_Verilog/smith_waterman.v): Smith-Waterman local alignment hardware implementation  
  - [`tb_smith_waterman.v`](Smith_Waterman_Verilog/tb_smith_waterman.v): Testbench  
  - Results: Simulation outputs

- **Rolling_Hash_Verilog/**  
  - [`dna_base4_hash.v`](Rolling_Hash_Verilog/dna_base4_hash.v): Base-4 hash computation for DNA  
  - [`rolling_hash.v`](Rolling_Hash_Verilog/rolling_hash.v): Rolling hash hardware module  
  - [`tb.v`](Rolling_Hash_Verilog/tb.v): Testbench  
  - Results: Simulation and schematic images

### 3. Documentation and Reports

- **Project Report.pdf**: Detailed project report
- **Project_Poster/**: Poster PDFs summarizing the project

---

## DNA Base Encoding

| Base | Binary |
|------|--------|
| A    | `00`   |
| C    | `01`   |
| G    | `10`   |
| T    | `11`   |
| \$   | `00` (used only in FPGA BWT module)

---

## How to Run

### Python Notebooks

1. Open any of the notebooks (`Needleman_Wunsch.ipynb`, `Smith_Waterman.ipynb`, `Seeding_Techniques.ipynb`) in Jupyter or VS Code.
2. Run all cells to see:
   - Alignment results
   - Seeding and hash table demonstrations
   - Consensus genome reconstruction

### Verilog Modules

1. Open the relevant Verilog folder in your FPGA tool (e.g., Xilinx Vivado).
2. Add the `.v` files and testbenches to your project.
3. Simulate the testbench to observe:
   - Alignment outputs
   - Hash computation results
   - Power and utilisation reports (see Results folders)

---

## Results

- Simulation waveforms and output images are in the `Results/` subfolders of each Verilog module.
- Project report and posters provide further details and analysis.

---

## Future Work

- Use Tiling Approaches
- Multi-seed consensus and error correction in Python pipeline

---