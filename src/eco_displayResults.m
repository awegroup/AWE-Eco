function eco_displayResults(inp, eco)
  %ECO_DISPLAYRESULTS Display economic metrics and breakdown in AWE-Eco simulation.
  %   This function visualizes economic metrics and breakdown, including cost of
  %   energy (LCoE), net present value (NPV), return on equity (RoE), profit, and
  %   others, using pie charts and text summaries.
  %
  %   Inputs:
  %   - eco: Structure containing results and metrics of the AWE-Eco simulation.

  % Extracting significant ICC components
  icc_perc = eco.metrics.icc / sum(eco.metrics.icc) * 100;
  [sorted_icc_perc, icc_order] = sort(icc_perc, 'descend');
  significant_icc_idx = sorted_icc_perc > 2;
  list_icc = eco.metrics.icc_name(icc_order(significant_icc_idx));
  pp_icc = sorted_icc_perc(significant_icc_idx);

  % Extracting significant OMC components
  omc_perc = eco.metrics.omc / sum(eco.metrics.omc) * 100;
  [sorted_omc_perc, omc_order] = sort(omc_perc, 'descend');
  significant_omc_idx = sorted_omc_perc > 2;
  list_omc = eco.metrics.omc_name(omc_order(significant_omc_idx));
  pp_omc = sorted_omc_perc(significant_omc_idx);

  % Extracting significant LCoE contributions
  LCoE_contr_perc = eco.metrics.LCoE_contr / sum(eco.metrics.LCoE_contr) * 100;
  [sorted_LCoE_contr_perc, LCoE_order] = sort(LCoE_contr_perc, 'descend');
  significant_lcoe_idx = sorted_LCoE_contr_perc > 3;
  list_lcoe = eco.metrics.LCoE_contr_name(LCoE_order(significant_lcoe_idx));
  pp_lcoe = sorted_LCoE_contr_perc(significant_lcoe_idx);

  % Define common plotting properties
  fontSize = 12;
  legendFontSize = 10;
  titleFontSize = 14;

  % Define original colormap
  cmap = jet(256);
  num_colors = max(max(length(pp_lcoe), length(pp_omc)), length(pp_icc));
  % Extract colors from Parula colormap
  parula_colors = interp1(linspace(0, 1, size(cmap, 1)), cmap, linspace(0, 1, num_colors));
  % Define pastel factors to soften colors
  pastel_factor = 0.3; % Adjust as needed for desired pastel effect
  % Soften colors to create pastel effect
  pastel_colors = (1 - pastel_factor) * parula_colors + pastel_factor * ones(num_colors, 3);
  % Ensure RGB values are within [0, 1] range
  pastel_colors = max(0, min(1, pastel_colors));
  

  % Create Figure 1: Pie charts in one row
  figure('units', 'normalized', 'outerposition', [0 0 0.5 1])

  % Subplot 1: ICC Pie Chart
  subplot(1, 3, 1);
  pie(pp_icc);
  colormap(pastel_colors)
  legend(list_icc, 'Location', 'southoutside', 'Interpreter', 'latex', 'FontSize', legendFontSize);
  title(['ICC = ', num2str(round(eco.metrics.ICC / 1e3)), ' k EUR'], 'Interpreter', 'latex', 'FontSize', fontSize);

  % Subplot 2: OMC Pie Chart
  subplot(1, 3, 2);
  pie(pp_omc);
  legend(list_omc, 'Location', 'southoutside', 'Interpreter', 'latex', 'FontSize', legendFontSize);
  title(['OMC = ', num2str(round(eco.metrics.OMC / 1e3)), ' k EUR/year'], 'Interpreter', 'latex', 'FontSize', fontSize);

  % Subplot 3: LCoE Pie Chart
  subplot(1, 3, 3);
  pie(pp_lcoe);
  legend(list_lcoe, 'Location', 'southoutside', 'Interpreter', 'latex', 'FontSize', legendFontSize);
  title(['LCoE = ', num2str(round(eco.metrics.LCoE)), ' EUR/MWh'], 'Interpreter', 'latex', 'FontSize', fontSize);

  % Adding overall title for Figure 1
  sgtitle('Cost breakdown (shares above 2 percent)', 'Interpreter', 'latex', 'FontSize', titleFontSize);

  % Adjusting figure properties for better visualization
  set(gcf, 'Color', 'w');


  % Create Figure 2: Metrics and Cashflow in one column
  figure('units', 'normalized', 'outerposition', [0.5 0 0.5 1])

  % Metrics Text
  subplot(2, 1, 1);
  hold on
  str_2_print = sprintf(['Metrics:\n\n' ...
      'CF = %.2f\n' ...
      'LCoE = %.0f EUR/MWh\n' ...
      'CoVE = %.0f EUR/MWh\n' ...
      'LRoE = %.0f EUR/MWh\n' ...
      'LPoE = %.0f EUR/MWh\n' ...
      'NPV = %.0f k EUR\n' ...
      'IRR = %.3f'], ...
      eco.metrics.CF, eco.metrics.LCoE, eco.metrics.CoVE, eco.metrics.LRoE, ...
      eco.metrics.LPoE, eco.metrics.NPV/1e3, eco.metrics.IRR);  
  text(0.1, 0.9, str_2_print, 'Interpreter', 'latex', 'FontSize', fontSize, 'VerticalAlignment', 'Top'); 
  axis off

  % Cashflow
  subplot(2, 1, 2);
  hold on
  grid on
  box on
  % Bar plot for cashflow
  bar(eco.metrics.cashflow ./ 1e6, 'FaceColor','flat');
  % Plot payback year as a point
  if ~isempty(eco.metrics.payback_year)
      plot(eco.metrics.payback_year + 1, eco.metrics.cashflow(eco.metrics.payback_year + 1) / 1e6, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 8);
  end
  ylabel('Million €', 'FontSize', fontSize);
  xlabel('Year', 'FontSize', fontSize);
  xticks(1:inp.business.N_y + 1);
  xticklabels(0:inp.business.N_y);
  title('Project Cashflow', 'FontSize', titleFontSize);

  % Add some aesthetic improvements
  set(gca, 'FontSize', fontSize);
  legend({'Cashflow', 'Payback Year'}, 'Location', 'Best', 'FontSize', legendFontSize);
  hold off

  % Adjusting figure properties for better visualization
  set(gcf, 'Color', 'w');

  
  % Display outputs in command window
  disp(['ICC = ',num2str(round(eco.metrics.ICC/1e3)),' k€'])
  disp(['OMC = ',num2str(round(eco.metrics.OMC/1e3)),' k€/year'])
  disp(['LCoE = ',num2str(round(eco.metrics.LCoE)),' €/MWh'])
  disp(['CoVE = ',num2str(round(eco.metrics.CoVE)),' €/MWh'])
  disp(['LRoE = ',num2str(round(eco.metrics.LRoE)),' €/MWh'])
  disp(['LPoE = ',num2str(round(eco.metrics.LPoE)),' €/MWh'])
  disp(['NPV = ',num2str(round(eco.metrics.NPV/1e3)),' k€'])
  disp(['IRR = ',num2str(round(eco.metrics.IRR,3)*100),' %'])

end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  