classdef test_ecomodel_main < matlab.unittest.TestCase
    
  methods(Test)
        function realSolution(testCase)
            
            addpath(genpath([pwd '\inputData']));
            addpath(genpath([pwd '\src']));

            % Expected output
            exp_lcoe = 157;
            exp_lroe = 83;
            exp_lpoe = -74;
            exp_npv = -4807;
            exp_icc = 540;

            % Eco settings
            global eco_settings
            eco_settings.input_cost_file = 'Eco.xlsx'; % set the input file
            eco_settings.input_model_file = 'code'; % code || set the input file
            eco_settings.power = 'GG';  % FG || GG 
            eco_settings.wing = 'fixed';  % fixed || soft
            
            inp = eco_inputs;
            par = eco_import_cost_par;
            [eco] = eco_main(inp,par);

                       
            testCase.verifyEqual(eco.metrics.LCoE, exp_lcoe, "RelTol", 0.1)
            
        end
    end
end