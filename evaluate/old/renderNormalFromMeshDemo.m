% Render normal from mesh (given the camera informtion from meshlab project (mlh) file)
% Authors: Binh-Son Hua and Boxin Shi

close all;
clear;
clc;

addpath('_lib\openexr-matlab-windows\x64')
addpath('_lib\struct2xml')

% set the dir. to your Mitsuba renderer
mitsubaDir = 'C:\mitsuba-win64\';
xmlDir = [pwd, '\'];

dataname = 'happyBuddha';
% camera information from meshlab (happyBuddha_gt.mlp)
% GT
% RotationMatrix
R = [0.987808 -0.154049 -0.0224342 0;
     0.0306824 0.0513752 0.998208 0;
    -0.152621 -0.986727 0.0554755 0;
     0 0 0 1];
% TranslationalVector
T_vec = [2.29256 16.4027 -0.830813 1];
% ViewportPx
w = 1920;
h = 1080;
% PixelSizeMm
pixelSizeW = 0.0298405;
pixelSizeH = 0.0298405;
% FocalMm
focalMmX = 214.308;
focalMmY = 214.308;

% assume that Mitsuba renders to this file, just for verification later
exrOutput = [dataname, '_world_normal.exr'];

% meshlab coordinate to mitsuba coordinate
rotY180 = [
-1 0 0 0;
0 1 0 0;
0 0 -1 0;
0 0 0 1
];

T = eye(4);
T(:,4) = T_vec;
world2cam = R * T;
cam2world = inv(world2cam);

mitsubaViewMatrix = cam2world * rotY180;

% pixel size and focal from MeshLab 
fx = focalMmX / pixelSizeW; % focal length in pixel unit
fy = focalMmY / pixelSizeH;

% Mitsuba uses a 35mm equivalent focal length, i.e., focal length for the diagonal field of view of a 36x24mm sensor
focal_35mm = 43.3 * fx / sqrt(w * w + h * h); 

%% Render normal
xml = xml2struct('skeleton.xml');
xml.scene.integrator.Attributes.type = 'field';
xml.scene.integrator.string.Attributes.name = 'field';
xml.scene.integrator.string.Attributes.value = 'shNormal';
xml.scene.shape.string.Attributes.value = [dataname, '.obj'];

% setup the camera
xml.scene.sensor.string.Attributes.value = num2str(focal_35mm);
xml.scene.sensor.film.integer{1,1}.Attributes.value = num2str(w);
xml.scene.sensor.film.integer{1,2}.Attributes.value = num2str(h);
camVec = mitsubaViewMatrix';
xml.scene.sensor.transform.matrix.Attributes.value = num2str(camVec(:)');
xmlName = 'worldN.xml';
struct2xml(xml, xmlName);

% call Mitsuba for rendering
system([mitsubaDir, 'mitsuba', ' ', [xmlDir, xmlName]]);

% Mitsuba provides the normal in world coordinate, and it should be
% converted to camera coordinate for photometric stereo
worldN = exrread('worldN.exr');
camN = zeros(size(worldN));

% this code can be made faster
fprintf('Computing camera space normal...\n')
for i = 1 : size(worldN, 1)
	for j = 1 : size(worldN, 2) 
		n = world2cam * [squeeze(worldN(i, j, :)); 0];
		camN(i, j, :) = n(1:3);
	end
end 

maskNormal = zeros(size(camN,1), size(camN, 2));
maskNormal(sqrt(camN(:, :, 1).^2 + camN(:, :, 2).^2 + camN(:, :, 3).^2) > 0.01) = 1;
mask3 = repmat(maskNormal, [1, 1, 3]);

% for visualization purpose
imwrite((camN + 1) * 0.5 .* mask3, 'camN.png');
imwrite((worldN + 1) * 0.5, 'worldN.png');

% save normalm
Normal_gt = camN;
save Normal_gt.mat Normal_gt;