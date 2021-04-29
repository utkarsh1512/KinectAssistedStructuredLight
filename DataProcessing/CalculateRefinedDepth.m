% CalculateRefinedDepth - Calculate the depth map with the input phase map.
%
% INPUTS -
% Phase - phase map for horiontal encoding as captured by the camera
% P - Projection matrix of the projector w.r.t. the camera
% f - focal length of the camera
% u,v - Principal point or the image center of the camera
%
% OUTPUT - 
% DEPTH - Estimated Depth map w.r.t. the camera
function [DEPTH]= CalculateRefinedDepth(Phase,P,f,u,v)
h=size(Phase,1);w=size(Phase,2);
if(isempty(f));f=530*length(Phase)/640;end
if(isempty(u));u=w/2;end
if(isempty(v));v=h/2;end
P=P(1:2:end,:)';P=P(:);
[x,y]=meshgrid(1:size(Phase,2),size(Phase,1):-1:1);
i=reshape(1:numel(Phase),size(Phase));
DEPTH=NaN(h,w);
x=x-u; y=y-v;
x=x(:); y=y(:);
Phase=Phase(:)*1366/2/pi; k=~isnan(Phase); x=x(k); y=y(k); Phase=Phase(k); i=i(k);

a=  -(P(1)-P(5)*Phase).*x+...
    -(P(2)-P(6)*Phase).*y+...
     (P(3)-P(7)*Phase)*f;
b=(P(4)-P(8)*Phase)*f;
Z=-b./a;
DEPTH(i)=-Z;