function [inp,par,eco] = eco_tether(inp,par,eco)

  global eco_settings

  % Tether cross sectional area
  if isfield(inp.tether,'d')
      inp.tether.A = pi/4*inp.tether.d^2;
  elseif isfield(inp.tether,'A')
      inp.tether.d = sqrt(4*inp.tether.A/pi);
  end

  % For brevity in code
  t = inp.tether;

  %% CAPEX 
  switch  eco_settings.power
      case 'GG'
          eco.tether.CAPEX = par.tether.p * t.A *par.tether.f_At* t.L * t.rho * (1+ par.tether.f_coat);
                  
      case 'FG'
          eco.tether.CAPEX  = par.tether.f_mt * (par.tether.p * t.A *par.tether.f_At * t.L * t.rho * (1+ par.tether.f_coat));
  end
  sigma = min(inp.system.F_t' / (par.tether.f_At*t.A), par.tether.sigma_max)';
  
  %% OPEX
  % Tether life extimation due to bending - Relevant for GG
  switch  eco_settings.power
      case 'GG'
          exp = par.tether.a_1b - par.tether.a_2b * sigma/1e9;
          Nb = 10.^exp;
          integral_term = inp.atm.gw./(inp.system.Dt_cycle./8760./3600.*Nb);
          integral_term(isinf(integral_term)) = 0;
          L_bend = 1./(par.tether.N_bends * trapz(inp.atm.wind_range,integral_term));
          eco.tether.f_repl_bend = 1/L_bend/3; % 3 times correction factor
  end

  % Tether life extimation due to creep - Relevant for FG
  exp = polyval(par.tether.L_creep,sigma/1e9);
  L_creep = 10.^exp;
  life_creep = 1./(trapz(inp.atm.wind_range,inp.atm.gw./L_creep));
  eco.tether.f_repl_creep = 1/life_creep;
  
  % Set tether life to infinte is tether life > AWE operational years
  if inp.tether.f_repl < 0
      switch  eco_settings.power
          case 'GG'
              eco.tether.f_repl = max([eco.tether.f_repl_bend,eco.tether.f_repl_creep]);
          case 'FG'
              eco.tether.f_repl = eco.tether.f_repl_creep;
      end
  end
  
  if 1/eco.tether.f_repl > inp.business.N_y
      eco.tether.f_repl = 0;
  end
  eco.tether.OPEX = eco.tether.f_repl * eco.tether.CAPEX ;

end