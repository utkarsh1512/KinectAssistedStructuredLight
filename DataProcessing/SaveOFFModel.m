% SaveOFFModel - Saves the 3D model obtained by triangulating the point
% cloud.
%%%% INCOMPLETE works with triangle meshes only
function SaveOFFModel(FileName,VERTICES,FACES,Type,Invert)
if(nargin<5);Invert=0;end;
if(nargin<4);Type='';end;
File=fopen(FileName,'w');
fprintf(File,'%sOFF\n%d %d %d\n',Type,size(VERTICES,2),size(FACES,2),0);
if(strcmp(Type,''))
    if(Invert);VERTICES(2:3,:)=-VERTICES(2:3,:);end;
    fprintf(File,'%f %f %f\n',VERTICES);
end
if(strcmp(Type,'C'))
    if(Invert);VERTICES(2:3,:)=-VERTICES(2:3,:);end;
    if(size(VERTICES,1)==4);VERTICES=[VERTICES;VERTICES([4,4],:)];end;
    VERTICES=[VERTICES;repmat(255,[1,size(VERTICES,2)])];
    fprintf(File,'%f %f %f %d %d %d %d\n',VERTICES);
end
if(strcmp(Type,'N'))
    if(Invert);VERTICES([2,3,5,6],:)=-VERTICES([2,3,5,6],:);end;
    fprintf(File,'%f %f %f %f %f %f\n',VERTICES);
end
if(strcmp(Type,'NC'))
    if(Invert);VERTICES([2,3,5,6],:)=-VERTICES([2,3,5,6],:);end;
    VERTICES=[VERTICES(1:9,:);repmat(255,[1,size(VERTICES,2)])];
    fprintf(File,'%f %f %f %f %f %f %d %d %d %d\n',VERTICES);
end
FACES=[repmat(3,[1,size(FACES,2)]);FACES-1];
fprintf(File,'%d %d %d %d\n',FACES);
fclose(File);
end