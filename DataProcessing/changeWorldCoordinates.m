% changeWorldCoordinates - move the reference coordinate system using the
% rotation matrix R and the translation vector t
%
% INPUT - 
% xyzPhase - 3D coordinates 
% R - rotation matrix
% t - tranlation Vector
%
% OUTPUT - 
% XYZNew - 3D coordinates w.r.t the new reference frame
function [XYZNew]=changeWorldCoordinates(xyzPhase,R,t)
XYZNew=NaN(size(xyzPhase,1),size(xyzPhase,2));
XYZ1=[xyzPhase(1:3,:)',ones(1,size(xyzPhase,2))']';
M=[R,t];
XYZ1=M*XYZ1;
XYZNew(1:3,:)=XYZ1;
XYZNew(4:end,:)=xyzPhase(4:end,:);
end