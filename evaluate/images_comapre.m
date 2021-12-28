img1=imread('static.png');
img2=imread('static_light.png');
Dist = sqrt(sum((img1(:) - img2(:)) .^ 2));  % [TYPO fixed, thanks Sean]