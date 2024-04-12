clear; clear global;
close all;
clc
%%

addpath(genpath([pwd '\inputData']));
addpath(genpath([pwd '\src']));

global eco_settings

%%
eco_settings.input_cost_file = 'Eco.xlsx'; % set the input file
eco_settings.input_model_file = 'code'; % code || set the input file
eco_settings.power = 'FG';  % FG || GG 
eco_settings.wing = 'fixed';  % fixed || soft

%% Import or create system to be evaluated
inp = eco_inputs;

%% Import cost model parameters
par = eco_import_cost_par;

%% Evaluate costs
[eco] = eco_main(inp,par);

%% Display outputs
disp(['LCoE = ',num2str(round(eco.metrics.LCoE)),' eur/MWh'])
disp(['LRoE = ',num2str(round(eco.metrics.LRoE)),' eur/MWh'])
disp(['LPoE = ',num2str(round(eco.metrics.LPoE)),' eur/MWh'])
disp(['NPV = ',num2str(round(eco.metrics.NPV/1e3)),' k eur'])
disp(['ICC = ',num2str(round(eco.metrics.ICC/1e3)),' k eur'])
disp(['Profit = ',num2str(round(eco.metrics.Pi/1e3)),' k eur/y'])
