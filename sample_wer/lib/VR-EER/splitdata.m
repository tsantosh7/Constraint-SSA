function [ndata, index] = splitdata(data, ratio);
%ndata is a cell containing n elements where n=length(ratio)
%index is a cell containing n elements with indexes
%pointing to the original data

[n,d] = size(data);
div = ratio / sum(ratio);
for i=1:size(div,2),
    n_div(i)= sum(div(1:i));
end;
n_div = n_div * n;
n_div = [0 n_div] +1;
n_div = round(n_div); %to handle even numbers

n_set = size(n_div,2)-1;

%ind = randperm(n);

for i=1:n_set,
    selected = n_div(i):n_div(i+1)-1;
    
    if nargout >=2,
      index{i} = selected;
    end;
    
    ndata{i} = data(selected, :);
end;