function [stat] = robust_stat(data,alpha)

if (nargin < 2),
	alpha = 0.05;
end;
a = alpha/2;
b = 1 - a;

[f,x] = ecdf(data);
seta = find(f >= a);
setb = find(f <= b);
index = intersect(seta,setb);
stat.mean = mean(data(index,:));
stat.std = std(data(index,:));
stat.data = data(index,:);