%this function removes Mitsuba watermark
function [image2] = remove_mitsuba_mark(image)
N=size(image,1);
M=size(image,2);
image2=image;
blackValue=image(1,1);

for i=ceil(0.9*N):N
    for j=1:M
        image2(i,j)=blackValue;
    end
end
end