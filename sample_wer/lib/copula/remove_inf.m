function matrix = remove_inf(matrix)

tmp = logical(zeros(size(matrix,1),1));
for i=1:size(matrix,2),
  tmp = tmp | isinf(matrix(:,i));
end;
matrix(tmp,:)=[];