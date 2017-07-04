%%

clear all
clc
close all
load EEG_data_filter.mat
%%
directory = strcat(pwd,'/Multivariate AFAVA artefact free/');
subjects = dir(directory);
subjectIndex = find([subjects.isdir]);

for iter1 = 1:length(subjectIndex)-2
disp(iter1);
subjectName = subjects(subjectIndex(iter1+2)).name;
% Do stuff
subjectNameIndex = dir(strcat(directory,subjectName));

    for iter2 = 1:1:length(subjectNameIndex)-2
    
        channels = subjectNameIndex(iter2+2).name;
        epochs = dir(strcat(directory,subjectName,'/',channels));
   
        for iter3 = 1:1:length(epochs)-2
            
           temp = load(strcat(directory,subjectName,'/',channels,'/',epochs(iter3+2).name));
           EEG_data{iter1}{iter2}(iter3,:) = temp;
            
        end
        
        
    end


end
%%

labels = [1, -1, 1, -1, -1, 1, -1, 1, 1, -1, 1, 1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, -1 ]';
for electrode = 1:1:16
    EEG_patients{electrode} = [];
    EEG_healthy{electrode} = [];

for i = 2:1:length(labels)
    
    if(labels(i) ==1)
    EEG_patients{electrode} = [EEG_patients{electrode}; (EEG_data{1,i}{1,electrode})];
    else
    EEG_healthy{electrode} = [EEG_healthy{electrode}; (EEG_data{1,i}{1,electrode})];   
    end
    
end
epoch_labels{electrode} = [ones(size(EEG_patients{electrode},1),1); zeros(size(EEG_healthy{electrode},1),1)];
end
%%
for electrode = 1:1:16
    patient_prb{electrode} = [];
    healthy_prb{electrode} = [];
    
for i = 1:1:size(EEG_patients{electrode},1)
      [~,patient_prb{electrode}(i,:)]=Get_Benford_Divergence(EEG_patients{electrode}(i,:));
end


for i = 1:1:size(EEG_healthy{electrode},1)
   [~,healthy_prb{electrode}(i,:)]=Get_Benford_Divergence(EEG_healthy{electrode}(i,:));
end

end
%%
for iterations = 1:1:20 % get the results for 20 cross validation
for electrode = 1:1:16
    Dataset = [];
    lab = [];
Dataset = [patient_prb{electrode}; healthy_prb{electrode}];
lab = epoch_labels{electrode};%[ones(size(patient_prb,1),1); zeros(size(healthy_prb,1),1)];

tic
train = Dataset;
train_labels = lab;
fold = 5;

samplesize = size(train_labels , 1);
c = cvpartition(samplesize,  'kfold' , fold);

for i=1 : fold 
   trainIdxs = find(c.training(i));   % find index of training set
   vIdxs  = find(c.test(i)); % find index of test set
   trainMatrix =   train(trainIdxs,:);  % create training set
   vMatrix  =  train(vIdxs,:);  % create test set
   trainLabels = train_labels(trainIdxs,1);  % create training labels
   vLabels = train_labels(vIdxs,1);  % create test labels
   
   SVMModel = fitcsvm(trainMatrix,trainLabels,'Standardize',true,'KernelFunction','RBF',...
    'KernelScale',1,'Prior','empirical', 'BoxConstraint',0.01);
   [~,scores{electrode}{i}] = predict(SVMModel,vMatrix);
  wer_min{iterations}{electrode}(i) = wer2(scores{electrode}{i}(find(vLabels==1),1),scores{electrode}{i}(find(vLabels==0),1),[],0); %#ok<FNDSB>
end
end
disp(iterations)
end

%%

for iterations = 1:1:20
averages(iterations,:) = cellfun(@mean, wer_min{iterations});
vars(iterations,:)  = cellfun(@var, wer_min{iterations});
end

mean_results = mean(averages);
std_results =  mean(sqrt(vars));

for electrode = 1:1:16
fprintf('%1.4f $\\pm$ %1.4f\n',mean_results(electrode), std_results(electrode))
end

%%
channel_names = struct2cell(dir('/vol/vssp/persmed/Daniel/Multivariate AFAVA artefact free/01'));
close all

subplot(2,1,1)
boxplot(averages)
set(gca,'xtick',1:16, 'xticklabel',channel_names(1,3:end)) 
ylabel('mean WER')
axis tight
subplot(2,1,2)
boxplot(vars)
set(gca,'xtick',1:16, 'xticklabel',channel_names(1,3:end)) 
ylabel('std WER')
axis tight
xlabel('Electrodes')

fname = sprintf('Pictures/nodiff_Benfords_average_std_results_electrodes_all');
pause(1)
print('-depsc',[fname '.eps']);
print('-dpng',[fname '.png']);


%%
Benvalues = [0.3010 0.1760 0.1250 0.0970 0.0790 0.0670 0.0580 0.0510 0.0460];
[~,electrode] = min(mean(averages));
subplot(2,1,1)
boxplot(patient_prb{9})
hold on
plot(Benvalues,'k*','markersize',10)
hold off
axis tight
subplot(2,1,2)
boxplot(healthy_prb{electrode})
hold on
plot(Benvalues,'k*','markersize',10)
legend('Benford''s law')
xlabel('First digits')
ylabel('Probabilities')
hold off
axis tight
fname = sprintf('Pictures/nodiff_Benfords_hist_min_electrode');
pause(1)
print('-depsc',[fname '.eps']);
print('-dpng',[fname '.png']);

