GTfull=imread('face_full_GT1006.png');
normalMap=load('nmap_static_face_Hlight').n;
staticdark=0;
if staticdark==0
    eval_mask=load('eval_face_mask1006').eval_mask;
else
    eval_mask=(~isnan(normalMap(:,:,1)));
    save('eval_face_mask1006','eval_mask');
end
normalMap=normalMap.*eval_mask;
normalMap1= normalMap(:,:,1);
normalMap2= normalMap(:,:,2);
normalMap3= normalMap(:,:,3);
indexes= normalMap1+normalMap2+normalMap3;
normalMap1(indexes==0)=NaN;
normalMap2(indexes==0)=NaN;
normalMap3(indexes==0)=NaN;
normalMap(:,:,1)=normalMap1;
normalMap(:,:,2)=normalMap2;
normalMap(:,:,3)=normalMap3;
[H,W,D]=size(normalMap);
[a,b,c]=size(GTfull);
b1=(a/H)*W;
cutGT=GTfull(:,(b-b1)/2:(b+b1)/2,:);
downSampleGT= cutGT(1:size(cutGT,1)/H:size(cutGT,1),1:size(cutGT,2)/W:size(cutGT,2),:);
% BW=flipud(load('maskface2505').BW);
% trimedNormalMap= trim_image2(BW,normalMap);
% trimedGT= trim_image2(BW,downSampleGT);
normal_GT=color_to_normalmap(downSampleGT);
degrees=calcDegreeError(normal_GT,normalMap);
[H1,W1,D1]=size(normalMap);
figure
%imagesc(flipud(degrees'));
him=imshow([flipud(degrees) nan(H1,1); nan(1,W1+1)],colormap(jet(30)));
set(him, 'AlphaData', ~isnan([flipud(degrees) nan(H1,1); nan(1,W1+1)]))
shading flat;
set(gca, 'ydir', 'reverse');
%title('angular error map');
%colorbar;   
medianDegree=calcMedian(degrees);
avDegree=calcSum(degrees);
figure
histogram(degrees);
xlabel('angular error [degrees]');
ylabel('number of points');
title('angular error histogram');
figure();
N=ones(size(normalMap));
N(~isnan(normalMap)==1)=normalMap((~isnan(normalMap)==1));
imshow(flipud(N));
figure()
n=normalMap;
fprintf('Estimating depth map from normal vectors...\n');
p = -n(:,:,1) ./ n(:,:,3);
q = -n(:,:,2) ./ n(:,:,3);
p(isnan(p)) = 0;
q(isnan(q)) = 0;
Z = DepthFromGradient(p, q);
% Visualize depth map.
figure
Z= load('Zmap_static_face_Hlight').Z;
Z(isnan(n(:,:,1)) | isnan(n(:,:,2)) | isnan(n(:,:,3))) = NaN;
surf(Z, 'EdgeColor', 'None', 'FaceColor', [0.5 0.5 0.5]);
axis equal; camlight;
view(-35, 30);
axis off
