function [inp,par,eco] = eco_computeMetrics(inp,par,eco)

  r                 = inp.business.r;
  N_y               = inp.business.N_y;
  eco.metrics.CRF   = r*(1+r)^N_y/((1+r)^N_y-1);
  
  eco.metrics.AEP   = 8760 * trapz(inp.atm.wind_range,inp.system.P_e_avg.*inp.atm.gw)/1e6; % MWh
  eco.metrics.CF    = eco.metrics.AEP/(inp.system.P_e_rated/1e6*8760); % Capacity factor
  eco.metrics.p     = 8760 * trapz(inp.atm.wind_range,(par.metrics.electricity.p_0 + par.metrics.electricity.p_1 * inp.atm.wind_range).*inp.system.P_e_avg/1e6.*inp.atm.gw)/eco.metrics.AEP; % Revenues euros/year/MWh 
  eco.metrics.p_hat = trapz(inp.atm.wind_range,(par.metrics.electricity.p_0 + par.metrics.electricity.p_1 * inp.atm.wind_range).*inp.atm.gw); % euros/MWh 
  eco.metrics.vf    = eco.metrics.p/eco.metrics.p_hat; % value factor - 
  
  %% Find all CAPEX and OPEX and organize them

  PATH            = structree(eco);
  CAPEX_ind       = zeros(length(PATH),1);
  eco.metrics.ICC = 0; % Initial Capital Cost a.k.a sum of total CAPEX
  eco.metrics.OMC = 0; % Operational Maintainance Cost a.k.a sum of total OPEX
  OPEX_ind        = zeros(length(PATH),1);
  ind_capex       = 1;
  ind_opex        = 1;
  eco.metrics.LCoE_contr      = zeros(length(PATH),1);
  for ind = 1:length(PATH)
      a   = PATH(ind);
      a   = a{1};
      if strcmp(a(end),'CAPEX')
          CAPEX_ind(ind) = 1;
          if length(a) == 2
              eco.metrics.icc(ind_capex)      = eco.(string(a(1))).(string(a(2)));
              eco.metrics.icc_name{ind_capex} = a{1};
          elseif length(a) == 3
              eco.metrics.icc(ind_capex)      = eco.(string(a(1))).(string(a(2))).(string(a(3)));
              eco.metrics.icc_name{ind_capex} = strcat([a{1},'.',a{2}]);
          end
          eco.metrics.ICC      = eco.metrics.ICC + eco.metrics.icc(ind_capex);
          eco.metrics.LCoE_contr(ind)      = eco.metrics.icc(ind_capex)* eco.metrics.CRF /eco.metrics.AEP;
          eco.metrics.LCoE_contr_name{ind} = [eco.metrics.icc_name{ind_capex},'.capex'];
  
          ind_capex = ind_capex+1;
          
      elseif strcmp(a(end),'OPEX')
          OPEX_ind(ind) = 1;
          if length(a) == 2
              eco.metrics.omc(ind_opex)      = eco.(string(a(1))).(string(a(2)));
              eco.metrics.omc_name{ind_opex} = a{1};
          elseif length(a) == 3
              eco.metrics.omc(ind_opex)      = eco.(string(a(1))).(string(a(2))).(string(a(3)));
              eco.metrics.omc_name{ind_opex} = strcat([a{1},'.',a{2}]);
          end
  
          eco.metrics.OMC      = eco.metrics.OMC + eco.metrics.omc(ind_opex);
          eco.metrics.LCoE_contr(ind)      = eco.metrics.omc(ind_opex)/eco.metrics.AEP;
          eco.metrics.LCoE_contr_name{ind} = [eco.metrics.omc_name{ind_opex},'.opex'];
  
          ind_opex = ind_opex + 1;
      end
  end
  
  %% Compute metrics

  num_LCoE        =   eco.metrics.ICC;
  eco.metrics.NPV = - eco.metrics.ICC;    
  num_LRoE        = 0;
  den             = 0;
  den_cove        = 0;
  
  for t = 1:N_y
      num_LCoE        = num_LCoE + eco.metrics.OMC/(1+r)^t;
      num_LRoE        = num_LRoE + (eco.metrics.p + par.metrics.subsidy) * eco.metrics.AEP/(1+r)^t;
      den             = den + eco.metrics.AEP/(1+r)^t;
      den_cove        = den_cove + eco.metrics.vf .* eco.metrics.AEP/(1+r)^t;
      eco.metrics.NPV = eco.metrics.NPV + (eco.metrics.p + par.metrics.subsidy * eco.metrics.AEP - eco.metrics.OMC)/(1+r)^t;
  end
  eco.metrics.LCoE = num_LCoE/den;
  eco.metrics.CoVE = num_LCoE/den_cove;
  eco.metrics.LRoE = num_LRoE/den;
  eco.metrics.LPoE = eco.metrics.LRoE - eco.metrics.LCoE;
  eco.metrics.Pi   = eco.metrics.LPoE * eco.metrics.AEP;  

end