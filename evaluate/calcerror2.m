clear all 
D=load('fishdepth3.mat');
S=stlread('fish2.stl');
S1=unique(S.vertices,'rows');
moving = pointCloud(S1);
Z=D.Z';
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
trimedMap= Z(upBound:lowBound,leftBound:rightBound);
rows =lowBound-upBound+1;
cols =rightBound-leftBound+1;
XL=moving.XLimits;
            X= XL(1):((XL(2)-XL(1))/(rows-1)):XL(2);
            if size(X,2)<rows
                X(:,rows)=XL(2);
            end
YL=moving.YLimits;
Y= YL(1):((YL(2)-YL(1))/(cols-1)):YL(2);
ratio= (rows-1)\(XL(2)-XL(1));
fixed=depthToCloud(trimedMap,X,Y,ratio);
movingDownsampled = pcdownsample(moving,'gridAverage',0.3);
fixedDownsampled = pcdownsample(fixed,'gridAverage',0.3);
figure
pcshowpair(movingDownsampled,fixedDownsampled,'MarkerSize',5)
xlabel('X')
ylabel('Y')
zlabel('Z')
title('Point clouds before registration')
legend({'Moving point cloud','Fixed point cloud'},'TextColor','w')
legend('Location','southoutside')
tform = pcregistericp(movingDownsampled,fixedDownsampled);
movingReg = pctransform(movingDownsampled,tform);
figure
pcshowpair(movingReg,fixedDownsampled,'MarkerSize',5)
xlabel('X')
ylabel('Y')
zlabel('Z')
title('Point clouds after registration')
legend({'Moving point cloud','Fixed point cloud'},'TextColor','w')
legend('Location','southoutside')
