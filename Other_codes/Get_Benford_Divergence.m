function [div,prb]=Get_Benford_Divergence(EEG_Data)
jj = diff(EEG_Data);
img_coef63 = abs(jj);

for ii=1:numel(img_coef63)
    while (img_coef63(ii)>=10)||((img_coef63(ii)<1)&&(img_coef63(ii)~=0))
        if img_coef63(ii)>=10
            img_coef63(ii)=img_coef63(ii)/10;
        end
        if img_coef63(ii)<1
            img_coef63(ii)=img_coef63(ii)*10;
        end    
    end
end

for iji=1:9
    prb(iji)=(numel(find(floor(img_coef63)==iji)))/(nnz(img_coef63));
end

Benvalues = [0.3010 0.1760 0.1250 0.0970 0.0790 0.0670 0.0580 0.0510 0.0460];
div = ((prb - Benvalues).^2)/Benvalues;
  
% plot (Benvalues, 'b'); hold on;
% plot (prb, 'r')
%  xlabel('First Digit');
%  ylabel('Probability');legend('Standard Benford''s law','Actual distribution');


