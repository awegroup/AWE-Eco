function [inp,par,eco] = eco_kite(inp,par,eco)

  global eco_settings

  %% Structure

  switch eco_settings.wing
      case 'fixed'
          switch par.kite.structure.fixed.approach
              case 1
                  eco.kite.structure.CAPEX = par.kite.structure.fixed.one.p_str * inp.kite.structure.m + ...
                      par.kite.structure.fixed.one.p_wet * inp.kite.structure.A;
                  
              case 2
                  eco.kite.structure.CAPEX = (1+par.kite.structure.fixed.two.f_man)*...
                      (par.kite.structure.fixed.two.p_uni  * inp.kite.structure.m_uni + ...
                      par.kite.structure.fixed.two.p_triax * inp.kite.structure.m_tri);
          end
          eco.kite.structure.OPEX = inp.kite.structure.fixed.f_repl * eco.kite.structure.CAPEX; % Capex times replacement frequency
          
      case 'soft'
          eco.kite.structure.CAPEX = (par.kite.structure.soft.p_fabric + par.kite.structure.soft.p_bridle ) * inp.kite.structure.A;
          
          if inp.kite.structure.soft.f_repl < 0
              LF = trapz(inp.atm.wind_range,inp.atm.gw.*inp.system.F_t./max(inp.system.F_t));
              inp.kite.structure.soft.f_repl = LF/par.kite.structure.soft.L_str;
          end
          eco.kite.structure.OPEX = inp.kite.structure.soft.f_repl* eco.kite.structure.CAPEX; % Capex times replacement frequency
  
  end

  %% Onboard generators batteries

  switch eco_settings.power
      case 'FG'
        % Onboard generators
        eco.kite.obGen.CAPEX = par.kite.obGen.p * inp.system.P_e_rated/1e3;  
        eco.kite.obGen.OPEX  = 0;

        % Onboard batteries
        
          
      case 'GG'
        % Onboard generators
        eco.kite.obGen.CAPEX  = par.kite.obGen.p * inp.kite.obGen.P/1e3;
        eco.kite.obGen.OPEX   = 0;
          
        % Onboard batteries
        eco.kite.obBatt.CAPEX = par.kite.obBatt.p * inp.kite.obBatt.E;
        eco.kite.obBatt.CAPEX = 0;
          
  end
  
  %% Avionics
  
  eco.kite.avionics.CAPEX = par.kite.avio.C; 
  eco.kite.avionics.OPEX  = 0;

end