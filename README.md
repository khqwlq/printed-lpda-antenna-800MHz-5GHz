# printed-lpda-antenna-800MHz-5GHz


This repository contains the complete design, analytical script, and EM simulation files for an Ultra-Wideband (UWB) Printed Log-Periodic Dipole Array (LPDA) antenna operating from **800 MHz to 5 GHz**. 

This project was developed during an internship at the **Centre de Développement des Technologies Avancées (CDTA)** 

## 📡 Technical Specifications
* **Frequency Range:** 800 MHz – 5.0 GHz (UWB)
* **Antenna Type:** Printed Log-Periodic Dipole Array (LPDA)
* **Software Tool:** CST Studio Suite
* **Analytical Modeling:** MATLAB

## 🗂️ Repository Contents
* `/simulation`: Core `.cst` simulation model and theoretical scripts.
  * `parameters_generator.m`: MATLAB script used to analytically determine the scaling factor ($\tau$), spacing factor ($\sigma$), and lengths of the dipole elements.
  * `/macros`: Contains `build_lpda_geometry.vba`, the custom VBA macro script written to fully automate the parametric construction of the LPDA layers inside CST.
* `/data`: Raw Touchstone (`.s1p`) S11 data and broadband gain text files.
* `/images`: High-resolution far-field radiation patterns and performance plots.


## How to Reproduce
1. Run `simulation/parameters_generator.m` in MATLAB to inspect the geometric progression calculations.
2. Open `simulation/lpda_800mhz_5ghz.cst` in CST Studio Suite to review the layout, ports, boundary conditions, and solver parameters.
3. Alternatively, you can use the VBA macro located in `simulation/macros/build_lpda_geometry.vba` within CST's Macro Editor to automatically reconstruct or modify the parametric structure of the antenna dynamically.
## 👤 Author
* **Khaoula Bendjeddou** - Master 1 in Space Telecommunications, University of Blida 1.
* **Supervised by:** Bachir Zoubiri (CDTA).
