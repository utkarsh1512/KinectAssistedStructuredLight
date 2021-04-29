% LoadNIImage Loads RGB images from Kinect Raw Data Files
% 
% INPUT
% FileName - FileName of the input raw data file
%
% OUTPUT
% Image - RGB image captured by the Kinect RGB camera
function [Image]=LoadNIImage(FileName)
File=fopen(FileName,'rb');
% Image=reshape(uint8(fread(File,480*640*3,'uchar')),640*3,480)';
% Image=reshape([Image(:,1:3:end),Image(:,2:3:end),Image(:,3:3:end)],480,640,3);
Image=uint8(fread(File,480*640*3,'uchar'));
fclose(File);
if(length(Image)==640*480*3)
    Image=reshape(Image,640*3,480)';
    Image=reshape([Image(:,1:3:end),Image(:,2:3:end),Image(:,3:3:end)],480,640,3);
elseif(length(Image)==320*240*3)
    Image=reshape(Image,320*3,240)';
    Image=reshape([Image(:,1:3:end),Image(:,2:3:end),Image(:,3:3:end)],240,320,3);
else
    error('Improper Data Size');
end
end