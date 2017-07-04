function [deg_list,nradius] = ROC2polar(FAR,FRR,deg_list,toplot)
if (nargin<3 | length(deg_list)==0)
  deg_list = [0:90];
end;
if (nargin<4 | length(toplot)==0)
  toplot=0;
end;

%angle = atan(FAR ./ (FRR+eps));
%radius = sqrt(FAR .^2 + (FRR) .^ 2);
angle = atan((1-FRR) ./ (1-FAR+eps));
radius = sqrt((1-FAR) .^2 + (1-FRR) .^ 2);

deg = angle / (2*pi) * 360;

%find(isnan(deg))
deg(1)=90;radius(1)=1;
selected=1:min(find(deg==0));
nradius = interp1(deg(selected),radius(selected),deg_list, 'linear');
nradius(1)=1-eps;
nradius(end)=1-eps;

if toplot,
  figure(1);
  clf; hold on;
  plot(FAR,FRR,'b.');
  [FAR_,FRR_] = polar2ROC(nradius,deg_list);
  plot(FAR_,FRR_,'ro--','linewidth',2);
  set(gca,'xscale','log');
  set(gca,'yscale','log');
  %set(gca,'xscale','linear');
  %set(gca,'yscale','linear');

  figure(2);
  clf; plot(deg_list,nradius);
end;