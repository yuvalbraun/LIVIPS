function circles_peaks=findCircle(ball_img)
% creating the edge image
BW_ball = edge(ball_img);
% creating the hough matrix for circles
hough_mat_circle = dip_hough_circles(BW_ball);
figure;
% shows one slice of the hough matrix because it's 3D
imshow(hough_mat_circle(:,:,1),[]);
title('Hough Circles Matrix');
% extract the highest peaks, naive version commented
circles_peaks = houghpeaks_3D(hough_mat_circle,1);
% shows the circles corresponding to the peaks upon the image
showCirclesOnImage(circles_peaks,ball_img);
end

function [] = showCirclesOnImage(peaks,img)
% correct the values should be [min_r:max_r]
min_r = 30;
peaks(:,3) = peaks(:,3) + min_r-1;
figure;
for i=1:1
    x = peaks(i,2);
    y = peaks(i,1);
    r = peaks(i,3);
    img = insertShape(img,'circle',[x y r],'LineWidth',5,'Color','r');
end
imshow(img);
title('Hough circles detection');
end

function [peaks] = houghpeaks_3D(H,count)
peaks = zeros( count , 3 ) ;
for i = 1 : count
    [ ~ , idx ] = max(H( : ) ) ;
    [ idx1 , idx2 , idx3 ] = ind2sub ( size(H) , idx ) ;
    peaks ( i , : ) = [ idx1 , idx2 , idx3 ] ;
    % resseting the environment of the peak
    % so we wont get peaks that correlates to the same circle
    H = resetEnv(H,peaks ( i , : ));
    % naive version of only resseting the founded peak itself
    % H( idx1 , idx2 , idx3 ) = 0 ;
end
end

function H = resetEnv(H,argmax)
Factor = 110;
L = size(H);
x = findEnv(argmax(1),Factor,L(1));
y = findEnv(argmax(2),Factor,L(2));
z = findEnv(argmax(3),Factor,L(3));
H(x,y,z) = 0 ;
end
% make sure to not exceed the matrix dimensions
function vec = findEnv(center, fac,L)
from = center - fac;
if from <1
    from=1;
end
to = center + fac;
if to >L
    to=L;
end
vec = from:to;
end

function hough_mat = dip_hough_circles(BW)
[M,N] = size(BW);
min_r = 30;
max_r = 70;
hough_mat = zeros(M,N,max_r-min_r+1);
% limit the search to circles with radius [min_r,max_r]
r = min_r:max_r;
theta = 0:359;
[x,y] = find(BW);
for i = 1:length(x) % iterates the white pixels
    for R = r % iterates all the possible radiuses
        for t = theta % iterates all angles
            a = round(x(i)-R*cos(deg2rad(t)));
            b = round(y(i)-R*sin(deg2rad(t)));
            %             update the hough matrix only if the circle center
            %             is inside the image
            if ((a<M && a>0) && (b<N && b>0))
                hough_mat(a,b,R-min_r+1) = hough_mat(a,b,R-min_r+1)+1;
            end
        end
    end
end
end

function norm_img = dip_GN_imread(file_name)
img = imread(file_name);
gray_img = rgb2gray(img);
norm_img = normalizeImg(gray_img);
end

function norm_img = normalizeImg(img)
img = double(img);
min_img = min(min(img));
max_img = max(max(img));
norm_img = (img - min_img)./(max_img - min_img);
end

