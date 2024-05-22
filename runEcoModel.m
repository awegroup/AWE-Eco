%% EcoModel

% A Reference Economic Model for Airborne Wind Energy Systems

% Authors
% - Rishikesh Joshi, 
%   Delft University of Technology
%
% - Filippo Trevisi,
%   Politecnico di Milano

% License: MIT

%% Clear memory

clear; clear global;
close all;
clc

%% Add folders to path

addpath(genpath([pwd '\inputData']));
addpath(genpath([pwd '\src']));

global eco_settings

%% Inputs

eco_settings.input_cost_file  = 'Eco_GG_fixed.xlsx'; % set the input file
eco_settings.input_model_file = 'code'; % code || set the input file
eco_settings.power            = 'GG';  % FG || GG 
eco_settings.wing             = 'fixed';  % fixed || soft

%% Import or create system to be evaluated

inp = eco_inputs;

%% Import cost model parameters

par = eco_import_cost_par;

%% Evaluate metrics

[inp,par,eco] = eco_main(inp,par);

%% Display results

eco_displayResults(eco)
