function quantil_val = quantil(data,quantil_list)
% quantil_val = quantil(data,quantil_list)
% data is a matrix
% quantil_list is for example [25 75]
if nargin < 2,
  quantil_list = [25 75];
end;
for i=1:size(data,2),
  col = data(:,i);
  col(find(isnan(col)))=[]; %ignore NaN
  sorted = sort(col);
  for q=1:length(quantil_list),
    pos = quantil_list(q)/100 * length(sorted);
    if (ceil(pos) ~= floor(pos)),
        if (floor(pos)==0),
            quantil_val(q,i) = sorted(1);
        else
        alpha = pos-floor(pos)/(ceil(pos) - floor(pos));
        quantil_val(q,i) = alpha * sorted(floor(pos)) + (1-alpha) * sorted(ceil(pos));
        end;
    else
      quantil_val(q,i) = sorted(pos);
    end;
  end;
end;

