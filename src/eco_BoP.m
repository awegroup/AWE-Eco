function [inp,par,eco] = eco_BoP(inp,par,eco)
  %ECO_BOP Calculate costs related to Balance of Plant (BoP) subsystem in AWE-Eco simulation.
  %   This function computes the capital expenditure (CAPEX) and operational
  %   expenditure (OPEX) associated with the BoP subsystem, including array cables,
  %   substations, and grid integration.
  %
  %   Inputs:
  %   - inp: Structure containing input parameters for the AWE-Eco simulation.
  %   - par: Structure containing cost model parameters.
  %   - eco: Structure containing results and metrics of the AWE-Eco simulation.
  %
  %   Outputs:
  %   - inp: Updated input structure after processing.
  %   - par: Updated parameter structure.
  %   - eco: Updated structure containing results and metrics.
  
  eco.BoP.arrayCables.CAPEX = 0;
  eco.BoP.substations.CAPEX = 0;
  eco.BoP.gridInt.CAPEX     = 0;

  eco.BoP.arrayCables.OPEX  = 0;
  eco.BoP.substations.OPEX  = 0;
  eco.BoP.gridInt.OPEX      = 0;

end