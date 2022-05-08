%% This function creates points on a circle around the center point
%% input:
% N: number of points
% R: radius of the circle
% x,y center of the circle
%% output:
% points: list of (x,y) pairs
function points = createCirclePoints(N,R,x,y)
    step=2*pi/N;
    for i = 0:N-1
        deg=step*i;
        points{i+1}=  R*[cos(deg),sin(deg)]+[x,y];
    end
end

