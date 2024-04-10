function inp = eco_import_model
% Import input file and organize in structures for speeding up the code.
%%
global eco_settings
%% Import from excel
sheets = {'kite','tether','g_station','LLA','system','business'};
for q = 1:length(sheets)
    cell = readcell(eco_settings.input_model_file,'Sheet',sheets{q},'Range','A1:G30');
    
    i = 1;
    flag = 0;
    while  flag == 0
        
        if sum(ismissing(cell{i,1}))==0 % skip when missing data
            
            sub_str = strfind(cell(i,1),'.');
            n_sub_str = length(sub_str{1});
            str = char(cell(i,1));
            
            %%
            if n_sub_str == 0
                %%                
                if ischar(cell{i,2})
                    inp.(sheets{q}).(str) = str2num(cell{i,2}); %#ok<*ST2NM>
                else
                    inp.(sheets{q}).(str) =  cell2mat(cell(i,2));
                end
                
                
                if ismissing(cell{i,3})==0
                    inp.UQ.(sheets{q}).(str).type = cell{i,3};
                end
                if ismissing(cell{i,4})==0
                    inp.UQ.(sheets{q}).(str).range = cell{i,4};
                end
                if ismissing(cell{i,5})==0
                    inp.UQ.(sheets{q}).(str).ref = cell{i,5};
                end
                
            elseif n_sub_str == 1
                %%
                if ischar(cell{i,2})
                     inp.(sheets{q}).(str(1:sub_str{1}(1)-1)).(str(sub_str{1}(1)+1:end)) = str2num(cell{i,2}); %#ok<*ST2NM>
                else
                   inp.(sheets{q}).(str(1:sub_str{1}(1)-1)).(str(sub_str{1}(1)+1:end)) = cell2mat(cell(i,2));
                end
                
                if ismissing(cell{i,3})==0
                    inp.UQ.(sheets{q}).(str(1:sub_str{1}(1)-1)).(str(sub_str{1}(1)+1:end)).type = cell{i,3};
                end
                if ismissing(cell{i,4})==0
                    inp.UQ.(sheets{q}).(str(1:sub_str{1}(1)-1)).(str(sub_str{1}(1)+1:end)).range = cell{i,4};
                end
                if ismissing(cell{i,5})==0
                    inp.UQ.(sheets{q}).(str(1:sub_str{1}(1)-1)).(str(sub_str{1}(1)+1:end)).ref = cell{i,5};
                end
                
                %                 end
                
                %             elseif n_sub_str == 2
                %                 par.(sheets{q}).(str(1:sub_str{1}(1)-1)).(str(sub_str{1}(1)+1:sub_str{1}(2)-1)).(str(sub_str{1}(2)+1:end)) = cell{i,2};
            end
        end
        
        if i == size(cell,1)
            flag = 1;
        end
        i = i+1;
    end
    
end

end