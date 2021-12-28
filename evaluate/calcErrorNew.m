%% this function calc the absolute error between the depth map and the refrence (STL file) an the angular error between the vector map and  the reference.
%created by Yuval Braun
%% load data
clear all 
close all
scale=textread('scale.txt');
% faces=load('facef.mat').faces;
% vertices=load('faceV.mat').vertices;
% [vertices,faces]  = updateStl(S);
% ptCloudSTL = pointCloud(S.vertices);
S=stlread('fish2.stl')
faces=S.faces;
vertices=S.vertices;
ptCloudSTL = pointCloud(vertices);
S2=stlread('fish_alligned.stl')
faces2=S2.faces;
vertices2=S2.vertices;
ptCloudSTL2 = pointCloud(vertices2);

rot=[0.989076 -0.143076 0.0354601;
     0.144832 0.988023 -0.0532308;
     -0.0274194 0.0577851 0.997952];
trans=[24.9674 -24.4213 -392.072];
trans=[0 0 0];
T(1:3,1:3)=rot;
T(4,1:3)=trans;
T(1:4,4) = [0 , 0 , 0, 1]';

tform = affine3d(T);


ptCloudSTLReg=pctransform(ptCloudSTL,tform);
ref_image=imread("face_ref.png");
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

%%%%
meshlab_image=imread("face_meshlab.png");
flag = 0;
for i=1:size(meshlab_image,1)
    for j=1:size(meshlab_image,2)
        if meshlab_image(i,j,1)~=0|| meshlab_image(i,j,2)~=0||meshlab_image(i,j,3)~=0
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
for i=size(meshlab_image,1):-1:1
    for j=1:size(meshlab_image,2)
        if meshlab_image(i,j,1)~=0|| meshlab_image(i,j,2)~=0||meshlab_image(i,j,3)~=0
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
for j=1:size(meshlab_image,2)
    for i=1:size(meshlab_image,1)
        if meshlab_image(i,j,1)~=0|| meshlab_image(i,j,2)~=0||meshlab_image(i,j,3)~=0
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
for j=size(meshlab_image,2):-1:1
    for i=1:size(meshlab_image,1)
        if meshlab_image(i,j,1)~=0|| meshlab_image(i,j,2)~=0||meshlab_image(i,j,3)~=0
            rightBound=j;
            flag = 1;
            break
        end
    end
    if flag==1
        break
    end
end
trimed_meshlab_image=meshlab_image(upBound:lowBound,leftBound:rightBound,:);
ratioH=size(trimed_meshlab_image,1)/size(trimed_ref,1);
ratioW=size(trimed_meshlab_image,2)/size(trimed_ref,2);
GT=trimed_ref;
for i=1:size(GT,1)
   for j=1:size(GT,2)
       GT(i,j,:)=trimed_meshlab_image(round(i*ratioH),round(j*ratioW),:);
   end
end
 