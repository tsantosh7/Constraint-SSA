function [xtest, xtesta1, xtesta2, na, nb] = make_test(expe, n_samples)

dat = [expe.dset{1,1};expe.dset{1,2};expe.dset{2,1};expe.dset{2,2}];

a = [min(dat(:,1)) max(dat(:,1)) min(dat(:,2)) max(dat(:,2))];

[xtesta1,xtesta2]=meshgrid(linspace(a(1),a(2),n_samples), linspace(a(3),a(4),n_samples));
[na,nb]=size(xtesta1);
xtest1=reshape(xtesta1,1,na*nb);
xtest2=reshape(xtesta2,1,na*nb);
xtest=[xtest1;xtest2]';
