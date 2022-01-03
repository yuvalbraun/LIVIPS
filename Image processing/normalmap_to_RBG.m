%% get a normal map and convert it to RGB 
%created by Yuval Braun
function [RGB_image] = normalmap_to_RBG(normalMap)
N=size(normalMap,1);
M=size(normalMap,2);
RGB_image=zeros(N,M,3);
for i=1:N
    for j=1:M
        if ~isnan(normalMap(i,j,1)) 
            x = normalMap(i,j,1);
            y = normalMap(i,j,2);
            z = normalMap(i,j,3);
            red = (x+1)*256/2;
            green = (y+1)*256/2;
            blue= (z*(1)*127+128);
            RGB_image(i,j,:)= [red, green, blue];
        end
        
    end
end
RGB_image=uint8(RGB_image);