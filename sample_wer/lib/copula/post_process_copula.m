function copula = post_process_copula(expe, copula, debug)
if nargin<3,
  debug = 0;
end;
min_ = min([expe.dset{1,1};expe.dset{1,2}]);
max_ = max([expe.dset{1,1};expe.dset{1,2}]);
for dim=1:size(expe.dset{1,1},2),
  
  %if debug,
    figure(100);clf;
    signs_={'r.','bo','gx'};
    for k=1:3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ,
      %subplot(2,2,k);
      data = linspace(min_(dim), max_(dim),100);
      copula_{1} = copula{k}{dim};
      llk = gauss_copula_transform(data', copula_);
      %plot(copula{dim}{k}.x, copula{dim}{k}.ecdf,'.')
      subplot(2,2,1);hold on;
      plot(data, llk,signs_{k})
      subplot(2,2,2);hold on;
      plot(copula_{1}.x, copula_{1}.ecdf,signs_{k})
    end;
    subplot(2,2,2);
    axis_ = axis;
    x_range{dim}=axis_(1:2);
  %end;
  
  for k=1:3,
    copula{k}{dim}.ecdf = [0+realmin;copula{k}{dim}.ecdf;1-realmin];
    copula{k}{dim}.x = [x_range{dim}(1);copula{k}{dim}.x;x_range{dim}(2)];
  end;

end;
signs_={'r.','bo','gx'};
if debug,
  for dim=1:size(expe.dset{1,1},2),
    figure(100+dim);clf;
    for k=1:3,
      %subplot(2,2,k);
      data = linspace(min_(dim), max_(dim),100);
      copula_{1} = copula{k}{dim};
      llk = gauss_copula_transform(data', copula_);
      %plot(copula{dim}{k}.x, copula{dim}{k}.ecdf,'.')
      subplot(2,2,1);hold on;
      plot(data, llk,signs_{k})
      subplot(2,2,2);hold on;
      plot(copula_{1}.x, copula_{1}.ecdf,signs_{k})
    end;
  end;
end;