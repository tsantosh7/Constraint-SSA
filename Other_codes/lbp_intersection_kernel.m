function [ temp_tr, temp_de, temp_te ] = lbp_intersection_kernel(X,X_d,X_t,Y,C)

his  = zscore(X);
his_t  = zscore(X_t);
his_d  = zscore(X_d);

% for it  = 1:1:size(X,1)
%     for jit  =  1:1:size(X,1)
%       K(it,jit) = sum(min([his(it,:);his(jit,:)]));
%     end
% end

a = size(X,1);
for i = 1:size(X,1)
    Va = repmat(his(i,:),a,1);
    K(i,:) = sum(min(Va,his),2)';
end


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
options = optimset('Algorithm','interior-point-convex');
% calculate alpha using quadprog function
alpha = quadprog(H, c, A, b, Aeq, beq, l, u,[],options);
%near boundary coefficients
alpha(alpha < C * 0.001) = 0;
alpha(alpha > C*0.999) = C;
sv = find(alpha >0 & alpha<C);
sv_one = zeros(size(X,1),1);
sv_one(sv,1) = 1;
b = sv_one'*(Y-((alpha.*Y)'*K')')/sum(sv_one);
sv = find(alpha >0);
sv_one = zeros(size(X,1),1);
sv_one(sv,1) = 1;

%decision function for training set

temp_tr = bsxfun(@plus,K(sv,:)'*(alpha(sv,:).*Y(sv,:)),b);
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

Ki_t = [];
for it  = 1:1:length(sv)
    for jit  =  1:1:size(X_t,1)
        
        Ki_t(it,jit) = sum(min([his_sv(it,:);his_t(jit,:)]));
    end
end

temp_te = bsxfun(@plus,Ki_t'*(alpha(sv,:).*Y(sv,:)),b);




end


