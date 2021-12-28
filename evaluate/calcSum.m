function meanError=calcSum(A)
%% calc the avarage value of a Matrix
%created by Yuval Braun
N=size(A,1);
M=size(A,2);
Sum=0;
numOfNumbers=0;
for i=1:N
    for j=1:M
        if ~isnan(A(i,j))
            numOfNumbers=numOfNumbers+1;
            Sum=Sum+abs(A(i,j));
        end
    end
end
meanError=Sum/numOfNumbers;
end
