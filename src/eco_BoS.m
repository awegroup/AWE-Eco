function [inp,par,eco] = eco_BoS(inp,par,eco)
  %ECO_BOS Calculate costs related to Balance of System (BoS) subsystem in AWE-Eco simulation.
  %   This function computes the capital expenditure (CAPEX) and operational
  %   expenditure (OPEX) associated with the BoS subsystem, including site preparation,
  %   foundation, installation, operations and maintenance (O&M), and decommissioning.
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
  
  eco.BoS.sitePrep.CAPEX = par.BoS.sitePrep.p * inp.system.P_e_rated/1e3;
  eco.BoS.found.CAPEX    = par.BoS.found.p    * inp.system.P_e_rated/1e3;
  eco.BoS.install.CAPEX  = par.BoS.install.p  * inp.system.P_e_rated/1e3;
  eco.BoS.OM.OPEX        = par.BoS.OM.p       * inp.system.P_e_rated/1e3;
  eco.BoS.decomm.CAPEX   = par.BoS.decomm.f   * eco.BoS.install.CAPEX;

end