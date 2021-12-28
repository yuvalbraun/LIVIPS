function points = createCirclePoints(N,R,x,y)
    step=2*pi/N;
    for i = 0:N-1
        deg=step*i;
        points{i+1}=  R*[cos(deg),sin(deg)]+[x,y];
    end
end

