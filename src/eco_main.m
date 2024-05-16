function [inp,par,eco] = eco_main(inp, par)

eco = struct;
%% Kite
[inp,par,eco] = eco_kite(inp,par,eco);

%% Tether
[inp,par,eco] = eco_tether(inp,par,eco);

%% Ground station
[inp,par,eco] = eco_g_station(inp,par,eco);

%% BoS
[inp,par,eco] = eco_BoS(inp,par,eco);

%% BoP
[inp,par,eco] = eco_BoP(inp,par,eco);

%% Economic indicators
[inp,par,eco] = eco_metrics(inp,par,eco);

end