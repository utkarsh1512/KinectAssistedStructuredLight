% Calibrate - Calibrates the structured light system.
%
% INPUT
% xyzPhase - 5XN array of input data which contains 3D coordinates (1:3)
% and the corresponding pixel coordinates (4:5). The 3D coordinates are
% w.r.t. device 1 and the pixel coordinates are those of device 2. The
% projection matrix obtained is of device2 w.r.t. device1.
%
% OUTPUT
% P - projection matrix of device 2 w.r.t device 1 as detailed above
function [P]=Calibrate(xyzPhase)

%Get initial estimate of P using DLT and SVD
X=xyzPhase(1,:);   Y=xyzPhase(2,:);   Z=xyzPhase(3,:);
x=xyzPhase(4,:);   y=xyzPhase(5,:);
A=[[X;Y;Z;ones(1,size(X,2))]',zeros(4,size(X,2))', -bsxfun(@times,[X;Y;Z;ones(1,size(X,2))],x)'];
B=[zeros(4,size(X,2))',[X;Y;Z;ones(1,size(X,2))]', -bsxfun(@times,[X;Y;Z;ones(1,size(X,2))],y)'];
C=[A;B];
[e,d]=eig(C'*C);
[~,j]=sort(diag(d));
P0=e(:,j(1)); %initial estimate of P
%Use nonlinear optimization to get refined P matrix. The optimisation is
%initialized with the P estimated above.
options = optimoptions('fminunc','Algorithm','quasi-newton',...
'TolFun',1e-16,'TolX',1e-16,'MaxFunEvals',40000,'MaxIter',40000);
% options.Algorithm = 'levenberg-marquardt';
f=@(P)vectorObjective(P,[X;Y;Z;x;y]);
[P,~]=fminunc(f,P0,options);
P=reshape(P,4,3)';  
end