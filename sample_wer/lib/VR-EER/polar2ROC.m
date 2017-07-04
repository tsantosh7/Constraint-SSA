function [FAR,FRR] = polar2ROC(radius,deg_list)
if (nargin<2 | length(deg_list)==0)
  deg_list = [0:90];
end;
for r=1:size(radius,1),
  FAR(:,r)=1-(radius(r,:) .* (cos(deg_list/360*2*pi)))';
  FRR(:,r)=1-(radius(r,:) .* (sin(deg_list/360*2*pi)))';
  FRR(find(FRR<0))=0;
end;