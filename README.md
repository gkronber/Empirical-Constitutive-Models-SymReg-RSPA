This repository contains data and code used for the paper Kabliman E., Kronberger G.: _Identification of Empirical Constitutive Models for Age-Hardenable Aluminium Alloy and High-Chromium Martensitic Steel Using Symbolic Regression_, Special Issue on Symbolic Regression in the Physical Sciences of the Proceedings of the Royal Society, Part A, 2026

## Data
The data used in this paper stems from different publications. If you use the data files please reference the corresponding paper.

Aluminium alloy data is from: Kabliman E, Kolody AH, Kommenda M, Kronberger G.: _Prediction of stress-strain curves for aluminium alloys using symbolic regression_. AIP Conference Proceedings 2113, 180009, 2019. (https://doi.org/10.1063/1.5112747)

Another publication using the same aluminium dataset is: Kronberger G, Kabliman E, Kronsteiner J, Kommenda M. _Extending a physics-based constitutive model using genetic programming._ Applications in Engineering Science 9, 100080, 2022 (https://doi.org/10.1016/j.apples.2021.100080)

Martensitic steel data is from: Eisenträger J, Naumenko K, Altenbach H, Gariboldi E.: _Analysis of temperature and strain rate dependencies of softening regime for tempered martensitic steel._ The Journal of Strain Analysis for Engineering Design 52, 226–238, 2017 (https://doi.org/10.1177/0309324717699746)

## Data Preprocessing
Julia code for data preprocessing is found in  `data/interpolate.jl` 

## Source 
Folder `src/` contains the python3 script to run the experiments with pyoperon `run_pyoperon.py`. 

Installation of pyoperon is required
`pip install pyoperon`

## Results
Logs of pyoperon runs with cross-validation and using the full datasets for training are found in the `results` folder.

## Plots
The `plots` folder contains the symbolic regression models extracted from the pyoperon runs with the full dataset at the length found via cross-validation (`models.plt`). 
The `paper.plt` file is a gnuplot script to produce the plots as shown in the paper. 

Requires gnuplot version 6.