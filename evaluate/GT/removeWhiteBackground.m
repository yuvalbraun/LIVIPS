ref=imread('snapshot01.png');
GTfull=imread('snapshot00.png');

left=0;
right=size(ref,2);
for i=1:size(ref,2)
    if ref(1,i,1)==0
        left=i;
        break
    end
end
for i=size(ref,2):-1:1
    if ref(1,i,1)==0
        right=i;
        break
    end
end
image=ref(:,left:right,:);
GT=GTfull(:,left:right,:);
imwrite(GT,'GT.png');    
