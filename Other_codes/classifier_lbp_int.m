function [pred_labels, scores] = classifier_lbp_int(X,Y,X_d,C)

his  = zscore(X);
%his_d  = zscore(X_d); 

 for it  = 1:1:size(X,1)
     for jit  =  1:1:size(X,1)
       K(it,jit) = sum(min([hist(his(it,:));hist(his(jit,:))]));
     end
 end

%a = size(X,1);
%for i = 1:size(X,1)
%Va = repmat(his(i,:),a,1);
%K(i,:) = sum(min(Va,his),2)';
%end

 %K = squeeze(sum(bsxfun(@min,his,permute(his,[3 2 1])),2));
 
 %%
 %his = X;
 %his  = zscore(X);
 %K = sum(bsxfun(@min,permute(his,[1 3 2]),permute(his,[3 1 2])),3);
 C = 10;
   Y(Y==0)=-1;
    Ki = [];
    clear res
    H = (Y*Y').*K;
    A = [];
    Aeq = Y';
    l = zeros(size(X,1),1);
    c = -1*ones(size(X,1),1);
    b = [];
    beq = 0;
    u = C*ones(size(X,1), 1);
    options = optimset('Algorithm','interior-point-convex','Display','off');
% calculate alpha using quadprog function
    alpha = quadprog(H, c, A, b, Aeq, beq, l, u,[],options);
%near boundary coefficients
    alpha(alpha < C * 0.0000001) = 0;
    alpha(alpha > C*0.9999999) = C;
    sv = find(alpha >0 & alpha<C);
    sv_one = zeros(size(X,1),1);
    sv_one(sv,1) = 1;
    b = sv_one'*(Y-((alpha.*Y)'*K')')/sum(sv_one);
    sv = find(alpha >0);
    sv_one = zeros(size(X,1),1);
    sv_one(sv,1) = 1;
    
%decision function for training set
    
    temp_tr = bsxfun(@plus,K(sv,:)'*(alpha(sv,:).*Y(sv,:)),b);  
    plot(temp_tr)
    
    temp_tr(temp_tr<0) = -1;
    temp_tr(temp_tr>=0) = 1;
    sum(temp_tr == Y)/length(Y)
    %%
    his_sv = his(sv,:);
    
    % development set
     Ki_d = [];
%     for it  = 1:1:length(sv)
%     for jit  =  1:1:size(X_d,1)
% 
%         Ki_d(it,jit) = sum(min([his_sv(it,:);his_d(jit,:)]));
%     end
%     end
b = size(X_d,1);
for i = 1:length(sv)
Va = repmat(his_sv(i,:),b,1);
Ki_d(i,:) = sum(min(Va,his_d),2)';
end

    temp_de= bsxfun(@plus,Ki_d'*(alpha(sv,:).*Y(sv,:)),b);
    

end


