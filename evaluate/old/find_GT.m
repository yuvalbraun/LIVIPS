clear all 
close all
scale=textread('scale.txt');
faces=load('facef.mat').faces;
vertices=load('faceV.mat').vertices;
ptCloudSTL = pointCloud(vertices);
R = [ 0.999072 -0.0400936 0.0157348 0;
     0.0390317 0.997262 0.0628074 0;
     -0.0182099 -0.062135 0.997902 0;
     0 0 0 1];
% TranslationalVector
%T_vec = [0.0938534 -0.764 -53.4135 1];
T_vec = [0 0 0 1];
% ViewportPx
w = 640; 
h = 480;
% PixelSizeMm
pixelSizeW = 0.0690639;
pixelSizeH = 0.0690639;
% FocalMm
focalMmX = 102.414;
focalMmY = 102.414;
rotY180 = [
-1 0 0 0;
0 1 0 0;
0 0 -1 0;
0 0 0 1
];
T = eye(4);
T(:,4) = T_vec;
world2cam = R * T;
cam2world = inv(world2cam);
for i=1:size(vertices,1)
    p= world2cam*[vertices(i,:) 1]';
    vertices_new(i,:)=p(1:3)';
end
ptCloudSTLReg=pointCloud(vertices_new);

%%%%%
ref_image=flipud(permute(imread("face_GT_1105.png"),[2 1 3]));
flag = 0;
for i=1:size(ref_image,1)
    for j=1:size(ref_image,2)
        if ref_image(i,j,1)~=0|| ref_image(i,j,2)~=0||ref_image(i,j,3)~=0
            upBound=i;
            flag = 1;
            break
        end
    end
    if flag==1
        break
    end
end
flag = 0;
for i=size(ref_image,1):-1:1
    for j=1:size(ref_image,2)
        if ref_image(i,j,1)~=0|| ref_image(i,j,2)~=0||ref_image(i,j,3)~=0
            lowBound=i;
            flag = 1;
            break
        end
    end
    if flag==1
        break
    end
end
flag = 0;
for j=1:size(ref_image,2)
    for i=1:size(ref_image,1)
        if ref_image(i,j,1)~=0|| ref_image(i,j,2)~=0||ref_image(i,j,3)~=0
            leftBound=j;
            flag = 1;
            break
        end
    end
    if flag==1
        break
    end
end
flag = 0;
for j=size(ref_image,2):-1:1
    for i=1:size(ref_image,1)
        if ref_image(i,j,1)~=0|| ref_image(i,j,2)~=0||ref_image(i,j,3)~=0
            rightBound=j;
            flag = 1;
            break
        end
    end
    if flag==1
        break
    end
end
trimed_ref=ref_image(upBound:lowBound,leftBound:rightBound,:);
rows =lowBound-upBound+1;
cols =rightBound-leftBound+1;

%% create new axis using the rotated cloud
XL2=ptCloudSTLReg.XLimits;
            X2= XL2(1):((XL2(2)-XL2(1))/(rows-1)):XL2(2);
            if size(X2,2)<rows
                X2(:,rows)=XL2(2);
            end
YL2=ptCloudSTLReg.YLimits;
Y2= YL2(1):((YL2(2)-YL2(1))/(cols-1)):YL2(2);
ratio2= (rows-1)\(XL2(2)-XL2(1));
%% create ground truth normals map
vn=STLVertexNormals(faces, ptCloudSTLReg.Location ); %%s.faces
[newL,depthMap,normalsMapStl]= findClosestPoint(X2,Y2,rows,cols,ptCloudSTLReg.Location,ratio2,vn);
figure;
imshow(flipud(permute(normalsMapStl,[2 1 3])));
title('ground truth normals map');
