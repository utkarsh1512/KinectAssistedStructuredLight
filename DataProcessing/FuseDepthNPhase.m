% FuseDepthNPhase - Given a depth map and phase maps w.r.t a camera, find
% the correspondences i.e., for a camera pixel find its corresponding 3D
% coordinates and the corresponding pixel coordinate in the other device
% (projector)
%
% INPUTS - 
% DEPTH - depth map w.r.t. the camera
% PHASEx - Phse map for horizontal encoding as captured by the camera
% PHASEy - Phse map for vertical encoding as captured by the camera
% f - focal length of the camera
% u,v - coordinates of the principal point or the image center
% widthXheight - resolution of the projected images
%
% OUTPUT -
% xyzPhase - 7X(resolution) sized array which contains 3D coordinates
% (1:3), corresponding projector pixels coordinates (4:5) ,and the camera
% pixel coordinates (6:7)

function [xyzPhase]=FuseDepthNPhase(DEPTH,PHASEx,PHASEy,f,u,v,height,width)
DiscardValue=0;
DEPTH(isnan(PHASEx))=DiscardValue;
DEPTH(isnan(PHASEy))=DiscardValue;
h=size(DEPTH,1);w=size(DEPTH,2);
if(isempty(f));f=530*length(DEPTH)/640;end % default f for Kinect estimated through calibration
if(isempty(u));u=w/2;end                   % If image center is not passed assuem it to be actual center
if(isempty(v));v=h/2;end
[x,y]=meshgrid(1:size(DEPTH,2),size(DEPTH,1):-1:1);
[V,~]=TriangulateDepthMap(DEPTH,f,u,v,[],cat(3,PHASEx,PHASEy,x,y),DiscardValue,[],[]);
V(4,:)=V(4,:)*width/2/pi;                   % corresponding projector pixel x coordinate
V(5,:)=V(5,:)*height/2/pi;                  % corresponding projector pixel y coordinate
V(4:5,:)=ceil(V(4:5,:));
xyzPhase=V(1:7,:);
end