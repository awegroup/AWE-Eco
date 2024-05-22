%% Example script to run the EcoModel

%% Clear memory
clear; clear global; close all; clc

%% Add necessary folders to path
addpath(genpath([pwd '\inputData']));
addpath(genpath([pwd '\src']));

%% Import inputs
inp = eco_system_inputs_example;

%% Run EcoModel by parsing the inputs
[inp,par,eco] = eco_main(inp);

%% Display results
eco_displayResults(eco)
