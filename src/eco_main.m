function [inp,par,eco] = eco_main(inp)  
  %ECO_MAIN Main function to run AWE-Eco simulation.
  %   This function orchestrates the AWE-Eco simulation by importing input data,
  %   defining cost model parameters, executing subsystem modules (kite, tether,
  %   ground station, BoS, BoP), and computing relevant metrics.
  %
  %   Inputs:
  %   - inp: Structure containing input parameters for the AWE-Eco simulation.
  %
  %   Outputs:
  %   - inp: Updated input structure after processing.
  %   - par: Structure containing cost model parameters.
  %   - eco: Structure containing results and metrics of the AWE-Eco simulation.
  %
  %   See also: eco_import_cost_par, eco_kite, eco_tether, eco_gStation,
  %   eco_BoS, eco_BoP, eco_computeMetrics.
  
  global eco_settings

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

  % Save outputs 
  if not(isfolder('outputFiles'))
    mkdir 'outputFiles';
  end
  % Change names to associate with specific input file
  save(['outputFiles/' eco_settings.name '_' 'inp' '.mat'], 'inp');
  save(['outputFiles/' eco_settings.name '_' 'par' '.mat'], 'par');
  save(['outputFiles/' eco_settings.name '_' 'eco' '.mat'], 'eco');


end