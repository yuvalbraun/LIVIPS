%% simulate calssic PS in dark or alight enviorment and evaluate the result with GT.
close all;
clear;
clc;
%% choose parameters for simulation
fleshNoFlesh=0;
ambient_light=0;
N=8;
R=10;
number_of_frames=1;
irradiance=1.5;
H=512;
W=512;
servers=1; % set to 1 only when "servers.txt" exsists
samples_per_frame=512;
noise_level=0.008;

%% set dir and path
currnetDir = fullfile(fileparts(mfilename('fullpath')));
topDir=extractBefore(currnetDir,"simulation");
imagesDir=topDir + "\PSBox-v0.3.1\data\Objects";
addpath(topDir+"image processing");
addpath(topDir+"LIVItools");
addpath(genpath(char(topDir+"PSBox-v0.3.1\")));
addpath(topDir+"evaluate")
addpath('_lib\openexr-matlab-windows\x64');
addpath('_lib\struct2xml');
addpath(genpath(topDir+"PSBox-v0.3.1"));
objects_dir=currnetDir+"\objects\";
objects_names= ["bunny","face"];
object_number=1;
object_name=objects_names(object_number)+'.obj';%todo change to ply
object= convertStringsToChars(objects_dir+object_name);
GT_dir=currnetDir+"\GT\";
GT_name=objects_names(object_number)+'_GT.exr';
GT_file= convertStringsToChars(GT_dir+GT_name);

env_dir=currnetDir+"\env\";
env_names=["pisa_diffuse","pisa","glacier_diffuse","glacier"];
env_number=1;
env_name=env_names(env_number)+'.hdr';
env=convertStringsToChars(env_dir+env_name);
% set the dir. to your Mitsuba renderer
mitsubaDir = 'C:\mitsuba-win64\';
xmlDir = [currnetDir, '\'];
xmlName = 'simulation.xml';

if servers==1
    serversString=['-s',mitsubaDir, '\servers.txt',' ',];
else
    serversString='';
end



%% meshlab coordinate to mitsuba coordinate
T_vec =[0 ,0, 0,1];
rotY180 = [
-1 0 0 0;
0 1 0 0;
0 0 -1 0;
0 0 0 1
];

T = eye(4);
T(:,4) = T_vec;
world2cam =  T;
cam2world = inv(world2cam);

mitsubaViewMatrix = cam2world * rotY180;

%% sources
xml = xml2struct('simulation.xml');
camVec = mitsubaViewMatrix';
%xml.scene.sensor.transform.matrix.Attributes.value = num2str(camVec(:)');
%% set resolution
xml.scene.sensor.film.integer{1, 1}.Attributes.value=H;
xml.scene.sensor.film.integer{1, 2}.Attributes.value=W;

%% set number of samples per frame
xml.scene.sensor.sampler.integer.Attributes.value = samples_per_frame;

%% camrea location
camera_locations_str = split(xml.scene.sensor.transform.lookat.Attributes.origin,',');
x=str2num(camera_locations_str{1});
y=str2num(camera_locations_str{2});
z=-str2num(camera_locations_str{3});
points = createCirclePoints(N,R,x,y);
sources_location=zeros(N,3);
directions=sources_location';
for i=1:N
    sources_location(i,:)=[points{i}(1),points{i}(2),-z];
    directions(:,i)=(sources_location(i,:)-[x,y,0])/norm(sources_location(i,:));
end
%% crate sources
if ambient_light==1
    sources_cell =cell(1,N+1);
else
    sources_cell =cell(1,N);
end
%create sources
for i=1:N   
    sources_cell{1,i} = xml.scene.emitter{1,1};
    sources_cell{1,i}.Attributes.type = 'directional';
    sources_cell{1,i}.spectrum.Attributes.name = 'irradiance';
    sources_cell{1,i}.spectrum.Attributes.value = num2str(irradiance);
    sources_cell{1,i}.vector.Attributes.x = num2str(-directions(1,i));
    sources_cell{1,i}.vector.Attributes.y = num2str(-directions(2,i));
    sources_cell{1,i}.vector.Attributes.z = num2str(-directions(3,i));
    sources_cell{1,i}.float.Attributes.name = 'scale';
    sources_cell{1,i}.float.Attributes.value = '1';%num2str(normrnd(1,0.1));
end
%create enviorment light
if ambient_light==1
    sources_cell{1,N+1}.Attributes.type = 'envmap';
    sources_cell{1,N+1}.string.Attributes.name = 'filename';
    sources_cell{1,N+1}.string.Attributes.value = env;
    sources_cell{1,N+1}.float.Attributes.name = 'scale';
    sources_cell{1,N+1}.float.Attributes.value = '0';
end
 xml.scene.emitter=sources_cell;
%% create object
xml.scene.shape.string.Attributes.value=object;

%% crate mask
struct2xml(xml, xmlName);
system([mitsubaDir, 'mitsuba', ' ',serversString, [xmlDir, xmlName],' -q']);
mask=exrread('simulation.exr');
mask=rgb2gray(mask);
mask=mask~=0;
if ambient_light==1
    xml.scene.emitter{1,N+1}.float.Attributes.name = 'scale';
    xml.scene.emitter{1,N+1}.float.Attributes.value ='1';% num2str(normrnd(1,0.1));
end
for i=1:N
     xml.scene.emitter{1,i}.spectrum.Attributes.name = 'irradiance';
     xml.scene.emitter{1,i}.spectrum.Attributes.value = '0';
 end

%% No flesh
if fleshNoFlesh==1 
    struct2xml(xml, xmlName);
    system([mitsubaDir, 'mitsuba', ' ',serversString, [xmlDir, xmlName],' -q']);
    noFleshImage=exrread('simulation.exr'); %%%todo change to uint 8 and add noise
    if number_of_frames>1
       for j=1:(number_of_frames-1) 
           system([mitsubaDir, 'mitsuba', ' ',serversString, [xmlDir, xmlName],' -q']);
           noFleshImage=noFleshImage+exrread('simulation.exr');
       end
     noFleshImage=noFleshImage/number_of_frames;
    end

end
%% take N photos with diffrets sources
for i=1:N
    if i>1
       xml.scene.emitter{1,(i-1)}.spectrum.Attributes.name = 'irradiance';
       xml.scene.emitter{1,(i-1)}.spectrum.Attributes.value = '0';%num2str(normrnd(1,0.1));
    end
    xml.scene.emitter{1,i}.spectrum.Attributes.name = 'irradiance';
    xml.scene.emitter{1,i}.spectrum.Attributes.value = num2str(irradiance);
    xml.scene.emitter{1,i}.float.Attributes.name = 'scale';
    xml.scene.emitter{1,i}.float.Attributes.value = '1';%num2str(normrnd(1,0.1));
    struct2xml(xml, xmlName);
    system([mitsubaDir, 'mitsuba', ' ',serversString, [xmlDir, xmlName],' -q']);
    newImage=rgb2gray(exrread('simulation.exr'));
    if noise_level>0
        newImage = imnoise(newImage,'gaussian',0,noise_level^2); % Gaussian white noise with mean 0 and variance noise_level.
    end
    newImage_8bit=uint8(newImage*256);%%%image in 8bit 
    image=double(newImage_8bit); %% convert to double for avareging
    if number_of_frames>1
       for j=1:(number_of_frames-1)
           system([mitsubaDir, 'mitsuba', ' ',serversString, [xmlDir, xmlName],' -q']);
           newImage=rgb2gray(exrread('simulation.exr'));
           if noise_level>0
              newImage = imnoise(newImage,'gaussian',0,noise_level^2); % Gaussian white noise with mean 0 and variance noise_level.
           end
           newImage_8bit=uint8(newImage*256);%%%image in 8bit 
           image=image+double(newImage_8bit);
       end
           image=image/number_of_frames;
    end

    if fleshNoFlesh==1  
        image=image-noFleshImage;
    end
    %image=rgb2gray(image);
    image=mask.*image;

    imwrite(image,imagesDir + "\image_0"+num2str(i)+".png");  
    imwrite(double(image/256),imagesDir + "\image_0"+num2str(i)+".tiff");
    save(imagesDir + "\image_0"+num2str(i),'image');
end
 dlmwrite(topDir +"PSBox-v0.3.1\data\light_directions.txt", directions, ...
    'delimiter', ' ', 'precision', '%20.16f');
demoPSBox;
GT=exrread(GT_file);
degrees=calcDegreeError(flipud(GT),n);
[H1,W1,D1]=size(degrees);
figure
%imagesc(flipud(degrees'));
him=imshow([flipud(degrees) nan(H1,1); nan(1,W1+1)],colormap(jet(30)));
set(him, 'AlphaData', ~isnan([flipud(degrees) nan(H1,1); nan(1,W1+1)]))
shading flat;
set(gca, 'ydir', 'reverse');
%title('angular error map');
colorbar;   
medianDegree=calcMedian(degrees);
avDegree=calcSum(degrees);
figure
histogram(degrees);
xlabel('angular error [degrees]');
ylabel('number of points');
title('angular error histogram');
