function eco = eco_business(inp,par,eco)
global eco_settings
%%
if strcmp(eco_settings.business,'off-grid')
    eco.business.installation.CAPEX = 0;  
    eco.business.decomissioning.CAPEX = 0;

elseif strcmp(eco_settings.business,'single-unit')
    eco.business.installation.CAPEX = 0;  
    
    eco.business.grid.CAPEX = 0;  
    eco.business.grid.OPEX = 0;  
    
    eco.business.decomissioning.CAPEX = 0;
    
elseif strcmp(eco_settings.business,'flock')
    eco.business.installation.CAPEX = 0;
    
    eco.business.cables.CAPEX = 0;
    eco.business.cables.OPEX = 0;
    
    eco.business.sub_station.CAPEX = 0;
    eco.business.sub_station.OPEX = 0;
    
    eco.business.grid.CAPEX = 0;
    eco.business.grid.OPEX = 0;
    
    eco.business.decomissioning.CAPEX = 0;
elseif strcmp(eco_settings.business,'power2X')
    eco.business.installation.CAPEX = 0;
    eco.business.decomissioning.CAPEX = 0;

end



end