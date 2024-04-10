classdef test_ecomodel_main < matlab.unittest.TestCase
    
  methods(Test)
        function realSolution(testCase)
            
            addpath(genpath([pwd '\inputData']));
            addpath(genpath([pwd '\src']));

            % Expected output
            exp_lcoe = 1.568984775835752e+02;
            exp_lroe = 83.364900976117450;
            exp_lpoe = -73.533576607457790;
            exp_npv = -4.806927431677931e+06;
            exp_icc = 5.395126573473667e+05;

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
            testCase.verifyEqual(eco.metrics.LRoE, exp_lroe, "RelTol", 0.1)
            testCase.verifyEqual(eco.metrics.LPoE, exp_lpoe, "RelTol", 0.1)
            testCase.verifyEqual(eco.metrics.NPV, exp_npv, "RelTol", 0.1)
            testCase.verifyEqual(eco.metrics.ICC, exp_icc, "RelTol", 0.1)
        end
    end
end