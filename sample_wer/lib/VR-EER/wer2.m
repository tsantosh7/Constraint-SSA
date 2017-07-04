function [wer_min, thrd_min, x, FAR, FRR] = wer2(wolves, sheep, cost, dodisplay,max_scale,holdon, criterion)
%function [wer_min, thrd_min, x] = wer2(impostor_scores, client_scores, cost, dodisplay,max_scale,holdon)
%
%impostor_scores and client_scores must be vectors of column 1 but they can
%can have different number of rows
%
%cost(1) : cost of false acceptance, default =0.5
%cost(2) : cost of false rejection, default =0.5
%dodisplay = 
% 1: plot options 2,4,5 and 6 (see below)
% 2: DET
% 3: ROC
% 4: Density vs score
% 5: FAR, FRR vs thrd
% 6: WER vs thrd
% max_scale is a parameter used in DET curve. If omitted, the max_scale
% value will be determined automatically.
% holdon is by default zero. If set to more than 1, curves will be plotted onto
% existing ones. If set to 1, the exisiting curves will be removed. holdon
% is useful for plotting multiple curves by calling wer repeatedly.
%
% Author: Norman Poh <normanpoh@ieee.org>
% updated 11 November 2008
% Example of usage:
% If you have two experiments and you want to compare them,
% use the following:
% wer2(impostor_scores1, client_scores1, [],2,[],1);
% wer2(impostor_scores2, client_scores2, [],2,[],2);
%

if (nargin < 3 | length(cost)==0),
  cost = [0.5 0.5];
end;

if (nargin < 4 | length(dodisplay)==0),
  dodisplay = 0;
end

if (nargin < 5 | length(max_scale)==0),
    max_scale = 0; %decide from the data itself
end;

if nargin < 6,
  holdon = 1; %for plotting more than one curves
end

if nargin<7,
  criterion='hter';
end;
n_hist_wolves = 0;
n_hist_sheep = 0;

[ecdf_{1},x_{1}] = ecdf(wolves);
[ecdf_{2},x_{2}] = ecdf(sheep);

for k=1:2,
  %the precision of the extreme value is half way between the last two
  %values
  myeps = (ecdf_{k}(end) - ecdf_{k}(end-1))/2;
  ecdf_{k}(end)=1-myeps;
  ecdf_{k}(1)=0+myeps;

  %find duplicates and add random noise to break it
  [xu, tmp, index] = unique(x_{k});
  dup_index = find(diff(index)==0);
  x_{k}(dup_index) = x_{k}(dup_index) + rand * myeps;
  
end;
x =  sort(unique([wolves;sheep]));
new_f_I = interp1(x_{1},ecdf_{1},x,'linear');
new_f_C = interp1(x_{2},ecdf_{2},x,'linear');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This section replace NAN value with zero or one in new_f_C and new_f_I
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
index_ = isnan(new_f_C);
end_NAN = find([index_;1] - [1;index_] >= 1) - 1;
start_NAN = find([index_;1] - [1;index_] <= -1);

%sometimes the first element is not zero!
if (start_NAN == 1),
else
  new_f_C(1:start_NAN)=0;
end;
%the end element is always 1!
new_f_C(end_NAN:size(new_f_C,1))=1;

index_ = isnan(new_f_I);
end_NAN = find([index_;1] - [1;index_] >= 1) - 1;
start_NAN = find([index_;1] - [1;index_] <= -1);
if (start_NAN == 1),
else
  new_f_I(1:start_NAN)=0;
end;
new_f_I(end_NAN:size(new_f_C,1))=1;

%convert into FAR and FRR
new_f_I= 1-new_f_I;
%no change for new_f_C= new_f_C;

% for debugging
% cla; hold on;
% plot( x, new_f_I,'r');
% plot( x, new_f_C,'b');

%[min_value, min_index] = min( abs(cost(1) * new_f_I - cost(2) * new_f_C) );
switch lower(criterion)
  case 'hter'
    [min_value, min_index] = min( abs(cost(1) * new_f_I + cost(2) * new_f_C) );
  case 'eer'
    [min_value, min_index] = min( abs(cost(1) * new_f_I - cost(2) * new_f_C) );
  otherwise
    error('option does not exist');
end;
thrd_min = x(min_index);

wer_min = cost(1) * new_f_I(min_index) + cost(2) * new_f_C(min_index);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% construct the styles for ploting purpose
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
style = {'-','--'};%,':'};
color = {'b', 'g', 'r', 'k', 'm', 'y', 'k'};
i=0;
for c=1:length(color),
  for j=1:2, %repeat twice
    for s =1:length(style),
      i=i+1;
      signs{i}=sprintf('%s%s',color{c},style{s});
      lwidth(i) = j;
    end;
  end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% now display according to the switch
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (dodisplay==1),
  
  %density estimation
  subplot(2,2,1);  
  [fI,xI] = ksdensity(wolves);
  [fC,xC] = ksdensity(sheep);
  if holdon == 1, hold off; else hold on; end;
  plot(xC, fC,signs{1});
  hold on;
  plot(xI, fI,signs{2});
  ylabel('Density');
  xlabel('Scores');
  title('(a) Density');
  
  %plot ecdf curve
  subplot(2,2,2);
  if holdon == 1, hold off; else hold on; end
  plot(x,cost(1)*new_f_C,signs{1});
  hold on;
  plot(x,cost(2)*new_f_I,signs{2});
  xlabel('Scores');
  ylabel('FRR, FAR');
  title('(b) FAR and FRR');
  
  %debug use only:
  %plot(x_I,1-f_I,'c');
  %hold on;
  %plot(x_C,f_C,'m');

  %plot the hter curve
  subplot(2,2,3);
  if holdon == 1, hold off; else hold on; end
  hter_all = cost(1) * new_f_I + cost(2) * new_f_C;
  plot(x,hter_all,signs{1});
  xlabel('Scores');
  ylabel('WER');
  title('(c) WER');

  subplot(2,2,4);
  if holdon == 1, hold off; else hold on; end

  %DET curve
  %see code in ~marietho/matlab/
  plot(ppndf(new_f_I), ppndf(new_f_C), signs{1});
  if (max_scale == 0),
      max_scale = max(hter_all);
  end;
  Make_DET(max_scale);
  title('(d) DET');
end;

if (dodisplay==2),
  %DET curve
  if holdon == 1, hold off; else hold on; end
  plot(ppndf(new_f_I), ppndf(new_f_C), signs{holdon},'linewidth',lwidth(holdon));
  %plot(norminv(new_f_I), norminv(new_f_C), signs{holdon},'linewidth',lwidth(holdon));
  Make_DET;
  title('DET');
end;

if (dodisplay==4),
  [fI,xI] = ksdensity(wolves);
  [fC,xC] = ksdensity(sheep);
  if holdon == 1, hold off; else hold on; end;
  plot(xC, fC,signs{1});
  hold on;
  plot(xI, fI,signs{2});
  ylabel('Density');
  xlabel('Scores');
  title('Density');
end;

if (dodisplay==3),
  %ROC curve
  if holdon == 1, hold off; else hold on; end
  plot(new_f_I, new_f_C, signs{holdon},'linewidth',lwidth(holdon));
  title('ROC');
  ylabel('FRR');
  xlabel('FAR');

end;

if (dodisplay==5),
  if holdon == 1, hold off; else hold on; end
  hold on;
  stem(x(min_index:end),new_f_I(min_index:end));
  stem(x(1:min_index+1),new_f_C(1:min_index+1),'r');
  plot(x,cost(2)*new_f_C,signs{1});
  hold on;
  plot(x,cost(1)*new_f_I,signs{2});
  
  %hter_all = cost(1) * new_f_I + cost(2) * new_f_C;
  %plot(x,hter_all,'m-','linewidth',2);

  xlabel('Scores');
  ylabel('FRR, FAR');
  title('FAR and FRR');
end;

if (dodisplay==6),
  if holdon == 1, hold off; else hold on; end
  hter_all = cost(1) * new_f_I + cost(2) * new_f_C;
  plot(x,hter_all,signs{holdon});
  xlabel('Scores');
  ylabel('WER');
  title('WER');
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% return the computed FAR and FRR for examination
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FAR = new_f_I;
FRR = new_f_C;
