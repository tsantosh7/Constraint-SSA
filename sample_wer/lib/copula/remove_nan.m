function matrix = remove_nan(matrix)

tmp = logical(zeros(size(matrix,1),1));
for i=1:size(matrix,2),
  tmp = tmp | isnan(matrix(:,i));
end;
matrix(tmp,:)=[];