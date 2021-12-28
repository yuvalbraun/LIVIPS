function [D] = calcDegreeError(normalMap1,normalMap2)
%% calc the degrees between two normal maps
%created by Yuval Braun
N=size(normalMap1,1);
M=size(normalMap1,2);
D=zeros(N,M);
for i=1:N
    for j=1:M
        P1=reshape(normalMap1(i,j,:), [3,1]);
        P2=reshape(normalMap2(i,j,:), [3,1]);
        if ~isnan(P1(1))&&~isnan(P2(1))&&~isequal(P1,[0;0;0])&&~isequal(P2,[0;0;0])
            D(i,j) = atan2d(norm(cross(P1,P2)),dot(P1,P2));
        else
            D(i,j)=NaN;
        end
    end
end
end

