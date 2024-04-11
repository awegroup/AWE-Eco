classdef test_ecomodel_main < matlab.unittest.TestCase
    
  methods(Test)
        function test_FG(testCase)
            
            addpath(genpath([pwd '\..\inputData']));
            addpath(genpath([pwd '\..\src']));

            
            exp_lcoe_FG       = 57.552534648588946;
            

            % Eco settings
            global eco_settings
            eco_settings.input_cost_file = 'Eco.xlsx'; % set the input file
            eco_settings.input_model_file = 'code'; % code || set the input file
            eco_settings.power = 'FG';  % FG || GG 
            eco_settings.wing = 'fixed';  % fixed || soft
            
            inp = eco_inputs;
            par = eco_import_cost_par;
            [eco] = eco_main(inp,par);

            
            testCase.verifyEqual(eco.metrics.LCoE, exp_lcoe_FG, "RelTol", 0.1)
            
        end
        
        function test_GG_fixed(testCase)
            
            addpath(genpath([pwd '\..\inputData']));
            addpath(genpath([pwd '\..\src']));

            exp_lcoe_GG_fixed = 1.568984775835752e+02;
            
           

            % Eco settings
            global eco_settings
            eco_settings.input_cost_file = 'Eco.xlsx'; % set the input file
            eco_settings.input_model_file = 'code'; % code || set the input file
            eco_settings.power = 'GG';  % FG || GG 
            eco_settings.wing = 'fixed';  % fixed || soft
            
            inp = eco_inputs;
            par = eco_import_cost_par;
            [eco] = eco_main(inp,par);

            
            testCase.verifyEqual(eco.metrics.LCoE, exp_lcoe_GG_fixed, "RelTol", 0.1)
        end

        function test_GG_soft(testCase)
            
            addpath(genpath([pwd '\..\inputData']));
            addpath(genpath([pwd '\..\src']));
            
            exp_lcoe_GG_soft  = 1.412295577674939e+02;

            % Eco settings
            global eco_settings
            eco_settings.input_cost_file = 'Eco.xlsx'; % set the input file
            eco_settings.input_model_file = 'code'; % code || set the input file
            eco_settings.power = 'GG';  % FG || GG 
            eco_settings.wing = 'soft';  % fixed || soft
            
            inp = eco_inputs;
            par = eco_import_cost_par;
            [eco] = eco_main(inp,par);

            
            testCase.verifyEqual(eco.metrics.LCoE, exp_lcoe_GG_soft, "RelTol", 0.1)
             
         end  
    end
end
