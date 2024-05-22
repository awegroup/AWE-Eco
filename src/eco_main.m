%% EcoModel
% A Reference Economic Model for Airborne Wind Energy Systems

% Authors
% - Rishikesh Joshi, 
%   Delft University of Technology
%
% - Filippo Trevisi,
%   Politecnico di Milano

% License: MIT

function [inp,par,eco] = eco_main()  
  
  % Import system data
  inp = eco_inputs;
  
  % Import cost model parameters
  par = eco_import_cost_par;

  % Defined structure to store results
  eco = struct;
  
  % Kite
  [inp,par,eco] = eco_kite(inp,par,eco);
  
  % Tether
  [inp,par,eco] = eco_tether(inp,par,eco);
  
  % Ground station
  [inp,par,eco] = eco_gStation(inp,par,eco);
  
  % BoS
  [inp,par,eco] = eco_BoS(inp,par,eco);
  
  % BoP
  [inp,par,eco] = eco_BoP(inp,par,eco);
  
  % Compute metrics
  [inp,par,eco] = eco_computeMetrics(inp,par,eco);

end