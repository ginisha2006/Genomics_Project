# Genomics_Project


This repository contains a **two-part implementation** of core algorithms in genomics for efficient pattern searching and sequence transformation:
- A **Python-based FM-Index pipeline** using **Suffix Tree**, **BWT**, and **Backward Search**
- A **Verilog hardware implementation** of the **Burrows-Wheeler Transform (BWT)** for FPGA simulation in Vivado

---

##  Project Structure


---

## Key Concepts

### 1. Python FM-Index (in `Genomics_project_course.ipynb`)
Implements:
- **Suffix Tree Construction** from a reference genome
- **Suffix Array** generation from the tree
- **Burrows-Wheeler Transform (BWT)**
- **C Table** and **OCC Table** for FM-index
- **Seed-based Pattern Search** using **Backward Search**
- **Read Reconstruction** using retrieved seed positions

 Example Input:  
`reference_genome = "abracadabracadkff"`  
 Output includes:
- Suffix Array
- BWT String
- FM-index tables
- Seed Search Matches
- Reconstructed Read Skeleton

### 2.  Verilog BWT Module (in `vivado_verilog/`)
Implements:
- BWT computation in hardware using **2-bit encoding per DNA base**
- Handles the **$** sentinel for correct suffix sorting
- Uses **bitwise rotation**, **in-place sorting**, and **final decoding**

Test Input (ACGTACGT):  
`input_dna = 16'b0011011000110110`  
Output:  
Displays BWT string with correct character decoding and dollar marker position.

---

##  DNA Base Encoding

| Base | Binary |
|------|--------|
| A    | `00`   |
| C    | `01`   |
| G    | `10`   |
| T    | `11`   |
| \$   | `00` (used only in FPGA BWT module)

---

##  How to Run

### Python (FM-index)
1. Open the notebook:  
   `python_colab_file/Genomics_project_course.ipynb`
2. Run all cells to view:
   - BWT, Suffix Array, Tables
   - Pattern search and reconstruction output

### Verilog (BWT on FPGA)
1. Open `vivado_verilog/` in **Xilinx Vivado**
2. Add `bwt.v` and `bwt_tb.v` to your project
3. Simulate the testbench
4. Observe output:
   - Binary BWT
   - Decoded characters
   - Dollar marker position

---

##  Reports and Results

###  Simulation Results
Located in `vivado_verilog/Simulation_Results/`  
- RTL Simulation Waveform  
- Console Output (Decoded BWT String)

### Utilization & Power Reports
Located in `vivado_verilog/Reports/`  
- Slice LUT utilization  
- Register and BRAM usage  
- Power consumption estimates

---

##  Future Work

- Add hardware modules for **FM-index Search**
- Extend Python pipeline to support **multi-seed reconstruction**

---


