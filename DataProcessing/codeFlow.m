% codeFlow -  Calibrates the structured light system and estimates the 3D
% structure of the captured scene. It calls all the functions required to
% estimate the 3D model using the input data.
%
% INPUTS 
% kinectPhaseX - unwrapped phase map for horizontal encoding of the scene
% as captured from the Kinect RGB camera.
% kinectPhaseY - unwrapped phase map for vertical encoding of the scene
% as captured from the Kinect RGB camera.
% depth - depth map as captured from the Kinect depth camera
% camPhaseX - unwrapped phase map for horizontal encoding of the scene
% as captured from the high resolution RGB camera.
% camPhaseY - unwrapped phase map for vertical encoding of the scene
% as captured from the high resolution RGB camera.
% OFFModelFileName - File name with which to save the 3D model
%
% OUTPUTS
% Ppc- Projection Matrix of the projector w.r.t the high resolution camera
% fcam - focal length of the high resolution camera
% OFF model with the input file name is saved in the current directory

function [Ppc,fcam]=codeFlow(kinectPhaseX,kinectPhaseY,depth,camPhaseX,camPhaseY,OFFModelFileName)
% Fuse depth map from the kinect with the phase map obtained from the
% images of the kinect RGB camera. Then normalize the 3D coordinates and the
% pixel coordinates for better estmation using ransac. Find inliers using
% RANSAC and use those inliers to find the projection matrix (Ppk) of the 
% projector with respect to Kinect. 

[XYZKinect] = FuseDepthNPhase(depth,kinectPhaseX,kinectPhaseY,[],[],[],768,1366);
[newpts2D, T] = normalise2dpts([XYZKinect(4:5,:);ones(1,size(XYZKinect,2))]);
[newpts3D, U] = normalise3dpts([XYZKinect(1:3,:);ones(1,size(XYZKinect,2))]);
XYZKinect=[newpts3D(1:3,:);newpts2D(1:2,:)];
[~, inliersprojkinect] = ransac1(XYZKinect, @Calibrate, @distfn, @degenfn, 100, 0.05);
XYZK=XYZKinect(:,inliersprojkinect);
P=Calibrate(XYZK);
% Projection matrix of the projector w.r.t. Kinect. Take into account the 2D and 3D normalisations.
[Ppk]=T\P*U;    

% Calculate refined depth map using Ppk and the Kinect RGB camera phase
% map. Fuse the refined depth map and the kinect phase maps. Find the
% 3D coordinates corresponding to each pixel of the high res camera using
% the phase maps. Calibrate the camera with respect to Kinect since the 3D
% coordinates are w.r.t. Kinect to obtain Pck.

[DEPTH]=CalculateRefinedDepth(kinectPhaseX,Ppk,[],[],[]);
[XYZKinect] = FuseDepthNPhase(DEPTH,kinectPhaseX,kinectPhaseY,[],[],[],768,1366);
[camPhs]=reduceCamData(camPhaseX,camPhaseY,768,1366);
[mappedCamKinect]=mapProj3DtoCam(XYZKinect,camPhs,768,1366);
[newpts2D, T] = normalise2dpts([mappedCamKinect(4:5,:);ones(1,size(mappedCamKinect,2))]);
[newpts3D, U] = normalise3dpts([mappedCamKinect(1:3,:);ones(1,size(mappedCamKinect,2))]);
mappedCamKinect=[newpts3D(1:3,:);newpts2D(1:2,:)];
[~, inlierscamkinect] = ransac1(mappedCamKinect, @Calibrate, @distfn, @degenfn, 100, 0.05);
mapped=mappedCamKinect(:,inlierscamkinect);
P=Calibrate(mapped);
[Pck]=T\P*U;

% Decompose the Projection matrix to obtain the high res camera intrinsics
% (K), the rotation matrix of the camera w.r.t. Kinect (Rck) and the
% translation vector of the camera w.r.t. Kinect (tck). Obtain the focal
% length of the camera from K. Using Rck,tck change the coordinate axes
% from Kinect centered to camera centred. The refined depth map is now
% w.r.t. high res camera. Now, calibrate the projector w.r.t. the high res
% camera to obtain Ppc. Use Ppc to calculate the depth map w.r.t. the high
% resolution camera. This is a dense depth map as the camera phase map has
% higher resolution and can be focused on the object being scanned.

[Kck,Rck,tck]=calculateKRt(Pck);fcam=(Kck(1,1)-Kck(2,2))/2;
[XYZCam]=changeWorldCoordinates(XYZKinect,Rck,tck);
[newpts2D, T] = normalise2dpts([XYZCam(4:5,:);ones(1,size(XYZCam,2))]);
[newpts3D, U] = normalise3dpts([XYZCam(1:3,:);ones(1,size(XYZCam,2))]);
XYZCam=[newpts3D(1:3,:);newpts2D(1:2,:)];
[~, inliersprojcam] = ransac1(XYZCam, @Calibrate, @distfn, @degenfn, 100, 0.05);
XYZC=XYZCam(:,inliersprojcam);
P=Calibrate(XYZC);
[Ppc]=T\P*U;
[DEPTHcam]=CalculateRefinedDepth(camPhaseX,Ppc,fcam,1024,768);

%Triangulate the camera depth map to obtain 3D model
[V,T]=TriangulateDepthMap(DEPTHcam,fcam,1024,768,[],[],[],[],[]);

SaveOFFModel(OFFModelFileName,V,T);