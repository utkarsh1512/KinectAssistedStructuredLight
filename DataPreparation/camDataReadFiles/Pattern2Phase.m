% Pattern2Phase Decodes the patterns to phase
% First calculates the wrapped phase maps for each frequency using the
% phase shifted set of images for that particular frequency. Using the
% wrapped phase map for all the frequencies, a single unwrapped phase map
% is estimated.
%
% INPUTS:
% Pattern - A image_resolutionXnFreqXnShift sized 3D matrix
% nFreq - number of different frequencies used for the pattern encoding
% nShift - number of phase shifts used for each frequency
% ph - constant phase shift used for the pattern encoding
%
% OUTPUT:
% Phase - Unwrapped phase map which gives a one to one correspondence with
% the projector pixel location (either along each row or each column
% depending on the type of pattern used)

function [Phase] = Pattern2Phase(Pattern,nFreq,nShift)
% Calculate wrapped phase map for each frequency
for f=1:nFreq
    P=Pattern(:,:,(1:nShift)+nShift*(f-1));
    a=mean(P,3);
    c=sum(bsxfun(@times,P,permute(cos(2*pi/nShift*(0:(nShift-1))),[3,1,2])),3);
    s=sum(bsxfun(@times,P,permute(sin(2*pi/nShift*(0:(nShift-1))),[3,1,2])),3);
    P=-atan2(s,c);
    P((c.*c+s.*s)<.25*a.*a)=NaN;
    Phase(:,:,f)=P;
end
% Change the range of phase from (-pi, pi] to (0,2*pi]
Phase(Phase<0)=Phase(Phase<0)+2*pi; 
% Unwrap the phase maps to get a single unwrapped phase map
for f=1:nFreq-1
    P=Phase(:,:,f+1)+round((2*Phase(:,:,f)-Phase(:,:,f+1))/2/pi)*2*pi;
    P(P<0)=P(P<0)+2*pi;
    Phase(:,:,f+1)=P;
end
Phase=Phase(:,:,end)/(2^(nFreq-1));
Phase(Phase>6.28)=NaN;
% Gaussian Filtering for smoothing
Phase = imgaussfilt(Phase,0.5);
end