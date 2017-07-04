function c=lbpcode(x)
    l=ceil(length(x)/2);
    c=0;
    for i=1:l-1
       c=c+signc(x(i)-x(l))*2^(i-1)+signc(x(i+l)-x(l))*2^(i+l-2);
    end

function x=signc(x)
    if(x>=0)
        x=1;
    else
        x=0;
    end
