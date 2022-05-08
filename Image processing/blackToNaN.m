%% this function gets an RGB image and replaces all the black pixel with NaN values
function [Image] = blackToNaN(normalMap)
N=size(normalMap,1);
M=size(normalMap,2);
Image=normalMap;
tresh=10^-9;
for i=1:N
    for j=1:M
        if normalMap(i,j,1)<tresh && normalMap(i,j,2)<tresh && normalMap(i,j,3)<tresh
            Image(i,j,:) = [NaN,NaN,NaN];
        end
    end
end
end
