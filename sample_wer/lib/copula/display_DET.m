function display_DET(com)
set(gca,'fontsize',12);
plot(ppndf(1-com.neg.f), ppndf(com.pos.f));
Make_DET;
xlabel('FAR(%)');
ylabel('FRR(%)');
