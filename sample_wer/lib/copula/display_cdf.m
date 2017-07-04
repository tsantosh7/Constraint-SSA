function display_cdf(orig, leg_txt)

clf; hold all;
set(gca,'fontsize',12);
for i=1:size(orig.pos.f,2),
  plot(orig.x,orig.pos.f(:,i));
end
for i=1:size(orig.neg.f,2),
  plot(orig.x,1-orig.neg.f(:,i));
end
xlabel('scores');
ylabel('cdf');
legend(leg_txt);
