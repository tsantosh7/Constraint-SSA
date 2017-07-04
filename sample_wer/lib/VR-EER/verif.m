function [verif_rate] = verif(wolves, sheep, op)

if (nargin < 3 || isempty(op)),
  op = [0.001, 0.01, 0.1];
end;

[f_I,x_I] = ecdf(wolves);
[f_C,x_C] = ecdf(sheep);
%[length(wolves), length(sheep)]

if length(f_I) <= 2 || length(f_C) <= 2,
  warning('cannot plot continuous cdf with only 2 points in it');
  wer_min=NaN; thrd_min=NaN; x=NaN; FAR=NaN; FRR=NaN;
  return;
end;

%delete non-unique abscissae
%figure(100); clf; hold on;
%plot(x_I,1-f_I,'r--');
%plot(x_C,f_C,'b-');
%[length(f_I) length(f_C)]


index = find(x_I(1:size(x_I,1)-1) - x_I(2:size(x_I,1)) == 0 );
f_I(index) = [];
x_I(index) = [];
index = find(x_C(1:size(x_C,1)-1) - x_C(2:size(x_C,1)) == 0 );
f_C(index) = [];
x_C(index) = [];

%figure(100);
%plot(x_I,1-f_I,'r--','linewidth',2);
%plot(x_C,f_C,'b-','linewidth',2);
%[length(f_I) length(f_C)]
%pause;
%curve fitting:
%sample the function
x = union(x_I, x_C);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get a linear interpolation of FAR and FRR based on sample data x
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (length(x_C) == 1),
	[r,c]=size(x);
	new_f_C = zeros(size(x));cr
	[tmp_, ind] = min(x_C - x);
	new_f_C(ind:r) = ones(r-ind+1,1);
else
	new_f_C = interp1(x_C,f_C,x, 'linear');
end;
new_f_I = interp1(x_I,f_I,x, 'linear');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[new_f_I, new_f_C] = patch_FAR_FRR(new_f_I, new_f_C);
%convert into FAR and FRR
new_f_I= 1-new_f_I;
%no change for new_f_C= new_f_C;

for i=1:numel(op),
  [val, index] = min(abs(new_f_I - op(i)));
  verif_rate(i) = new_f_C(index(1)); %return GAR or 1-FRR
end;  
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% return the computed FAR and FRR for examination
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FAR = new_f_I;
%FRR = new_f_C;

function [new_f_I, new_f_C] = patch_FAR_FRR(new_f_I, new_f_C)
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
