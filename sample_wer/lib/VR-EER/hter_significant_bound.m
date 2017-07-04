function [upper, lower, hter] = hter_significant_bound(far, frr, n_impostors, n_clients, alpha)
% [upper, lower, hter] = hter_significant_bound(far, frr, n_impostors, n_clients, alpha)
%
% INPUT:
% far and frr are column vectors of size nx1 (or scalar when n=1) for
% n number of FAR and FRR values to evaluate
% 1-alpha is the confidence interval
% e.g. alpha = 0.05 to specify 95% confidence interval desired (default)
% this is a two-sided test
%
% OUTPUT:
% upper is the upper bound of HTER
% lower is the lower bound of HTER such that
% lower <= HTER <= upper

if nargin <5,
  alpha = 0.05;
end;

portion = 1-alpha/2;
%actually the upper and lower bound is:
%portion = [alpha/2 1-alpha/2];

%the confidence interval
z = norminv(portion,0,1);

t1= (far .* (1 - far) ) ./ (4 .* n_impostors');
t2 = (frr .* (1 - frr) ) ./ (4 .* n_clients');
sigma  = sqrt(t1 + t2);

hter = ( far + frr ) ./ 2;
upper = hter + sigma * z;
lower = hter - sigma * z;