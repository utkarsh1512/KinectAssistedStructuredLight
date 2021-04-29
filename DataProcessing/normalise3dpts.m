% normalise3dpts - function for normalising 3D coordinates
%
% INPUT - 
% pts - 4XN array of N homogeneous points (X,Y,Z,1)
%
% OUTPUT - 
% newpts - normalised points
% U - normalisation matrix
function [newpts, U] = normalise3dpts(pts)
    if size(pts,1) ~= 4
        error('pts must be 4xN');
    end
    % Find the indices of the points that are not at infinity
    finiteind = find(abs(pts(4,:)) > eps);
    
    % For the finite points ensure homogeneous coordinatess have scale of 1
    pts(1,finiteind) = pts(1,finiteind)./pts(4,finiteind);
    pts(2,finiteind) = pts(2,finiteind)./pts(4,finiteind);
    pts(3,finiteind) = pts(3,finiteind)./pts(4,finiteind);
    pts(4,finiteind) = 1;
    
    c = mean(pts(1:3,finiteind)')';            % Centroid of finite points
    newp(1,finiteind) = pts(1,finiteind)-c(1); % Shift origin to centroid.
    newp(2,finiteind) = pts(2,finiteind)-c(2);
    newp(3,finiteind) = pts(3,finiteind)-c(3);
    
    dist = sqrt(newp(1,finiteind).^2 + newp(2,finiteind).^2 + newp(3,finiteind).^2);
    meandist = mean(dist(:));
    
    scale = sqrt(3)/meandist;
    
    U = [scale,0,0,-scale*c(1);0,scale,0,-scale*c(2);0,0,scale,-scale*c(3);0,0,0,1];
    
    newpts = U*pts;