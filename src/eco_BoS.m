function [inp,par,eco] = eco_BoS(inp,par,eco)

  eco.BoS.sitePrep.CAPEX = par.BoS.sitePrep.p * inp.system.P_rated/1e3;
  eco.BoS.found.CAPEX    = par.BoS.found.p    * inp.system.P_rated/1e3;
  eco.BoS.install.CAPEX  = par.BoS.install.p  * inp.system.P_rated/1e3;
  eco.BoS.OM.OPEX        = par.BoS.OM.p       * inp.system.P_rated/1e3;
  eco.BoS.decomm.CAPEX   = par.BoS.decomm.f   * eco.BoS.install.CAPEX;

end