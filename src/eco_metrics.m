function [inp,par,eco] = eco_metrics(inp,par,eco)

  r = inp.business.r;
  T = inp.business.T;
  eco.metrics.CRF = r*(1+r)^T/((1+r)^T-1);
  
  eco.metrics.AEP   = 8760 * trapz(inp.atm.wind_range,inp.system.P.*inp.atm.gw)/1e6; % MWh
  eco.metrics.CF    = eco.metrics.AEP/(inp.system.P_rated/1e6*8760); % Capacity factor
  eco.metrics.p     = 8760 * trapz(inp.atm.wind_range,(par.metrics.electricity.p_0 + par.metrics.electricity.p_1 * inp.atm.wind_range).*inp.system.P/1e6.*inp.atm.gw)/eco.metrics.AEP; % Revenues euros/year/MWh 
  eco.metrics.p_hat = trapz(inp.atm.wind_range,(par.metrics.electricity.p_0 + par.metrics.electricity.p_1 * inp.atm.wind_range).*inp.atm.gw); % euros/MWh 
  eco.metrics.vf    = eco.metrics.p/eco.metrics.p_hat; % value factor - 
  
  %% Find all CAPEX and OPEX and organize them

  PATH = structree(eco);
  CAPEX_ind = zeros(length(PATH),1);
  eco.metrics.ICC = 0; % Initial Capital Cost a.k.a sum of total CAPEX
  eco.metrics.OMC = 0; % Operational Maintainance Cost a.k.a sum of total OPEX
  OPEX_ind  = zeros(length(PATH),1);
  ind_capex = 1;
  ind_opex = 1;
  LCoE_contr = zeros(length(PATH),1);
  for ind = 1:length(PATH)
      a = PATH(ind);
      a = a{1};
      if strcmp(a(end),'CAPEX')
          CAPEX_ind(ind) = 1;
          if length(a) == 2
              icc(ind_capex) = eco.(string(a(1))).(string(a(2)));
              icc_name{ind_capex} = a{1};
          elseif length(a) == 3
              icc(ind_capex) = eco.(string(a(1))).(string(a(2))).(string(a(3)));
              icc_name{ind_capex} = strcat([a{1},'.',a{2}]);
          end
          eco.metrics.ICC = eco.metrics.ICC + icc(ind_capex);
          LCoE_contr(ind) = icc(ind_capex)* eco.metrics.CRF /eco.metrics.AEP;
          LCoE_contr_name{ind} = [icc_name{ind_capex},'.capex'];
  
          ind_capex = ind_capex+1;
          
      elseif strcmp(a(end),'OPEX')
          OPEX_ind(ind) = 1;
          if length(a) == 2
              omc(ind_opex) = eco.(string(a(1))).(string(a(2)));
              omc_name{ind_opex} = a{1};
          elseif length(a) == 3
              omc(ind_opex) = eco.(string(a(1))).(string(a(2))).(string(a(3)));
              omc_name{ind_opex} = strcat([a{1},'.',a{2}]);
          end
  
          eco.metrics.OMC = eco.metrics.OMC + omc(ind_opex);
          LCoE_contr(ind) = omc(ind_opex)/eco.metrics.AEP;
          LCoE_contr_name{ind} = [omc_name{ind_opex},'.opex'];
  
          ind_opex = ind_opex + 1;
      end
  end
  
  %% Metrics

  num_LCoE        =   eco.metrics.ICC;
  eco.metrics.NPV = - eco.metrics.ICC;    
  num_LRoE = 0;
  den      = 0;
  den_cove = 0;
  
  for t = 1:T
      num_LCoE = num_LCoE + eco.metrics.OMC/(1+r)^t;
      num_LRoE = num_LRoE + (eco.metrics.p + par.metrics.subsidy) * eco.metrics.AEP/(1+r)^t;
      
      den      = den + eco.metrics.AEP/(1+r)^t;
      den_cove = den_cove + eco.metrics.vf .* eco.metrics.AEP/(1+r)^t;
      
      eco.metrics.NPV = eco.metrics.NPV + (eco.metrics.p + par.metrics.subsidy * eco.metrics.AEP - eco.metrics.OMC)/(1+r)^t;
  end
  eco.metrics.LCoE = num_LCoE/den;
  eco.metrics.CoVE = num_LCoE/den_cove;
  eco.metrics.LRoE = num_LRoE/den;
  eco.metrics.LPoE = eco.metrics.LRoE - eco.metrics.LCoE;
  eco.metrics.Pi   = eco.metrics.LPoE * eco.metrics.AEP;
  
  %% Figure

  figure('units', 'normalized', 'outerposition', [0 0 0.9 0.9]);

  % Plot 1: Metrics Text
  subplot(1, 4, 1); 
  hold on
  str_2_print = sprintf(['-- Metrics --\n CF = %.2f \n LCoE = %.0f EUR/MWh \n CoVE = %.0f EUR/MWh \n LRoE = %.0f EUR/MWh \n LPoE = %.0f EUR/MWh \n NPV = %.0f k EUR \n ICC = %.0f k EUR \n OMC = %.0f k EUR/year \n Profit = %.0f k EUR'], ...
      eco.metrics.CF, eco.metrics.LCoE, eco.metrics.CoVE, eco.metrics.LRoE, eco.metrics.LPoE, eco.metrics.NPV/1e3, eco.metrics.ICC/1e3, eco.metrics.OMC/1e3, eco.metrics.Pi/1e3);
  text(0, 1, str_2_print, 'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Top', 'Interpreter', 'latex', 'FontSize', 12);
  axis off
  
  % Extracting significant ICC components
  icc_perc = icc / sum(icc) * 100;
  [sorted_icc_perc, icc_order] = sort(icc_perc, 'descend');
  significant_icc_idx = sorted_icc_perc > 2;
  list_icc = icc_name(icc_order(significant_icc_idx));
  pp_icc = sorted_icc_perc(significant_icc_idx);
  
  % Plot 2: ICC Pie Chart
  subplot(1, 4, 2);
  pie(pp_icc);
  legend(list_icc, 'Location', 'southoutside', 'Interpreter', 'latex', 'FontSize', 10);
  title(['ICC = ', num2str(round(eco.metrics.ICC / 1e3)), ' k EUR'], 'Interpreter', 'latex', 'FontSize', 12);
  
  % Extracting significant OMC components
  significant_omc_idx = omc > 2;
  [sorted_omc, omc_order] = sort(omc(significant_omc_idx), 'descend');
  list_omc = omc_name(omc_order);
  pp_omc = sorted_omc;
  
  % Plot 3: OMC Pie Chart
  subplot(1, 4, 3);
  pie(pp_omc);
  legend(list_omc, 'Location', 'southoutside', 'Interpreter', 'latex', 'FontSize', 10);
  title(['OMC = ', num2str(round(eco.metrics.OMC / 1e3)), ' k EUR/year'], 'Interpreter', 'latex', 'FontSize', 12);
  
  % Extracting significant LCoE contributions
  LCoE_contr_perc = LCoE_contr / sum(LCoE_contr) * 100;
  [sorted_LCoE_contr_perc, LCoE_order] = sort(LCoE_contr_perc, 'descend');
  significant_lcoe_idx = sorted_LCoE_contr_perc > 2;
  list_lcoe = LCoE_contr_name(LCoE_order(significant_lcoe_idx));
  pp_lcoe = sorted_LCoE_contr_perc(significant_lcoe_idx);
  
  % Plot 4: LCoE Pie Chart
  subplot(1, 4, 4);
  pie(pp_lcoe);
  legend(list_lcoe, 'Location', 'southoutside', 'Interpreter', 'latex', 'FontSize', 10);
  title(['LCoE = ', num2str(round(eco.metrics.LCoE)), ' EUR/MWh'], 'Interpreter', 'latex', 'FontSize', 12);
  
  % Adding overall title for the figure
  sgtitle('Economic Metrics and Breakdown', 'Interpreter', 'latex', 'FontSize', 14);
  
  % Adjusting figure properties for better visualization
  set(gcf, 'Color', 'w');

end