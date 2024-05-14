function inp = eco_inputs

global eco_settings

switch eco_settings.input_model_file
    case 'code'
        % Topology specific caractheristics
        
        switch eco_settings.power
            case 'FG'
                %     if strcmp(,)
                
                % Wind resources
                inp.atm.wind_range = [3:1/3:10, 15, 20];% ,11,12,13,14,16,18,20,22];
                atm.k = 2;
                atm.A = 8;
                inp.atm.gw = atm.k/atm.A *(inp.atm.wind_range/atm.A).^(atm.k-1).*exp(-(inp.atm.wind_range/atm.A).^atm.k); % Wind distribution
                
                % Business related quantities
                inp.business.T = 25; % years
                inp.business.r = 0.1; % discount rate
                
                % system
                inp.kite.structure.m = 122.5;
                inp.kite.structure.b = 10;
                inp.kite.structure.AR = 6;
                inp.kite.structure.A = inp.kite.structure.b^2/inp.kite.structure.AR;
                inp.system.E_rated_uc = inp.kite.structure.m * 9.81*inp.kite.structure.b*5/3.6e6; % kWh
                
                % Tether
                inp.tether.d = 1.6 *1e-3 * inp.kite.structure.b;
                inp.tether.sigma_lim = 1.5e9;
                inp.tether.L = 100;
                inp.tether.rho = 970;
                
                % Power and loads
                inp.system.F_t = inp.tether.d^2/4*pi* [0.124572136342289,0.151797436838344,0.181460994246145,0.214172304028360,0.250094485666586,0.289217262316979,0.331480668302760,0.376825094990467,0.425204519064134,0.476587107759039,0.530951609064390,0.588284030406247,0.648575480469101,0.711819900342773,0.667172308938198,0.538286443708873,0.479418546822401,0.440125256353379,0.410771458547833,0.387467590011167,0.368260306087034,0.352050875661555,0.3,0.25];
                inp.system.P_rated = 100e3;
                inp.system.P = inp.system.P_rated * [0.0514836036930580,0.0740924523303653,0.101398515897930,0.133916653105838,0.172155839837058,0.216618610982057,0.267802451082606,0.326201238110832,0.392306298442283,0.466607150752925,0.549592018061346,0.641748164098206,0.743562144341504,0.855519973731538,0.978107215387062,0.999997934928179,0.999999974273665,0.999999480541176,0.999999330603523,0.999999355894903,0.999999280365251,0.999996057827535, 1,1];
                
                inp.kite.f_repl = 0;
                
            case  'GG'
                
                switch eco_settings.wing
                    case 'fixed'
                        
                        % Wind resources
                        inp.atm.wind_range = [1:1:25];
                        atm.k = 2;
                        atm.A = 9/gamma(1 + 1/atm.k);
                        inp.atm.gw = atm.k/atm.A *(inp.atm.wind_range/atm.A).^(atm.k-1).*exp(-(inp.atm.wind_range/atm.A).^atm.k); % Wind distribution
                        
                        % Business related quantities
                        inp.business.T = 25; % years
                        inp.business.r = 0.1; % discount rate
                        
                        % Power and loads
                        inp.system.F_t = [0,	0,	0,	0,	182818.959316332,	295408.178060434,	419690.246978853,	450000.000015734,	449992.160039458,	450000.000000000,	450000.000000253,	450000.000000000,	449999.680709179,	442573.874551799,	438814.591609086,	429597.887168394,	429257.929939298,	422567.939253649,	419685.418715207,	417373.577072876,	415928.968598799,	414967.739557817,	414273.382259127,	413748.643654778,	413343.209219202];
                        inp.system.P_out_rated = 4.0000e+06;
                        inp.system.P = [0	0	0	0	87438.8853031594	253393.205748841	484332.048240857	755090.545996486	1114076.64124289	1405930.79083093	1670466.98327117	1903559.07568152	1999999.99857249	1999999.94760103	2000000.00000002	2000000.00000006	2000000.00106575	1999999.43299789	2000000.00027475	2000000.08302597	2000000.00296865	2000000.00016184	2000000.00002195	2000000.00001266	2000000.00000112];
                        inp.system.P_rated = 2000*1000;
                        
                        inp.system.E_rated_uc = 1.1*inp.system.P_rated * 25/3600/1e3; % kWh Power which needs to be supplied during reel-in at rated wind speed
                        %inp.system.f_repl_uc = 0.25;
                        inp.system.E_ex_uc = inp.system.E_rated_uc/2; % In reality should be a function of wind speed
                        inp.system.Dt_cycle = 75/3600; % h
                        
                        inp.system.E_rated_hacc = inp.system.E_rated_uc;
                        inp.system.E_ex_hacc    = inp.system.E_ex_uc;
                        
                        inp.kite.structure.m = 9.250207476900000e+03;
                        inp.kite.structure.A = 150;
                        
                        inp.kite.f_repl = 0;
                        
                        inp.tether.d = 0.030901936161855;
                        inp.tether.sigma_lim = 1.5e9;
                        inp.tether.L = 2.000004520590911e+03;
                        inp.tether.rho = 970;
                        
                        inp.system.P_obgen = 1e3;
                        inp.system.P_prop = 1e3;
                        inp.system.E_batt = 0;
                        
                    case 'soft'
                        
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
                        
                        inp.system.E_rated_uc = 1.5*inp.system.P_rated * 40/3600/1e3;
                        inp.system.f_repl_uc = 0.25;
                        inp.system.E_ex_uc = inp.system.E_rated_uc/2; % check
                        inp.system.Dt_cycle = 60/3600; % h
                        
                        inp.system.E_rated_hacc = inp.system.E_rated_uc;
                        inp.system.E_ex_hacc    = inp.system.E_ex_uc;
                        
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
        
    otherwise
        inp = eco_import_model;
        
end

end