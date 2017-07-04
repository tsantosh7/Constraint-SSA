function [hter,far,frr] = hter_apriori(wolves, sheep, thrd)
% [hter,far,frr] = hter_apriori(wolves, sheep, thrd)

%wolves and sheep are 1 dimension in column
fa = size(find (wolves >= thrd),1);
fr = size(find (sheep < thrd),1);
far = fa /numel(wolves);
frr = fr /numel(sheep);
%fprintf(1, 'far = %2.3f, frr = %2.3f\n', far*100, frr*100);
hter = far + frr;
hter = hter/2;

