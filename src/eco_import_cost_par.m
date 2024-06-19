function par = eco_import_cost_par
  %ECO_IMPORT_COST_PAR Import cost parameters from an Excel file and organize them into a structure.
  %   This function reads cost parameters from an Excel file and organizes them into
  %   a structured format for use in the AWE-Eco simulation.
  %
  %   Outputs:
  %   - par: Structure containing imported cost parameters.

  global eco_settings
  
  % Import from excel
  sheets = {'kite','tether','gStation','BoS','BoP','metrics'};
  for q = 1:length(sheets)
      cell = readcell(eco_settings.input_cost_file,'Sheet',sheets{q},'Range','A1:B50');
      
      i = 1;
      flag = 0;
      while  flag == 0
          
          if sum(ismissing(cell{i,1}))==0 % skip when missing data
              
              sub_str = strfind(cell(i,1),'.');
              n_sub_str = length(sub_str{1});
              str = char(cell(i,1));
              
              if n_sub_str == 0
                  
                  if ischar(cell{i,2})
                      par.(sheets{q}).(str) = str2num(cell{i,2}); %#ok<*ST2NM>
                  else
                      par.(sheets{q}).(str) = cell2mat(cell(i,2));
                  end
                  
              elseif n_sub_str == 1
                  if ischar(cell{i,2})
                      par.(sheets{q}).(str(1:sub_str{1}(1)-1)).(str(sub_str{1}(1)+1:end)) = str2num(cell{i,2}); %#ok<*ST2NM>
                  else
                      par.(sheets{q}).(str(1:sub_str{1}(1)-1)).(str(sub_str{1}(1)+1:end)) = cell2mat(cell(i,2));
                  end
              elseif n_sub_str == 2
                  if ischar(cell{i,2})
                      par.(sheets{q}).(str(1:sub_str{1}(1)-1)).(str(sub_str{1}(1)+1:sub_str{1}(2)-1)).(str(sub_str{1}(2)+1:end)) = str2num(cell{i,2}); %#ok<*ST2NM>
                  else
                      par.(sheets{q}).(str(1:sub_str{1}(1)-1)).(str(sub_str{1}(1)+1:sub_str{1}(2)-1)).(str(sub_str{1}(2)+1:end)) = cell2mat(cell(i,2));
                  end
              elseif n_sub_str == 3
                  if ischar(cell{i,2})
                      par.(sheets{q}).(str(1:sub_str{1}(1)-1)).(str(sub_str{1}(1)+1:sub_str{1}(2)-1)).(str(sub_str{1}(2)+1:sub_str{1}(3)-1)).(str(sub_str{1}(3)+1:end)) = str2num(cell{i,2}); %#ok<*ST2NM>
                  else
                      par.(sheets{q}).(str(1:sub_str{1}(1)-1)).(str(sub_str{1}(1)+1:sub_str{1}(2)-1)).(str(sub_str{1}(2)+1:sub_str{1}(3)-1)).(str(sub_str{1}(3)+1:end)) = cell2mat(cell(i,2));
                  end
              end
          end
          
          if i == size(cell,1)
              flag = 1;
          end
          i = i+1;
      end
      
  end

end