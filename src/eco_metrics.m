function eco = eco_metrics(inp,par,eco)
%%
r = inp.business.r;
T = inp.business.T;

%%
% PATH = structree(eco);
% CAPEX_ind = zeros(length(PATH),1);
% eco.metrics.ICC = 0;
% eco.metrics.OMC = 0;
% OPEX_ind  = zeros(length(PATH),1);
% for ind = 1:length(PATH)
%     a = PATH(ind);
%     a = a{1};
%     if strcmp(a(end),'CAPEX')
%         CAPEX_ind(ind) = 1;
%         if length(a) == 1
%             icc = eco.(string(a(1)));
%         elseif length(a) == 2
%             icc = eco.(string(a(1))).(string(a(2)));
%         elseif length(a) == 3
%             icc = eco.(string(a(1))).(string(a(2))).(string(a(3)));
%         end
%         eco.metrics.ICC = eco.metrics.ICC + icc;
%     elseif strcmp(a(end),'OPEX')
%         OPEX_ind(ind) = 1;
%         if length(a) == 1
%             omc = eco.(string(a(1)));
%         elseif length(a) == 2
%             omc = eco.(string(a(1))).(string(a(2)));
%         elseif length(a) == 3
%             omc = eco.(string(a(1))).(string(a(2))).(string(a(3)));
%         end
%         eco.metrics.OMC = eco.metrics.OMC + omc;
%     end
% end

%%
%%
PATH = structree(eco);
CAPEX_ind = zeros(length(PATH),1);
eco.metrics.ICC = 0;
eco.metrics.OMC = 0;
OPEX_ind  = zeros(length(PATH),1);
ind_capex = 1;
ind_opex = 1;
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
        ind_opex = ind_opex + 1;
    end
end
 
%%
figure('units','normalized','outerposition',[0 0 1 1])
tg = uitabgroup;
 
thistab = uitab(tg,'Title','ICC'); % build iith tab
axes('Parent',thistab); % somewhere to plot
 
t = 1;
for q = 1:length(icc)
    per(q) = round(icc(q)/eco.metrics.ICC *100,0);
    if per(q)>0
        list{t} = [icc_name{q},' ',num2str(per(q)),' %'];
        pp(t) = per(q);
        t = t+1;
    end
end
p = pie(pp,list);
title(['ICC = ',num2str(round(eco.metrics.ICC/10^3)),' k €'])
 
%%
% thistab = uitab(tg,'Title','OMC'); % build iith tab
% axes('Parent',thistab); %
% thistab = uitab(tg,'Title','OMC'); % build iith tab
% axes('Parent',thistab); % somewhere to plot
 
figure()
 
per = [];
list = [];
pp =[];
t = 1;
for q = 1:length(omc)
    per(q) = round(omc(q)/eco.metrics.OMC *100,0);
    if per(q)>0
        list{t} = [omc_name{q},' ',num2str(per(q)),' %'];
        pp(t) = per(q);
        t = t+1;
    end
end
p = pie(pp,list);
title(['OMC = ',num2str(round(eco.metrics.OMC/10^3)),' k €'])


%% Metrics
inp.system.AEP = 8760 * trapz(inp.atm.wind_range,inp.system.P.*inp.atm.gw)/1e6; % MWh
eco.metrics.p = 8760 * trapz(inp.atm.wind_range,(par.metrics.electricity.p_0+par.metrics.electricity.p_1*inp.atm.wind_range).*inp.system.P/1e6.*inp.atm.gw) ;

num_LCoE = eco.metrics.ICC;
num_LRoE = 0;
den = 0;
eco.metrics.NPV = 0;
for t = 1:T
    num_LCoE = num_LCoE + eco.metrics.OMC/(1+r)^t;
    num_LRoE = num_LRoE + (eco.metrics.p + par.metrics.subsidy * inp.system.AEP )/(1+r)^t;
    
    den = den + inp.system.AEP/(1+r)^t;
    
    eco.metrics.NPV = eco.metrics.NPV + (eco.metrics.p + par.metrics.subsidy * inp.system.AEP - eco.metrics.ICC - eco.metrics.OMC)/(1+r)^t;
end
eco.metrics.LCoE = num_LCoE/den;
eco.metrics.LRoE = num_LRoE/den;
eco.metrics.LPoE = eco.metrics.LRoE - eco.metrics.LCoE;
% eco.metrics.Pi = eco.metrics.p - (eco.metrics.ICC * eco.metrics.CRF + eco.metrics.OMC);


% Capacity factor
eco.metrics.CF = inp.system.AEP*1e6/8760/inp.system.P_rated;
end