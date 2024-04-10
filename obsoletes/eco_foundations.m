function eco = eco_foundations(inp,par,eco)
global eco_settings
%%
if strcmp(eco_settings.foundations,'on-shore')
    eco.foundations.CAPEX = 0;
    eco.foundations.OPEX = 0;
    
elseif strcmp(eco_settings.foundations,'floating')
    eco.foundations.floater.CAPEX = 0;
    eco.foundations.floater.OPEX = 0;
    
    eco.foundations.lines.CAPEX = 0;
    eco.foundations.lines.OPEX = 0;
    
end


end