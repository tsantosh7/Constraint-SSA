function [hter,far,frr] = hter_us_apriori(imp, gen, thrd_imp, thrd_gen)
% [hter,far,frr] = hter_us_apriori(imp, gen, thrd)¨


if size(imp,2) ~= 1 || size(gen,2) ~= 1,
  error('imp and gen must be one dimension in column');
end;
fa = size(find (imp-thrd_imp >= 0),1);
fr = size(find (gen-thrd_gen < 0),1);
far = fa /prod(size(imp));
frr = fr /prod(size(gen));
%fprintf(1, 'far = %2.3f, frr = %2.3f\n', far*100, frr*100);
hter = far + frr;
hter = hter/2;

