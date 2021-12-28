GTfull=imread('face_full_GT2505.png');
trimedGT= trim_image(GTfull);
normalMap=load('nmap_static_face_dark').n;
BW=flipud(load('maskface2505').BW);
trimedNormalMap= trim_image2(BW,normalMap);
[H,W,D]=size(trimedNormalMap);
downSampleGT= trimedGT(1:size(trimedGT,1)/H:size(trimedGT,1),1:size(trimedGT,2)/W:size(trimedGT,2),:);
normal_GT=color_to_normalmap(downSampleGT);
degrees=calcDegreeError(normal_GT,trimedNormalMap);
figure
%imagesc(flipud(degrees'));
him=imshow([flipud(degrees) nan(H,1); nan(1,W+1)],colormap(jet(30)));
set(him, 'AlphaData', ~isnan([flipud(degrees) nan(H,1); nan(1,W+1)]))
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

