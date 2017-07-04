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

%%

addpath Other_codes/
clear hter_min
%
 %fold = 10;
 %c = cvpartition(labels,  'kfold' , fold);
 %save cvpartition.mat c fold 
 load cvpartition.mat

for i=1 : fold 
   trainIdxs = find(c.training(i));   % find index of training set
   vIdxs  = find(c.test(i)); % find index of test set
   trainMatrix =   Dataset(trainIdxs,:);  % create training set
   vMatrix  =  Dataset(vIdxs,:);  % create test set
   trainLabels = labels(trainIdxs,1);  % create training labels
   vLabels = labels(vIdxs,1);  % create test labels
   [pLabels, scores] = SVM_Hist_Int_Kernel(trainMatrix,trainLabels,vMatrix,1,1024);
    
   hter_min(i) = hter(scores(find(vLabels==0),1),scores(find(vLabels==1),1),[],0);
   f_measure(i) = Evaluate(vLabels,pLabels);

   disp(i)
end
%
mean(hter_min)
mean(f_measure)