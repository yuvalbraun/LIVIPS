full_image=imread("face_GT_1105.png");
flag = 0;
for i=1:size(full_image,1)
    for j=1:size(full_image,2)
        if full_image(i,j,1)~=0|| full_image(i,j,2)~=0||full_image(i,j,3)~=0
            upBound=i;
            flag = 1;
            break
        end
    end
    if flag==1
        break
    end
end
flag = 0;
for i=size(full_image,1):-1:1
    for j=1:size(full_image,2)
        if full_image(i,j,1)~=0|| full_image(i,j,2)~=0||full_image(i,j,3)~=0
            lowBound=i;
            flag = 1;
            break
        end
    end
    if flag==1
        break
    end
end
flag = 0;
for j=1:size(full_image,2)
    for i=1:size(full_image,1)
        if full_image(i,j,1)~=0|| full_image(i,j,2)~=0||full_image(i,j,3)~=0
            leftBound=j;
            flag = 1;
            break
        end
    end
    if flag==1
        break
    end
end
flag = 0;
for j=size(full_image,2):-1:1
    for i=1:size(full_image,1)
        if full_image(i,j,1)~=0|| full_image(i,j,2)~=0||full_image(i,j,3)~=0
            rightBound=j;
            flag = 1;
            break
        end
    end
    if flag==1
        break
    end
end
trimed_GT=full_image(upBound:lowBound,leftBound:rightBound,:);
imwrite(trimed_GT,'for_GT_trimmed.png');
