%% this function calc the absolute error between the depth map and the refrence (STL file) an the angular error between the vector map and  the reference.
%created by Yuval Braun
%% load data
clear all 
close all
scale=textread('scale.txt');
D=load('ZstaticDark.mat'); %%depth map
n=permute(load('nstaticDark.mat').n,[2 1 3]); %%normals map
S=stlread('SealedFace1-FACE.stl');%% stl file
%[S1,ia]=unique(S.vertices,'rows');
 faces=load('facef.mat').faces;
 vertices=load('faceV.mat').vertices;
% [vertices,faces]  = updateStl(S);
% ptCloudSTL = pointCloud(S.vertices);
ptCloudSTL = pointCloud(vertices);




% 
% theta = pi;
% rot = [cos(theta) sin(theta) 0; ...
%       -sin(theta) cos(theta) 0; ...
%                0          0  1];
% trans = [0, 0, 0];
% tform = rigid3d(rot,trans);
% ptCloudSTL = pctransform(ptCloudSTL,tform);

Z=D.Z';
realSize=86; %%%the object size is 86 mm
%% PLOT 3D surface
figure;
Z(isnan(n(:,:,1)) | isnan(n(:,:,2)) | isnan(n(:,:,3))) = NaN;
surf(Z, 'EdgeColor', 'None', 'FaceColor', [0.5 0.5 0.5]);
axis equal; camlight;
view(-128,25);
axis off;


%% count the number of rows and cols for scaling
flag = 0;
for i=1:size(Z,1)
    for j=1:size(Z,2)
        if ~isnan(Z(i,j))
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
for i=size(Z,1):-1:1
    for j=1:size(Z,2)
        if ~isnan(Z(i,j))
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
for j=1:size(Z,2)
    for i=1:size(Z,1)
        if ~isnan(Z(i,j))
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
for j=size(Z,2):-1:1
    for i=1:size(Z,1)
        if ~isnan(Z(i,j))
            rightBound=j;
            flag = 1;
            break
        end
    end
    if flag==1
        break
    end
end
trimedZMap= Z(upBound:lowBound,leftBound:rightBound); %%depth map after cut the edges
trimednMap=n(upBound:lowBound,leftBound:rightBound,:); %%normal map after cut the edges
rows =lowBound-upBound+1;
cols =rightBound-leftBound+1;
%% create new cloud using the depth map
XL=ptCloudSTL.XLimits;
            X= XL(1):((XL(2)-XL(1))/(rows-1)):XL(2);
            if size(X,2)<rows
                X(:,rows)=XL(2);
            end
YL=ptCloudSTL.YLimits;
Y= YL(1):((YL(2)-YL(1))/(cols-1)):YL(2);
ratio= (rows-1)\(XL(2)-XL(1));
ptCloudCamera=depthToCloud(trimedZMap,X,Y,ratio);
%% find registration between the two clouds
[tform,rmse]=findTransform(ptCloudSTL,ptCloudCamera);
ptCloudSTLReg=pctransform(ptCloudSTL,tform);
%% create new axis using the rotated cloud
XL2=ptCloudSTLReg.XLimits;
            X2= XL2(1):((XL2(2)-XL2(1))/(rows-1)):XL2(2);
            if size(X,2)<rows
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
figure;
imshow(flipud(permute(trimednMap,[2 1 3])));
title('estimated normals map');
%% calc absulute error map and mean
diff=depthMap-trimedZMap;
avError=calcSum(scale*diff); 
medianError=calcMedian(scale*diff);
figure
%imagesc(flipud(abs(scale*diff)'));
pcolor([flipud(abs(scale*diff)') nan(cols,1); nan(1,rows+1)]);
shading flat;
set(gca, 'ydir', 'reverse');
title('absulute error map');
colorbar;         
figure
histogram(abs(scale*diff))
title('absulute error histogram');
xlabel('absolute error [mm]')
ylabel('number of points')
%% calc angular error map and median
degrees=calcDegreeError(normalsMapStl,trimednMap);
figure
%imagesc(flipud(degrees'));
pcolor([flipud(degrees') nan(cols,1); nan(1,rows+1)]);
shading flat;
set(gca, 'ydir', 'reverse');
title('angular error map');
colorbar;   
medianDegree=calcMedian(degrees);
avDegree=calcSum(degrees);
figure
histogram(degrees);
xlabel('angular error [degrees]');
ylabel('number of points');
title('angular error histogram');
% save('normalsMapStl-LIVI300Dark','normalsMapStl');
% save('trimednMap-LIVI300Dark','trimednMap');
% save('diff-LIVI300Dark','diff');
% save('degrees-LIVI300Dark','degrees');
% save('cols-LIVI300Dark','cols');
% save('rows-LIVI300Dark','rows');
% save('avDegree-staticDark','avDegree');
% save('avError-staticDark','avError');
% save('medianDegree-staticDark','medianDegree');
% save('medianDegree-staticDark','medianDegree');




