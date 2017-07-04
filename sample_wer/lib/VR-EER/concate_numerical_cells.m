function n_list = concate_numerical_cells(list)
%this function concatenate columns
%row in each element of 'list' must be fixed

n_elems = zeros(1,length(list));
for i=1:length(list),
  n_elems(i) = size(list{i},2);
end;
n_rows = size(list{1},1);
n_list = zeros(n_rows,sum(n_elems));
upto=1;
for i=1:length(list),
  n_list(:,upto:upto+n_elems(i)-1)=list{i};
  upto = upto+n_elems(i);
end;