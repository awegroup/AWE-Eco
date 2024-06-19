function inp = eco_import_model(inp)
%ECO_IMPORT_MODEL Import model parameters from an Excel file and organize them into a structure.
%   This function reads model parameters from an Excel file and organizes them into
%   a structured format for use in the AWE-Eco simulation.
%
%   Inputs:
%   - inp: Structure containing existing input parameters.
%
%   Outputs:
%   - inp: Updated structure containing imported model parameters.

global eco_settings

% Import from excel
sheets = {'atm','kite','tether','system','gStation'};
for q = 1:length(sheets)
    cell = readcell(eco_settings.input_model_file,'Sheet',sheets{q},'Range','A1:B30');
    
    i = 1;
    flag = 0;
    while  flag == 0
        
        if sum(ismissing(cell{i,1}))==0 % skip when missing data
            
            sub_str = strfind(cell(i,1),'.');
            n_sub_str = length(sub_str{1});
            str = char(cell(i,1));
            
            
            if n_sub_str == 0
                                
                if ischar(cell{i,2})
                    inp.(sheets{q}).(str) = str2num(cell{i,2}); %#ok<*ST2NM>
                else
                    inp.(sheets{q}).(str) =  cell2mat(cell(i,2));
                end
                
            elseif n_sub_str == 1
                
                if ischar(cell{i,2})
                     inp.(sheets{q}).(str(1:sub_str{1}(1)-1)).(str(sub_str{1}(1)+1:end)) = str2num(cell{i,2}); %#ok<*ST2NM>
                else
                   inp.(sheets{q}).(str(1:sub_str{1}(1)-1)).(str(sub_str{1}(1)+1:end)) = cell2mat(cell(i,2));
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