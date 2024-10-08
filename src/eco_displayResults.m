function eco_displayResults(inp, eco)
  %ECO_DISPLAYRESULTS Display economic metrics and breakdown in AWE-Eco simulation.
  %   This function visualizes economic metrics and breakdown, including cost of
  %   energy (LCoE), net present value (NPV), return on equity (RoE), profit, and
  %   others, using pie charts and text summaries.
  %
  %   Inputs:
  %   - eco: Structure containing results and metrics of the AWE-Eco simulation.

  % Extracting significant initial capital cost (ICC) components
  icc_perc = eco.metrics.icc / sum(eco.metrics.icc) * 100;
  [sorted_icc_perc, icc_order] = sort(icc_perc, 'descend');
  significant_icc_idx = sorted_icc_perc > 2;
  list_icc = eco.metrics.icc_name(icc_order(significant_icc_idx));
  for i = 1:length(list_icc)
    list_icc{i} = [list_icc{i}, '.capex'];
  end
  pp_icc = sorted_icc_perc(significant_icc_idx);

  % Extracting significant operational maintainence cost (OMC) components
  omc_perc = eco.metrics.omc / sum(eco.metrics.omc) * 100;
  [sorted_omc_perc, omc_order] = sort(omc_perc, 'descend');
  significant_omc_idx = sorted_omc_perc > 2;
  list_omc = eco.metrics.omc_name(omc_order(significant_omc_idx));
  for i = 1:length(list_omc)
    list_omc{i} = [list_omc{i}, '.opex'];
  end
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
  titleFontSize = 12;

  % Identify all unique components across ICC, OMC, and LCoE
  all_components = unique([list_icc(:); list_omc(:); list_lcoe(:)]);

  % Assign colors using the jet colormap
  num_all_components = length(all_components);
  % cmap = parula(num_all_components); % Generate colors from jet colormap

  % Define original colormap
  cmap = jet(256);
  num_colors = num_all_components;
  % Extract colors from Parula colormap
  parula_colors = interp1(linspace(0, 1, size(cmap, 1)), cmap, linspace(0, 1, num_colors));
  % Define pastel factors to soften colors
  pastel_factor = 0.3; % Adjust as needed for desired pastel effect
  % Soften colors to create pastel effect
  pastel_colors = (1 - pastel_factor) * parula_colors + pastel_factor * ones(num_colors, 3);
  % Ensure RGB values are within [0, 1] range
  pastel_colors = max(0, min(1, pastel_colors));

  % Create a mapping from component names to colors
  % color_map = containers.Map(all_components, num2cell(cmap, 2));
  color_map = containers.Map(all_components, num2cell(pastel_colors, 2));

  % Create Figure 1: Pie charts in one row
  figure('units', 'normalized', 'outerposition', [0 0 0.5 1])

  % Set up a 1x3 tiled layout for the pie charts
  tiledlayout(1, 3, 'TileSpacing', 'Compact', 'Padding', 'Compact');

  % ICC Pie Chart
  nexttile;
  h1 = pie(pp_icc); % Create pie chart for ICC
  icc_colors = cell2mat(values(color_map, list_icc)); % Get the colors for ICC components
  icc_colors = reshape(icc_colors, [3, length(pp_icc)])';
  % Set colors manually for each slice
  for i = 1:length(pp_icc)
    h1(2*i-1).FaceColor = icc_colors(i, :);
  end
  legend(list_icc, 'Location', 'southoutside', 'Interpreter', 'latex', 'FontSize', legendFontSize);
  title(['CapEx = ', num2str(round(eco.metrics.ICC / 1e3)), ' k€'], 'FontSize', fontSize);

  % OMC Pie Chart
  nexttile;
  h2 = pie(pp_omc); % Create pie chart for OMC
  omc_colors = cell2mat(values(color_map, list_omc)); % Get the colors for OMC components
  omc_colors = reshape(omc_colors, [3, length(pp_omc)])';
  % Set colors manually for each slice
  for i = 1:length(pp_omc)
    h2(2*i-1).FaceColor = omc_colors(i, :);
  end
  legend(list_omc, 'Location', 'southoutside', 'Interpreter', 'latex', 'FontSize', legendFontSize);
  title(['OpEx = ', num2str(round(eco.metrics.OMC / 1e3)), ' k€/year'], 'FontSize', fontSize);

  % LCoE Pie Chart
  nexttile;
  h3 = pie(pp_lcoe); % Create pie chart for LCoE
  lcoe_colors = cell2mat(values(color_map, list_lcoe)); % Get the colors for LCoE components
  lcoe_colors = reshape(lcoe_colors, [3, length(pp_lcoe)])';
  % Set colors manually for each slice
  for i = 1:length(pp_lcoe)
    h3(2*i-1).FaceColor = lcoe_colors(i, :);
  end
  legend(list_lcoe, 'Location', 'southoutside', 'Interpreter', 'latex', 'FontSize', legendFontSize);
  title(['LCoE = ', num2str(round(eco.metrics.LCoE)), ' €/MWh'], 'FontSize', fontSize);

  % Add overall figure title at the top
  sgtitle('Cost shares above 2\%', 'FontSize', fontSize + 2, 'Interpreter', 'latex');

  % Adjusting figure properties for better visualization (commented out as per user instructions)
  set(gcf, 'Color', 'w');

  hold off



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