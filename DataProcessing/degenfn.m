% degenfn - Check if the points in the current sample are coplanar.
% Projection matrix estimated using coplanar points will be degenerate.
% At least six points which are not coplanar are required for the estimation 
% of a non-degenerate projection matrix. Hence the check is applied on only 
% 6 of the N points in the current sample. If any 3 of the 6 points are
% degenrate, the flag is set and returned.

function [fl]=degenfn(x)
x=x(1:3,:); %Consider only the X,Y,Z coordinates
x=bsxfun(@minus,x,x(:,1));  %Calculate the vectors from x(0) to all other points
% perpend=cross(x(:,2),x(:,3));
C=cross(repmat(x(:,2),1,4),x(:,3:6));
if  dot(C(:,1),C(:,2))==0|| dot(C(:,1),C(:,3))==0 || dot(C(:,1),C(:,4))==0 || dot(C(:,2),C(:,3))==0 || dot(C(:,2),C(:,4))==0 || dot(C(:,3),C(:,4))==0
    fl=1;
else
    fl=0;
end
end