function [com, epc_cost] = fusion_gauss_copula(expe, chosen, copula_, com, draw)

%default config:
n_samples = 11;
epc_range = [0.1 0.9];
gen_k=6;

if (nargin < 2),
  chosen = [1:2];
end;

if nargin<3 || isempty(copula_),
  copula_=[];
end;

if nargin<4 || isempty(com),
  com=[];
end;

if nargin<5,
  draw=0;
end;

%make chosen
for d=1:2,for k=1:7,
    expe.dset{d,k} = expe.dset{d,k}(:,chosen);
end;end;

%standard procedure
data = [expe.dset{1,1}; expe.dset{1,2}; expe.dset{1,3};expe.dset{1,4};expe.dset{1,5};expe.dset{1,6};expe.dset{1,7}]; %random, gen, traced
labels = [ zeros(size(expe.dset{1,1},1),1);ones(size(expe.dset{1,2},1),1)];

%parameter estimation
if ~isempty(copula_),
  for dim =1:length(chosen),
    for k=1:7,
      copula{k}{dim} = copula_{k}{chosen(dim)};
    end;
  end;
else
  d=1;
  for k=1:7,
    [~, copula{k}] = gauss_copula_transform(expe.dset{d,k});
  end;
end;

copula = post_process_copula(expe, copula);

if isempty(com), %estimate mean cov parameter
  for k=1:12,
    [data_] = gauss_copula_transform(expe.dset{d,k},copula{k});
    data_=remove_nan(data_);
    com.mean{k} = mean(data_);
    com.cov{k} = cov(data_);
    %reset the mean and variance to one
    %we need only to model the cov/corr
    %com.mean{k} = ones(size(com.mean{k}));
    %for i=1:length(chosen),
    %  com.cov{k}(i,i)=1;
    %end;
  end;
end;

%inference
for d=1:2,
  for k=1:7,
    for k_=1:7,
      tmp = gauss_copula_transform(expe.dset{d,k}, copula{k_});
      llh{k_} = mvnpdf(tmp,com.mean{k_},com.cov{k_});
      %set undefined llh to small values
      llh{k_}(isnan(llh{k_}))=0.000001 * rand;
    end;
    %com.dset{d,k} = llh{1} ./ (llh{1} + llh{2});%
    %com.dset{d,k} = log(llh{2}) - log( (llh{1} + llh{3})/2 ); %class 2 is positive; 1 and 3 are negative
    
    priors =ones(1,6);
    priors = priors / sum(priors([1:6]));
    sum_= priors(1) * llh{1} + priors(2) * llh{2} + ...
      priors(3) * llh{3} + priors(4) * llh{4} + ...
      priors(5) * llh{5} + priors(6) * llh{6};
    com.dset{d,k} =  log(llh{7}) - log( sum_ );
  
  end;
end;

[com.epc.dev, com.epc.eva, epc_cost]  = epc( ...
  [com.dset{1,1};com.dset{1,3}], com.dset{1,2}, ...
  [com.dset{2,1};com.dset{2,3}], com.dset{2,2}, n_samples,epc_range);

%surface fitting
if ~isempty(find(draw==3, 1)),
  figure(4);clf; set(gca,'fontsize',12);
    [xtesta1,xtesta2]=meshgrid( ...
      linspace(min(data(:,1)), max(data(:,1)), 100), ...
      linspace(min(data(:,2)), max(data(:,2)), 100) );
  [na,nb]=size(xtesta1);
  xtest1=reshape(xtesta1,1,na*nb);
  xtest2=reshape(xtesta2,1,na*nb);
  xtest=[xtest1;xtest2]';

  for k_=1:7,
    llh{k_} = mvnpdf(gauss_copula_transform(xtest, copula{k_}),com.mean{k_},com.cov{k_});
    %set undefined llh to small values
    %min_(k_)=min(llh{k_}(~isnan(llh{k_})))
    %llh{k_}(isnan(llh{k_}))=min_(k_);
    llh{k_}(isnan(llh{k_})) = 0.000001 * rand;
  end;
  
  %ypred = log(llh{2}) -  log( (llh{1} + llh{3})/2);

  priors =ones(1,6);
  priors = priors / sum(priors([1:6]));
    sum_= priors(1) * llh{1} + priors(2) * llh{2} + ...
      priors(3) * llh{3} + priors(4) * llh{4} + ...
      priors(5) * llh{5} + priors(6) * llh{6};
  ypred =  log(llh{7}) - log( sum_ );
  
  ypredmat=reshape(ypred,na,nb);
  figure(10); set(gca,'fontsize',12);
  hold off;
  contourf(xtesta1,xtesta2,ypredmat,10);shading flat;
  %[~,h]=contour(xtesta1,xtesta2,ypredmat,5); %shading flat;
  %set(h,'ShowText','on','TextStep',get(h,'LevelStep')*2)
  hold on;
  
  d=2;
  plot(expe.dset{d,1}(:,1),expe.dset{d,1}(:,2),'r.');
  plot(expe.dset{d,2}(:,1),expe.dset{d,2}(:,2),'b*');
  plot(expe.dset{d,3}(:,1),expe.dset{d,3}(:,2),'gd');
  plot(expe.dset{d,4}(:,1),expe.dset{d,4}(:,2),'m^');
  plot(expe.dset{d,5}(:,1),expe.dset{d,5}(:,2),'yv');
  plot(expe.dset{d,6}(:,1),expe.dset{d,6}(:,2),'rs');
  plot(expe.dset{d,7}(:,1),expe.dset{d,7}(:,2),'kx');
  
  thrd = wer(com.dset{1,1}, com.dset{1,2});
  [cs,h]=contour(xtesta1,xtesta2,ypredmat,[thrd],'k');
  clabel(cs,h);colorbar;

  legend('LLR','zero effort imposture','genuine match','deliberate imposture','location','southwest');
  ylabel('Liveness score');
  xlabel('Matching score');
  axis__=axis;
end;

if any(draw==1)|| any(draw==2),
  for k_=1:7,
    figure(k_);clf;
    hold on; set(gca,'fontsize',12);

    [xtesta1,xtesta2]=meshgrid( ...
      linspace(min(data(:,1)), max(data(:,1)), 100), ...
      linspace(min(data(:,2)), max(data(:,2)), 100) );
    [na,nb]=size(xtesta1);
    xtest1=reshape(xtesta1,1,na*nb);
    xtest2=reshape(xtesta2,1,na*nb);
    xtest=[xtest1;xtest2]';

    llh{k_} = mvnpdf(gauss_copula_transform(xtest, copula{k_}),com.mean{k_},com.cov{k_})
    %llh{k_} = mvnpdf(gauss_copula_transform(xtest, copula{k_}),com.mean{k_},[1 0; 0 1]);
    %set undefined llh to small values
    llh{k_}(isnan(llh{k_}))=0.000001 * rand;

    ypred = llh{k_}; %log(llh{2})-log(llh{1});
    ypredmat=reshape(ypred,na,nb);
    
    d=1;
    %draw_empiric(expe.dset{d,1},expe.dset{d,2});
    %plot(expe.dset{d,k_}(:,1),expe.dset{d,k_}(:,2),'m.');
    scatterhist(expe.dset{d,k_}(:,1),expe.dset{d,k_}(:,2),'marker','.');
    
    %[~,h]=contourf(xtesta1,xtesta2,ypredmat,10);shading flat;
    hold on;
    [~,h]=contour(xtesta1,xtesta2,ypredmat,5);shading flat;
    set(h,'ShowText','on','TextStep',get(h,'LevelStep')*2);%,'Linewidth',2)
    
    
    %axis tight; 
    %colorbar;
    ylabel('Liveness score');
    xlabel('Matching score');
    axis(axis__);
  end;
end;

com.copula=copula;