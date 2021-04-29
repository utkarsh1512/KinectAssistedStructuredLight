% calculateKRt - Decompose the estimated projection matrix (P) to obtain the
% camera intrinsics (K), rotation matrix (R) and the translation vector
% (t). The function uses RQ decomposition to achive the decompostion of P
% into K, R, and t.

function [K,R,t]=calculateKRt(P)
% Estimate C.
[~,~,V]=svd(P);
C=V(1:3,end)/V(end,end);
P=P*sign(det(P(1:3,1:3)));
% Estimating K and R by RQ decomposition.
[K,R] = rqdecomposition(P(1:3,1:3));
% Enforce positive diagonal of K by changing signs in both K and R.
D = diag(sign(diag(K)));
K = K*D;
R = D*R;
K = K/K(end,end);
K(:,2)=-1*K(:,2);
R(2,:)=-1*R(2,:);
K(:,3)=-1*K(:,3);
R(3,:)=-1*R(3,:);
%Determine t from the estimated C.
t = -R*C;
end