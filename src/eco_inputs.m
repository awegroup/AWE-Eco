function inp = eco_inputs

global eco_settings
%%
if strcmp(eco_settings.input_model_file,'code')
       
%     % Topology specific caractheristics
    
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