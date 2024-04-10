function [f] = eco_scaling(S, S0, a)
% Implement cost reduction by learning factors

f = (S/S0)^(-a);

end