function [count]  = countZeros(k,TF1)
count=0;
for i=1:k
    if TF1(i)==0
       count=count+1;
    end
end
end