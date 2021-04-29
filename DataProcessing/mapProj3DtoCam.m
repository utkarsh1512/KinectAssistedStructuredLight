% mapProj3DtoCam - find the 3D coordinates corresponding to the high res
% camera pixels using the Kinect phase maps. The Kinect and high res camera
% pixels having the same phase values correspond to the same 3D
% coordinates.
%
% INPUT - 
% XYZPhase - 7XN array of 3D coordinates (1:3) and the corresponding
% projector pixel coordinates (4:5) and the device's pixel coordinates
% (6:7)
% camPhases - 5XM array of projector pixel coordinates (1:2) and the
% corresponding camera pixel coordinates (3:4)
% wXh - resolution of the projected images
%
% OUTPUT -
% mappedCamProj - 7XN array of 3D coordinates (1:3) and the corresponding
% projector pixel coordinates (4:5) and the device's pixel coordinates
% (6:7)
function [mappedCamProj]=mapProj3DtoCam(XYZPhase,camPhases,h,w)
Map3D=NaN(h,w,5);
idx = XYZPhase(5,:)~=0 & XYZPhase(4,:)~=0;
Map3D(XYZPhase(5,idx),XYZPhase(4,idx),1:3) = XYZPhase(1:3,idx);
Map3D(XYZPhase(5,idx),XYZPhase(4,idx),4:5) = XYZPhase(6:7,idx); %x and y of the reference device
% for i=1:size(XYZPhase,2)
%     if XYZPhase(5,i)~=0 && XYZPhase(4,i)~=0
%     Map3D(XYZPhase(5,i),XYZPhase(4,i),1:3)=XYZPhase(1:3,i);
%     Map3D(XYZPhase(5,i),XYZPhase(4,i),4:5)=XYZPhase(6:7,i);%x and y of the reference device
%     end
% end
mappedCamProj=NaN(7,size(camPhases,2));
idx = camPhases(1,:)~=0 & camPhases(2,:)~=0;
mappedCamProj(1:3,idx)=Map3D(camPhases(2,idx),camPhases(1,idx),1:3);%3D coordinates w.r.t reference device (kinect)
mappedCamProj(4:5,idx)=camPhases(3:4,idx);                          %x and y of the device being calibrated
mappedCamProj(6:7,idx)=Map3D(camPhases(2,idx),camPhases(1,idx),4:5);%x and y of the reference device
% for i=1:size(camPhases,2)
%     if camPhases(1,i)~=0 && camPhases(2,i)~=0
%     mappedCamProj(1:3,i)=Map3D(camPhases(2,i),camPhases(1,i),1:3);%3D coordinates w.r.t reference device
%     mappedCamProj(4:5,i)=camPhases(3:4,i);%x and y of the device being calibrated
%     mappedCamProj(6:7,i)=Map3D(camPhases(2,i),camPhases(1,i),4:5);%x and y of the reference device
%     end
% end
k=~isnan(mappedCamProj(1,:));
mappedCamProj=mappedCamProj(:,k);
end