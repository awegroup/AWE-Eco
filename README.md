# Reference Economic Model for Airborne Wind Energy Systems
![GitHub License](https://img.shields.io/github/license/awegroup/AWE-Eco)
![Static Badge](https://img.shields.io/badge/MATLAB-R2021b-blue)
[![DOI](https://zenodo.org/badge/784601047.svg)](https://zenodo.org/doi/10.5281/zenodo.12166696)



This is a MATLAB code implementation of the [Reference Economic Model for Airborne Wind Energy Systems](https://doi.org/10.5281/zenodo.10959930).

This is an active repository and hence we invite developers to contribute in developing this model further. Check `CONTRIBUTING.md` to know how you can contribute.

## Citation

If you use AWE-Eco in your work, please cite the associated report using the following format:

Rishikesh Joshi and Filippo Trevisi (2024) "Reference Economic Model for Airborne Wind Energy Systems" (Version 1). IEA Wind TCP Task 48. https://doi.org/10.5281/zenodo.10959930. 

You can access the newest version of the report here - https://doi.org/10.5281/zenodo.8114627.

## Dependencies
The model is built and tested in MATLAB R2021b (without needing additional Add-ons). Try installing this version if your version of MATLAB does not execute the code successfully.
The input files use .xlsx file format.

## Installation and execution 
Please Clone or Download the repository to start using the model.

To clone execute in the terminal
```
git clone https://github.com/awegroup/AWE-Eco.git
```

To download as .zip file of the latest release, click on the following link: https://github.com/awegroup/AWE-Eco/archive/refs/tags/v0.1.0.zip

### run_aweEco.m
This is the main script for running the economic model. Users can create instances of this script to run with their own inputs. 

### inputData
This folder contains some example input data which can be used to run the model. The inputs data can be defined in an Excel file or in a MATLAB function. 

### src
This folder contains all the source files of the model.

## Licence
This project is licensed under the MIT License. Please see the below WAIVER in association with the license.

## Acknowledgement
The project was supported by the Digital Competence Centre, Delft University of Technology.

### WAIVER
Technische Universiteit Delft hereby disclaims all copyright interest in the program “AWE-Eco” (a reference economic model for airborne wind energy systems) written by the Author(s).

Prof.dr. H.G.C. (Henri) Werij, Dean of Aerospace Engineering

Copyright (c) 2024 Rishikesh Joshi & Filippo Trevisi