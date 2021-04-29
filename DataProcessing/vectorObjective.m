% vectorObjective - The objective function for the non linear optimisation.
% Reprojection error is used as the objective function.
%
% INPUTS
% P - projection matrix
% xyzPhase - 5XN array of 3D coordinates (1:3) and the corresponding pixel
% coordintes (4:5)
%
% OUTPUT
% error - the reprojection error with the projection matrix P

function [error]=vectorObjective(P,xyzPhase)
X=xyzPhase(1,:);
Y=xyzPhase(2,:);
Z=xyzPhase(3,:);
x=xyzPhase(4,:);
y=xyzPhase(5,:);
num=P(1)*X+P(2)*Y+P(3)*Z+P(4);
den=P(9)*X+P(10)*Y+P(11)*Z+P(12);
err=((num./den)-x);
num1=P(5)*X+P(6)*Y+P(7)*Z+P(8);
den1=P(9)*X+P(10)*Y+P(11)*Z+P(12);
err1=((num1./den1)-y);
% error=[err;err1];
error=sqrt(sum(err.^2+err1.^2));