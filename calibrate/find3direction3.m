function [directions,r]  = find3direction3( I1,I2,I3,I4 )
%% This function find lights directions using 3 images of chrome sphere
% input : I1-3 are images of the same sphere under diffrent lights
% Output : directions is 3x3 matrix contains the 3 vectors of the lights
% directions, r is the radius of the ball
%created by Yuval Braun
%% create gray scale images
I1 = rgb2gray(I1);
I2 = rgb2gray(I2);
I3 = rgb2gray(I3);
%%find circle manualy
figure();
imshow(I1);
[x,y]= ginput(10);
options.Visualize= 'on';
[xc, yc, r] = FitCircle(x, y, options);
%% find circle automaticly
% [centers, radii, metric] = imfindcircles(I4,[50 100],'ObjectPolarity','dark');
% xc = centers(1,1);
% yc= centers(1,2);
% r=radii(1);
%% remove bakground
for i=1:size(I1,1)
    for j=1:size(I1,2)
        if((i-yc)^2+(j-xc)^2>r^2)
            I1(i,j)=0;
            I2(i,j)=0;
            I3(i,j)=0;
        end
    end
end
imshow(I1);
options.Visualize= 'on';
%% find directions
directions(:,1)= FindLightDirectionFromChromeSphere(I1, [xc, yc, r], 250, options)';
directions(:,2)= FindLightDirectionFromChromeSphere(I2, [xc, yc, r], 250, options)';
directions(:,3)= FindLightDirectionFromChromeSphere(I3, [xc, yc, r], 250, options)';