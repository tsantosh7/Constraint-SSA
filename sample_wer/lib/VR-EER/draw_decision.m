function draw_decision(expe, n_samples)

ypred = 
ypredmat=reshape(ypred,na,nb);

[xtesta1,xtesta2]=meshgrid([-4:1:4],[-4:1:4]);
[na,nb]=size(xtesta1);
xtest1=reshape(xtesta1,1,na*nb);
xtest2=reshape(xtesta2,1,na*nb);
xtest=[xtest1;xtest2]';
ypred = 
ypredmat=reshape(ypred,na,nb);
