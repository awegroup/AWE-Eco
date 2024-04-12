function inp = eco_inputs

global eco_settings

if strcmp(eco_settings.input_model_file,'code')
       
    % Topology specific caractheristics
    
    if strcmp(eco_settings.power,'FG')
      
        % Wind resources
        inp.atm.wind_range = [4,5,6,7,8,9,10,11,12,13,14,16,18,20,22];
        atm.k = 2;
        atm.A = 8;
        inp.atm.gw = atm.k/atm.A *(inp.atm.wind_range/atm.A).^(atm.k-1).*exp(-(inp.atm.wind_range/atm.A).^atm.k); % Wind distribution
        
        % Business related quantities
        inp.business.T = 25; % years
        inp.business.r = 0.1; % discount rate

        % Power and loads
        inp.system.F_t = [19581.5974490300,30589.4427976802,43855.1311512270,58322.4490072310,69451.8065536476,68432.4018007148,69371.4628861828,69478.8976127206,69485.8563217407,69497.1308164078,69482.9452160423,69481.7762790974,69481.0428798217,62833.9833242605,51867.1740101547];
        inp.system.P = [21496.0471473482,41246.4942079856,69966.0193058485,108887.503260755,156932.246230542,198576.031463368,198565.375606173,198114.942308234,197641.383532483,197199.181237688,196755.860610617,195920.800890573,195135.252500918,174603.698597567,143719.204086628];
        inp.system.P_rated = 200e3;
        
        inp.kite.structure.m = 4e2;
        inp.kite.structure.A = 15;
        inp.kite.f_repl = 0;
        
        inp.tether.d = 2e-2;
        inp.tether.sigma_lim = 1.5e9;
        inp.tether.L = 300;
        inp.tether.rho = 1e3;
        
    elseif  strcmp(eco_settings.power,'GG')

        if strcmp(eco_settings.wing,'fixed')

          % Wind resources
          inp.atm.wind_range = [1:1:25];
          atm.k = 2;
          atm.A = 9;
          inp.atm.gw = atm.k/atm.A *(inp.atm.wind_range/atm.A).^(atm.k-1).*exp(-(inp.atm.wind_range/atm.A).^atm.k); % Wind distribution
          
          % Business related quantities
          inp.business.T = 25; % years
          inp.business.r = 0.1; % discount rate
          
          % Power and loads
          inp.system.F_t = [0	0	0	0	297733.178229182	450159.606123297	600000.000000000	600000.000000017	600000.000000003	600000.437201348	600000.000000040	599999.991932207	599999.981471276	600000.000000000	599896.756036812	599854.655813089	599842.632716659	599999.992828913	599999.999207714	599999.865749360	599999.999765187	599999.999898903	599896.988232362	599948.561852316	599952.973959314];
          inp.system.P_out_rated = 4.0000e+06;
          inp.system.P = [0	0	0	0	143893.760066087	380013.531783924	723296.379152915	1083452.48282721	1386022.75480015	1732243.45740978	2000000.00000010	2000000.00000056	1999999.99999987	1999999.99999997	1999999.99999891	1999999.98806025	1999999.99999967	1999999.98709885	1999999.99855111	1999999.63942612	1999999.99948966	1999999.99976117	1999999.92253487	1999988.86568092	1999998.45931204];
          inp.system.P_rated = 2000*1000;
          
          inp.system.E_rated_uc = 1.5*inp.system.P_rated * 40/3600; 
          inp.system.f_repl_uc = 0.25;
          inp.system.E_ex_uc = inp.system.E_rated_uc/2; % check
          inp.system.Dt_cycle = 60/3600; % h
          
          inp.system.E_ex_hacc = inp.system.E_rated_uc;

          inp.kite.structure.m = 1.397710089360000e+04;
          inp.kite.structure.A = 200;
          
          inp.kite.f_repl = 0;
          
          inp.tether.d = 0.033035559344463;
          inp.tether.sigma_lim = 1.5e9;
          inp.tether.L = 2.000004520590911e+03;
          inp.tether.rho = 970;
          
          inp.system.P_obgen = 1e3;
          inp.system.P_prop = 1e3;
          inp.system.E_batt = 0;

        elseif strcmp(eco_settings.wing,'soft')
            
          % Wind resources
          inp.atm.wind_range = [4,5,6,7,8,9,10,11,12,13,14,16,18,20,22];
          atm.k = 2;
          atm.A = 8;
          inp.atm.gw = atm.k/atm.A *(inp.atm.wind_range/atm.A).^(atm.k-1).*exp(-(inp.atm.wind_range/atm.A).^atm.k); % Wind distribution
          
          % Business related quantities
          inp.business.T = 25; % years
          inp.business.r = 0.1; % discount rate
          
          % Power and loads
          inp.system.F_t = [19581.5974490300,30589.4427976802,43855.1311512270,58322.4490072310,69451.8065536476,68432.4018007148,69371.4628861828,69478.8976127206,69485.8563217407,69497.1308164078,69482.9452160423,69481.7762790974,69481.0428798217,62833.9833242605,51867.1740101547];
  %         inp.system.P_out = [21496.0471473482,41246.4942079856,69966.0193058485,108887.503260755,156932.246230542,198576.031463368,198565.375606173,198114.942308234,197641.383532483,197199.181237688,196755.860610617,195920.800890573,195135.252500918,174603.698597567,143719.204086628];
          inp.system.P_out_rated = 200e3;
          inp.system.P = 3/4*[21496.0471473482,41246.4942079856,69966.0193058485,108887.503260755,156932.246230542,198576.031463368,198565.375606173,198114.942308234,197641.383532483,197199.181237688,196755.860610617,195920.800890573,195135.252500918,174603.698597567,143719.204086628];
          inp.system.P_rated = max(inp.system.P);
          
          inp.system.E_rated_uc = 1.5*inp.system.P_rated * 40/3600; 
          inp.system.f_repl_uc = 0.25;
          inp.system.E_ex_uc = inp.system.E_rated_uc/2; % check
          inp.system.Dt_cycle = 60/3600; % h
          
          inp.system.E_ex_hacc = inp.system.E_rated_uc;

          inp.kite.structure.m = 4e2;
          inp.kite.structure.A = 15;
          
          inp.kite.f_repl = 0;
          
          inp.tether.d = 2e-2;
          inp.tether.sigma_lim = 1.5e9;
          inp.tether.L = 300;
          inp.tether.rho = 1e3;
          
          inp.system.P_obgen = 1e3;
          inp.system.P_prop = 1e3;
          inp.system.E_batt = 0;

          inp.kite.structure.A = 15;
          
          inp.tether.d = 2e-2;
          inp.tether.sigma_lim = 1.5e9;
          inp.tether.L = 300;
          inp.tether.rho = 1e3;
          
          inp.system.P_obgen = 1e3;
          inp.system.P_prop = 0;
          inp.system.E_batt = 0;
            
        end
        
    end
    
else
    inp = eco_import_model;
    
end

end