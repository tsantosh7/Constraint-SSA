function [fratio] = f_ratio(param, chosen)
% [fratio] = f_ratio(param)
% This function calculates the F-ratio of base-expert(s)

if (nargin < 2),
    chosen = 1;
end;
fratio = (param.mu_C(chosen) - param.mu_I(chosen)) ./ (param.sigma_C(chosen) + param.sigma_I(chosen));