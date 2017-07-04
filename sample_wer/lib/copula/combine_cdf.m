function com = combine_cdf(orig, prior_pos, prior_neg)

if nargin>=3,
  com.pos.prior = prior_pos;
  com.neg.prior = prior_neg;
end;

com.pos.prior = com.pos.prior ./ sum(com.pos.prior);
com.neg.prior = com.neg.prior ./ sum(com.neg.prior);

com.pos.f= orig.pos.f * com.pos.prior';
com.neg.f= orig.neg.f * com.neg.prior';
com.x= orig.x;
