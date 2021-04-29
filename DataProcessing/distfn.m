% distfun - distance function to find inliers w.r.t. the fitted model.
% distance function is based on reprojection error.
%
% INPUTS - 
% P - fitted model (Estimated projection matrix)
% pts - 5XN array of input data which contains 3D coordinates (1:3)
% and the corresponding pixel coordinates (4:5).
% t - distance threshold within which points are taken as inliers.
%
% OUTPUTS
% inliers - inlier indices
% M - the model (projection matrix P)
function [inliers,M]=distfn(P,pts,t)
reprojectedPixCoord=P*[pts(1:3,:);ones(1,size(pts,2))];
reprojectedPixCoord=bsxfun(@rdivide,reprojectedPixCoord,reprojectedPixCoord(3,:));
dist=sqrt(sum((reprojectedPixCoord(1:2,:)-pts(4:5,:)).^2));
inliers=find(dist<t);
M=P;
end