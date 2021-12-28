function [Image1, Image2, Image3]  = removeGreenBackground( I1,I2,I3,I4,I5,I6,I7 )
lab_he = rgb2lab(I1);
ab = lab_he(:,:,2:3);
ab = im2single(ab);
nColors = 2;
% repeat the clustering 3 times to avoid local minima
pixel_labels = imsegkmeans(ab,nColors,'NumAttempts',3);
mask1 = pixel_labels==2;

% gray = rgb2gray(I4);
% SE  = strel('Disk',1,4);
% morphologicalGradient = imsubtract(imdilate(gray, SE),imerode(gray, SE));
% mask = im2bw(morphologicalGradient,0.03);
% SE  = strel('Disk',3,4);
% mask = imclose(mask, SE);
% mask = imfill(mask,'holes');
% mask = bwareafilt(mask,1);
% notMask = ~mask;
% mask = mask | bwpropfilt(notMask,'Area',[-Inf, 5000 - eps(5000)]);
% T=1;
% M=size(I1,1);
% N=size(I1,2);
% Image1 =I5;
% Image2 =I6;
% Image3 =I7;
% for i = 1:M
%     for j = 1:N
%         if (I1(i,j,1)*T< I1(i,j,2) && I1(i,j,3)*T<I1(i,j,2)&&5< I1(i,j,2)) || (I2(i,j,1)*T< I2(i,j,2) && I2(i,j,3)*T<I2(i,j,2)&&5< I2(i,j,2)) ||(I3(i,j,1)*T< I3(i,j,2) && I3(i,j,3)*T<I3(i,j,2)&&5< I3(i,j,2)) ||(I4(i,j,1)*T< I4(i,j,2) && I4(i,j,3)*T<I4(i,j,2)&&5< I4(i,j,2))
%             Image1(i,j,:)= [0 0 0 ];
%             Image2(i,j,:)= [0 0 0 ];
%             Image3(i,j,:)= [0 0 0 ];
%         end
%     end
% end
% val1= max(I1,[],3); 
% mask1=uint8(I1(:,:,2)~=val1);
% val2= max(I2,[],3); 
% mask2=uint8(I2(:,:,2)~=val2);
% val3= max(I3,[],3); 
% mask3=uint8(I3(:,:,2)~=val3);
% val4= max(I4,[],3); 
% mask4=uint8(I4(:,:,2)~=val4);
 Image1=I5.* uint8(mask1);
 Image2=I6.* uint8(mask1);
 Image3=I7.* uint8(mask1);
end