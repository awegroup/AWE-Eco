%% Example script to run the EcoModel

%% Clear memory
clear; clear global; close all; clc

%% Add necessary folders to path
addpath(genpath([pwd '\inputData']));
addpath(genpath([pwd '\src']));

%% Run EcoModel
[inp,par,eco] = eco_main();

%% Display results
eco_displayResults(eco)
