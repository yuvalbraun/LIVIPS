function Image  = removeBlueBackground( I )
M=size(I,1);
N=size(I,2);
Image =I;
for i = 1:M
    for j = 1:N
        if (I(i,j,1)<50 && I(i,j,2)<50 && I(i,j,3)>150)||(I(i,j,1)<80 && I(i,j,2)<80 && I(i,j,3)>200)
            Image(i,j,:)= [0 0 0 ];
        end
    end
end
end