function NPV = eco_NPV(r,eco,par,N_y)
  %ECO_NPV Calculate the net present value NPV and it is used to compute the
  %internal rate of return IRR
  %
  %   Inputs:
  %   - r:   Discout rate.
  %   - par: Structure containing cost model parameters.
  %   - eco: Structure containing results and metrics of the AWE-Eco simulation.
  %   - N_y: project lifetime in years .
  %
  %   Outputs:
  %   - NPV: Updated input structure after processing.
NPV = - eco.metrics.ICC;
for t = 1:N_y
    NPV = NPV + ((eco.metrics.p + par.metrics.subsidy) * eco.metrics.AEP - eco.metrics.OMC)/(1+r)^t;
end
end