function [x,margin] = cal_margin(wolves, sheep, cost, dodisplay)
%function [wer_min, thrd_min, x] = wer(wolves, sheep, cost, dodisplay)
%cost(1) : cost of false acceptance
%cost(2) : cost of false rejection

n_hist_wolves = 0;
n_hist_sheep = 0;

if nargin < 3,
  cost = [0.5 0.5];
end;

if nargin < 4,
  dodisplay = 0;
end;

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
x = union(x_I, x_C);
x = unique(x);

new_f_C = interp1(x_C,f_C,x, 'nearest');
new_f_I = interp1(x_I,f_I,x, 'nearest');

%replace NaN with 0 or 1
index_ = isnan(new_f_C);
%plot(x,isnan(new_f_C)); %just to check
end_NAN = find([index_;1] - [1;index_] >= 1) - 1;
start_NAN = find([index_;1] - [1;index_] <= -1);
new_f_C(1:start_NAN)=0;
new_f_C(end_NAN:size(new_f_C,1))=1;

index_ = isnan(new_f_I);
end_NAN = find([index_;1] - [1;index_] >= 1) - 1;
start_NAN = find([index_;1] - [1;index_] <= -1);
new_f_I(1:start_NAN)=0;
new_f_I(end_NAN:size(new_f_C,1))=1;

new_f_I= 1-new_f_I;
new_f_C= new_f_C;

%replace NaN with 0

margin = abs(cost(1)*new_f_C - cost(2)*new_f_I);

%plot ecdf curve
if (dodisplay==1),
	signs = {'b', 'r'};
	subplot(2,1,1);
	hold off;
	plot(x,cost(1)*new_f_C*2,'b');
	hold on;
	plot(x,cost(2)*new_f_I*2,'r--');
	%xlabel('Scores');
	ylabel('FRR, FAR');
	legend('FRR', 'FAR');
	title('(a)');
	subplot(2,1,2);
	hold off;
	plot(x, margin*2,'g--');
	xlabel('Scores');
	ylabel('Margin');
	title('(b)');
end;
