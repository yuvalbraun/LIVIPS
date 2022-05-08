function trimedGT =trim_image(image)
flag=0;
for i=1:size(image,1)
    for j=1:size(image,2)
        if ~isnan(image(i,j,1))&&~(image(i,j,1)==0 &&image(i,j,2)==0 &&image(i,j,3)==0)
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
for i=size(image,1):-1:1
    for j=1:size(image,2)
        if ~isnan(image(i,j,1))&&~(image(i,j,1)==0 &&image(i,j,2)==0 &&image(i,j,3)==0)
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
for j=1:size(image,2)
    for i=1:size(image,1)
        if ~isnan(image(i,j,1))&&~(image(i,j,1)==0 &&image(i,j,2)==0 &&image(i,j,3)==0)
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
for j=size(image,2):-1:1
    for i=1:size(image,1)
        if ~isnan(image(i,j,1))&&~(image(i,j,1)==0 &&image(i,j,2)==0 &&image(i,j,3)==0)
            rightBound=j;
            flag = 1;
            break
        end
    end
    if flag==1
        break
    end
end
trimedGT= image(upBound:lowBound,leftBound:rightBound,:);

