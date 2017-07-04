function [K] = intersection_kernel(xi,xj)
K = sum(bsxfun(@min,permute(xi,[1 3 2]),permute(xj,[3 1 2])),3);


end

