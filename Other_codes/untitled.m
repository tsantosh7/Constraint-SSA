%% Visualise SSA frequencies

idx = reshape(1:18,3,[])';
idx=idx(:);
subplot(6,3,idx(1))
plot(Dataset(1,:),'LineWidth',1);axis tight; axis off;
subplot(6,3,idx(2))
plot(Dataset_SSA{1}.Delta,'LineWidth',1);axis tight; axis off;
subplot(6,3,idx(3))
plot(Dataset_SSA{1}.Theta,'LineWidth',1);axis tight; axis off;
subplot(6,3,idx(4))
plot(Dataset_SSA{1}.Alpha,'LineWidth',1);axis tight; axis off;
subplot(6,3,idx(5))
plot(Dataset_SSA{1}.Beta,'LineWidth',1);axis tight; axis off;
subplot(6,3,idx(6))
plot(Dataset_SSA{1}.Gamma,'LineWidth',1);axis tight; axis off;

subplot(6,3,idx(7))
plot(Dataset(102,:),'LineWidth',1);axis tight; axis off;
subplot(6,3,idx(8))
plot(Dataset_SSA{102}.Delta,'LineWidth',1);axis tight; axis off;
subplot(6,3,idx(9))
plot(Dataset_SSA{102}.Theta,'LineWidth',1);axis tight; axis off;
subplot(6,3,idx(10))
plot(Dataset_SSA{102}.Alpha,'LineWidth',1);axis tight; axis off;
subplot(6,3,idx(11))
plot(Dataset_SSA{102}.Beta,'LineWidth',1);axis tight; axis off;
subplot(6,3,idx(12))
plot(Dataset_SSA{102}.Gamma,'LineWidth',1);axis tight; axis off;

subplot(6,3,idx(13))
plot(Dataset(201,:),'LineWidth',1);axis tight; axis off;
subplot(6,3,idx(14))
plot(Dataset_SSA{201}.Delta,'LineWidth',1);axis tight; axis off;
subplot(6,3,idx(15))
plot(Dataset_SSA{201}.Theta,'LineWidth',1);axis tight; axis off;
subplot(6,3,idx(16))
plot(Dataset_SSA{201}.Alpha,'LineWidth',1);axis tight; axis off;
subplot(6,3,idx(17))
plot(Dataset_SSA{201}.Beta,'LineWidth',1);axis tight; axis off;
subplot(6,3,idx(18))
plot(Dataset_SSA{201}.Gamma,'LineWidth',1);axis tight; axis off;

tightfig;
%
print -depsc Pictures/Freqs.eps


seg = [3,5,7,9,11];
for i =1:1:length(seg)
for j = 1:1:300
sprintf('Dataset_train_%d_Alpha(%d,:)',seg(i),j) = ...
    eval(sprintf('Dataset_LBP_%d{%d}.Alpha',seg(i),j));

eval(sprintf('Dataset_train_%d_Beta(%d,:)',seg(i),j)) = ...
    eval(sprintf('Dataset_LBP_%d{%d}.Beta',seg(i),j));

eval(sprintf('Dataset_train_%d_Gamma(%d,:)',seg(i),j)) = ...
    eval(sprintf('Dataset_LBP_%d{%d}.Gamma',seg(i),j));

eval(sprintf('Dataset_train_%d_Theta(%d,:)',seg(i),j)) = ...
    eval(sprintf('Dataset_LBP_%d{%d}.Theta',seg(i),j));

eval(sprintf('Dataset_train_%d_Delta(%d,:)',seg(i),j)) = ...
    eval(sprintf('Dataset_LBP_%d{%d}.Delta',seg(i),j));


eval(sprintf('Dataset_train_%d_Concat(%d,:)',seg(i),j)) = ...
    eval(sprintf('Dataset_LBP_%d{%d}.Concat',seg(i),j));
end
end