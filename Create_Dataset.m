function [Dataset_train] = Create_Dataset(Dataset_LBP,total)

for i = 1:1:total
Dataset_train.Alpha(i,:) = Dataset_LBP{i}.Alpha;   
Dataset_train.Beta(i,:) = Dataset_LBP{i}.Beta; 
Dataset_train.Theta(i,:) = Dataset_LBP{i}.Theta; 
Dataset_train.Gamma(i,:) = Dataset_LBP{i}.Gamma; 
Dataset_train.Delta(i,:) = Dataset_LBP{i}.Delta; 
Dataset_train.Concat(i,:) = Dataset_LBP{i}.Concat; 
end


end

