%%
clear all
clc
close all
%load workspace_oliver.mat
%load RSVP_mary_data_shuffle.mat
load workspace_alaleh.mat
%% 
% select the electrode 
g = 33; % select the electrode
tt = buffer(traint(:,g),1100)'; % extract Alpha, Beta, Gamma, Delta, Theta
tnt = buffer(trainnt(:,g),1100)';
tet = buffer(testt(:,g),1100)';
tent = buffer(testnt(:,g),1100)';
dt = buffer(valt(:,g),1100)';
dnt = buffer(valnt(:,g),1100)';
%%

Data_pos = [tt; dt;tet];
lab_pos = ones(size(Data_pos,1),1);
Data_neg =  [tnt; dnt; tent];
lab_neg = zeros(size(Data_neg,1),1);

Dataset = [Data_pos;Data_neg];
labels = [lab_pos;lab_neg];
%%
addpath /vol/vssp/persmed/Daniel/
segsize = 10;
 
for i = 1:1:length(labels)
[~,Dataset_Benfords(i,:)] = Get_Benford_Divergence(Dataset(:,i)); %  onedlbp(Dataset(i,:),segsize);
disp(i);
end

%%
% for i = 1:1:length(labels)
% [Dataset_SSA{i}] = get_SSA_Freqs(Dataset(i,:));
% disp(i);
% end
% 
% %%
% segsize = 7;
% for i = 1:1:length(labels)
% [Dataset_LBP(i,:)] = Get_LBP_1D(Dataset_SSA{i},segsize);
% disp(i)
% end

%% 
fold = 10;
samplesize = size(labels , 1);
c = cvpartition(samplesize,  'kfold' , fold);

for i=1 : fold 
  scores  =[];
   trainIdxs = find(c.training(i));   % find index of training set
   vIdxs  = find(c.test(i)); % find index of test set
   trainMatrix =   Dataset_Benfords(trainIdxs,:);  % create training set
   vMatrix  =  Dataset_Benfords(vIdxs,:);  % create test set
   trainLabels = labels(trainIdxs,1);  % create training labels
   vLabels = labels(vIdxs,1);  % create test labels
   
   SVMModel = fitcsvm(trainMatrix,trainLabels,'Standardize',true,'KernelFunction','RBF',...
    'KernelScale','auto','Prior','empirical', 'BoxConstraint',Inf);
     [~,temp] = predict(SVMModel,vMatrix);
     scores(:,i) = temp(:,1);
     [X{i},Y{i},~,AUC(i)] = perfcurve(vLabels,scores(:,i),0);
   disp(i)
end

mean(AUC)

%%
Benvalues = [0.3010 0.1760 0.1250 0.0970 0.0790 0.0670 0.0580 0.0510 0.0460];
subplot(2,1,1)
boxplot(vMatrix(find(vLabels==1),:))
hold on
plot(Benvalues,'k*','markersize',10)
hold off
axis tight
subplot(2,1,2)
boxplot(vMatrix(find(vLabels==0),:))
hold on
plot(Benvalues,'k*','markersize',10)
legend('Benford''s law')
xlabel('First digits')
ylabel('Probabilities')
hold off
axis tight
% fname = sprintf('Pictures/nodiff_Benfords_hist_min_electrode');
% pause(1)
% print('-depsc',[fname '.eps']);
% print('-dpng',[fname '.png']);


%% 
