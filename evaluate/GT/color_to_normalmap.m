function A =color_to_normalmap(color_image)
A=(double(color_image)/255)*2-1;
A=flipud(A);
for i=1:size(A,1)
    for j=1:size(A,2)
            if A(i,j,1)==-1 &&A(i,j,2)==-1 &&A(i,j,3)==-1 
                A(i,j,1)=NaN;
                A(i,j,2)=NaN;
                A(i,j,3)=NaN;
            else
                A(i,j,:)=A(i,j,:)/(A(i,j,1)^2+A(i,j,2)^2+A(i,j,3)^2)^0.5;
            end
            
    end
end
