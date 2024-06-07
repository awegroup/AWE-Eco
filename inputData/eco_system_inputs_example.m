function inp = eco_system_inputs_example
  %ECO_SYSTEM_INPUTS_EXAMPLE Generate example input parameters for the economic model.
  %   This function generates example input parameters for the economic model based on the 
  %   selected configuration in eco_settings. It provides values for wind conditions, 
  %   business-related quantities, and topology-specific parameters.
  %
  %   Outputs:
  %   - inp: Structure containing input parameters.

  global eco_settings

  eco_settings.input_cost_file  = 'eco_cost_inputs_GG_fixed'; % eco_cost_inputs_GG_fixed || eco_cost_inputs_FG || eco_cost_inputs_GG_soft || set the input file
  eco_settings.input_model_file = 'code'; % code || eco_system_inputs_GG_fixed_example || eco_system_inputs_FG_example || eco_system_inputs_GG_soft_example || set the input file
  eco_settings.power            = 'GG';  % FG || GG 
  eco_settings.wing             = 'fixed';  % fixed || soft
  
  %% Common parameters
  % Wind conditions
  atm.k = 2;
  atm.A = 8;
  
  % Business related quantities
  inp.business.N_y     = 25; % project years
  inp.business.r_d     = 0.08; % cost of debt
  inp.business.r_e     = 0.12; % cost of equity
  inp.business.TaxRate = 0.25; % Tax rate (25%)
  inp.business.DtoE    = 70/30; % Debt-Equity-ratio
  
  %% Topology specific parameters
  switch eco_settings.input_model_file
      case 'code'
  
          switch eco_settings.power
              case 'FG'
                  
                  % Wind resources
                  inp.atm.wind_range = [3:1/3:10, 15, 20]; % m/s
                  inp.atm.gw         = atm.k/atm.A *(inp.atm.wind_range/atm.A).^(atm.k-1).*exp(-(inp.atm.wind_range/atm.A).^atm.k); % - Wind distribution
                                  
                  % Kite
                  inp.kite.structure.m            = 122.5; % kg
                  inp.kite.structure.b            = 10;    % m
                  inp.kite.structure.AR           = 6; % -
                  inp.kite.structure.f_repl       = 0; % 1/year
                  
                  % Tether
                  inp.tether.d      = 1.6 *1e-3 * inp.kite.structure.b; % m
                  inp.tether.L      = 100; % m
                  inp.tether.rho    = 970; % kg/m^3
                  inp.tether.f_repl = -1; 
                  
                  % System
                  inp.system.F_t       = inp.tether.d^2/4*pi* [0.124572136342289,0.151797436838344,0.181460994246145,0.214172304028360,0.250094485666586,0.289217262316979,0.331480668302760,0.376825094990467,0.425204519064134,0.476587107759039,0.530951609064390,0.588284030406247,0.648575480469101,0.711819900342773,0.667172308938198,0.538286443708873,0.479418546822401,0.440125256353379,0.410771458547833,0.387467590011167,0.368260306087034,0.352050875661555,0.3,0.25]*1e9; % N
                  inp.system.P_e_rated = 100e3; % W
                  inp.system.P_e_avg   = inp.system.P_e_rated * [0.0514836036930580,0.0740924523303653,0.101398515897930,0.133916653105838,0.172155839837058,0.216618610982057,0.267802451082606,0.326201238110832,0.392306298442283,0.466607150752925,0.549592018061346,0.641748164098206,0.743562144341504,0.855519973731538,0.978107215387062,0.999997934928179,0.999999974273665,0.999999480541176,0.999999330603523,0.999999355894903,0.999999280365251,0.999996057827535, 1,1]; % W
                  inp.system.lambda    = 7; % wing speed ratio
                  inp.system.R0        = 5*inp.kite.structure.b; % turbing radius
                  
                  % Ground station
                  inp.gStation.ultracap.E_rated = inp.kite.structure.m * 9.81*inp.kite.structure.b*5/3.6e6; % kWh
                  inp.gStation.ultracap.f_repl  = -1;
                  inp.gStation.batt.E_rated     = inp.system.P_e_rated/1e3; % kWh
                  inp.gStation.batt.f_repl      = -1; % /year
                  
              case  'GG' 
                  switch eco_settings.wing
                      case 'fixed'
                          
                          % Wind resources
                          inp.atm.wind_range = [1:1:25]; % m/s
                          inp.atm.gw         = atm.k/atm.A *(inp.atm.wind_range/atm.A).^(atm.k-1).*exp(-(inp.atm.wind_range/atm.A).^atm.k); % Wind distribution
                          
                          % Kite
                          inp.kite.structure.m            = 5543; % kg
                          inp.kite.structure.A            = 100; % m^2
                          inp.kite.structure.f_repl       = 0; % /year
                          inp.kite.obGen.P                = 1e3; % W
                          inp.kite.obBatt.E                = 1; % kWh
                          
                          % Tether
                          inp.tether.d      = 0.0273; % m
                          inp.tether.L      = 2600; %m
                          inp.tether.rho    = 970; % kg/m^3
                          inp.tether.f_repl = -1; % /year
                          
                          % System
                          inp.system.F_t       = [0	0	0	0	0	176218.741942466	247326.729934132	335309.738279319	349999.999905368	349999.999983002	349999.999999204	349983.541245218	348784.001594628	345425.348864681	349095.793762565	346191.685571336	341260.264393564	340281.862240894	340333.765419009	340876.771496480	341638.231403760	342493.800708096	343392.451059166	344311.108894388	345237.030244762]; % N
                          inp.system.P_m_peak  = 1.87e+06; % W
                          inp.system.P_e_avg   = [0	0	0	0	0	145524.730974731	288495.257975699	488571.542997977	727335.279338411	953941.843495889	1000000.00000461	999999.999798969	1000000.00001413	1000000.00000000	1000000.00000046	1000000.00000080	1000000.00000000	1000000.00000017	1000000.00000000	999999.999732790	999999.999965783	999999.999995972	999999.999999559	999999.999999956	1000000.00000000]; % W
                          inp.system.P_e_rated = 1e+06; % W
                          inp.system.Dt_cycle  = [0	0	0	0	0	130.388949196501	132.125896939284	130.302239127635	135.689613751230	132.500820465091	124.515660439110	123.350051661913	122.919611216260	122.626866710798	122.754436421934	122.745072840010	122.773588271380	122.901681745870	123.093919941459	123.315575577003	123.547269528843	123.778584819469	124.003535889111	124.218500332100	124.421040233482]; % s
                          
                          % Ground station
                          inp.gStation.ultracap.E_rated = 11.25; % kWh
                          inp.gStation.ultracap.E_ex    = [0	0	0	0	0	0.794997961209469	1.91620710592149	3.66340782590143	7.00053194254757	10.6616297528835	11.1890647627290	11.2279405187141	11.2277213125461	11.1934366085895	11.2473922571621	11.2098142616423	11.1438062076693	11.1273616907102	11.1228424486107	11.1240295153377	11.1278176039227	11.1328371206444	11.1385755705485	11.1448282168896	11.1514961274243]; % kWh
                          inp.gStation.ultracap.f_repl  = -1; % /year  
                          inp.gStation.batt.E_rated     = inp.system.P_e_rated/1e3; % kWh
                          inp.gStation.batt.E_ex        = [0	0	0	0	0	0.794997961209469	1.91620710592149	3.66340782590143	7.00053194254757	10.6616297528835	11.1890647627290	11.2279405187141	11.2277213125461	11.1934366085895	11.2473922571621	11.2098142616423	11.1438062076693	11.1273616907102	11.1228424486107	11.1240295153377	11.1278176039227	11.1328371206444	11.1385755705485	11.1448282168896	11.1514961274243]; % kWh
                          inp.gStation.batt.f_repl      = -1; % /year
                          inp.gStation.hydAccum.E_rated = inp.gStation.ultracap.E_rated ;  % kWh
                          inp.gStation.hydAccum.E_ex    = inp.gStation.ultracap.E_ex; % kWh
                          inp.gStation.hydAccum.f_repl  = -1; % /year
                          inp.gStation.hydMotor.f_repl  = 0; % /year
                          inp.gStation.pumpMotor.f_repl = 0; % /year
                          
                      case 'soft'
                          
                          % Wind resources
                          inp.atm.wind_range = [4,5,6,7,8,9,10,11,12,13,14,16,18,20,22];
                          inp.atm.gw         = atm.k/atm.A *(inp.atm.wind_range/atm.A).^(atm.k-1).*exp(-(inp.atm.wind_range/atm.A).^atm.k); % Wind distributio
                          
                          % Kite
                          inp.kite.structure.m           = 4e2;
                          inp.kite.structure.A           = 15;
                          inp.kite.structure.f_repl      = -1;
                          inp.kite.obGen.P               = 1e3; % W
                          inp.kite.obBatt.E              = 0; % kWh
                          
                          % Tether
                          inp.tether.d      = 2e-2;
                          inp.tether.L      = 300;
                          inp.tether.rho    = 1e3;
                          inp.tether.f_repl = -1;
                          
                          % System
                          inp.system.F_t       = [19581.5974490300,30589.4427976802,43855.1311512270,58322.4490072310,69451.8065536476,68432.4018007148,69371.4628861828,69478.8976127206,69485.8563217407,69497.1308164078,69482.9452160423,69481.7762790974,69481.0428798217,62833.9833242605,51867.1740101547];
                          inp.system.P_m_peak  = 200e3;
                          inp.system.P_e_avg   = 3/4*[21496.0471473482,41246.4942079856,69966.0193058485,108887.503260755,156932.246230542,198576.031463368,198565.375606173,198114.942308234,197641.383532483,197199.181237688,196755.860610617,195920.800890573,195135.252500918,174603.698597567,143719.204086628];
                          inp.system.P_e_rated = max(inp.system.P_e_avg);
                          inp.system.Dt_cycle  = 60; % s
                          
                          % Ground station
                          inp.gStation.ultracap.E_rated = 1.1*inp.system.P_e_rated * 25/3600/1e3; % kWh
                          inp.gStation.ultracap.E_ex    = inp.gStation.ultracap.E_rated/2; % kWh
                          inp.gStation.ultracap.f_repl  = -1;    
                          inp.gStation.batt.E_rated     = inp.system.P_e_rated/1e3; % kWh
                          inp.gStation.batt.E_ex        = inp.gStation.ultracap.E_rated/2; % kWh
                          inp.gStation.batt.f_repl      = -1; % /year
                          inp.gStation.hydAccum.E_rated = inp.gStation.ultracap.E_rated ;  % kWh
                          inp.gStation.hydAccum.E_ex    = inp.gStation.ultracap.E_ex; % kWh
                          inp.gStation.hydAccum.f_repl  = 0.1;
                          inp.gStation.hydMotor.f_repl  = 0.083;
                          inp.gStation.pumpMotor.f_repl =  0.125;
                          
                  end             
          end        
      otherwise
          inp = eco_import_model(inp); 
          inp.atm.gw  = atm.k/atm.A *(inp.atm.wind_range/atm.A).^(atm.k-1).*exp(-(inp.atm.wind_range/atm.A).^atm.k); % Wind distribution

  end
end