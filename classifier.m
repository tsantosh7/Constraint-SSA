function [ result ] = classifier(Dataset_train,labels,c,fold)

types = {'Alpha', 'Beta','Theta','Gamma','Delta','Concat'};
train = struct2cell(Dataset_train);
    
for k = 1:1:length(types)
for i=1:1:fold 
   %scores  =[];
   trainIdxs = find(c.training(i));   % find index of training set
   vIdxs  = find(c.test(i)); % find index of test set
   trainMatrix =   train{k}(trainIdxs,:);  % create training set
   vMatrix  =  train{k}(vIdxs,:);  % create test set
   trainLabels = labels(trainIdxs,1);  % create training labels
   vLabels = labels(vIdxs,1);  % create test labels
   
   %SVMModel = fitcsvm(trainMatrix,trainLabels,'Standardize',true,'KernelFunction','RBF',...
   % 'KernelScale','auto','Prior','empirical', 'BoxConstraint',Inf);
   SVMModel = fitcsvm(trainMatrix,trainLabels,'KernelFunction','RBF',...
    'KernelScale','auto','Prior','empirical', 'BoxConstraint',1);
     [pred_labels,temp] = predict(SVMModel,vMatrix);
     scores(:,i) = temp(:,1);
     %[X{i},Y{i},~,AUC(i)] = perfcurve(vLabels,scores(:,i),0);
     hter_min(i) = hter(scores(find(vLabels==1),i),scores(find(vLabels==0),i),[],0); %#ok<FNDSB>
     %f_measure(i) = Evaluate(vLabels,pred_labels);
   disp(i)
end

%result(k,:) = [mean(f_measure), std(f_measure)];
result(k,:) = [mean(hter_min), std(hter_min)];

end

end

