function eco = eco_main(inp, par)

eco = struct;
%% Kite
eco = eco_kite(inp,par,eco);

%% Tether
eco = eco_tether(inp,par,eco);

%% Ground station
eco = eco_g_station(inp,par,eco);

%% BoS
eco = eco_BoS(inp,par,eco);

%% BoP
eco = eco_BoP(inp,par,eco);

%% Economic indicators
eco = eco_metrics(inp,par,eco);

end