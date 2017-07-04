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

Dataset_ = [Epileptic; N_Healthy; F_Healthy];
labels = [ones(size(Epileptic,1),1); zeros(size(N_Healthy,1),1);zeros(size(F_Healthy,1),1)];

%% Benfords


for i = 1:1:size(Dataset_,1)
      [Dataset_div(i,1),Dataset(i,:)]=Get_Benford_Divergence(Dataset_(i,:));
end


%% Apply LBP - 1D for Freqs and 2D for Time-Freqs
%
%addpath sample_wer
%fold = 10;
%%samplesize = size(labels , 1);
%c = cvpartition(samplesize,  'kfold' , fold);
load cvpartition.mat

for i=1 : fold 
   trainIdxs = find(c.training(i));   % find index of training set
   vIdxs  = find(c.test(i)); % find index of test set
   trainMatrix =   Dataset(trainIdxs,:);  % create training set
   vMatrix  =  Dataset(vIdxs,:);  % create test set
   trainLabels = labels(trainIdxs,1);  % create training labels
   vLabels = labels(vIdxs,1);  % create test labels
   
   %SVMModel = fitcsvm(trainMatrix,trainLabels,'KernelFunction','intersection_kernel',...
           %'Prior','empirical', 'BoxConstraint',Inf);
       
SVMModel = fitcsvm(trainMatrix,trainLabels,'KernelFunction','RBF',...
  'KernelScale','auto','Prior','empirical', 'BoxConstraint',1);
       
     [pLabels,temp] = predict(SVMModel,vMatrix);
     f_measure(i) = Evaluate(vLabels,pLabels);
   disp(i)
end
%
mean(f_measure)