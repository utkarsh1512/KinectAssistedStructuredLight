% reduceCamData - Find the projector pixel coordinates cooresponding to
% each camera pixel using the camera phase maps
%
% INPUT -
% hPhase - high resolution camera phase map for encoding the horizontal
% direction
% vPhase - high resolution camera phase map for encoding the vertical
% direction
% width X height - resolution of the projected patterns
%
% OUTPUT - 
% camPhases - 5 X (widthXheight) array of camera pixel coordinates and the
% corresponding projector pixel coordinates

function [camPhases]=reduceCamData(hPhase,vPhase,height,width)
h=size(hPhase,1);w=size(hPhase,2);
i=reshape(1:numel(hPhase),size(hPhase)); i=i(:);
x=repmat((1:w),h,1);x=x(:);    
y=repmat((1:h)',1,w);y=y(:);
hPhase=hPhase(:);
vPhase=vPhase(:);
k=and(~isnan(hPhase),~isnan(vPhase));
x=x(k); y=y(k); hPhase=hPhase(k); vPhase=vPhase(k); i=i(k);
camPhases(1,:)=ceil(hPhase*width/2/pi);     %Corresponding Projector pixel x Coordinates
camPhases(2,:)=ceil(vPhase*height/2/pi);    %Corresponding Projector pixel y Coordinates
camPhases(3,:)=x;                           %Camera pixel x coordinate
camPhases(4,:)=y;                           %Camera pixel y coordinate
camPhases(5,:)=i;
camPh=camPhases(1:2,:)';
[~,ia,~]=unique(camPh,'rows');
camPhases=camPhases(:,ia);
end
