function F = my_ecdf(x, x_pts)

% x_pts must be non-decreasing

[f_C,x_C] = ecdf(x);
index = find(x_C(1:size(x_C,1)-1) - x_C(2:size(x_C,1)) == 0 );
f_C(index) = [];
x_C(index) = [];
[index1]=isnan(f_C);
[index2]=isinf(f_C);
[index3]=isnan(x_C);
[index4]=isinf(x_C);
index=index1 | index2 | index3 | index4;
f_C(index) = [];
x_C(index) = [];

new_f_C = interp1(x_C,f_C,x_pts, 'linear');

index_ = isnan(new_f_C);
end_NAN = find([index_;1] - [1;index_] >= 1);
start_NAN = find([index_;1] - [1;index_] <= -1)-1;

%sometimes the first element is not zero!
if (start_NAN == 1),
else
  new_f_C(1:start_NAN)=0;
end;
%the end element is always 1!
new_f_C(end_NAN:size(new_f_C,1))=1;

F = new_f_C;