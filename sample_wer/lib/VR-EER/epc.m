function [dev, eva, cost]  = epc(dev_wolves, dev_sheep, eva_wolves, eva_sheep, n_samples,range)
%function [dev, eva, cost]  = epc(dev_wolves, dev_sheep, eva_wolves, eva_sheep, n_samples,range)
% Other options
% 
% range : a vector of the form [a,b]
%         It analyses the range from a to b
%         default is [0,1]
% n_samples : the number of samples to take from a to b
if (nargin < 5),
  n_samples =11;
end;
if (nargin < 6),
  range = [0,1];
end;

c_fa = linspace(min(range),max(range),n_samples);
c_fr = 1-c_fa;
cost = [c_fa' c_fr'];

%a faster implementation:
[tmp, tmp, x{1}, FAR{1}, FRR{1}] = wer(dev_wolves, dev_sheep);
[tmp, tmp, x{2}, FAR{2}, FRR{2}] = wer(eva_wolves, eva_sheep);
for i=1:n_samples,
  [tmp, min_index] = min( abs(cost(i,1) * FAR{1} - cost(i,2) * FRR{1}) );
  thrd_min = x{1}(min_index);

  dev.wer_apost(i) = cost(i,1) * FAR{1}(min_index) + cost(i,2) * FRR{1}(min_index);
  dev.thrd_fv(i) = thrd_min;

  [eva.hter_apri(i), eva.far_apri(i), eva.frr_apri(i)] = hter_apriori(eva_wolves, eva_sheep, dev.thrd_fv(i));
  eva.wer_apri(i) = cost(i,1) * eva.far_apri(i) + cost(i,2) * eva.frr_apri(i);
  
  [dev.hter(i), dev.far(i), dev.frr(i)] = hter_apriori(dev_wolves, dev_sheep, dev.thrd_fv(i));
end;

