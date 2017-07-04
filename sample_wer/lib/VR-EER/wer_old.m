function [wer_min, thrd_min, x, FAR, FRR] = wer(wolves, sheep, cost, dodisplay,max_scale,holdon)
%function [wer_min, thrd_min, x] = wer(wolves, sheep, cost, dodisplay,max_scale,holdon)
%cost(1) : cost of false acceptance
%cost(2) : cost of false rejection
%dodisplay = 
% 1: all four
% 2: DET
% 3: ROC
% 4: Density vs score
% 5: FAR, FRR vs thrd
% 6: WER vs thrd
n_hist_wolves = 0;
n_hist_sheep = 0;

if (nargin < 3 | length(cost)==0),
  cost = [0.5 0.5];
end;

if (nargin < 4 | dodisplay ==0),
  dodisplay = 0;
end

if (nargin < 5 | length(max_scale)==0),
    max_scale = 0; %decided by the data itself
end;

if nargin < 6,
  holdon = 1;
end

%if ( prod(size(find(wolves == -1000))) ~= 0 ),
%  fprintf(1, 'WARNING: there are outliers in wolves\n');
%end;
%if ( prod(size(find(sheep == -1000))) ~= 0 ),
%  fprintf(1, 'WARNING: there are outliers in sheep\n');
%end;
%
%wolves( find(wolves== -1000) ) = [];
%sheep( find(sheep== -1000) ) = [];


[f_I,x_I] = ecdf(wolves);
[f_C,x_C] = ecdf(sheep);

%delete non-unique abscissae
index = find(x_I(1:size(x_I,1)-1) - x_I(2:size(x_I,1)) == 0 );
f_I(index) = [];
x_I(index) = [];
index = find(x_C(1:size(x_C,1)-1) - x_C(2:size(x_C,1)) == 0 );
f_C(index) = [];
x_C(index) = [];

%curve fitting:
%sample the function
x = union(x_I, x_C);


%this also works but too slow
%for i=1:size(x,1), %thrd
%  index = find(x_C >=  x(i));
%  if (size(index,1) == 0)
%    new_f_C(i) = 1;
%  else
%    new_f_C(i) = f_C(index(1));
%  end;
%
%  index = find(x_I >=  x(i));
%  if (size(index,1) == 0)
%    new_f_I(i) = 1;
%  else
%  new_f_I(i) = f_I(index(1));
%  end;
%end;

%hold off;
%plot(x_I,f_I,'b');
%hold on;; 
%plot(x_C,f_C,'r');
%plot(x,new_f_I, 'b:');
%plot(x,new_f_C, 'r:');

if (length(x_C) == 1),
	[r,c]=size(x);
	new_f_C = zeros(size(x));
	[tmp_, ind] = min(x_C - x);
	new_f_C(ind:r) = ones(r-ind+1,1);
else
	new_f_C = interp1(x_C,f_C,x, 'linear');
end;
new_f_I = interp1(x_I,f_I,x, 'linear');

% OR the following one but is too noisy!
%new_f_C = spline(x_C,[0;f_C;1],x);
%new_f_I = spline(x_I,[0;f_I;1],x);

if (1),
    %replace NaN with 0 or 1
    index_ = isnan(new_f_C);
    %plot(x,isnan(new_f_C)); %just to check
    end_NAN = find([index_;1] - [1;index_] >= 1) - 1;
    start_NAN = find([index_;1] - [1;index_] <= -1);

    %figure(2);
    %plot(x,new_f_C); %just to check
    %hold on;
    %plot(x,new_f_I, 'r'); %just to check
    %pause;

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
    
    %figure(3);hold off;
    %plot(x,new_f_C); %just to check
    %hold on;
    %plot(x,1-new_f_I, 'r'); %just to check
    %pause;
    
    %figure(1);
end;

%convert into FAR and FRR
new_f_I= 1-new_f_I;
%no change for new_f_C= new_f_C;

[min_value, min_index] = min( abs(cost(1) * new_f_I - cost(2) * new_f_C) );

thrd_min = x(min_index);
wer_min = cost(1) * new_f_I(min_index) + cost(2) * new_f_C(min_index);

%if holdon == 0,
%  signs = {'b', 'r'};
%elseif holdon == 1,
%  signs = {'b--', 'r--'};
%else
style = {'-','--'};%,':'};
color = {'b', 'g', 'r', 'k'};%, 'm', 'y', 'k'};
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
%lwidth = repmat([1 1 1 1 2 2 2 2],1,4);
%signs=  {signs{:}, 'b--', 'g--', 'r--', 'c--', 'm--', 'y--', 'k--'};    
%signs=  {signs{:}, 'b-.', 'g-.', 'r-.', 'c-.', 'm-.', 'y-.', 'k-.'};    
%signs=  {signs{:}, 'b:', 'g:', 'r:', 'c:', 'm:', 'y:', 'k:'};    
%end;

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

  %roc curve
  subplot(2,2,4);
  if holdon == 1, hold off; else hold on; end
  %plot(cost(1) * new_f_I, cost(2) * new_f_C,signs{1});
  %plot(new_f_I, new_f_C, signs{1});
  %xlabel('FAR');
  %ylabel('FRR');
  %title('(d) ROC');

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
  plot(new_f_I, new_f_C, signs{1});
  title('ROC');
  ylabel('FRR');
  xlabel('FAR');

end;

if (dodisplay==5),
  if holdon == 1, hold off; else hold on; end
  plot(x,cost(2)*new_f_C,signs{1});
  hold on;
  plot(x,cost(1)*new_f_I,signs{2});
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

FAR = new_f_I;
FRR = new_f_C;
