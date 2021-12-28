function trimedGT =trim_image2(ref,image)
flag=0;
for i=1:size(ref,1)
    for j=1:size(ref,2)
        if ref(i,j)~=0&&i~=1
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
for i=size(ref,1):-1:1
    for j=1:size(ref,2)
        if ref(i,j)~=0
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
for j=1:size(ref,2)
    for i=1:size(ref,1)
        if ref(i,j)~=0
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
for j=size(ref,2):-1:1
    for i=1:size(ref,1)
        if ref(i,j)~=0
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

