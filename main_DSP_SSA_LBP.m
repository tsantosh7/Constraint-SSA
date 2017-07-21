%
clear all
clc
close all

dir_name = pwd;

dir_name = 'C:/Users/Priesh/Dropbox/MDX/PHD/MDX/MDX_01_15/Research/Matlab_12_09_2015/MATLAB/SSCI2017';
addpath C:/Users/Priesh/Dropbox/MDX/PHD/MDX/MDX_01_15/Research/Matlab_12_09_2015/MATLAB/SSCI2017/SSA_Code
addpath C:/Users/Priesh/Dropbox/MDX/PHD/MDX/MDX_01_15/Research/SSCI
addpath C:/Users/Priesh/Dropbox/MDX/PHD/MDX/MDX_01_15/Research/Matlab_12_09_2015/MATLAB/SSCI2017

addpath ('C:/Program Files/MATLAB/R2017a/toolbox/stats/stats')
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

%% Visualise picture for Dataset section

subplot(3,1,1)
plot(Epileptic(1,:),'LineWidth',1);
axis tight;
subplot(3,1,2)
plot(N_Healthy(1,:),'LineWidth',1);
axis tight;
subplot(3,1,3)
plot(F_Healthy(1,:),'LineWidth',1);
ylabel('EEG Amplitude');
xlabel('Time in milli sec');
axis tight;
print -depsc Pictures/dataset.eps
%% Apply LBP - 1D for Freqs and 2D for Time-Freqs

for i = 1:1:length(labels)
% [Dataset_SSA{i}] = get_SSA_Freqs(Dataset(i,:));

[Dataset_SSA_100{i}] = get_SSA_Freqs(Dataset(i,:),100);
[Dataset_SSA_128{i}] = get_SSA_Freqs(Dataset(i,:),128);
[Dataset_SSA_256{i}] = get_SSA_Freqs(Dataset(i,:),256);
[Dataset_SSA_512{i}] = get_SSA_Freqs(Dataset(i,:),512);
[Dataset_SSA_1024{i}] = get_SSA_Freqs(Dataset(i,:),1024);

disp(i);
end
%% Visualise Frequencies
rows =6;
cols = 1;

idx = reshape(1:rows,1,[])';
idx=idx(:);

subplot(rows,cols,idx(1))
plot(Dataset(1,:),'LineWidth',1);axis tight; %axis off;
title('Epileptic EEG')
subplot(rows,cols,idx(2))
plot(Dataset_SSA{1}.Delta,'LineWidth',1);axis tight; %axis off;
title('Delta')
subplot(rows,cols,idx(3))
plot(Dataset_SSA{1}.Theta,'LineWidth',1);axis tight; %axis off;
title('Theta')
subplot(rows,cols,idx(4))
plot(Dataset_SSA{1}.Alpha,'LineWidth',1);axis tight; %axis off;
title('Alpha')
subplot(rows,cols,idx(5))
plot(Dataset_SSA{1}.Beta,'LineWidth',1);axis tight; %axis off;
title('Beta')
subplot(rows,cols,idx(6))
plot(Dataset_SSA{1}.Gamma,'LineWidth',1);axis tight; %axis off;
ylabel('EEG Amplitude');
xlabel('Time in milli sec');
title('Gamma')
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 20 15])
print -depsc Pictures/Freqs.eps


%% Get LBP Histograms
for i = 1:1:length(labels)
[Dataset_LBP_3{i}] = Get_LBP_1D(Dataset_SSA{i},3);
[Dataset_LBP_5{i}] = Get_LBP_1D(Dataset_SSA{i},5);
[Dataset_LBP_7{i}] = Get_LBP_1D(Dataset_SSA{i},7);
[Dataset_LBP_9{i}] = Get_LBP_1D(Dataset_SSA{i},9);
[Dataset_LBP_11{i}] = Get_LBP_1D(Dataset_SSA{i},11);
disp(i)
end

%% Create Datasets

for i = 1:1:length(labels)

    [Dataset_train_3] = Create_Dataset(Dataset_LBP_3,length(labels));
    [Dataset_train_5] = Create_Dataset(Dataset_LBP_5,length(labels));
    [Dataset_train_7] = Create_Dataset(Dataset_LBP_7,length(labels));
    [Dataset_train_9] = Create_Dataset(Dataset_LBP_9,length(labels));
    [Dataset_train_11] = Create_Dataset(Dataset_LBP_11,length(labels));

disp(i)
end



%% 
 fold = 10;
 c = cvpartition(labels,  'kfold' , fold);
 save cvpartition.mat c fold 
load cvpartition.mat

[ result_3 ] = classifier(Dataset_train_3,labels,c,fold);
[ result_5 ] = classifier(Dataset_train_5,labels,c,fold);
[ result_7 ] = classifier(Dataset_train_7,labels,c,fold);
[ result_9 ] = classifier(Dataset_train_9,labels,c,fold);
[ result_11 ] = classifier(Dataset_train_11,labels,c,fold);


%% Print latex source: Copy to Libre Calc merge delimeter & --> Generate table online
clc
types = {'Alpha', 'Beta','Theta','Gamma','Delta','Concat'};
for i= 1:1:6
sprintf('%s & %.2f$//pm$%.2f & %.2f$//pm$%.2f & %.2f$//pm$%.2f & %.2f$//pm$%.2f & %.2f$//pm$%.2f',...
    types{i}, result_3(i,1),result_3(i,2),result_5(i,1),result_5(i,2),...
    result_7(i,1),result_7(i,2), result_9(i,1), result_9(i,2),...
    result_11(i,1),result_11(i,2))
end

% /begin{table}[]
% /centering
% /caption{My caption}
% /label{my-label}
% /begin{tabular}{|l|l|l|l|l|l|}
% /hline
% /textbf{Frequency} & /multicolumn{5}{l|}{/textbf{HTER (mean$/pm$std) reported for various LBP segment lengths}}                        // /hline
%                    & /textbf{3}             & /textbf{5}             & /textbf{7}             & /textbf{9}             & /textbf{11}   // /hline
% /textbf{Alpha}     & 0.31$/pm$0.12          & 0.29$/pm$0.11          & 0.29$/pm$0.11          & 0.29$/pm$0.08          & 0.28$/pm$0.07 // /hline
% /textbf{Beta}      & 0.27$/pm$0.07          & 0.23$/pm$0.05          & 0.21$/pm$0.06          & 0.17$/pm$0.04          & 0.14$/pm$0.05 // /hline
% /textbf{Theta}     & 0.22$/pm$0.10          & 0.21$/pm$0.10          & 0.23$/pm$0.08          & 0.24$/pm$0.09          & 0.23$/pm$0.08 // /hline
% /textbf{Gamma}     & 0.14$/pm$0.09          & 0.17$/pm$0.06          & 0.16$/pm$0.05          & 0.16$/pm$0.05          & 0.09$/pm$0.03 // /hline
% /textbf{Delta}     & 0.15$/pm$0.11          & 0.14$/pm$0.10          & 0.15$/pm$0.11          & 0.14$/pm$0.10          & 0.16$/pm$0.11 // /hline
% /textbf{All}       & /textbf{0.01$/pm$0.03} & /textbf{0.01$/pm$0.03} & /textbf{0.01$/pm$0.03} & /textbf{0.01$/pm$0.03} & 0.02$/pm$0.04 // /hline
% /end{tabular}
% /end{table}
%% Classify raw data as a baseline result;

for i=1 : fold 
   trainIdxs = find(c.training(i));   % find index of training set
   vIdxs  = find(c.test(i)); % find index of test set
   trainMatrix =   Dataset(trainIdxs,:);  % create training set
   vMatrix  =  Dataset(vIdxs,:);  % create test set
   trainLabels = labels(trainIdxs,1);  % create training labels
   vLabels = labels(vIdxs,1);  % create test labels
   
   SVMModel = fitcsvm(trainMatrix,trainLabels,'KernelFunction','RBF',...
    'KernelScale','auto','Prior','empirical', 'BoxConstraint',1);
%      [~,temp] = predict(SVMModel,vMatrix);
     [pred_labels,temp] = predict(SVMModel,vMatrix);

     scores(:,i) = temp(:,1);
     %[X(:,i),Y(:,i),~,AUC(i)] = perfcurve(vLabels,scores(:,i),0);
%      hter_min_raw(i) = hter(scores(find(vLabels==1),i),scores(find(vLabels==0),i),[],0);
       f_measure_raw(i) = Evaluate(vLabels,pred_labels);


   disp(i)
end
% [mean(hter_min_raw) std(hter_min_raw)]
%  0.0200    0.0422
[mean(f_measure_raw), std(f_measure_raw)]
%     0.8733    0.0900


%% Visualize LBP histograms
subplot(3,1,1)
bar(Dataset_train_3.Concat(1:100,:)'); axis tight; title('Epileptic');
subplot(3,1,2)
bar(Dataset_train_3.Concat(101:200,:)'); axis tight; title('Healthy');
subplot(3,1,3)
bar(Dataset_train_3.Concat(201:300,:)'); axis tight; title('Healthy');
xlabel('Alpha, Beta, Theta, Gamma and Delta')
print -depsc Pictures/LBP_histograms.eps

%%

