function [newL,depthMap,normalMap]=findClosestPoint(X,Y,rows,cols,L,ratio,normalsList)
%% this function gets a list of points and create a depth map and a normals map rows*cols size
% input : X and Y are vectors represent the axis. rows and cols are
% integers represent the size of the map, L is list of points, normal list
% are list of vectors normal to the surface.
% output: newL is list with only the point who where taken to create the
% depth map. depthMap is row by cols size depth map and normalMap is row by cols size normal map
% created by Yuval Braun
newL=zeros(rows*cols,3);
depthMap=zeros(rows,cols);
S=size(L,1);
step=X(2)-X(1);
l=1;
for i=1:rows
    for j=1:cols
        x  = L(1,1);
        y  = L(1,2);
        z  = L(1,3);
        d= (x-X(i))^2+(Y(j)-y)^2;
        for k=2:S
            xk  = L(k,1);
            yk  = L(k,2);
            zk  = L(k,3);
            dk= (xk-X(i))^2+(Y(j)-yk)^2;
            if dk<d 
                d=dk;
                x=xk;
                y=yk;
                z=zk;
                kFound=k;

            end
        end
        if d<=step
            z=z/ratio;
            newL(l,:)=[X(i),Y(j),z];
            depthMap(i,j)=z;
            normalMap(i,j,:)=normalsList(kFound,:);
            l=l+1;
        else
           depthMap(i,j)=NaN;
        end
        
    end
end
end