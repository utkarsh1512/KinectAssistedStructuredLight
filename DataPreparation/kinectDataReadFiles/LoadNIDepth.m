% LoadNIDepth Loads the depth values captured by Kinect
%
% INPUT 
% FileName - FileName of the raw data file
% 
% OUTPUT
% Depth - Captured epth of the scene
function [Depth]=LoadNIDepth(FileName)
File=fopen(FileName,'rb');
Depth=fread(File,480*640,'ushort');
fclose(File);
if(length(Depth)==640*480)
    Depth=reshape(Depth,640,480)';
elseif(length(Depth)==320*240)
    Depth=reshape(Depth,320,240)';
elseif(length(Depth)==512*424)
    Depth=reshape(Depth,512,424)';
else
    error('Improper Data Size');
end
end