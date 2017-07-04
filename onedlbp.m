function [hist,codes]=onedlbp(data,segsize)
    hist=zeros(2^(segsize-1),1);
    codes=zeros(length(data)-segsize+1,1);
    
    for i=1:length(data)-segsize+1
        x=data(i:i+segsize-1);
        c=lbpcode(x);
        hist(c+1)=hist(c+1)+1;
        codes(i)=c;
    end

