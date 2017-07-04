function [bayesS,f,x] = ksdensity_gmm(data)
FJ_params = { 'Cmax', 5, 'Cmin', 2, 'thr', 1e-2, 'animate', 0, 'verbose', 1, 'covtype',0};
labels = ones(size(data,1),1);
bayesS = gmmb_create(data, labels, 'FJ', FJ_params{:});
if (nargout >1),
    x=sort(data);   
    c=1;
    f = gmmb_pdf(x, bayesS(c).mu, bayesS(c).sigma, bayesS(c).weight );
end;