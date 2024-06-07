function [inp,par,eco] = eco_kite(inp,par,eco)
  %ECO_KITE Calculate costs related to kite subsystem in AWE-Eco simulation.
  %   This function computes the capital expenditure (CAPEX) and operational
  %   expenditure (OPEX) associated with the kite subsystem, including structure,
  %   onboard generators, onboard batteries, and avionics.
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
  
  global eco_settings

  %% Structure
  % find wing area if wingspan and aspect ratio are provided
  if isfield(inp.kite.structure,'b')
      inp.kite.structure.A = inp.kite.structure.b^2/inp.kite.structure.AR; % m^2
  end
  
  switch eco_settings.wing
      case 'fixed'
          switch par.kite.structure.fixed.approach
              case 1
                % CAPEX
                  eco.kite.structure.CAPEX = par.kite.structure.fixed.one.p_str * inp.kite.structure.m + ...
                      par.kite.structure.fixed.one.p_wet * inp.kite.structure.A;
                  
              case 2
                % CAPEX
                  eco.kite.structure.CAPEX = (1+par.kite.structure.fixed.two.f_man)*...
                      (par.kite.structure.fixed.two.p_uni  * inp.kite.structure.m_uni + ...
                      par.kite.structure.fixed.two.p_triax * inp.kite.structure.m_tri);
          end

          % OPEX
          eco.kite.structure.OPEX = inp.kite.structure.f_repl * eco.kite.structure.CAPEX; % Capex times replacement frequency
          
      case 'soft'
          % CAPEX
          eco.kite.structure.CAPEX = (par.kite.structure.soft.p_fabric + par.kite.structure.soft.p_bridle ) * inp.kite.structure.A;
          
          % OPEX
          if inp.kite.structure.f_repl < 0
              LF = trapz(inp.atm.wind_range,inp.atm.gw.*inp.system.F_t./max(inp.system.F_t));
              inp.kite.structure.f_repl = LF/par.kite.structure.soft.L_str;
          end
          eco.kite.structure.OPEX = inp.kite.structure.f_repl* eco.kite.structure.CAPEX; % Capex times replacement frequency
  
  end

  %% Onboard generators batteries
  switch eco_settings.power
      case 'FG'
        % Onboard generators
        eco.kite.obGen.CAPEX = par.kite.obGen.p * inp.system.P_e_rated/1e3;  
        eco.kite.obGen.OPEX  = 0;
          
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