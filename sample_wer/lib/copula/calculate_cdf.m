function orig = calculate_cdf(points)

scores_neg = points.neg{:};
scores_pos = points.pos{:};
scores_both = unique([scores_neg(:); scores_pos(:)]);
orig.x = scores_both;

orig.pos.f = zeros(numel(scores_both),numel(points.pos));
orig.neg.f = zeros(numel(scores_both),numel(points.neg));

for i=1:numel(points.pos),
  %[orig.pos.f{i},orig.pos.x{i}]=ksdensity(points.pos{i},scores_both, 'function','cdf','support','positive');
  [orig.pos.f(:,i)]=ksdensity(points.pos{i},scores_both, 'function','cdf');
  orig.pos.prior(i)=numel(points.pos{i});
end;
for i=1:numel(points.neg),
  %[orig.neg.f{i},orig.neg.x{i}]=ksdensity(points.pos{i},scores_both, 'function','cdf','support','positive');
  [orig.neg.f(:,i)]=ksdensity(points.neg{i},scores_both, 'function','cdf');
  orig.neg.prior(i)=numel(points.neg{i});
end;
orig.pos.prior = orig.pos.prior ./ sum(orig.pos.prior);
orig.neg.prior = orig.neg.prior ./ sum(orig.neg.prior);
