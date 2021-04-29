% TriangulateDepthMap - Estimate the 3D model using Delaunay Traingulation
% 
% INPUTS - 
% D - depth map
% f - focal length of the device used to capture the depth map
% u,v - coordinates of the principal point or the image center
% cutoff - cutoff 
% A - any attribute of the pixels that is to be passed to the vertices
% A can contain COLOR MAP or INTENSITY MAP or NORMAL MAP
% discardValue - value in the depth map to be discarded 
% R - Rotation Matrix, should be passed if the reference coordinate axes 
% are to be rotated to a different frame
% t - translation vector, should be passed if the origin of the reference
% coordinate axes is to be shifted to another frame
%
% OUTPUT
% V - Vertices along with the corresponding map values from A
% T - Indices of the input points that form a triangle or tetrahedron in
% the triangulation
function [V,T]=TriangulateDepthMap(D,f,u,v,cutoff,A,discardvalue,R,t)
h=size(D,1);w=size(D,2);
if(isempty(f));f=530*length(D)/640;end
if(isempty(u));u=w/2;end
if(isempty(v));v=h/2;end
if(isempty(R));R=eye(3);end
if(isempty(t));t=zeros(3,1);end
if(isempty(cutoff));cutoff=8;end
if(nargin<7 || isempty(discardvalue))
if(isinteger(D))
    if(nargin<7 || isempty(discardvalue))
        discardvalue=0;
    end
    D=double(D);D(D==discardvalue)=NaN;
else
    if ~(nargin<7 || isempty(discardvalue)  || isnan(discardvalue))        
        D(D==discardvalue)=NaN;
    end
end
end
x=repmat((1:w),h,1);x=x(:);    y=repmat((1:h)',1,w);y=y(:);
D=D(:);    k=~isnan(D);    x=x(k); y=y(k); D=D(k);
V=[((x-u)/f).*D,((v-y)/f).*D,-D,ones(length(D),1)];
V=[R,t]*V';V=V';
if(nargin>5 && ~isempty(A))
    A=reshape(A,size(A,1)*size(A,2),size(A,3));
    V=[V,double(A(k,:))];clear A;
end
T = delaunay(x,y);
v1=V(T(:,1),1:3);   v2=V(T(:,2),1:3);   v3=V(T(:,3),1:3); %Vertices
e1=v2-v1;   e2=v3-v2;   e3=v1-v3;                         %Edges
vc=(v1(:,3)+v2(:,3)+v3(:,3))/3000*cutoff;
k=(max([sum(e1.*e1,2),sum(e2.*e2,2),sum(e3.*e3,2)]')'<vc.*vc);
T=T(k,:);

% Remove Unreferenced Vertices
T=T(:);  i=unique(T);  j=zeros(size(V,1),1);  V=V(i,:);  j(i,1)=1:length(i);
T=reshape(j(T,1),length(T)/3,3);


T=T(:,end:-1:1)';
V=V';
end