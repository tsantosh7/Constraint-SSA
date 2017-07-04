function [corr_pair, labels] = estimate_corrcoef(tmp, leg_)

tmp=remove_nan(tmp);
plotmatrix(tmp);
corr_=corrcoef(tmp);

tmp_=triu(ones(5),1);
[I,J]= ind2sub(size(tmp_), find(tmp_));

for i=1:numel(I),
  fprintf(1,'%s, %s, %1.2f\n', leg_{I(i)},leg_{J(i)},corr_(I(i),J(i)));
  corr_pair(i)=corr_(I(i),J(i));
  labels{i}=sprintf('%s, %s\n', leg_{I(i)},leg_{J(i)});
end;
