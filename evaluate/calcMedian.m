function [med] = calcMedian(Matrix)
%% calc the median value of matrix
%created by Yuval Braun
[N,M]=size(Matrix);
k=1;
for i=1:N
    for j=1:M
        if ~isnan(Matrix(i,j))
            List(k)=Matrix(i,j);
            k=k+1;
        end
    end
end
med=median(List);
end
