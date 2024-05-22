function [inp,par,eco] = eco_gStation(inp,par,eco)

  global eco_settings
  
  switch  eco_settings.power
      case 'GG'
          % Winch     
          eco.gStation.winch.D = par.gStation.winch.dwinch_dt * inp.tether.d;   
          switch par.gStation.winch.material
              case 1 % alluminium
                  eco.gStation.winch.t = pi/4 * par.tether.sigma_max/par.gStation.winch.sigma_al * inp.tether.d;
                  eco.gStation.winch.m = pi/4*(eco.gStation.winch.D^2 - (eco.gStation.winch.D-2*eco.gStation.winch.t)^2) * inp.tether.L * inp.tether.d/(eco.gStation.winch.D*pi) * par.gStation.winch.rho_al * par.gStation.winch.SF_dt * par.gStation.winch.SF_Lt;
                  eco.gStation.winch.CAPEX = eco.gStation.winch.m * par.gStation.winch.p_al;
                  
            case 2 % steel
                  eco.gStation.winch.t = pi/4 * par.tether.sigma_max/par.gStation.winch.sigma_st * inp.tether.d;
                  eco.gStation.winch.m = pi/4*(eco.gStation.winch.D^2 - (eco.gStation.winch.D-2*eco.gStation.winch.t)^2) * inp.tether.L * inp.tether.d/(eco.gStation.winch.D*pi) * par.gStation.winch.rho_st * par.gStation.winch.SF_dt * par.gStation.winch.SF_Lt;
                  eco.gStation.winch.CAPEX = eco.gStation.winch.m * par.gStation.winch.p_st;
          end
          eco.gStation.winch.OPEX = 0;
          
          % Drivetrain
          switch par.gStation.drivetrain_type
              case 1 % electric drivetrain                  
                  % Gearbox
                  switch par.gStation.gearbox.approach
                      case 1
                          eco.gStation.gearbox.CAPEX = par.gStation.gearbox.one.p * inp.system.P_m_peak/1e3;
                      case 2
                          eco.gStation.gearbox.m = par.gStation.gearbox.two.k * (max(inp.system.F_t)*eco.gStation.winch.D/2/1e3)^par.gStation.gearbox.two.b; 
                          eco.gStation.gearbox.CAPEX = par.gStation.gearbox.two.p * eco.gStation.gearbox.m;
                  end
                  eco.gStation.gearbox.OPEX = 0;
                  
                  % Electric generator
                  switch par.gStation.gen.approach
                      case 1
                          eco.gStation.gen.CAPEX = par.gStation.gen.one.p * inp.system.P_m_peak/1e3;
                      case 2
                          eco.gStation.gen.m = par.gStation.gen.two.k * inp.system.P_m_peak/1e3 + par.gStation.gen.two.b;
                          eco.gStation.gen.CAPEX = par.gStation.gen.two.p * eco.gStation.gen.m;
                  end
                  eco.gStation.gen.OPEX = 0;
                  
                  % Ultracapacitors
                  eco.gStation.ultracap.CAPEX = par.gStation.ultracap.p * inp.gStation.ultracap.E_rated;
                  if inp.gStation.ultracap.f_repl<0
                      inp.gStation.ultracap.f_repl = (8760 * trapz(inp.atm.wind_range,inp.atm.gw.* fillmissing(inp.gStation.ultracap.E_ex./(inp.system.Dt_cycle./3600),'constant',0)) /inp.gStation.ultracap.E_rated)/par.gStation.ultracap.N;
                  end
                  eco.gStation.ultracap.OPEX = inp.gStation.ultracap.f_repl * eco.gStation.ultracap.CAPEX;
                  
                  % Power converters
                  eco.gStation.powerConv.CAPEX = par.gStation.powerConv.p * (inp.system.P_e_rated + inp.system.P_m_peak)/1e3;
                  eco.gStation.powerConv.OPEX = 0;
                  
                  
              case 2 % Hydraulic drivetrain                   
                  % pump Motor
                  eco.gStation.pumpMotor.CAPEX = par.gStation.pumpMotor.p_1 * inp.system.P_m_peak/1e3;
                  eco.gStation.pumpMotor.OPEX = inp.gStation.pumpMotor.f_repl * par.gStation.pumpMotor.p_2 * inp.system.P_m_peak/1e3;
                  
                  % Hydropneumatic accumulator bank
                  eco.gStation.hydAccum.CAPEX = par.gStation.hydAccum.p_1.* inp.gStation.hydAccum.E_rated/1e3;
                  eco.gStation.hydAccum.OPEX  = inp.gStation.hydAccum.f_repl *  par.gStation.hydAccum.p_2.* inp.gStation.hydAccum.E_ex/1e3;
                  
                  % Hydraulic motor
                  eco.gStation.hydMotor.CAPEX = par.gStation.hydMotor.p_1 * inp.system.P_e_rated/1e3;
                  eco.gStation.hydMotor.OPEX = inp.gStation.hydMotor.f_repl *  par.gStation.hydMotor.p_2 * inp.system.P_e_rated/1e3;
                  
                  % Electric generator
                  switch par.gStation.gen.approach
                      case 1
                          eco.gStation.gen.CAPEX = par.gStation.gen.one.p * inp.system.P_e_rated/1e3;
                      case 2
                          eco.gStation.gen.m = par.gStation.gen.two.k * inp.system.P_e_rated/1e3 + par.gStation.gen.two.b;
                          eco.gStation.gen.CAPEX = par.gStation.gen.two.p * eco.gStation.gen.m;
                  end
                  eco.gStation.gen.OPEX = 0;                  
          end
          
      case 'FG'
          % Winch
          eco.gStation.winch.D = par.gStation.winch.dwinch_dt * inp.tether.d;        
          switch par.gStation.winch.material
              case 1 % alluminium
                  eco.gStation.winch.t = inp.tether.d;
                  eco.gStation.winch.m = pi/4*(eco.gStation.winch.D^2 - (eco.gStation.winch.D-2*eco.gStation.winch.t)^2) * inp.tether.L * inp.tether.d/(eco.gStation.winch.D*pi) * par.gStation.winch.rho_al * par.gStation.winch.SF_dt * par.gStation.winch.SF_Lt;
                  eco.gStation.winch.CAPEX = eco.gStation.winch.m * par.gStation.winch.p_al;
                  
              case 2 % steal
                  eco.gStation.winch.t = inp.tether.d;
                  eco.gStation.winch.m = pi/4*(eco.gStation.winch.D^2 - (eco.gStation.winch.D-2*eco.gStation.winch.t)^2) * inp.tether.L * inp.tether.d/(eco.gStation.winch.D*pi) * par.gStation.winch.rho_st * par.gStation.winch.SF_dt * par.gStation.winch.SF_Lt;
                  eco.gStation.winch.CAPEX = eco.gStation.winch.m * par.gStation.winch.p_st;
          end
          eco.gStation.winch.OPEX = 0;
          
          % Ultracapacitors
          eco.gStation.ultracap.CAPEX = par.gStation.ultracap.p * inp.gStation.ultracap.E_rated;
           if inp.gStation.ultracap.f_repl<0
              inp.gStation.ultracap.f_repl = 8760 * trapz(inp.atm.wind_range,inp.atm.gw.* inp.atm.wind_range .* inp.system.lambda /(2*pi*inp.system.R0) ) /par.gStation.ultracap.N;
          end
          eco.gStation.ultracap.OPEX = inp.gStation.ultracap.f_repl * eco.gStation.ultracap.CAPEX;
          
          % Power converters
          eco.gStation.powerConv.CAPEX = 2 * par.gStation.powerConv.p * inp.system.P_e_rated/1e3;
          eco.gStation.powerConv.OPEX  = 0;
          
  end
  
  %% Launch & land system
  eco.gStation.lls.CAPEX = 0;
  eco.gStation.lls.OPEX  = 0;
  
  %% Yaw system
  eco.gStation.yaw.CAPEX = 0;
  eco.gStation.yaw.OPEX  = 0;
  
  %% Control and communication unit
  eco.gStation.controlStation.CAPEX = 0;
  eco.gStation.controlStation.OPEX  = 0;

end