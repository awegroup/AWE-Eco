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

%% Evaluate costs

[inp,par,eco] = eco_main(inp,par);

%% Display outputs

disp(['LCoE = ',num2str(round(eco.metrics.LCoE)),' €/MWh'])
disp(['CoVE = ',num2str(round(eco.metrics.CoVE)),' €/MWh'])
disp(['LRoE = ',num2str(round(eco.metrics.LRoE)),' €/MWh'])
disp(['LPoE = ',num2str(round(eco.metrics.LPoE)),' €/MWh'])
disp(['NPV = ',num2str(round(eco.metrics.NPV/1e3)),' k€'])
disp(['ICC = ',num2str(round(eco.metrics.ICC/1e3)),' k€'])
disp(['Profit = ',num2str(round(eco.metrics.Pi/1e3)),' k€/year'])
