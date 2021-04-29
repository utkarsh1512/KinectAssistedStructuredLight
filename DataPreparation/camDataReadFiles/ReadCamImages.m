% ReadCamImages Read the images from high res camera and obtain the
% horizontaal and vertical phase maps
%
% INPUT
% nFreq - number of different frequencies
% nShift - number of phase shifts per frequency
% wXh - resolution of the images
%
% OUTPUT
% camPhaseX - phase map for horizontal encoding
% camPhaseY - phase map for vertical encoding
function [camPhaseX,camPhaseY] = ReadCamImages(nFreq,nShift,w,h)
N=2*nFreq*nShift;
img=zeros(h,w,N);
for k=1:N
  colFileName = sprintf('img (%d).JPG',k);
  imageData = imread(colFileName);
  img(:,:,k) = rgb2gray(imageData);
end
camPhaseX = Pattern2Phase(img(:,:,1:48),nFreq,nShift);
camPhaseY = Pattern2Phase(img(:,:,49:96),nFreq,nShift);
