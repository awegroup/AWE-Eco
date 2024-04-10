function eco = eco_LLA(inp,par,eco)
global eco_settings
%%
if strcmp(eco_settings.TOL,'VTOL')    
    eco.LLA.CAPEX = 0;
    eco.LLA.OPEX = 0;
    
elseif strcmp(eco_settings.TOL,'HTOL')
    eco.LLA.electronics.CAPEX = par.LLA.electronics;
    eco.LLA.electronics.OPEX = 0;
    
    eco.LLA.mechanism.CAPEX = par.LLA.mechanism.p_m * 0;
    eco.LLA.mechanism.OPEX = 0;
    
    eco.LLA.steelwork.CAPEX = par.LLA.steelwork.p_m*0;
    eco.LLA.steelwork.OPEX = 0;
end

end