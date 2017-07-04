%%
% This tutorial is about biometric performance evaluation
% in a verification scenario.
% Increasingly, this evaluation is also used for open-set identification
%

%% path
addpath ../lib

%%
%d=1; %dev scores
d=1; %eva scores

%load impostor data in NIST format
[expe.dset{d,1}, tmp, expe.label{d,1}, tmp] = load_raw_scores_labels('imp.scores');
%load client data in NIST format
[tmp, expe.dset{d,2}, tmp, expe.label{d,2}] = load_raw_scores_labels('gen.scores');
clear tmp

%% Let's try plotting

chosen =1;
wer(expe.dset{d,1}(:,chosen),expe.dset{d,2}(:,chosen),[],1);
print('-dpng','perf.png');
%% Let's see what options are available
help wer

%% Let's plot the two systems
chosen = 1;
wer(expe.dset{d,1}(:,chosen),expe.dset{d,2}(:,chosen),[],2, [],1);
chosen = 2;
wer(expe.dset{d,1}(:,chosen),expe.dset{d,2}(:,chosen),[],2, [],2);

%% Let's check the distributions
figure;
chosen = 1;
wer(expe.dset{d,1}(:,chosen),expe.dset{d,2}(:,chosen),[],4,[],1);
chosen = 2;
wer(expe.dset{d,1}(:,chosen),expe.dset{d,2}(:,chosen),[],4,[],2);

%% Let's do a scatter plot
clf; hold on;
set(gca, 'fontsize',16);
plot(expe.dset{d,1}(:,1),expe.dset{d,1}(:,2),'ro');
plot(expe.dset{d,2}(:,1),expe.dset{d,2}(:,2),'b+');
xlabel('System 1');
ylabel('System 2');
grid on;

%% boostrapping
n_user_bstrp=30;
n_sample_bstrp = 1;

chosen = 2; %the chosen system, can be 1 or 2 for our example

rad_list = joint_bootstrap(expe, chosen, n_user_bstrp, n_sample_bstrp);

%conf_interval = [5, 50, 95]/100;
conf_interval = [25, 50, 75]/100;
for i=1:size(rad_list,2),
  tmp(:,i) = quantile(rad_list(:,i), conf_interval);
end;

%DET coordinate
figure(1); clf; set(gca,'fontsize',12);
wer(expe.dset{1,1}(:,chosen),expe.dset{1,2}(:,chosen),[],2,[],3);
hold on;
signs = {'r--','r-','r--'};
for c=1:3,
  [nFAR,nFRR] = polar2DET(tmp(c,:));
  plot(nFAR, nFRR,signs{c},'linewidth',2);
end;
%% uncomment the following statements to see all the sampled DET curves
for c=1:size(rad_list,1),
  [nFAR,nFRR] = polar2DET(rad_list(c,:));
  plot(nFAR, nFRR,'b:','linewidth',1);
end;
legend('data', 'confidence', 'median', 'confidence' );

%% polar coordinate
[wer_min, thrd_min, x, FAR, FRR] = wer(expe.dset{1,1}(:,chosen),expe.dset{1,2}(:,chosen));
[deg_list, rad] = DET2polar(FAR,FRR,[],[]);
figure(2);clf; hold on; set(gca,'fontsize',12);
plot(deg_list,rad,'b','linewidth',2);
for c=1:3,
  plot(deg_list,tmp(c,:),signs{c},'linewidth',2);
end;
% uncomment the following statement to see all the sampled DET curves in
% polar coordinates
% plot(deg_list,rad_list,'b:');
legend('data', 'confidence', 'median', 'confidence' );
xlabel('angle (degree)');
ylabel('radius (normal deviates)');

%%
figure;
clf;
chosen =2;
cost=[0.9 0.1];
[wer_min, thrd_min, x, FAR, FRR] = wer(expe.dset{1,1}(:,chosen),expe.dset{1,2}(:,chosen),cost,2);
[hter,far,frr] = hter_apriori(expe.dset{1,1}(:,chosen),expe.dset{1,2}(:,chosen),thrd_min);
hold on;
plot(ppndf(far),ppndf(frr),'ro');
