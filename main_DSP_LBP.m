%
clear all
clc
close all

dir_name = pwd;
addpath /home/synoptica/Surrey/Sailendra_SSCI/SSA_Code
%% load Epileptic data
Epileptic_dir = fullfile(dir_name,'S_Epeleptic/');
folder = dir(Epileptic_dir);
for i = 1:1:length(folder)-2
    temp = strcat(Epileptic_dir,sprintf('S%03d.txt',i));
    Epileptic(i,:) = load(temp)'; 
    clear temp;
end

%% load Healthy data
Healthy_dir = fullfile(dir_name,'N_Healthy/');
folder = dir(Healthy_dir);
for i = 1:1:length(folder)-2
    temp = strcat(Healthy_dir,sprintf('N%03d.TXT',i));
    N_Healthy(i,:) = load(temp)'; 
    clear temp;
end
%% load Healthy data
Healthy_dir = fullfile(dir_name,'F_Healthy/');
folder = dir(Healthy_dir);
for i = 1:1:length(folder)-2
    temp = strcat(Healthy_dir,sprintf('F%03d.txt',i));
    F_Healthy(i,:) = load(temp)'; 
    clear temp;
end

%% Create Dataset

Dataset = [Epileptic; N_Healthy; F_Healthy];
labels = [ones(size(Epileptic,1),1); zeros(size(N_Healthy,1),1);zeros(size(F_Healthy,1),1)];

%% Apply LBP - 1D for Freqs and 2D for Time-Freqs
%
addpath sample_wer
fold = 4;
%samplesize = size(labels , 1);
c = cvpartition(labels,  'kfold' , fold);
%load cvpartition.mat

segsize = [3,5,7,9,11];
for k = 1:1:length(segsize) 
    scores = [];
    Dataset_LBP = [];
    
for i = 1:1:length(labels)
[Dataset_LBP(i,:),~] = onedlbp(Dataset(i,:),segsize(k));
%disp(i);
end

for i=1 : fold 
   trainIdxs = find(c.training(i));   % find index of training set
   vIdxs  = find(c.test(i)); % find index of test set
   trainMatrix =   Dataset_LBP(trainIdxs,:);  % create training set
   vMatrix  =  Dataset_LBP(vIdxs,:);  % create test set
   trainLabels = labels(trainIdxs,1);  % create training labels
   vLabels = labels(vIdxs,1);  % create test labels
   
   SVMModel = fitcsvm(trainMatrix,trainLabels,'KernelFunction','RBF',...
    'KernelScale','auto','Prior','empirical', 'BoxConstraint',1);
     %  SVMModel = fitcsvm(trainMatrix,trainLabels,'KernelFunction','intersection_kernel',...
      %     'Prior', 'empirical', 'BoxConstraint',1,'Standardize',true);
     [pLabels,temp] = predict(SVMModel,vMatrix);
     scores(:,i) = temp(:,1);
     %[X(:,i),Y(:,i),~,AUC(i)] = perfcurve(vLabels,scores(:,i),0);
     hter_min{k}(i) = hter(scores(find(vLabels==1),i),scores(find(vLabels==0),i),[],0);
     f_measure{k}(i) = Evaluate(vLabels,pLabels);

   disp(i)
end
end
%
%mean(AUC)
Meanz = cellfun(@mean,hter_min,'UniformOutput',false);
Stdz = cellfun(@std,hter_min,'UniformOutput',false);
[cell2mat(Meanz)' cell2mat(Stdz)']'

Meanz = cellfun(@mean,f_measure,'UniformOutput',false);
Stdz = cellfun(@std,f_measure,'UniformOutput',false);
[cell2mat(Meanz)' cell2mat(Stdz)']'




%0.0300    0.0200    0.0100    0.0100    0.0100
%0.0483    0.0422    0.0316    0.0316    0.0316
%%
% for i =1:1:5
% hold on
% plot(X(:,1),Y(:,1))
% hold off
% end

%%
Dataset_LBP = [];
for k = 1:1:length(labels)
[Dataset_LBP(k,:)] = [onedlbp(Dataset(k,:),3); onedlbp(Dataset(k,:),5)]';
  
end

for i=1 : fold 
   trainIdxs = find(c.training(i));   % find index of training set
   vIdxs  = find(c.test(i)); % find index of test set
   trainMatrix =   Dataset_LBP(trainIdxs,:);  % create training set
   vMatrix  =  Dataset_LBP(vIdxs,:);  % create test set
   trainLabels = labels(trainIdxs,1);  % create training labels
   vLabels = labels(vIdxs,1);  % create test labels
   
   SVMModel = fitcsvm(trainMatrix,trainLabels,'KernelFunction','RBF',...
    'KernelScale','auto','Prior','empirical', 'BoxConstraint',10);
     %  SVMModel = fitcsvm(trainMatrix,trainLabels,'KernelFunction','intersection_kernel',...
       %    'Prior', 'empirical', 'BoxConstraint',1,'Standardize',true);
     [pLabels,temp] = predict(SVMModel,vMatrix);
     scores(:,i) = temp(:,1);
     %[X(:,i),Y(:,i),~,AUC(i)] = perfcurve(vLabels,scores(:,i),0);
     hter_min_multi(i) = hter(scores(find(vLabels==1),i),scores(find(vLabels==0),i),[],0);
     f_measure_multi(i) = Evaluate(vLabels,pLabels);

   disp(i)
end

%
mean(hter_min_multi)
mean(f_measure_multi)
