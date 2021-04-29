% CosineStructuredLightPatterns - Generates Sinusoidal Patterns
%
% INPUTS
% width - number of pixels along the horizontal direction
% height - number of pixels along the vertical direction
% nFreq - number of frequencies (frequencies will be 2^0,
% 2^1,...,2^(nFreq-1))
% nShift - number of phase shifts per frequency 
% dir - direction along which encoding is required, 'h' for encoding along
% horizontal direction(i.e., vertical stripes) and 'v' for encoding along
% vertical direction (i.e., vertical stripes)
%
% OUTPUT - Saves nFreq X nShifts images in jpeg format in with filename as 
% freq_shift.jpg

function CosineStructuredLightPatterns(width,height,nFreq,nShift,dir)
% Patterns=zeros(height,width,nFreq*nShift);
for f=1:nFreq
    for s=1:nShift
        if dir=='h'
%             Patterns(:,:,(f-1)*nShift+s)=(repmat(cos((1:width)/width*2*pi*(2^(f-1))+(s-1)*2*pi/nShift),[height,1])+1)*0.5;
            pattern=(repmat(cos((1:width)/width*2*pi*(2^(f-1))+(s-1)*2*pi/nShift),[height,1])+1)*0.5;
        end
        if dir=='v'
%             Patterns(:,:,(f-1)*nShift+s)=(repmat(cos((1:height)/height*2*pi*(2^(f-1))+(s-1)*2*pi/nShift)',[1,width])+1)*0.5;
            pattern=(repmat(cos((1:height)/height*2*pi*(2^(f-1))+(s-1)*2*pi/nShift)',[1,width])+1)*0.5;
        end
        imwrite(pattern,sprintf('%d_%d.jpg',f,s));
    end
end
end