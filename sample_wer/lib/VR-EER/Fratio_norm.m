function [var_adj] = VR_Fratio_norm(param, param_global, beta, class_sep)
% This function normalises param such that
% the cliet and impostor mean difference is exactly 2
% [var_adj] = VR_Fratio_norm(param)
% returns the parameter that is needed to adjust the variance
% [var_adj] = VR_Fratio_norm(param, class_sep)
% overwrite the default value of class_sep = 2

if (nargin < 2),
	beta = 0;
end;
if (nargin < 4),
    class_sep = 2;
end;

mu_C = beta * param.mu_C + (1-beta) * param_global.mu_C;
mu_I = beta * param.mu_I + (1-beta) * param_global.mu_I;

%calculate variance adjustment:
mean_diff = (mu_C - mu_I  );
var_adj = class_sep ./ mean_diff;

