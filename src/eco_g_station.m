function eco = eco_g_station(inp,par,eco)

global eco_settings
if strcmp(eco_settings.power,'GG')
    %% Winch
    D_winch = par.gStation.winch.dwinch_dt * inp.tether.d;
    sigma_t = 1500;
    SF_dt = 1.1;
    SF_Lt = 1.1;
    
    if par.gStation.winch.material  == 1 % alluminium
        t_winch = pi/4 * sigma_t/par.gStation.winch.sigma_al * inp.tether.d;
        m_winch = pi/4/(D_winch^2 - (D_winch-2*t_winch)^2) * inp.tether.L * inp.tether.d/(D_winch*pi) * par.gStation.winch.rho_al * SF_dt * SF_Lt;
        eco.gStation.winch.CAPEX = m_winch * par.gStation.winch.p_al;
        
    elseif par.gStation.winch.material  == 2 % steal
        t_winch = pi/4 * sigma_t/par.gStation.winch.sigma_st * inp.tether.d;
        m_winch = pi/4/(D_winch^2 - (D_winch-2*t_winch)^2) * inp.tether.L * inp.tether.d/(D_winch*pi) * par.gStation.winch.rho_st * SF_dt * SF_Lt;
        eco.gStation.winch.CAPEX = m_winch * par.gStation.winch.p_st;
    end
    eco.gStation.winch.OPEX = 0;
    
    %% Drivetrain
    
    %% Electrical drivetrain
    if par.gStation.drivetrain_type == 1 % electric
        
        % Gearbox
        if par.gStation.gearbox.approach == 1
            eco.gStation.gearbox.CAPEX = par.gStation.gearbox.one.p * inp.system.P_out_rated/1e3;
        elseif par.gStation.gearbox.approach == 2
            m_gb = par.gStation.gearbox.two.k * (max(inp.system.F_t)*D_winch/2/1e3)^par.gStation.gearbox.two.b; % check with Rishi
            eco.gStation.gearbox.CAPEX = par.gStation.gearbox.two.p * m_gb;
        end
        eco.gStation.gearbox.OPEX = 0;
        
        % Electric generator
        if par.gStation.gen.approach == 1
            eco.gStation.gen.CAPEX = par.gStation.gen.one.p * inp.system.P_out_rated/1e3;
        elseif par.gStation.gen.approach == 2
            m_gen = par.gStation.gen.two.k * inp.system.P_out_rated/1e3 + par.gStation.gen.two.b;
            eco.gStation.gen.CAPEX = par.gStation.gen.two.p * m_gen;
        end
        eco.gStation.gen.OPEX = 0;
        
        % Ultracapacitors
        eco.gStation.ultracap.CAPEX = par.gStation.ultracap.p * inp.system.E_rated_uc/1e3;
        if isfield(inp.system,'f_repl_uc')==0
            inp.system.f_repl_uc = (8760 * trapz(inp.atm.wind_range,inp.atm.gw.* inp.system.E_ex_uc./inp.system.Dt_cycle) /inp.system.E_rated_uc)/par.gStation.ultracap.N;
        end
        eco.gStation.ultracap.OPEX = inp.system.f_repl_uc * eco.gStation.ultracap.CAPEX;
        
        % Power converters
        eco.gStation.powerConv.CAPEX = par.gStation.powerConv.p * (inp.system.P_rated + inp.system.P_out_rated)/1e3;
        eco.gStation.powerConv.OPEX = 0;
    end
    
    %% Hydraulic drivetrain
    if par.gStation.drivetrain_type == 2 % Hydraulic
        
        % pump Motor
        eco.gStation.pumpMotor.CAPEX = par.gStation.pumpMotor.p_1 * inp.system.P_out_rated/1e3;
        eco.gStation.pumpMotor.OPEX = par.gStation.pumpMotor.f_om * par.gStation.pumpMotor.p_2 * inp.system.P_out_rated/1e3;
        
        % Hydropneumatic accumulator bank
        eco.gStation.hydAccum.CAPEX = par.gStation.hydAccum.p_1.* inp.system.E_ex_hacc/1e3;
        eco.gStation.hydAccum.OPEX  = par.gStation.hydAccum.f_om *  par.gStation.hydAccum.p_2.* inp.system.E_ex_hacc/1e3;
        
        % Hydraulic motor
        eco.gStation.hydMotor.CAPEX = par.gStation.hydMotor.p_1 * inp.system.P_rated/1e3;
        eco.gStation.hydMotor.OPEX = par.gStation.hydMotor.f_om *  par.gStation.hydMotor.p_2 * inp.system.P_rated/1e3;
        
        % Electric generator
        if par.gStation.gen.approach == 1
            eco.gStation.gen.CAPEX = par.gStation.gen.one.p * inp.system.P_rated/1e3;
        elseif par.gStation.gen.approach == 2
            m_gen = par.gStation.gen.two.k * inp.system.P_rated/1e3 + par.gStation.gen.two.b;
            eco.gStation.gen.CAPEX = par.gStation.gen.two.p * m_gen;
        end
        eco.gStation.gen.OPEX = 0;

    end
end

%% Launch & land system
eco.gStation.lls.CAPEX = 0;
eco.gStation.lls.OPEX = 0;

%% Yaw system
eco.gStation.yaw.CAPEX = 0;
eco.gStation.yaw.OPEX = 0;

%% Control and communication unit
eco.gStation.control.CAPEX = 0;
eco.gStation.control.OPEX = 0;

end