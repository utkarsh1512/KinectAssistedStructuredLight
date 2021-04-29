% ReadKinectData Read the RGB images from the Kinect camera and obtain the
% horizontal and vertical phase maps and the kinect depth map.
%
% INPUT
% nFreq - number of different frequencies
% nShift - number of phase shifts per frequency
% wXh - resolution of the images
%
% OUTPUT
% kinectPhaseX - phase map for horizontal encoding
% kinectPhaseY - phase map for vertical encoding
% depth - depth map

function [kinectPhaseX,kinectPhaseY,depth] = ReadKinectData(nFreq,nShift,w,h)
N=2*nFreq*nShift;
img=zeros(h,w,N);
for k=0:N-1
  colFileName = sprintf('Color_%d.raw',k);
  % Load image from Kinect raw RGB image data
  imageData = fliplr(LoadNIImage(colFileName));
  imageData = rgb2gray(imageData);
  img(:,:,k+1)=imageData;
end
% Load depth from Kinect captured raw depth data
depth=fliplr(LoadNIDepth('Depth_0.raw'));
kinectPhaseX = Pattern2Phase(img(:,:,1:48),nFreq,nShift);
kinectPhaseY = Pattern2Phase(img(:,:,49:96),nFreq,nShift);