function [y1] = get_SSA_EEG(X, lower_limit, upper_limit)
L=length(X);
[E,V,A,R,C]=ssa(X,100);
m=1e1000;
index=0;
index1=0;
y1=0;
Fs = 256;
for i=3:50
    diff=abs(V(i)-V(i+1));
    %if (diff<m & V(i)>0.001*V(1) & diff<0.05*V(1));
    a=i;
    b=i+1;
    y=R(:,i);
    [maxValue,indexMax] = max(abs(fft(y-mean(y))));
    L=length(X);
    frequency = indexMax* Fs / L;
    if frequency>=lower_limit && frequency <=upper_limit;
        m=diff;
        index=i;index1=i+1;
        y1=y1+ y;%+ (R(:,a)+R(:,b));
    end
end