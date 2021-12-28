function [Image1, Image2, Image3]  = removeBackground( I1,I2,I3,I4)
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
 
lab_he = rgb2lab(I4);
ab = lab_he(:,:,2:3);
ab = im2single(ab);
nColors = 2;
% repeat the clustering 3 times to avoid local minima
pixel_labels = imsegkmeans(ab,nColors,'NumAttempts',3);
i=pixel_labels(240,320); 
mask4 = pixel_labels==i;
 


 Image1=I2.* uint8(mask1);%.*uint8(mask2).*uint8(mask3).*uint8(mask4);
 Image2=I3.* uint8(mask1);%.*uint8(mask2).*uint8(mask3).*uint8(mask4);
 Image3=I4.* uint8(mask1);%.*uint8(mask2).*uint8(mask3).*uint8(mask4);
 

end