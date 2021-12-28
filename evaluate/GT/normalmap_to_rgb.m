function A =normalmap_to_rgb(normalmap)
A= uint8(((normalmap+1)/2)*255);
A=flipud(A);
for i=1:size(A,1)
    for j=1:size(A,2)
            if A(i,j,1)==0 &&A(i,j,2)==0 &&A(i,j,3)==0
                A(i,j,1)=NaN;
                A(i,j,2)=NaN;
                A(i,j,3)=NaN;
            end         
    end
end
