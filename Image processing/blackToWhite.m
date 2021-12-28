function [Image]  = blackToWhite(I)
%%this function replace the black background with white
N=size(I,1);
M=size(I,2);
Image=I;
for i=1:N
    for j=1:M
        if isnan(I(i,j,1)) || (I(i,j,1)==0 &&I(i,j,2)==0&& I(i,j,3)==0)
            Image(i,j,:) = [1,1,1];
        end
    end
end
end
