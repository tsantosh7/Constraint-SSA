function y = sigmoid_inv(x, alpha,bias)
%tanh_inv prodcues an inverse function of sigmoid
% sigmoid is:
% sigmoid(z) = 1 / (1 + exp(-a(z-b))) 
%tanh_inv(z) = -log(t)/a+b
% where
% t = 1 ./ (x - 1)
% a is alpha
% b is bias
%if alpha not specified, alpha = 1
%if beta not specified, bias = 0
x = max(x, 0+eps);
x = min(x, 1-eps);

if (nargin < 2),
    alpha = 1;
end;
if (nargin < 3),
    bias = 0;
end;
y = -log( 1 ./ x -1 ) /alpha + bias;

%y = max(y, -18);
%y = min(y, 18); 

%map = zeros(n_samples,2);
%map(:,1) = linspace(range(1),range(2),n_samples)';
%sigmoid function with output range between -1 and 1
%map(:,2) = 1./(1+exp(alpha * map(:,1) ).^(-1)) * 2 -1;
%plot( map(:,2), -log( 2 ./ (map(:,2) +1)-1 ) /alpha);
