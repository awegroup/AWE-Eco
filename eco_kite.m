function eco = eco_kite(inp,par,eco)
global eco_settings
%% Structure
if strcmp(eco_settings.wing,'fixed')
    if par.kite.structure.fixed.approach == 1
                
        eco.kite.structure.CAPEX = par.kite.structure.fixed.one.p_str * inp.kite.structure.m + ...
            par.kite.structure.fixed.one.p_wet * inp.kite.structure.A;
               
    elseif par.kite.structure.fixed.approach == 2

        eco.kite.structure.CAPEX = (1+par.kite.structure.fixed.two.f_man)*...
            (par.kite.structure.fixed.two.p_uni  * inp.kite.structure.m_uni + ...
            par.kite.structure.fixed.two.p_triax * inp.kite.structure.m_tri);        
    end
    eco.kite.structure.OPEX = inp.kite.f_repl * eco.kite.structure.CAPEX; % Capex times replacement frequency

elseif strcmp(eco_settings.wing,'soft')
    eco.kite.structure.CAPEX = par.kite.structure.soft.p_A  * inp.kite.structure.A;
    LF = trapz(inp.atm.wind_range,inp.atm.gw.*inp.system.F_t./max(inp.system.F_t));
    par.kite.structure.soft.f_repl = LF/par.kite.structure.soft.L_str;
    eco.kite.structure.OPEX = par.kite.structure.soft.f_repl * eco.kite.structure.CAPEX; % Capex times replacement frequency

end
%% On board generators & power electronics
if strcmp(eco_settings.power,'FG')   
    eco.kite.gen.CAPEX = par.kite.obgen.p * inp.system.P_rated/1e3;  % eco.cost of the eco_settings.powererator
    eco.kite.gen.OPEX = 0;

elseif strcmp(eco_settings.power,'GG')   
    eco.kite.gen.CAPEX = par.kite.obgen.p * inp.system.P_obgen/1e3;
    eco.kite.prop.CAPEX = par.kite.prop.p * inp.system.P_prop/1e3;
    eco.kite.batt.CAPEX = par.kite.prop.p * inp.system.E_batt;
    
end

%% Avionics
eco.kite.avionics.CAPEX =  par.kite.avionics.C; 
eco.kite.avionics.OPEX = 0;

end