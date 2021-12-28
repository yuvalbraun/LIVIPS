function [Image1,Image2,Image3] =removeGreenBackgroundStatic(I1,I2,I3)
% T=1.1;
% M=size(img1,1);
% N=size(img1,2);
% I1 =img1;
% I2 =img2;
% I3 =img3;
% for i = 1:M
%     for j = 1:N
%         if (img1(i,j,1)*T< img1(i,j,2) && img1(i,j,3)*T<img1(i,j,2)&&5< img1(i,j,2)) || (img2(i,j,1)*T< img2(i,j,2) && img2(i,j,3)*T<img2(i,j,2)&&5< img2(i,j,2)) ||(img3(i,j,1)*T< img3(i,j,2) && img3(i,j,3)*T<img3(i,j,2)&&5< I3(i,j,2)) 
%             I1(i,j,:)= [0 0 0 ];
%             I2(i,j,:)= [0 0 0 ];
%             I3(i,j,:)= [0 0 0 ];
%         end
%     end
% end
%% this functiom remove the green backgroun from the images
%Input : I1 is an image that used to create the mask, I2-4 are images that
%will be edit.
%Output : Image1-3 are the same images as I2-4 without the background.
%created by Yuval Braun

lab_he = rgb2lab(I1);
ab = lab_he(:,:,2:3);
ab = im2single(ab);
nColors = 2;
% repeat the clustering 3 times to avoid local minima
pixel_labels = imsegkmeans(ab,nColors,'NumAttempts',3);
i=pixel_labels(240,320) 
mask1 = pixel_labels==i;

lab_he = rgb2lab(I2);
ab = lab_he(:,:,2:3);
ab = im2single(ab);
nColors = 2;
% repeat the clustering 3 times to avoid local minima
pixel_labels = imsegkmeans(ab,nColors,'NumAttempts',3);
i=pixel_labels(240,320) 
mask2 = pixel_labels==i;

lab_he = rgb2lab(I3);
ab = lab_he(:,:,2:3);
ab = im2single(ab);
nColors = 2;
% repeat the clustering 3 times to avoid local minima
pixel_labels = imsegkmeans(ab,nColors,'NumAttempts',3);
i=pixel_labels(240,320) 
mask3 = pixel_labels==i;
  


 Image1=I1.* uint8(mask1).*uint8(mask2).*uint8(mask3);
 Image2=I2.* uint8(mask1).*uint8(mask2).*uint8(mask3);
 Image3=I3.* uint8(mask1).*uint8(mask2).*uint8(mask3);
 

end




