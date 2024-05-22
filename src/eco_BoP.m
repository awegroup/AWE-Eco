function [inp,par,eco] = eco_BoP(inp,par,eco)

  eco.BoP.arrayCables.CAPEX = 0;
  eco.BoP.substations.CAPEX = 0;
  eco.BoP.gridInt.CAPEX     = 0;

  eco.BoP.arrayCables.OPEX  = 0;
  eco.BoP.substations.OPEX  = 0;
  eco.BoP.gridInt.OPEX      = 0;

end