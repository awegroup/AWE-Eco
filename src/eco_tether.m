function eco = eco_tether(inp,par,eco)

global eco_settings
t = inp.tether;

if isfield(t,'d')
    t.A = pi/4*t.d^2;
elseif isfield(t,'A')
    t.d = sqrt(4*t.A/pi);
end

%% Tether capex cost & Tether life extimation due to bending
switch  eco_settings.power
    case 'GG'
        eco.tether.CAPEX = par.tether.p * t.A *par.tether.f_At* t.L * t.rho * (1+ par.tether.f_coat);
                
    case 'FG'
        eco.tether.CAPEX  = par.tether.f_mt * (par.tether.p * t.A *par.tether.f_At * t.L * t.rho * (1+ par.tether.f_coat));
end
sigma = min(inp.system.F_t' / (par.tether.f_At*t.A), t.sigma_lim)';

%% Tether life extimation due to bending
switch  eco_settings.power
    case 'GG'
        exp = par.tether.a_1b - par.tether.a_2b * sigma/1e9;
        Nb = 10.^exp;
        Deltat_cycle = 1/inp.system.Dt_cycle/8760/3600;
        L_bend = 1./(par.tether.N_bends * trapz(inp.atm.wind_range,inp.atm.gw./( Deltat_cycle*Nb )));
        eco.tether.f_repl_bend = 1/L_bend/3; % 3 times correction factor
        
end
%% Tether life extimation due to creep
exp = polyval(par.tether.L_creep,sigma/1e9);
L_creep = 10.^exp;
life_creep = 1./(trapz(inp.atm.wind_range,inp.atm.gw./L_creep));
eco.tether.f_repl_creep = 1/life_creep;

%% Set tether life to infinte is tether life > AWE operational years
switch  eco_settings.power
    case 'GG'
        eco.tether.f_repl = max([eco.tether.f_repl_bend,eco.tether.f_repl_creep]);
    case 'FG'
        eco.tether.f_repl = eco.tether.f_repl_creep;
end

if 1/eco.tether.f_repl > inp.business.T
    eco.tether.f_repl = 0;
end
eco.tether.OPEX = eco.tether.f_repl * eco.tether.CAPEX ;

end