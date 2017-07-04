function [nwolves, nsheep] = VR_Fnorm(wolves, sheep, param, param_global, chosen, beta)
% [nwolves, nsheep] = VR_Fnorm(wolves, sheep, nparam, nparam_global, beta)

%class separation parameter is a constant
class_sep = 2;

%F-ratio normalisation
mu_C = beta * param.mu_C(chosen) + (1-beta) * param_global.mu_C(chosen);
mu_I = beta * param.mu_I(chosen) + (1-beta) * param_global.mu_I(chosen);

%calculate variance adjustment:
mean_diff = (mu_C - mu_I);
var_adj = class_sep ./ mean_diff;

denominator = 1 ./ var_adj;
shift = param.mu_I(chosen);
[nwolves, nsheep] = normalise_scores(wolves, sheep, shift, denominator);

%denominator = 1;
%shift = 1;
%[nwolves, nsheep] = normalise_scores(nwolves, nsheep, shift, denominator);
