function eco = eco_tether(inp,par,eco)

global eco_settings
t = inp.tether;

%% Tether life extimation
if isfield(t,'d')
    t.A = pi/4*t.d^2;
elseif isfield(t,'A')
    t.d = sqrt(4*t.A/pi);
end

sigma = min([inp.system.F_t' / (par.tether.f_At*t.A); t.sigma_lim*ones(size(inp.system.F_t'))])';
exp = polyval(par.tether.L_creep,sigma/1e9);

L = 10.^exp;
life = 1./(trapz(inp.atm.wind_range,inp.atm.gw./L));

%% Tether cost and correction factors for tether life
if strcmp(eco_settings.power,'GG')
    eco.tether.CAPEX = par.tether.p * t.A *par.tether.f_At* t.L * t.rho * (1+ par.tether.f_coat);
elseif strcmp(eco_settings.power,'FG')
    eco.tether.CAPEX  = par.tether.f_mt * (par.tether.p * t.A *par.tether.f_At * t.L * t.rho * (1+ par.tether.f_coat));
end

%% Set tether life to infinte is tether life > AWE operational years
eco.tether.f_repl = 1/life;
if life > inp.business.T
    eco.tether.f_repl = 0;
end
eco.tether.OPEX = eco.tether.f_repl * eco.tether.CAPEX ;

end