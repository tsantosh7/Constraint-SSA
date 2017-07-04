function [alpha, msg, norm_cov_inv] = cal_weight_fisher(chosen, dset)
%
% [alpha, msg, norm_cov_inv] = cal_weight_fisher(chosen, dset)
% This function calculate weights using Fisher criterion
% chosen = the chosen column
% param  = the parametric representation of the data given by VR_analysis
% msg = 1 indicates that the matrix is near singular!
%make covariance matrix

for i=1:size(chosen,2),
  for j=1:size(chosen,2),

    norm_cov_C(i,j) = dset.cov_C(chosen(i), chosen(j));
    norm_cov_I(i,j) = dset.cov_I(chosen(i), chosen(j));
  end;
end;
%inverse within-class cov matrix
%see bishop pg 108
factor_C = dset.size_C / (dset.size_C + dset.size_I);
factor_I = 1 - factor_C;

%check for reciprocal condition
Sw = factor_C * norm_cov_C + factor_I * norm_cov_I;
msg.rcond = rcond(Sw);
if (msg.rcond < 1e-14),
	fprintf(1, 'Message: Forcing with-in class matrix to be a valid covariance matrix!\n');
	Sw = covfixer2(Sw);
	msg.issingular = 1;
else
	msg.issingular = 0;
end;	
Sw_1 = inv(Sw);

mean_diff = dset.mu_C(chosen) - dset.mu_I(chosen);
norm_cov_inv = Sw_1 * mean_diff';

%calculate alpha: sum to 1
for i=1:size(chosen,2),	
  alpha(i) = sum(norm_cov_inv(i,:));
end;
alpha = alpha / sum(alpha); %normalise it