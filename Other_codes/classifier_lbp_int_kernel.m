function [pred_labels, scores] = classifier_lbp_int_kernel(X,Y,X_test,C,bins)

hist_zscoreX  = zscore(X);
hist_zscoreX_test  = zscore(X_test);


K = sum(bsxfun(@min,permute(hist_zscoreX,[1 3 2]),permute(hist_zscoreX,[3 1 2])),3);
   Y(Y==0)=-1;
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
    %temp_tr(temp_tr<0) = -1;
    %temp_tr(temp_tr>=0) = 1;
    %sum(temp_tr == Y)/length(Y)
   
    hist_zscoreX_sv = hist_zscoreX(sv,:);
    
    % test set
  K_test = sum(bsxfun(@min,permute(hist_zscoreX_sv,[1 3 2]),...
      permute(hist_zscoreX_test,[3 1 2])),3);

    temp_test= bsxfun(@plus,K_test'*(alpha(sv,:).*Y(sv,:)),b);
    
    scores = temp_test;
    pred_labels = temp_test;
    pred_labels(temp_test<0) = 0;
    pred_labels(temp_test>=0) = 1;

    
end


