function eco = eco_metrics(inp,par,eco)

r = inp.business.r;
T = inp.business.T;
eco.metrics.CRF = r*(1+r)^T/((1+r)^T-1);

eco.metrics.AEP = 8760 * trapz(inp.atm.wind_range,inp.system.P.*inp.atm.gw)/1e6; % MWh
eco.metrics.CF = trapz(inp.atm.wind_range,inp.system.P.*inp.atm.gw)/inp.system.P_rated; % Capacity factor
eco.metrics.p = 8760 * trapz(inp.atm.wind_range,(par.metrics.electricity.p_0 + par.metrics.electricity.p_1 * inp.atm.wind_range).*inp.system.P/1e6.*inp.atm.gw); % Revenues euros/year 

%%
PATH = structree(eco);
CAPEX_ind = zeros(length(PATH),1);
eco.metrics.ICC = 0;
eco.metrics.OMC = 0;
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
den = 0;

for t = 1:T
    num_LCoE = num_LCoE + eco.metrics.OMC/(1+r)^t;
    num_LRoE = num_LRoE + (eco.metrics.p + par.metrics.subsidy * eco.metrics.AEP )/(1+r)^t;
    
    den = den + eco.metrics.AEP/(1+r)^t;
    
    eco.metrics.NPV = eco.metrics.NPV + (eco.metrics.p + par.metrics.subsidy * eco.metrics.AEP - eco.metrics.OMC)/(1+r)^t;
end
eco.metrics.LCoE = num_LCoE/den;
eco.metrics.LRoE = num_LRoE/den;
eco.metrics.LPoE = eco.metrics.LRoE - eco.metrics.LCoE;
eco.metrics.Pi   = eco.metrics.LPoE * eco.metrics.AEP;

%%
figure('units','normalized','outerposition',[0 0 1 1])
tg = uitabgroup;
%
thistab = uitab(tg,'Title','outputs'); % build iith tab
axes('Parent',thistab); 

str_2_print = '------------------------ Main economic performances ------------------------ \n ';
str_2_print = [str_2_print, 'CF = ',num2str(round(eco.metrics.CF,2)),' \n '];
str_2_print = [str_2_print, 'LCoE = ',num2str(round(eco.metrics.LCoE)),' euro/MWh',' \n '];
str_2_print = [str_2_print,'LRoE = ',num2str(round(eco.metrics.LRoE)),' euro/MWh',' \n '];
str_2_print = [str_2_print,'LPoE = ',num2str(round(eco.metrics.LPoE)),' euro/MWh',' \n '];
str_2_print = [str_2_print,'NPV = ',num2str(round(eco.metrics.NPV/1e3)),' k euro',' \n '];
str_2_print = [str_2_print,'ICC = ',num2str(round(eco.metrics.ICC/1e3)),' k euro',' \n '];
str_2_print = [str_2_print,'OMC = ',num2str(round(eco.metrics.OMC/1e3)),' k euro/y',' \n '];
str_2_print = [str_2_print,'Profit = ',num2str(round(eco.metrics.Pi/1e3)),' k euro/y',' \n '];
text(0,1,compose(str_2_print),'HorizontalAlignment','Left', 'VerticalAlignment','Top','interpreter','latex')
axis off

%%
warning off

thistab = uitab(tg,'Title','ICC'); % build iith tab
axes('Parent',thistab); 
 
t = 1;
for q = 1:length(icc)
    if icc(q)>0
        list_icc{t} = icc_name{q};
        pp_icc(t) = icc(q);
        t = t+1;
    end
end
pie(pp_icc);
legend(list_icc,'Location','westoutside');

title(['ICC = ',num2str(round(eco.metrics.ICC/10^3)),' k euro'])
 
%%
thistab = uitab(tg,'Title','OMC'); % build iith tab
axes('Parent',thistab); %

list_omc = [];
pp_omc =[];
t = 1;
for q = 1:length(omc)
    if omc(q)>0
        list_omc{t} = omc_name{q};
        pp_omc(t) = omc(q);
        t = t+1;
    end
end
pie(pp_omc);
legend(list_omc,'Location','westoutside');
title(['OMC = ',num2str(round(eco.metrics.OMC/10^3)),' k euro/year'])

%%
thistab = uitab(tg,'Title','LCoE'); % build iith tab
axes('Parent',thistab); %
 
list_lcoe = [];
pp_lcoe =[];
t = 1;
for q = 1:length(PATH)
    if LCoE_contr(q)>0
        list_lcoe{t} = LCoE_contr_name{q};
        pp_lcoe(t) = LCoE_contr(q);
        t = t+1;
    end
end
pie(pp_lcoe);
legend(list_lcoe,'Location','westoutside');
title(['LCoE = ',num2str(round(eco.metrics.LCoE)),' euro/MWh'])

end